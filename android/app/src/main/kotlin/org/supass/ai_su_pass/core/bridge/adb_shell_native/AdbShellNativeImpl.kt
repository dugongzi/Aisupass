package org.supass.ai_su_pass.core.bridge.adb_shell_native

import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.provider.Settings
import android.util.Log
import org.supass.ai_su_pass.core.adb.AdbConnectionManager
import org.supass.ai_su_pass.core.adb.AdbShellChannel
import org.supass.ai_su_pass.core.adb.ExecChunkResult
import org.supass.ai_su_pass.core.adb.ExecJob
import org.supass.ai_su_pass.core.adb.PairingNotification
import org.supass.ai_su_pass.core.shell.ShellResult
import org.supass.ai_su_pass.core.shell.ShellStatus
import java.io.File
import java.util.UUID
import java.util.concurrent.Executors
import java.util.concurrent.LinkedBlockingQueue
import java.util.concurrent.TimeUnit

/**
 * 无线 ADB 配对与 shell 连接的原生实现。
 *
 * 只做两件事：
 * 1. 配对：把系统「使用配对码配对设备」给出的 6 位码换成本机公钥的信任，
 *    再用 `adb-tls-connect` 建链；
 * 2. 读状态：连接是否活着、当前 uid 是多少。
 *
 * 不持有常驻进程，不在设备上留任何东西；配对成功后本机就是一条普通的
 * `adb shell`（uid=2000）连接。
 *
 * 契约要求：
 * 1. 只回证据与原因码，不返回成败结论；
 * 2. 任何失败都走结构化返回值，不向 Dart 抛异常；
 * 3. 回调统一切回主线程。
 */
class AdbShellNativeImpl(private val context: Context) : AdbShellNative {

    private val executor = Executors.newSingleThreadExecutor()
    private val mainHandler = Handler(Looper.getMainLooper())

    /**
     * 命令执行专用线程。
     *
     * [AdbShellChannel.exec] 会阻塞到命令结束；若与配对轮询共用 [executor]，
     * 一条 `sleep 30` 就能让配对进度停更。单线程串行还顺带挡住了连点并发。
     */
    private val execExecutor = Executors.newSingleThreadExecutor()

    /** 唯一的身份来源：应用内无线调试自配对，不需要用户安装任何外部 App。 */
    private val adb = AdbShellChannel(AdbConnectionManager(context))

    /**
     * 配对码输入通知。
     *
     * 配对码不能在本 App 的界面里输入：切到本 App 会让系统「使用配对码配对设备」
     * 对话框失效、配对码作废。通知栏是 SystemUI 的覆盖窗口，不改变前台 Activity，
     * 只有它能承载「不切屏的输入框」。
     */
    private val pairingNotification = PairingNotification(context)

    /** 配对会话表；配对是长动作，跑在独立线程里，轮询只读快照。 */
    private val pairingLock = Any()
    private val pairingSessions = LinkedHashMap<String, PairingJob>()

    /**
     * 流式执行会话表。
     *
     * 与配对会话一样只活到命令结束：收尾的那次 [pollExec] 顺手把它摘掉，
     * 不额外开清扫线程——终端同时最多跑一两条命令，留着也只是几个空壳。
     */
    private val execLock = Any()
    private val execSessions = LinkedHashMap<String, ExecJob>()

    /** 会话编号；只在 [execExecutor] 单线程里自增，不需要同步。 */
    private var execSeq = 0L

    /**
     * 取增量的专用线程。
     *
     * [ExecJob.poll] 会把已交付的字节从缓冲里**摘走**，两个 poll 并发跑就会把同一段
     * 输出切成两半。Pigeon 的调用线程不保证串行，所以自己收敛到单线程。
     *
     * 也不能复用 [executor] 与 [execExecutor]：前者被 `connection()` 这类即时调用
     * 共用，后者会被一条长 `exec` 整个占住，轮询就会跟着停摆。
     */
    private val pollExecutor = Executors.newSingleThreadExecutor()

    override fun connection(callback: (Result<ShellConnection>) -> Unit) {
        executor.execute {
            val connected = adb.status() == ShellStatus.READY
            val result = ShellConnection(
                connected = connected,
                uid = if (connected) adb.uid else UNKNOWN_UID,
            )
            mainHandler.post { callback(Result.success(result)) }
        }
    }

    override fun startPairing(
        host: String,
        port: Long,
        code: String,
        callback: (Result<PairingStartResult>) -> Unit,
    ) {
        val trimmedHost = host.trim()
        val trimmedCode = code.trim()

        // 三参数全空 = 通知栏模式：配对码在通知里输入，地址与端口由 mDNS 自动发现。
        // 这是默认路径——让用户切回 App 抄 IP 再输码，系统配对对话框会直接失效。
        val notificationMode = trimmedHost.isEmpty() && port == 0L && trimmedCode.isEmpty()
        Log.i(
            TAG,
            "startPairing mode=${if (notificationMode) "notification" else "manual"} " +
                "host='$trimmedHost' port=$port codeLen=${trimmedCode.length}",
        )
        // 半填状态（例如只给码不给地址）是调用方拼错参数，直接拒绝，不要进后台白跑一轮。
        if (!notificationMode &&
            (trimmedHost.isEmpty() || port !in 1L..65535L || trimmedCode.isEmpty())
        ) {
            Log.w(TAG, "startPairing rejected: incomplete manual parameters")
            mainHandler.post {
                callback(
                    Result.success(
                        PairingStartResult(
                            accepted = false,
                            sessionId = "",
                            reasons = listOf(PairingReasons.HOST_PAIRING_FAILED),
                        ),
                    ),
                )
            }
            return
        }

        val job = PairingJob(
            session = PairingSession("pair-${UUID.randomUUID()}").apply {
                // 通知模式要等用户去系统设置里操作，窗口必须比手动模式宽得多。
                timeoutMs = if (notificationMode) NOTIFICATION_TIMEOUT_MS else PAIRING_TIMEOUT_MS
            },
            mode = if (notificationMode) PairingMode.NOTIFICATION else PairingMode.MANUAL,
            host = trimmedHost,
            port = port.toInt(),
            code = trimmedCode,
        )

        synchronized(pairingLock) {
            if (pairingSessions.size >= MAX_PAIRING_SESSIONS) {
                // 先淘汰已收尾的；全是进行中的话就淘汰最早的那个。
                val victim = pairingSessions.entries.firstOrNull { it.value.session.finished }
                    ?: pairingSessions.entries.firstOrNull()
                victim?.let { pairingSessions.remove(it.key) }
            }
            pairingSessions[job.session.sessionId] = job
        }

        // 配对 + mDNS 发现最坏要十几秒，不能占用共享的 executor，
        // 否则连 connection 这种只读调用也会被一起堵住。
        Thread(
            {
                if (job.mode == PairingMode.NOTIFICATION) {
                    runNotificationPairing(job)
                } else {
                    runPairing(job)
                }
            },
            PAIRING_THREAD_NAME,
        ).apply {
            isDaemon = true
            start()
        }

        mainHandler.post {
            callback(
                Result.success(
                    PairingStartResult(
                        accepted = true,
                        sessionId = job.session.sessionId,
                        reasons = emptyList(),
                    ),
                ),
            )
        }
    }

    /**
     * 打开系统的「开发者选项 → 无线调试」页面。
     *
     * 只负责跳转，不改任何系统开关：配对码必须由用户在系统页面里生成，本 App
     * 代劳不了。返回值只说明「Intent 是否发出去了」，页面里到底显示了什么由用户看。
     */
    override fun openWirelessDebuggingSettings(callback: (Result<Boolean>) -> Unit) {
        val opened = launchWirelessDebuggingSettings()
        mainHandler.post { callback(Result.success(opened)) }
    }

    override fun pollPairing(sessionId: String, callback: (Result<PairingSnapshot>) -> Unit) {
        executor.execute {
            val job = synchronized(pairingLock) { pairingSessions[sessionId] }
            val snapshot = when {
                job == null -> PairingSnapshot(
                    sessionId = sessionId,
                    stage = PairingStage.DONE,
                    reason = PairingReasons.HOST_PAIRING_FAILED,
                    detail = "unknown session",
                    finished = true,
                )
                // 重启判定必须早于超时：设备重启后配对线程随进程消失，会话停在
                // 最后一条快照上，单调钟归零让 `timedOut` 永远不成立。
                !job.session.finished && job.session.rebootedSinceStart -> {
                    Log.w(TAG, "pollPairing: session $sessionId rebooted, forcing finish")
                    job.session.fail(PairingReasons.DEVICE_REBOOTED, "device rebooted")
                    job.session.snapshot()
                }
                job.session.timedOut && !job.session.finished -> {
                    // 配对线程可能还卡在 TLS 握手或 mDNS 发现里收不回来；
                    // 这里先给上层一个终态，避免 Dart 无限轮询。
                    Log.w(TAG, "pollPairing: session $sessionId timed out, forcing finish")
                    job.session.fail(PairingReasons.PAIRING_TIMEOUT, "timed out")
                    job.session.snapshot()
                }
                else -> job.session.snapshot()
            }
            mainHandler.post { callback(Result.success(snapshot)) }
        }
    }

    override fun cancelPairing(sessionId: String, callback: (Result<Unit>) -> Unit) {
        val job = synchronized(pairingLock) { pairingSessions[sessionId] }
        job?.session?.cancel()
        mainHandler.post { callback(Result.success(Unit)) }
    }

    override fun exec(
        command: String,
        timeoutMs: Long,
        stdin: ByteArray?,
        callback: (Result<ShellExecResult>) -> Unit,
    ) {
        val trimmed = command.trim()
        if (trimmed.isEmpty()) {
            mainHandler.post {
                callback(Result.success(unstarted("empty command")))
            }
            return
        }

        // 超时必须夹在区间内：0 会让命令立刻被掐断，过大则会长期占住连接。
        val budget = timeoutMs.coerceIn(MIN_EXEC_TIMEOUT_MS, MAX_EXEC_TIMEOUT_MS)
        execExecutor.execute {
            val payload = runCatching { adb.exec(trimmed, budget, stdin) }
                .fold(
                    onSuccess = { it.toPayload() },
                    onFailure = { unstarted("exec failed: ${it.javaClass.simpleName}") },
                )
            Log.i(
                TAG,
                "exec exit=${payload.exitCode} ms=${payload.durationMs} timedOut=${payload.timedOut} " +
                    "stdout=${payload.stdout.length}c stderr=${payload.stderr.length}c",
            )
            mainHandler.post { callback(Result.success(payload)) }
        }
    }

    override fun startExec(
        command: String,
        timeoutMs: Long,
        callback: (Result<ExecStartResult>) -> Unit,
    ) {
        val trimmed = command.trim()
        if (trimmed.isEmpty()) {
            mainHandler.post { callback(Result.success(execRejected(ExecReasons.EMPTY_COMMAND))) }
            return
        }

        // 负值与 0 表示「不限时」，用于常驻交互 shell：这种会话必须一直活着，
        // 一旦被超时掐断，用户 `cd` 过去的目录、`export` 的变量全都没了。
        // 正数才按普通命令夹取（过小会被系统开销吃光，过大则长期占住连接）。
        val budget = if (timeoutMs <= 0L) UNBOUNDED_TIMEOUT else timeoutMs.coerceIn(MIN_EXEC_TIMEOUT_MS, MAX_EXEC_TIMEOUT_MS)
        // 开流会阻塞（要等 adbd 分配流），放进 execExecutor 排队，顺带挡住并发。
        execExecutor.execute {
            val result = try {
                if (adb.status() != ShellStatus.READY) {
                    Log.w(TAG, "startExec rejected: channel not ready")
                    execRejected(ExecReasons.CHANNEL_NOT_READY)
                } else {
                    val sessionId = "exec-${++execSeq}"
                    // 流式会话一律走 pty：界面就是终端，需要回显、行编辑、SIGINT、
                    // 窗口尺寸与 ANSI 控制序列。一次性 exec() 仍留在 raw（见 ShellProtocol）。
                    val job = ExecJob(sessionId, trimmed, adb.openPtyStream(trimmed), budget)
                    synchronized(execLock) {
                        pruneExecSessions()
                        execSessions[sessionId] = job
                    }
                    // 读线程从这里起跑，之后输出全由 pollExec 增量取走。
                    job.start()
                    Log.i(
                        TAG,
                        "startExec accepted session=$sessionId " +
                            "timeout=${if (budget > 0) "${budget}ms" else "unbounded"} " +
                            "cmd='${trimmed.take(LOG_SNIPPET)}'",
                    )
                    ExecStartResult(accepted = true, sessionId = sessionId, reasons = emptyList())
                }
            } catch (t: Throwable) {
                // 开流被拒 / 连接恰好断开：命令根本没跑起来。这里按「不受理」回，
                // 不能建一个永远不会有输出的会话让上层一直轮询。
                Log.w(TAG, "startExec failed to open stream: ${t.javaClass.simpleName}")
                execRejected(ExecReasons.STREAM_OPEN_FAILED)
            }
            mainHandler.post { callback(Result.success(result)) }
        }
    }

    override fun pollExec(sessionId: String, callback: (Result<ExecChunk>) -> Unit) {
        pollExecutor.execute {
            val job = synchronized(execLock) { execSessions[sessionId] }
            val chunk = if (job == null) {
                // 会话不存在：要么本来就传错，要么上一次已经拿到 finished 被回收了。
                // 统一回一个终态，避免上层陷入「永远轮询一个死会话」。
                ExecChunk(
                    sessionId = sessionId,
                    stdout = "",
                    stderr = UNKNOWN_SESSION,
                    finished = true,
                    exitCode = EXIT_NOT_STARTED.toLong(),
                    timedOut = false,
                    durationMs = 0L,
                    droppedBytes = 0L,
                    failure = UNKNOWN_SESSION,
                )
            } else {
                val snapshot = job.poll()
                // finished 之后再无人取增量，就地回收，免得表里攒一堆空壳。
                if (snapshot.finished) synchronized(execLock) { execSessions.remove(sessionId) }
                snapshot.toPayload()
            }
            mainHandler.post { callback(Result.success(chunk)) }
        }
    }

    override fun writeExecStdin(
        sessionId: String,
        data: ByteArray,
        callback: (Result<Boolean>) -> Unit,
    ) {
        val job = synchronized(execLock) { execSessions[sessionId] }
        // false = 会话已结束或 stdin 已关；调用方据此停止喂输入，不要重试。
        val accepted = job?.writeStdin(data) ?: false
        mainHandler.post { callback(Result.success(accepted)) }
    }

    override fun resizeExec(
        sessionId: String,
        rows: Long,
        cols: Long,
        callback: (Result<Unit>) -> Unit,
    ) {
        val job = synchronized(execLock) { execSessions[sessionId] }
        // 尺寸变化只影响远端排版，丢了也无害；主要用途是让全屏程序（top/vi）
        // 和长输出的折行跟本地视口一致。
        // 契约里的 int 走 Pigeon 会变成 Long（Dart 侧是 64 位），而 pty 的
        // winsize 是 16 位字段，这里先夹到合理范围再转 Int：越界的视口尺寸
        // 只会让远端按错误的列宽折行，不如直接丢掉。
        val safeRows = rows.coerceIn(1L, MAX_WINSIZE.toLong()).toInt()
        val safeCols = cols.coerceIn(1L, MAX_WINSIZE.toLong()).toInt()
        val applied = job?.resize(safeRows, safeCols) ?: false
        if (!applied) Log.d(TAG, "resizeExec session=$sessionId dropped rows=$rows cols=$cols")
        mainHandler.post { callback(Result.success(Unit)) }
    }

    override fun cancelExec(sessionId: String, callback: (Result<Unit>) -> Unit) {
        val job = synchronized(execLock) { execSessions[sessionId] }
        // 只发中断不删表：pty 下这一步是往 stdin 写 ^C，会话本身还活着（sh 会打新提示符），
        // 之后仍要靠 pollExec 取走残留输出；万一远端不理会 SIGINT，ExecJob 会自行关流。
        job?.cancel()
        Log.i(TAG, "cancelExec session=$sessionId found=${job != null}")
        mainHandler.post { callback(Result.success(Unit)) }
    }

    /** 内部结果 → 契约结果。两者字段一一对应，只换承载类型。 */
    private fun ShellResult.toPayload(): ShellExecResult = ShellExecResult(
        exitCode = exitCode.toLong(),
        stdout = stdout,
        stderr = stderr,
        durationMs = durationMs,
        timedOut = timedOut,
    )

    /** 流式增量 → 契约结果。同样是字段一一对应，只换承载类型。 */
    private fun ExecChunkResult.toPayload(): ExecChunk = ExecChunk(
        sessionId = sessionId,
        stdout = stdout,
        stderr = stderr,
        finished = finished,
        exitCode = exitCode.toLong(),
        timedOut = timedOut,
        durationMs = durationMs,
        droppedBytes = droppedBytes,
        failure = failure,
    )

    /** 会话没能开起来时的统一返回：只回原因码，不向 Dart 抛异常。 */
    private fun execRejected(reason: String): ExecStartResult = ExecStartResult(
        accepted = false,
        sessionId = "",
        reasons = listOf(reason),
    )

    /**
     * 挤掉会话表里的旧条目，保证新建会话一定进得去。
     *
     * 顺序是「先清已结束的，再淘汰最早的」：正常使用下第一步就够，
     * 走到第二步只可能是上层漏了收尾（连续 start 却没有 poll 到 finished）。
     * 被淘汰的会话必须先 [ExecJob.cancel] 关流，否则它的读线程会一直挂着。
     *
     * 调用方必须已持有 [execLock]。
     */
    private fun pruneExecSessions() {
        execSessions.entries.removeAll { it.value.finished }
        while (execSessions.size >= MAX_EXEC_SESSIONS) {
            val victim = execSessions.entries.firstOrNull() ?: return
            execSessions.remove(victim.key)
            Log.w(TAG, "pruneExecSessions: evicting ${victim.key}")
            victim.value.cancel()
        }
    }

    /**
     * 读原生库解压目录。
     *
     * 只在 `extractNativeLibs=true`（本工程走 `useLegacyPackaging = true`）时有值：
     * 此时 PackageManager 会把 jniLibs 里的 so 解压到该目录，权限为
     * `apk_data_file`，shell（uid=2000）既读得到也 dlopen 得动，
     * 于是注入不需要再把字节搬进 `/data/local/tmp`。
     *
     * 目录不可用时回空串——注入前必须据此拦一次，否则错误会伪装成「so 不存在」。
     */
    override fun nativeLibraryDir(callback: (Result<String>) -> Unit) {
        val dir = context.applicationInfo.nativeLibraryDir.orEmpty()
        val usable = dir.isNotEmpty() && File(dir).isDirectory
        Log.i(TAG, "nativeLibraryDir='$dir' usable=$usable")
        mainHandler.post { callback(Result.success(if (usable) dir else "")) }
    }

    /** 命令没能跑起来时的统一返回：只回证据，不向 Dart 抛异常。 */
    private fun unstarted(message: String): ShellExecResult = ShellExecResult(
        exitCode = EXIT_NOT_STARTED.toLong(),
        stdout = "",
        stderr = message,
        durationMs = 0L,
        timedOut = false,
    )

    /**
     * 通知栏输入模式的配对：先在通知里等用户输入 6 位码，再发现端点、走正常配对。
     *
     * 为什么不让 Dart 传码进来：系统的「使用配对码配对设备」对话框属于 Settings，
     * 一旦把本 App 切到前台就会失效、配对码作废。通知栏是 SystemUI 的覆盖窗口，
     * 不改变前台 Activity，是唯一能承载「不切屏输入框」的载体。
     */
    private fun runNotificationPairing(job: PairingJob) {
        val session = job.session
        if (!pairingNotification.show { code -> job.codeQueue.offer(code) }) {
            // 通知权限没给，流程根本开不了头；立刻收尾，别让 Dart 白轮询五分钟。
            Log.w(TAG, "notification pairing aborted: notification not posted")
            session.fail(PairingReasons.HOST_PAIRING_FAILED, "notification not posted")
            return
        }
        Log.i(TAG, "notification pairing: notification posted, waiting for code")

        // 发现必须和「等用户输码」并行：`_adb-tls-pairing._tcp` 只在系统配对对话框
        // 打开期间广播，等用户提交完码再开始发现，对话框往往已经关闭、服务已停止广播。
        val discovery = adb.startPairingDiscovery()
        Log.i(TAG, "notification pairing: mdns discovery started in parallel")

        try {
            var foundNotified = false
            val deadline = System.currentTimeMillis() + NOTIFICATION_CODE_WAIT_MS
            while (true) {
                if (session.cancelled) {
                    session.fail(PairingReasons.CANCELLED, "cancelled")
                    return
                }
                val remaining = deadline - System.currentTimeMillis()
                if (remaining <= 0L) break
                // 分片等待，好让「端点已发现 / 已消失」这些节点能及时反馈到通知栏。
                val code = job.codeQueue.poll(minOf(POLL_SLICE_MS, remaining), TimeUnit.MILLISECONDS)

                // 端点出现时立刻反馈，用户才知道 mDNS 那一路是通的。
                val endpointNow = discovery.endpoint
                if (!foundNotified && endpointNow != null) {
                    foundNotified = true
                    Log.i(TAG, "notification pairing: pairing endpoint found $endpointNow")
                    pairingNotification.markDeviceFound()
                }

                // 配对服务（= 系统「使用配对码配对设备」对话框）消失后，之前发现的端口
                // 立即作废。先把通知切回「请重新打开配对弹窗」，并让「已找到设备」
                // 的提示可以在对话框重开时再次触发。
                if (foundNotified && discovery.endpoint == null) {
                    foundNotified = false
                    Log.w(TAG, "notification pairing: pairing service lost, waiting for dialog to reopen")
                    pairingNotification.markPairingDialogClosed()
                }
                if (code == null) continue

                Log.i(TAG, "notification pairing: code received len=${code.length}")

                // 正常情况下这里立刻能读到端点；给一点宽限是因为用户可能恰好在
                // 对话框刚打开、mDNS 还没解析完时提交。
                val endpoint = discovery.await(ENDPOINT_GRACE_MS)
                if (endpoint == null) {
                    // 端点不存在 = 配对对话框已经关闭：这串码随配对端口一起作废。
                    // 绝不能拿旧端口去握手（只会 ECONNREFUSED，还白白消耗一次码），
                    // 保留输入入口，等用户重开弹窗后输新码。
                    Log.w(
                        TAG,
                        "notification pairing: endpoint gone before pairing, requesting a new code",
                    )
                    job.codeQueue.clear()
                    foundNotified = false
                    pairingNotification.markPairingDialogClosed()
                    continue
                }

                job.host = endpoint.address.hostAddress.orEmpty()
                job.port = endpoint.port
                job.code = code
                Log.i(TAG, "notification pairing: endpoint resolved to ${job.host}:${job.port}")
                runPairing(job)
                return
            }
            Log.w(
                TAG,
                "notification pairing: no code within ${NOTIFICATION_CODE_WAIT_MS}ms, " +
                    "discovery=${discovery.error ?: "stillRunning"}",
            )
            session.fail(PairingReasons.PAIRING_TIMEOUT, "no code received")
        } catch (_: InterruptedException) {
            Log.w(TAG, "notification pairing interrupted")
            Thread.currentThread().interrupt()
            session.fail(PairingReasons.CANCELLED, "interrupted")
        } finally {
            discovery.close()
            // 无论成败都要撤通知：配对码用过即作废，留着只会让人重复输入。
            Log.i(TAG, "notification pairing finished, dismissing notification")
            pairingNotification.dismiss()
            session.finish()
        }
    }

    /**
     * 配对工作流：交换配对码 → 发现连接端点并建链。
     *
     * 只写原因码，不判定成败；成功与否由 Dart 侧读 `finished` + `reason` 判定。
     */
    private fun runPairing(job: PairingJob) {
        val session = job.session
        val startedAt = SystemClock.elapsedRealtime()
        Log.i(
            TAG,
            "runPairing begin host='${job.host}' port=${job.port} codeLen=${job.code.length}",
        )
        try {
            session.advance(PairingStage.PAIRING)
            if (!adb.prepare()) {
                Log.w(TAG, "runPairing: credentials unavailable")
                session.fail(PairingReasons.HOST_PAIRING_FAILED, CREDENTIALS_UNAVAILABLE)
                return
            }
            if (!adb.canReach(job.host, job.port)) {
                // 配对端口不通，基本就是地址抄错或无线调试没开；
                // 先回 disconnected，别让用户白等一次握手超时。
                Log.w(TAG, "runPairing: pairing port unreachable ${job.host}:${job.port}")
                session.fail(PairingReasons.HOST_DISCONNECTED, "port unreachable")
                return
            }
            Log.i(TAG, "runPairing: pairing port reachable, starting spake2")

            val paired = adb.pair(job.host, job.port, job.code)
            Log.i(
                TAG,
                "runPairing: pair=$paired error=${adb.lastError ?: "-"} " +
                    "elapsed=${SystemClock.elapsedRealtime() - startedAt}ms",
            )
            if (!paired) {
                session.fail(PairingReasons.HOST_PAIRING_FAILED, adb.lastError ?: UNKNOWN_ERROR)
                return
            }

            // 配对端口与连接端口不是同一个：配对成功后必须重新发现 `adb-tls-connect` 端点。
            session.advance(PairingStage.CONNECTING)
            Log.i(TAG, "runPairing: discovering adb-tls-connect endpoint")
            val connected = adb.connectDiscovered(PAIRING_DISCOVERY_TIMEOUT_MS)
            Log.i(
                TAG,
                "runPairing: connect=$connected error=${adb.lastError ?: "-"} " +
                    "uid=${adb.uid} elapsed=${SystemClock.elapsedRealtime() - startedAt}ms",
            )
            if (!connected) {
                session.fail(connectFailureReason(), adb.lastError ?: UNKNOWN_ERROR)
                return
            }
            // 建链成功即收尾：配对只负责建链这一件事。
            session.finish()
        } catch (t: Throwable) {
            // 库内部任何未预料的异常都收敛成结构化原因，绝不向 Pigeon 抛。
            Log.e(TAG, "runPairing threw", t)
            session.fail(PairingReasons.HOST_PAIRING_FAILED, t.javaClass.simpleName)
        } finally {
            Log.i(TAG, "runPairing done elapsed=${SystemClock.elapsedRealtime() - startedAt}ms")
            session.finish()
        }
    }

    /** 连接阶段失败时区分「设备拒绝授权」与「网络 / 发现失败」。 */
    private fun connectFailureReason(): String =
        if (adb.lastError == AUTH_FAILED_EXCEPTION) {
            PairingReasons.HOST_AUTH_FAILED
        } else {
            PairingReasons.HOST_DISCONNECTED
        }

    /**
     * 把用户送到「开发者选项 → 无线调试」页面。
     *
     * 按「越精确越靠前」试一串候选入口：各家 ROM 都改过设置页，同一个入口在
     * 这台机器能用、在那台被裁掉，逐个 fallback 比赌一个稳。被裁掉的入口会抛
     * `ActivityNotFoundException` / `SecurityException`，这里一律吞掉换下一个。
     * 全都不行就回 `false`，让上层继续提示用户手动前往，不能假装已经跳过去了。
     *
     * 为什么不直接点开系统的「使用配对码配对设备」弹窗：那个弹窗没有对外 action，
     * 能落到的只有无线调试页面，由用户自己点一下。
     */
    private fun launchWirelessDebuggingSettings(): Boolean {
        val candidates = listOf(
            // 1. 系统内置 action：Pixel / AOSP 上直接落到无线调试页面。
            Intent(ACTION_WIRELESS_DEBUGGING_SETTINGS),
            // 2. AOSP 与多数 OEM 都保留的页面类名。
            Intent().setClassName(SETTINGS_PACKAGE, WIRELESS_DEBUGGING_ACTIVITY),
            // 3. 类名被改名时，退回通用 SubSettings + 目标 Fragment。
            Intent()
                .setClassName(SETTINGS_PACKAGE, SUBSETTINGS_ACTIVITY)
                .putExtra(SETTINGS_SHOW_FRAGMENT, WIRELESS_DEBUGGING_FRAGMENT),
            // 4. 再退一步：Fragment 类名也变了的老版本。
            Intent()
                .setClassName(SETTINGS_PACKAGE, SUBSETTINGS_ACTIVITY)
                .putExtra(SETTINGS_SHOW_FRAGMENT, ADB_WIRELESS_DEBUGGING_FRAGMENT),
            // 5. 最差情况：开发者选项首页，用户自己再点一下「无线调试」。
            Intent(Settings.ACTION_APPLICATION_DEVELOPMENT_SETTINGS),
        )

        for (base in candidates) {
            // 从应用上下文启动必须带 NEW_TASK，否则直接抛 AndroidRuntimeException。
            val intent = Intent(base).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            try {
                context.startActivity(intent)
                Log.i(TAG, "openWirelessDebuggingSettings ok: ${base.toShortString()}")
                return true
            } catch (e: Exception) {
                Log.w(
                    TAG,
                    "openWirelessDebuggingSettings failed: ${base.toShortString()} " +
                        "reason=${e.javaClass.simpleName}",
                )
            }
        }
        Log.w(TAG, "openWirelessDebuggingSettings: no candidate accepted by this ROM")
        return false
    }

    /** 断开连接、撤通知并停掉后台线程，由 [org.supass.ai_su_pass.NativeProvider] 调用。 */
    fun dispose() {
        Log.i(TAG, "dispose")
        // 页面已销毁，通知留着也没人收结果，一并撤掉。
        pairingNotification.dismiss()
        // 流式会话的读线程不会自己退，先逐个关流；否则断开连接后它们会各自
        // 抛一次异常再收尾，logcat 里留下一片无意义的堆栈。
        val leftovers = synchronized(execLock) {
            execSessions.values.toList().also { execSessions.clear() }
        }
        leftovers.forEach { it.cancel() }
        // 只断连接，不 close()：close() 会 destroy 掉当前私钥对象。
        adb.disconnect()
        executor.shutdownNow()
        execExecutor.shutdownNow()
        pollExecutor.shutdownNow()
    }

    /** 配对输入方式。 */
    private enum class PairingMode {
        /** Dart 已给出地址、端口与配对码（手动抄写）。 */
        MANUAL,

        /** 只等用户在通知栏输入配对码，地址与端口由 mDNS 发现。 */
        NOTIFICATION,
    }

    /** 一次配对请求的可变参数：通知模式下 host/port/code 要等用户输入后才填上。 */
    private class PairingJob(
        val session: PairingSession,
        val mode: PairingMode,
        var host: String,
        var port: Int,
        var code: String,
    ) {
        /** 通知栏回传的配对码；容量 1 即够，重复输入只保留最新一条。 */
        val codeQueue = LinkedBlockingQueue<String>(1)
    }

    private companion object {
        /** logcat 过滤标签；配对链路的每一步都往这里打，出问题直接看这一条。 */
        const val TAG = "AdbShell"

        const val PAIRING_THREAD_NAME = "adb-pairing"
        const val MAX_PAIRING_SESSIONS = 8
        const val UNKNOWN_UID = -1L

        /** 同时存活的流式会话上限；终端只会跑一两条，4 已足够宽裕。 */
        const val MAX_EXEC_SESSIONS = 4

        /**
         * 「不限时」的哨兵值。
         *
         * 用 0 而不是 `Long.MAX_VALUE`：`elapsedRealtime() + MAX_VALUE` 会溢出成负数，
         * 看守线程第一轮就判超时。0 走「不起看守」分支，不参与任何加法。
         */
        const val UNBOUNDED_TIMEOUT = 0L

        /** 会话查不到时的说明，写进 stderr / failure，供上层区分「真没输出」与「查错会话」。 */
        const val UNKNOWN_SESSION = "unknown session"

        /**
         * pty `winsize` 里行列字段的实际上限。
         *
         * 内核结构体是 `unsigned short`，超出会被截断成莫名其妙的列宽；而
         * Dart 侧的 int 是 64 位，经 Pigeon 原样变成 Long 传进来，必须自己夹。
         */
        const val MAX_WINSIZE = 10_000

        /** 日志里截取命令片段的长度，避免一条日志刷满屏幕。 */
        const val LOG_SNIPPET = 120

        /** 整条配对流程上限：可达性 3s + 握手 + mDNS 发现 15s 的宽松余量。 */
        const val PAIRING_TIMEOUT_MS = 60_000L

        /** 通知栏模式下等用户输码的上限：要切到设置里点开配对弹窗，必须给足时间。 */
        const val NOTIFICATION_CODE_WAIT_MS = 5 * 60_000L

        /**
         * 等码期间的分片轮询粒度。
         *
         * 必须分片而不是一次 `poll(5min)`：端点发现是并行的，只有每隔一小段时间
         * 回来看一眼，才能及时把「已找到设备」反馈到通知栏。500ms 既不空转占 CPU，
         * 也足够让用户感知到变化。
         */
        const val POLL_SLICE_MS = 500L

        /** 通知栏模式的会话总上限，必须大于「等码 + 发现 + 握手」，否则会先被轮询判超时。 */
        const val NOTIFICATION_TIMEOUT_MS = NOTIFICATION_CODE_WAIT_MS + 120_000L

        /** mDNS 发现 `adb-tls-connect` 端点的等待上限。 */
        const val PAIRING_DISCOVERY_TIMEOUT_MS = 15_000L

        /**
         * 提交配对码后，等 `adb-tls-pairing` 端点的宽限。
         *
         * 正常情况下发现是并行的、端点早就有了，这里几乎立即返回；留 3 秒只是为了
         * 覆盖「对话框刚开、mDNS 还没解析完」的极短窗口。超过说明对话框已关闭。
         */
        const val ENDPOINT_GRACE_MS = 3_000L

        const val CREDENTIALS_UNAVAILABLE = "credentialsUnavailable"
        const val UNKNOWN_ERROR = "unknown"

        /** 命令没跑起来（通道未连接、流未建立、被超时前关闭）。 */
        const val EXIT_NOT_STARTED = -1

        /** 单条命令的超时区间：下限防误传 0 立刻掐断，上限防误传天文数字占住连接。 */
        const val MIN_EXEC_TIMEOUT_MS = 1_000L

        /**
         * 上限取 15 分钟，留足长任务的余量。
         *
         * 载荷的重试节奏是 `EXPLOIT_ATTEMPTS=24` × `EXPLOIT_ATTEMPT_TIMEOUT_SEC=120`，
         * 上限若定在 120 秒，第一轮还没跑完就会被掐断。
         *
         * 提权链路目前是「后台起 + 轮询日志」，单条命令都在秒级，用不到这个
         * 上限；留着它只是为了不把调用方传的大值静默削小。控制台那条命令
         * 传 20 秒，不受影响。
         */
        const val MAX_EXEC_TIMEOUT_MS = 900_000L

        /** libadb 在设备未授权时抛的异常类名，用来把失败归到 `hostAuthFailed`。 */
        const val AUTH_FAILED_EXCEPTION = "AdbAuthenticationFailedException"

        /**
         * 「无线调试」页面的隐藏 action。
         *
         * 不在 `android.provider.Settings` 里公开，但 AOSP Settings 的
         * `WirelessDebuggingActivity` 挂了同名 intent-filter，Pixel 与多数 OEM 一直保留。
         */
        const val ACTION_WIRELESS_DEBUGGING_SETTINGS = "android.settings.WIRELESS_DEBUGGING_SETTINGS"

        /** 设置应用的包名；各家 OEM 的自定义设置一般也沿用这个包名。 */
        const val SETTINGS_PACKAGE = "com.android.settings"

        /** 无线调试页面的类名（AOSP / Pixel / MIUI 等）。 */
        const val WIRELESS_DEBUGGING_ACTIVITY = "com.android.settings.Settings\$WirelessDebuggingActivity"

        /** 通用二级设置容器，配合 `:settings:show_fragment` 直接塞 Fragment。 */
        const val SUBSETTINGS_ACTIVITY = "com.android.settings.SubSettings"

        /** Settings 内部用来指定目标 Fragment 的 extra。 */
        const val SETTINGS_SHOW_FRAGMENT = ":settings:show_fragment"

        /** 新版本无线调试页面 Fragment。 */
        const val WIRELESS_DEBUGGING_FRAGMENT = "com.android.settings.development.WirelessDebuggingFragment"

        /** 早期版本无线调试页面 Fragment（类名没改过来的 ROM 还停在这里）。 */
        const val ADB_WIRELESS_DEBUGGING_FRAGMENT =
            "com.android.settings.development.AdbWirelessDebuggingFragment"
    }
}
