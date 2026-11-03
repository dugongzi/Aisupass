package org.supass.ai_su_pass.core.adb

import android.os.SystemClock
import android.util.Log
import io.github.muntashirakon.adb.AdbStream
import org.supass.ai_su_pass.core.shell.ShellChannel
import org.supass.ai_su_pass.core.shell.ShellResult
import org.supass.ai_su_pass.core.shell.ShellStatus
import java.net.InetSocketAddress
import java.util.concurrent.atomic.AtomicReference

/**
 * 基于自建 ADB 连接（无线调试配对）的 shell 通道。
 *
 * 数据路径：`AdbStream("shell:<命令>")` → adbd 以 shell 身份执行 → 单条合并流回传。
 * 对 [ShellChannel] 之上的代码来说，身份从哪来完全无感。
 *
 * 两个必须自己补的坑：
 * 1. **退出码**：`AdbStream` 只给字节流，没有 `exitValue()`。这里在命令尾部追加
 *    `echo __AISUP_EXIT__:$?`，从输出里剥出退出码；剥不到就按「进程没跑起来」返回 -1。
 * 2. **超时**：`AdbStream.read` 没有读超时。这里把整个「打开流 + 读干」放进工作线程，
 *    主线程按超时 join；超时后 `close()` 流把读线程踢醒，再收尸。
 *
 * stderr 说明：adbd 的 v1 shell 服务把 stdout/stderr 合并成一条流，
 * 无法区分，因此统一放在 [ShellResult.stdout]，stderr 恒为空。
 */
internal class AdbShellChannel(
    private val manager: AdbConnectionManager,
) : ShellChannel {

    override val source: String get() = SOURCE

    /** 连接建立时探测一次身份并缓存；[uid] 本身不再执行命令。 */
    @Volatile
    private var identity: Long = UNKNOWN_UID

    /** 最近一次配对/连接失败的原因类名，供上层写证据。 */
    @Volatile
    var lastError: String? = null
        private set

    override fun status(): ShellStatus =
        if (runCatching { manager.isConnected }.getOrDefault(false)) {
            ShellStatus.READY
        } else {
            ShellStatus.NOT_CONNECTED
        }

    override val uid: Long get() = identity

    /**
     * 生成/读取磁盘上的配对密钥。
     *
     * 配对与连接复用同一套密钥，所以必须在 [pair] 之前成功；
     * 单独暴露出来是为了让失败能归到「凭据不可用」而不是笼统的配对失败。
     */
    fun prepare(): Boolean = runCatching { manager.ensureCredentials() }.getOrDefault(false)

    /** 短超时探测配对端口是否可达，避免地址填错时白等 TLS 握手超时。 */
    fun canReach(host: String, port: Int): Boolean = manager.canReach(host, port)

    /**
     * 用 mDNS 发现配对端点（`adb-tls-pairing`）。
     *
     * 供通知栏输入模式使用：用户只输 6 位码，地址与端口由系统广播自动发现，
     * 不需要从弹窗里抄 IP，也就不需要切屏。
     */
    fun discoverPairingEndpoint(timeoutMs: Long): InetSocketAddress? =
        manager.discoverPairingEndpoint(timeoutMs)

    /**
     * 启动持续发现并立刻返回句柄。
     *
     * 通知栏模式必须用这个：发现要和「等用户输码」并行，等码到再发现时系统配对
     * 对话框多半已经关闭，`_adb-tls-pairing._tcp` 已停止广播。
     */
    fun startPairingDiscovery(): PairingDiscovery = manager.startPairingDiscovery()

    /**
     * 配对：把 6 位配对码换成设备对本机公钥的信任。
     *
     * 注意配对端口与连接端口不是同一个，配对成功后还要重新发现连接端点。
     */
    fun pair(host: String, port: Int, code: String): Boolean {
        lastError = null
        return runCatching { manager.pairDevice(host, port, code) }
            .onFailure { lastError = it.javaClass.simpleName }
            .getOrDefault(false)
    }

    /** 配对后用 mDNS（`adb-tls-connect`）发现连接端点并建立 TLS 连接。 */
    fun connectDiscovered(timeoutMs: Long = DISCOVERY_TIMEOUT_MS): Boolean {
        lastError = null
        return runCatching { manager.connectDiscovered(timeoutMs) }
            .onFailure { lastError = it.javaClass.simpleName }
            .getOrDefault(false)
            .also { if (it) identity = probeIdentity() }
    }

    /** 已知连接端口时直接连接（无 mDNS）。 */
    fun connectDirect(host: String, port: Int): Boolean {
        lastError = null
        return runCatching { manager.connectDevice(host, port) }
            .onFailure { lastError = it.javaClass.simpleName }
            .getOrDefault(false)
            .also { if (it) identity = probeIdentity() }
    }

    /** 断开但保留磁盘凭据；下次连接会重新读密钥。 */
    fun disconnect() {
        manager.disconnectQuietly()
        identity = UNKNOWN_UID
    }

    override fun exec(command: String, timeoutMs: Long): ShellResult {
        val startedAt = SystemClock.elapsedRealtime()
        if (status() != ShellStatus.READY) {
            return ShellResult(EXIT_NOT_STARTED, "", "channel not ready", 0L, false)
        }

        val sink = StringBuilder()
        val streamRef = AtomicReference<AdbStream?>(null)
        val openFailure = AtomicReference<String?>(null)

        val worker = Thread({
            try {
                val stream = manager.openStream("shell:${wrapExecution(command)}")
                streamRef.set(stream)
                stream.openInputStream().bufferedReader(Charsets.UTF_8).use { reader ->
                    val buffer = CharArray(BUFFER_SIZE)
                    while (true) {
                        val read = reader.read(buffer)
                        if (read < 0) break
                        synchronized(sink) { sink.append(buffer, 0, read) }
                    }
                }
            } catch (t: Throwable) {
                // 超时被 close() 或设备掉线都走这里，统一记为打开/读取失败。
                openFailure.compareAndSet(null, t.javaClass.simpleName)
            } finally {
                runCatching { streamRef.get()?.close() }
            }
        }, "adb-shell-exec").apply {
            isDaemon = true
            start()
        }

        worker.join(timeoutMs)
        if (worker.isAlive) {
            // 超时：先关流让读线程退出，再收尸；不重试，避免把危险命令跑第二遍。
            runCatching { streamRef.get()?.close() }
            worker.join(STREAM_JOIN_MS)
            val text = currentText(sink)
            // 后台进程即使把 stdout/stderr 都重定向走，也可能有残留 fd 让 pty 不闭合，
            // 于是「命令早就跑完、退出码也回显了，流却等不到 EOF」。这种情况下
            // 标记其实就在输出里，丢掉它只会把结论错报成「没跑起来」。
            val parsed = parseExit(text)
            return ShellResult(
                exitCode = parsed.exitCode,
                stdout = parsed.stdout,
                stderr = if (parsed.exitCode == EXIT_NOT_STARTED) {
                    "timeout ${timeoutMs}ms, no exit marker"
                } else {
                    ""
                },
                durationMs = SystemClock.elapsedRealtime() - startedAt,
                timedOut = true,
            )
        }

        val text = currentText(sink)
        val failure = openFailure.get()
        val parsed = parseExit(text)
        if (parsed.exitCode == EXIT_NOT_STARTED) {
            // 退出码标记缺失说明命令根本没在 adbd 那边跑起来（流打开失败、设备掉线、
            // shell 被拒）。这里原本完全静默，上层只看到 exitCode=-1，无从判断原因。
            Log.w(
                TAG,
                "exec missing exit marker failure=${failure ?: "-"} exit=$EXIT_NOT_STARTED " +
                    "out='${text.take(LOG_SNIPPET)}'",
            )
            return ShellResult(
                exitCode = EXIT_NOT_STARTED,
                stdout = text,
                stderr = failure ?: "exit marker missing",
                durationMs = SystemClock.elapsedRealtime() - startedAt,
                timedOut = false,
            )
        }

        return ShellResult(
            exitCode = parsed.exitCode,
            stdout = parsed.stdout,
            stderr = "",
            durationMs = SystemClock.elapsedRealtime() - startedAt,
            timedOut = false,
        )
    }

    /**
     * 从流输出里剥出退出码与真正的 stdout。
     *
     * 标记缺失时返回 [EXIT_NOT_STARTED]，且 stdout 原样返回（保留现场）。
     */
    private fun parseExit(text: String): ExitParse {
        val markerIndex = text.lastIndexOf(EXIT_MARKER)
        if (markerIndex < 0) return ExitParse(EXIT_NOT_STARTED, text)
        val exitCode = text.substring(markerIndex + EXIT_MARKER.length)
            .trim()
            .toIntOrNull() ?: return ExitParse(EXIT_NOT_STARTED, text)
        return ExitParse(exitCode, text.substring(0, markerIndex).replace("\r\n", "\n"))
    }

    private class ExitParse(val exitCode: Int, val stdout: String)

    /**
     * 包一层外层 shell，顺带把退出码打进输出。
     *
     * adbd 会把 `shell:` 后面的整段字符串交给 `sh -c`，所以这里写的是
     * `sh -c '原命令'; echo __AISUP_EXIT__:$?`：内层执行原命令，外层负责回显退出码。
     * 原命令统一用单引号包裹，内部单引号按 POSIX 方式转义（`'\''`）。
     */
    private fun wrapExecution(command: String): String {
        val quoted = "'" + command.replace("'", "'\\''") + "'"
        return "sh -c $quoted; echo $EXIT_MARKER\$?"
    }

    /** 取身份：`id -u` 是 shell 用户 2000、root 模式 0。 */
    private fun probeIdentity(): Long {
        val result = exec("id -u", ID_TIMEOUT_MS)
        val uid = result.stdout.trim().toLongOrNull() ?: UNKNOWN_UID
        if (uid == UNKNOWN_UID) {
            // 连接已建立但取不到身份，说明 shell 流能开、命令却没回显，
            // 后续所有 exec 都会失败，这里必须留下现场。
            Log.w(
                TAG,
                "probeIdentity failed exit=${result.exitCode} " +
                    "out='${result.stdout.take(LOG_SNIPPET)}' err='${result.stderr}'",
            )
        }
        return uid
    }

    private fun currentText(sink: StringBuilder): String = synchronized(sink) { sink.toString() }

    private companion object {
        /** 与其他配对组件共用同一标签，便于一次过滤整条链路。 */
        const val TAG = "AdbShell"

        const val SOURCE = "adb"
        const val UNKNOWN_UID = -1L
        const val EXIT_NOT_STARTED = -1

        /** 日志里截取输出片段的长度，避免一条日志刷满屏幕。 */
        const val LOG_SNIPPET = 200
        const val BUFFER_SIZE = 4096
        const val STREAM_JOIN_MS = 300L
        const val ID_TIMEOUT_MS = 5_000L

        /** mDNS 发现 `adb-tls-connect` 的等待上限。 */
        const val DISCOVERY_TIMEOUT_MS = 15_000L

        /** 退出码标记；用不常见的前缀，避免与命令自身输出混淆。 */
        const val EXIT_MARKER = "__AISUP_EXIT__:"
    }
}
