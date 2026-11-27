package org.supass.ai_su_pass.cve43499

import android.os.SystemClock
import org.supass.ai_su_pass.core.bridge.ghost_lock_native.GhostLockChunk
import org.supass.ai_su_pass.core.shell.ShellChannel
import org.supass.ai_su_pass.core.shell.ShellProtocol
import org.supass.ai_su_pass.core.shell.ShellResult

/**
 * 一次 GhostLock 运行的会话：落 profile、后台拉起原生、轮询日志。
 *
 * 原生是 PIE 可执行文件，不是 JNI；profile 走 `--load-prebuilt-profile` 文件入口，
 * 不走 stdin——`--enable-status-record` 需要 stdin 保持打开回 ACK，而本项目
 * shell 通道的 stdin 是一次性写完即关。
 *
 * 取消只停止本侧读取：攻击进程中途被 kill 会留下半改的内核状态。
 */
internal class GhostLockSession(
    private val binPath: String,
    private val ksudPath: String,
    private val blob: ByteArray,
    private val channel: ShellChannel,
) {

    val sessionId: String = "cve43499-${System.currentTimeMillis()}"

    private val roundId: Long = System.currentTimeMillis()

    private val dir: String = "$WORK/round-$roundId"

    private val startedAt: Long = SystemClock.elapsedRealtime()

    private val lock = Any()

    private val output = StringBuilder()

    /** 已写出的字符数；每次读整份 run.log 后按字符游标取增量。 */
    private var emittedChars = 0

    private var ksuDumped = false

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

    fun start() {
        Thread({ runPipeline() }, "cve43499-session").apply {
            isDaemon = true
            start()
        }
    }

    /** 增量取走输出；取走即清空。 */
    fun poll(): GhostLockChunk = synchronized(lock) {
        val delta = output.toString()
        output.setLength(0)
        GhostLockChunk(
            sessionId = sessionId,
            output = delta,
            finished = finished,
            exitCode = exitCode.toLong(),
            timedOut = timedOut,
            durationMs = SystemClock.elapsedRealtime() - startedAt,
            failure = failure,
        )
    }

    /** 停止本侧读取；设备侧进程继续跑。 */
    fun cancel() {
        cancelled = true
        synchronized(lock) {
            timedOut = true
            finished = true
            exitCode = -1
        }
    }

    private fun runPipeline() {
        try {
            exec("mkdir -p $dir", SETUP_TIMEOUT_MS, null)
            val write = exec("cat > $dir/profile.bin", WRITE_TIMEOUT_MS, blob)
            if (write.exitCode != 0) {
                finishFailure("profileWriteFailed")
                return
            }
            val launch = exec(launchCommand(), LAUNCH_TIMEOUT_MS, null)
            if (launch.exitCode == ShellProtocol.EXIT_NOT_STARTED) {
                /* 命令没跑起来：通道掉了（设备重启/断连）而不是命令本身失败。 */
                finishFailure("deviceDisconnected")
                return
            }
            if (launch.exitCode != 0 || !launch.stdout.contains(STARTED)) {
                /* 把 shell 侧的原始输出与已落盘的 run.log 带回去，
                 * launchFailed 不再是无信息量的黑箱。 */
                synchronized(lock) {
                    if (launch.stdout.isNotBlank()) output.append(launch.stdout)
                    if (launch.stderr.isNotBlank()) output.append(launch.stderr)
                }
                drainLog()
                finishFailure("launchFailed")
                return
            }
            pollUntilDone()
        } catch (t: Throwable) {
            finishFailure(t.javaClass.simpleName)
        }
    }

    private fun pollUntilDone() {
        var bootDeadline = startedAt + BOOT_GRACE_MS
        var lostStreak = 0
        while (!cancelled) {
            val now = SystemClock.elapsedRealtime()
            if (now - startedAt > MAX_SESSION_MS) {
                synchronized(lock) {
                    timedOut = true
                    finished = true
                }
                return
            }
            val probe = exec(probeCommand(), PROBE_TIMEOUT_MS, null)
            if (probe.exitCode == ShellProtocol.EXIT_NOT_STARTED) {
                /* 设备重启或掉线时通道取不到退出帧；连续多次都这样立即收尾，
                 * 不要让用户干等到会话超时。 */
                if (++lostStreak >= LOST_STREAK_LIMIT) {
                    finishFailure("deviceDisconnected")
                    return
                }
                Thread.sleep(POLL_INTERVAL_MS)
                continue
            }
            lostStreak = 0
            val bytes = parseBytes(probe.stdout)
            val code = parseExitCode(probe.stdout)
            if (bytes > 0) bootDeadline = now + BOOT_GRACE_MS
            drainLog()
            if (code != null) {
                drainLog()
                dumpKsuLog()
                synchronized(lock) {
                    exitCode = code
                    finished = true
                }
                return
            }
            if (now > bootDeadline) {
                finishFailure("nativeNotStarted")
                return
            }
            Thread.sleep(POLL_INTERVAL_MS)
        }
    }

    /** 每轮读整份日志后按字符游标取增量：避免 `tail -c` 在 UTF-8 中间截断。 */
    private fun drainLog() {
        val text = exec("cat $dir/run.log 2>/dev/null", READ_TIMEOUT_MS, null).stdout
        if (text.length <= emittedChars) return
        synchronized(lock) {
            output.append(text, emittedChars, text.length)
        }
        emittedChars = text.length
    }

    /** KSU 的真实结论在 root 脚本的日志里；收尾附一次。 */
    private fun dumpKsuLog() {
        if (ksuDumped) return
        ksuDumped = true
        val text = exec("cat $dir/ksu.log 2>/dev/null", READ_TIMEOUT_MS, null).stdout
        if (text.isEmpty()) return
        synchronized(lock) { output.append(text) }
    }

    /**
     * 拉起原生。
     *
     * 环境变量必须用 `export`：`VAR=x ( 子shell )` 在 sh 里是语法错误，
     * 整条命令会直接以非 0 退出、连 `started` 都打不出来。
     */
    private fun launchCommand(): String = buildString {
        append("cd ").append(dir).append(" && ")
        append("export GHOSTLOCK_HOME=").append(WORK)
        append(" TMPDIR=/data/local/tmp HOME=/data/local/tmp")
        if (ksudPath.isNotEmpty()) {
            append(" GHOSTLOCK_KSUD=").append(quote(ksudPath))
        }
        append(" GHOSTLOCK_KSU_LOG=").append(dir).append("/ksu.log")
        append(" ; ")
        append("( nohup setsid ").append(quote(binPath))
        append(" --load-prebuilt-profile profile.bin")
        append(" > run.log 2>&1 < /dev/null; echo $? > exit.code ) & echo ").append(STARTED)
    }

    private fun finishFailure(code: String) {
        synchronized(lock) {
            failure = code
            finished = true
            exitCode = -1
        }
    }

    private fun exec(command: String, timeoutMs: Long, stdin: ByteArray?): ShellResult =
        channel.exec(command, timeoutMs, stdin)

    /** `nativeLibraryDir` 含 `~` `=`，不加引号会被 shell 吃掉。 */
    private fun quote(value: String): String = "'$value'"

    private fun parseBytes(stdout: String): Long =
        stdout.lineSequence()
            .firstOrNull { it.startsWith(BYTES_PREFIX) }
            ?.removePrefix(BYTES_PREFIX)
            ?.trim()
            ?.toLongOrNull() ?: 0L

    private fun parseExitCode(stdout: String): Int? =
        stdout.lineSequence()
            .firstOrNull { it.startsWith(CODE_PREFIX) }
            ?.removePrefix(CODE_PREFIX)
            ?.trim()
            ?.takeIf { it.isNotEmpty() }
            ?.toIntOrNull()

    /** 两条探针合一：日志字节数 + 退出码文件。 */
    private fun probeCommand(): String =
        "echo B:\$(wc -c < $dir/run.log 2>/dev/null); " +
            "echo C:\$(cat $dir/exit.code 2>/dev/null)"

    private companion object {
        const val WORK = "/data/local/tmp/cve43499"

        const val STARTED = "started"
        const val BYTES_PREFIX = "B:"
        const val CODE_PREFIX = "C:"

        const val POLL_INTERVAL_MS = 500L
        const val MAX_SESSION_MS = 15 * 60 * 1000L
        const val BOOT_GRACE_MS = 10 * 1000L

        /** 连续多少次探针取不到退出帧就认定设备已断连（重启/掉线）。 */
        const val LOST_STREAK_LIMIT = 3

        const val SETUP_TIMEOUT_MS = 5_000L
        const val WRITE_TIMEOUT_MS = 30_000L
        const val LAUNCH_TIMEOUT_MS = 10_000L
        const val PROBE_TIMEOUT_MS = 5_000L
        const val READ_TIMEOUT_MS = 10_000L
    }
}
