package org.supass.ai_su_pass.core.shell

import android.content.Context
import android.os.Bundle
import android.os.IBinder
import android.os.Parcel
import android.os.SystemClock
import android.util.Log
import org.supass.ai_su_pass.core.adb.AdbShellChannel
import org.supass.ai_su_pass.core.privileged.SupassBinderHolder
import org.supass.ai_su_pass.core.privileged.SupassLauncher
import org.supass.ai_su_pass.privileged.SupassProtocol

/**
 * 通过常驻特权进程执行的 shell 通道（M1-4）。
 *
 * 与 [AdbShellChannel] 的区别只在「命令发给谁」：
 * - ADB 通道：每条命令都压在一条活着的无线调试连接上，关掉无线调试就全断；
 * - 本通道：ADB 只用来点一次火，之后走 Binder，无线调试关掉照样执行。
 *
 * 三条实现约束（来自 [ShellChannel] 的契约）：
 * 1. [exec] 带超时，超时由服务端杀进程组，不在客户端无限等；
 * 2. 任何失败都折叠成 [ShellResult]，不抛异常；
 * 3. [status] / [uid] 零副作用 —— 只 `pingBinder()` 与读缓存，不下发命令。
 */
internal class BinderShellChannel(
    private val adb: AdbShellChannel,
    private val context: Context,
) : ShellChannel {

    override val source: String = SOURCE

    @Volatile
    private var cachedUid: Long = UNKNOWN_UID

    /** 累计重拉次数，写进 `hostStatus` 证据。 */
    @Volatile
    var relaunchAttempts: Long = 0L
        private set

    /**
     * 最近一次点火失败的具体原因，供上层原样回传给页面。
     *
     * 只写短字符串（不含完整日志），目的是让用户在 App 里就能看到
     * 「为什么没起来」，而不是被迫去翻 logcat。成功拿到 Binder 时清空。
     */
    @Volatile
    var lastFailure: String? = null
        private set

    /** 连续失败次数；到 [MAX_CONSECUTIVE_FAILURES] 就停手，不做无限重试。 */
    @Volatile
    private var consecutiveFailures: Int = 0

    override fun status(): ShellStatus =
        if (SupassBinderHolder.current() != null) ShellStatus.READY else ShellStatus.NOT_CONNECTED

    /**
     * 当前身份：优先用 Provider 登记时记下的真实调用方 uid。
     *
     * `cachedUid` 只在点火握手（[verify]）里写入，只要 Binder 是通过别的路径
     * 推进来的（或缓存被重置过），它就会停在 -1。以前只看 `cachedUid`，
     * 结果 `probe` 会得到「已连接 + 身份未知」，判定为不可用，页面直接报
     * 「不支持」——用户点重试只能看到秒失败。
     *
     * 仍然零副作用：两个来源都只读本地字段，不发 IPC。
     */
    override val uid: Long
        get() {
            if (status() != ShellStatus.READY) return UNKNOWN_UID
            val attached = SupassBinderHolder.attachedUid()
            return if (attached > 0L) attached else cachedUid
        }

    /**
     * 预热：确保特权进程已拉起并把 Binder 推过来，返回是否可用。
     *
     * 与 [status] 的分工必须分清：[status] 零副作用，只回现状；本方法会**真的点火**
     * （通过 ADB 跑一次 [SupassLauncher]），所以只允许在用户显式触发的写操作
     * （`warmUpHost` / `startRun`）里调用，绝不能出现在 `probe` / `hostStatus` 里。
     */
    fun warmUp(): Boolean = ensureBinder() != null

    /**
     * 断开宿主：让特权进程自己退出，Binder 随之失效。
     *
     * 宿主是普通应用进程，没有权限 kill 属于 uid 2000 的特权进程，只能借它自己的
     * shell 子进程动手：先 ping 拿到它的 pid，再让它执行 `kill -9 <pid>`。
     *
     * 这条 exec 的回复必然收不到——被杀掉的就是回复方——所以不解析结果，
     * 只看「指令是否发出」。真正的判据是随后的 `status()`，那里会
     * `pingBinder()` 失败并把陈旧引用清掉。
     *
     * 不清 [consecutiveFailures]：这是用户主动断开，不是点火失败，
     * 下次重新配对时应当从零开始计退避。
     */
    fun shutdown(): Boolean {
        val binder = SupassBinderHolder.current() ?: return false
        val pid = transact(binder, SupassProtocol.CODE_PING)
            ?.getInt(SupassProtocol.KEY_PID, 0)
            ?: 0
        if (pid <= 0) return false

        transact(
            binder,
            SupassProtocol.CODE_EXEC,
            "kill -9 $pid",
            SHUTDOWN_TIMEOUT_MS,
        )
        // 主动断开时不等死亡通知：回调是异步的，页面会立刻回查状态，
        // 先清空能让「未就绪」当场成立，不必赌回调的到达时机。
        SupassBinderHolder.clear()
        return true
    }

    override fun exec(command: String, timeoutMs: Long): ShellResult {
        val startedAt = SystemClock.elapsedRealtime()

        val binder = ensureBinder()
            ?: return failure("privileged binder unavailable", startedAt)

        val reply = transact(binder, SupassProtocol.CODE_EXEC, command, timeoutMs)
            ?: return failure("privileged exec transaction failed", startedAt)

        return ShellResult(
            exitCode = reply.getInt(SupassProtocol.KEY_EXIT_CODE, EXIT_NOT_STARTED),
            stdout = reply.getString(SupassProtocol.KEY_STDOUT).orEmpty(),
            stderr = reply.getString(SupassProtocol.KEY_STDERR).orEmpty(),
            // 服务端给的是它自己的耗时；缺省时退回客户端实测值。
            durationMs = reply.getLong(
                SupassProtocol.KEY_DURATION_MS,
                SystemClock.elapsedRealtime() - startedAt,
            ),
            timedOut = reply.getBoolean(SupassProtocol.KEY_TIMED_OUT, false),
        )
    }

    /**
     * 拿到可用代理：先看缓存，没有再点火。
     *
     * 重拉退避 1s → 2s → 4s → 8s → 封顶 30s；连续失败 3 次停手，
     * 让上层把「宿主不可用」报上去，而不是把线程耗在无限重试里。
     */
    private fun ensureBinder(): IBinder? {
        SupassBinderHolder.current()?.let { return it }

        if (consecutiveFailures >= MAX_CONSECUTIVE_FAILURES) {
            lastFailure = "relaunchPaused: $consecutiveFailures consecutive failures"
            Log.w(TAG, "relaunch paused after $consecutiveFailures consecutive failures")
            return null
        }
        if (adb.status() != ShellStatus.READY) {
            // 点火本身需要一条活着的 ADB 连接；没连接就只能等用户重新配对。
            lastFailure = "adbNotReady: ${adb.lastError ?: "no adb connection"}"
            Log.w(TAG, "relaunch skipped: adb channel not ready")
            return null
        }

        val backoff = backoffDelayMs(consecutiveFailures)
        if (backoff > 0L) sleepQuietly(backoff)

        relaunchAttempts += 1
        val launched = adb.exec(launchCommand(), LAUNCH_TIMEOUT_MS)
        Log.i(
            TAG,
            "relaunch #$relaunchAttempts exit=${launched.exitCode} " +
                "out=${launched.stdout.trim()} err=${launched.stderr.trim()}",
        )

        val binder = awaitBinder()
        if (binder == null) {
            consecutiveFailures += 1
            val launchOutput = launched.stderr.trim().ifEmpty { launched.stdout.trim() }
            // 点火脚本自己 exit=0 但没拿到 Binder，说明 `app_process` 起来了又退、
            // 或压根没加载到类。原因只在它自己的输出里，读回来给页面——否则
            // 用户看到的永远是「没起来」，我们也没法判断卡在哪一步。
            //
            // 顺序不能反：脚本成功时 stdout 一定有 `spawned pid=…`，先看它的话
            // 永远读不到日志，等于白等。
            //
            // 日志为空本身就是结论，但要再分一层：进程还在 / 已经没了。
            //
            // - 进程还在（pidof 有值）：它跑到了，只是没把 Binder 推回来，
            //   典型是卡在 `ActivityThread.systemMain()` 或 Provider 拒收。
            // - 进程没了：它在 ART 里崩了。`app_process` 一进 ART，错误全走
            //   logcat（liblog），根本不落到 fd 2，所以磁盘日志一定为空，
            //   必须去 logcat 捞。
            val alive = readProcessState()
            val raw = readHostLog()
                .ifEmpty { readDiagLog() }
                .ifEmpty { launchOutput }
                .ifEmpty { "noDiagnostics" }
            val detail = raw.replace(WHITESPACE, " ").trim().take(DETAIL_LIMIT)
            val launchState = "exit=${launched.exitCode}" + if (launched.timedOut) "/timeout" else ""
            lastFailure = "noBinderAfterLaunch: $launchState | $alive" +
                if (detail.isEmpty()) "" else " | $detail"
            Log.w(TAG, "relaunch failed, consecutive=$consecutiveFailures")
        } else {
            consecutiveFailures = 0
            lastFailure = null
        }
        return binder
    }

    /** 读回特权进程落盘的输出（尾部若干行），作为点火失败的可读原因。 */
    private fun readHostLog(): String {
        val result = adb.exec(
            "tail -n $LOG_TAIL_LINES ${SupassProtocol.HOST_LOG_PATH} 2>/dev/null",
            LOG_READ_TIMEOUT_MS,
        )
        return result.stdout.trim().ifEmpty { result.stderr.trim() }
    }

    /**
     * 从 logcat 捞特权进程的死亡原因。
     *
     * 一旦进程进了 ART，`ClassNotFoundException`、`UnsatisfiedLinkError`、
     * SELinux `avc: denied` 全都只写 logcat，磁盘日志必然是空的。不读这里，
     * 用户就只能看到「什么都没写」这种毫无指向性的结论。
     */
    private fun readDiagLog(): String {
        val result = adb.exec(DIAG_LOG_COMMAND, LOG_READ_TIMEOUT_MS)
        return result.stdout.trim()
    }

    /** 特权进程当前是否还活着：活着说明走到了 main 但没推 Binder，死了说明在 ART 里崩了。 */
    private fun readProcessState(): String {
        val result = adb.exec(
            "pidof ${SupassProtocol.NICE_NAME} 2>/dev/null",
            LOG_READ_TIMEOUT_MS,
        )
        val pid = result.stdout.trim()
        return if (pid.isEmpty()) "processDead" else "processAlive(pid=$pid)"
    }

    private fun launchCommand(): String = SupassLauncher.launchCommand(
        apkPath = context.applicationInfo.sourceDir,
        authority = context.packageName + SupassProtocol.AUTHORITY_SUFFIX,
    )

    /** 等特权进程把 Binder 推过来；顺带校验协议版本，避免用旧进程的旧接口。 */
    private fun awaitBinder(): IBinder? {
        val deadline = SystemClock.elapsedRealtime() + ATTACH_WAIT_MS
        while (SystemClock.elapsedRealtime() < deadline) {
            val candidate = SupassBinderHolder.current()
            if (candidate != null) {
                if (verify(candidate)) return candidate
                // 版本不匹配：旧进程已被清掉，下一轮重拉会杀掉它。
                continue
            }
            sleepQuietly(POLL_MS)
        }
        return null
    }

    /** 协议版本 + 身份确认；失败说明代理不可用或对端是升级前的旧进程。 */
    private fun verify(binder: IBinder): Boolean {
        val reply = transact(binder, SupassProtocol.CODE_PING) ?: return false
        val version = reply.getInt(SupassProtocol.KEY_VERSION, 0)
        if (version != SupassProtocol.VERSION) {
            Log.w(TAG, "protocol mismatch: service=$version, app=${SupassProtocol.VERSION}")
            SupassBinderHolder.clear()
            return false
        }
        cachedUid = reply.getLong(SupassProtocol.KEY_UID, UNKNOWN_UID)
        Log.i(TAG, "privileged ready pid=${reply.getInt(SupassProtocol.KEY_PID, -1)} uid=$cachedUid")
        return true
    }

    private fun transact(
        binder: IBinder,
        code: Int,
        command: String? = null,
        timeoutMs: Long = 0L,
    ): Bundle? {
        val data = Parcel.obtain()
        val reply = Parcel.obtain()
        return try {
            data.writeInterfaceToken(SupassProtocol.DESCRIPTOR)
            if (code == SupassProtocol.CODE_EXEC) {
                data.writeString(command.orEmpty())
                data.writeLong(timeoutMs)
            }
            if (!binder.transact(code, data, reply, 0)) {
                Log.w(TAG, "transact rejected code=$code")
                return null
            }
            reply.readException()
            reply.readBundle(javaClass.classLoader)
        } catch (t: Throwable) {
            // DeadObjectException 等一律折叠成 null：调用方按「通道不可用」处理。
            Log.w(TAG, "transact failed code=$code: ${t.javaClass.simpleName}")
            null
        } finally {
            data.recycle()
            reply.recycle()
        }
    }

    private fun failure(stderr: String, startedAt: Long): ShellResult = ShellResult(
        exitCode = EXIT_NOT_STARTED,
        stdout = "",
        stderr = stderr,
        durationMs = SystemClock.elapsedRealtime() - startedAt,
        timedOut = false,
    )

    private fun backoffDelayMs(failures: Int): Long {
        if (failures <= 0) return 0L
        val shift = (failures - 1).coerceAtMost(MAX_BACKOFF_SHIFT)
        return (BASE_BACKOFF_MS shl shift).coerceAtMost(MAX_BACKOFF_MS)
    }

    private fun sleepQuietly(millis: Long) {
        try {
            Thread.sleep(millis)
        } catch (_: InterruptedException) {
            Thread.currentThread().interrupt()
        }
    }

    private companion object {
        const val SOURCE = "binder"
        const val TAG = SupassProtocol.TAG
        const val UNKNOWN_UID = -1L
        const val EXIT_NOT_STARTED = -1
        const val MAX_CONSECUTIVE_FAILURES = 3
        const val BASE_BACKOFF_MS = 1_000L
        const val MAX_BACKOFF_MS = 30_000L
        const val MAX_BACKOFF_SHIFT = 5
        const val ATTACH_WAIT_MS = 5_000L
        const val POLL_MS = 100L

        /**
         * 断开时那条 `kill -9` 的等待上限。
         *
         * 正常情况下对端进程一死事务就中断，几毫秒返回；这里只是兜底，
         * 避免某种 ROM 上 `kill` 被 SELinux 拦下后把后台线程挂满。
         */
        const val SHUTDOWN_TIMEOUT_MS = 1_000L

        /**
         * 点火脚本自身的超时。
         *
         * 脚本只做几件毫秒级的事（判 uid、清旧进程、spawn、回显 pid），真正的
         * 长时间等待在后面的 [ATTACH_WAIT_MS]。这里给 4s 足够，不必按 10s 等——
         * 之前就是这 10s 让「明明配对成功」的反馈拖成了十几秒。
         */
        const val LAUNCH_TIMEOUT_MS = 4_000L

        /**
         * 回传失败详情时的长度上限。
         *
         * 特权进程的日志会带上「enter main / start / looper / push attempt …」若干行，
         * 400 字符会在关键异常之后被截断（实际发生过 `push attem…` 戛然而止），
         * 所以留 800。页面那侧是可选中的滚动文本，长度不影响可读性。
         */
        const val DETAIL_LIMIT = 800

        /** 读回特权进程日志时只取尾部这么多行：异常栈第一行才是重点。 */
        const val LOG_TAIL_LINES = 12
        const val LOG_READ_TIMEOUT_MS = 2_000L

        /**
         * 从 logcat 捞特权进程死亡原因。
         *
         * 只挑与本次点火相关的几类行：进程自己的 tag、`app_process` 的 C++ 输出、
         * ART 的崩溃日志、SELinux 拒绝。不限这几类的话，`-t 400` 会被系统噪声占满，
         * 真正的原因反而被 tail 截掉。
         */
        const val DIAG_LOG_COMMAND =
            "logcat -d -t 400 -v brief 2>/dev/null | " +
                "grep -iE 'supass|app_process|AndroidRuntime|avc: denied|Fatal signal' | " +
                "tail -n $LOG_TAIL_LINES"

        /** 把多行日志压成单行，避免详情里的换行把页面顶高。 */
        val WHITESPACE = Regex("\\s+")
    }
}
