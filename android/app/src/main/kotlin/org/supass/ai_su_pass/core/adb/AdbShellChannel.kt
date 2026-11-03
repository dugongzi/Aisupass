package org.supass.ai_su_pass.core.adb

import android.os.SystemClock
import android.util.Log
import io.github.muntashirakon.adb.AdbStream
import org.supass.ai_su_pass.core.shell.ShellChannel
import org.supass.ai_su_pass.core.shell.ShellResult
import org.supass.ai_su_pass.core.shell.ShellStatus
import java.io.ByteArrayOutputStream
import java.io.IOException
import java.io.InputStream
import java.net.InetSocketAddress
import java.util.concurrent.atomic.AtomicInteger
import java.util.concurrent.atomic.AtomicReference

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

    override fun exec(command: String, timeoutMs: Long, stdin: ByteArray?): ShellResult {
        val startedAt = SystemClock.elapsedRealtime()
        if (status() != ShellStatus.READY) {
            return ShellResult(EXIT_NOT_STARTED, "", "channel not ready", 0L, false)
        }

        val out = ByteArrayOutputStream()
        val err = ByteArrayOutputStream()
        // -1 表示「还没收到 kIdExit」；收到即写入真实退出码。
        val exitCode = AtomicInteger(EXIT_NOT_STARTED)
        val streamRef = AtomicReference<AdbStream?>(null)
        val failure = AtomicReference<String?>(null)

        val worker = Thread({
            try {
                val stream = manager.openStream("$SERVICE_PREFIX$command")
                streamRef.set(stream)
                // 写 stdin 单独一条线程：`AdbStream.write` 会等在写窗口上，可能长时间阻塞。
                Thread({ pumpStdin(stream, stdin) }, "adb-shell-stdin").apply {
                    isDaemon = true
                    start()
                }
                readFrames(stream, out, err, exitCode)
            } catch (t: Throwable) {
                // 超时被 close()、设备掉线、开流被拒都走这里，统一记为失败原因。
                failure.compareAndSet(null, t.javaClass.simpleName)
            } finally {
                // 关流同时负责踢醒还卡在 write 上的 stdin 线程。
                runCatching { streamRef.get()?.close() }
            }
        }, "adb-shell-exec").apply {
            isDaemon = true
            start()
        }

        worker.join(timeoutMs)
        val timedOut = worker.isAlive
        if (timedOut) {
            // 超时：先关流让读写线程退出，再收尸；不重试，避免把危险命令跑第二遍。
            runCatching { streamRef.get()?.close() }
            worker.join(STREAM_JOIN_MS)
        }

        val outText = textOf(out)
        val errText = textOf(err)
        val durationMs = SystemClock.elapsedRealtime() - startedAt

        if (timedOut) {
            return ShellResult(
                exitCode = exitCode.get(),
                stdout = outText,
                stderr = listOfNotNull(errText.takeIf { it.isNotEmpty() }, "timeout ${timeoutMs}ms")
                    .joinToString("\n"),
                durationMs = durationMs,
                timedOut = true,
            )
        }

        val code = exitCode.get()
        if (code == EXIT_NOT_STARTED) {
            // 流正常关闭却始终没收到 kIdExit：adbd 那边命令根本没跑起来（开流被拒、
            // 设备掉线、连接被掐）。这里原本完全静默，上层只看到 -1，无从判断原因。
            val notes = listOfNotNull(
                failure.get(),
                errText.takeIf { it.isNotEmpty() } ?: "exit frame missing",
            ).joinToString("\n")
            Log.w(
                TAG,
                "exec missing exit frame failure=${failure.get() ?: "-"} " +
                    "out='${outText.take(LOG_SNIPPET)}' err='${errText.take(LOG_SNIPPET)}'",
            )
            return ShellResult(EXIT_NOT_STARTED, outText, notes, durationMs, false)
        }

        return ShellResult(code, outText, errText, durationMs, false)
    }

    /**
     * 读取并解析 shell protocol v2 的帧，直到收到退出帧或流出错/关闭。
     *
     * stdout 与 stderr 必须**同时**被消费：adbd 侧两路共用一个 socket，
     * 只读一路会让另一路塞满缓冲、整条流一起卡死。
     */
    private fun readFrames(
        stream: AdbStream,
        out: ByteArrayOutputStream,
        err: ByteArrayOutputStream,
        exitCode: AtomicInteger,
    ) {
        val input: InputStream = stream.openInputStream()
        val header = ByteArray(HEADER_SIZE)
        val chunk = ByteArray(BUFFER_SIZE)

        while (true) {
            // 读到 -1 说明对端已关流；此时再读会抛 IOException，必须直接退出。
            if (!readFully(input, header, HEADER_SIZE)) return

            val id = header[0].toInt() and 0xFF
            val length = (header[1].toInt() and 0xFF) or
                ((header[2].toInt() and 0xFF) shl 8) or
                ((header[3].toInt() and 0xFF) shl 16) or
                ((header[4].toInt() and 0xFF) shl 24)
            if (length < 0 || length > MAX_FRAME_BYTES) {
                throw IOException("bad frame id=$id length=$length")
            }

            when (id) {
                ID_STDOUT, ID_STDERR -> {
                    val sink = if (id == ID_STDOUT) out else err
                    var remaining = length
                    while (remaining > 0) {
                        val want = minOf(remaining, chunk.size)
                        val read = input.read(chunk, 0, want)
                        if (read < 0) return
                        synchronized(sink) { sink.write(chunk, 0, read) }
                        remaining -= read
                    }
                }

                ID_EXIT -> {
                    // 退出帧长度是 1 字节（AOSP 客户端就是取 data()[0]），值 0..255。
                    // 被信号杀死时是 128 + signal。
                    val payload = ByteArray(length)
                    if (!readFully(input, payload, length)) return
                    if (length >= 1) exitCode.set(payload[0].toInt() and 0xFF)
                    return
                }

                else -> {
                    // 未知/本端不关心的帧（如 kIdWindowSizeChange）整体丢弃，
                    // 但必须把 payload 读掉，否则下一帧头会错位。
                    if (!skip(input, length)) return
                }
            }
        }
    }

    /**
     * 把 stdin 写进 `kIdStdin` 帧，最后统一发 `kIdCloseStdin`。
     *
     * 无论有没有 stdin 都发 EOF：否则任何读 stdin 的命令都会一直阻塞到超时，
     * 而不是像 `exec < /dev/null` 那样立刻拿到 EOF。
     */
    private fun pumpStdin(stream: AdbStream, stdin: ByteArray?) {
        try {
            val output = stream.openOutputStream()
            if (stdin != null && stdin.isNotEmpty()) {
                var offset = 0
                while (offset < stdin.size) {
                    val len = minOf(stdin.size - offset, MAX_STDIN_CHUNK)
                    val frame = buildFrame(ID_STDIN, stdin, offset, len)
                    output.write(frame, 0, frame.size)
                    offset += len
                }
            }
            val eof = buildFrame(ID_CLOSE_STDIN, null, 0, 0)
            output.write(eof, 0, eof.size)
            output.flush()
        } catch (t: Throwable) {
            // 进程已退出 / 超时关流 / 写窗口不再打开，都是正常收尾，
            // 不能覆盖读线程给出的主结果。
            Log.d(TAG, "stdin pump stopped: ${t.javaClass.simpleName}")
        }
    }

    /** 拼一帧：`[1B id][4B 小端长度][payload]`。 */
    private fun buildFrame(id: Int, src: ByteArray?, offset: Int, length: Int): ByteArray {
        val frame = ByteArray(HEADER_SIZE + length)
        frame[0] = id.toByte()
        frame[1] = (length and 0xFF).toByte()
        frame[2] = ((length ushr 8) and 0xFF).toByte()
        frame[3] = ((length ushr 16) and 0xFF).toByte()
        frame[4] = ((length ushr 24) and 0xFF).toByte()
        if (src != null && length > 0) {
            System.arraycopy(src, offset, frame, HEADER_SIZE, length)
        }
        return frame
    }

    /** 读满 [length] 字节；流提前关闭返回 false。 */
    private fun readFully(input: InputStream, buffer: ByteArray, length: Int): Boolean {
        var offset = 0
        while (offset < length) {
            val read = input.read(buffer, offset, length - offset)
            if (read < 0) return false
            offset += read
        }
        return true
    }

    /** 丢弃 [length] 字节的 payload；流提前关闭返回 false。 */
    private fun skip(input: InputStream, length: Int): Boolean {
        var remaining = length
        val scratch = ByteArray(minOf(length, BUFFER_SIZE))
        while (remaining > 0) {
            val want = minOf(remaining, scratch.size)
            val read = input.read(scratch, 0, want)
            if (read < 0) return false
            remaining -= read
        }
        return true
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

    private fun textOf(sink: ByteArrayOutputStream): String =
        synchronized(sink) { String(sink.toByteArray(), Charsets.UTF_8) }

    private companion object {
        /** 与其他配对组件共用同一标签，便于一次过滤整条链路。 */
        const val TAG = "AdbShell"

        const val SOURCE = "adb"
        const val UNKNOWN_UID = -1L
        const val EXIT_NOT_STARTED = -1

        /** `raw` 禁 pty：只有 raw 模式才分离 stdout/stderr 且 stdin 直通进程。 */
        const val SERVICE_PREFIX = "shell,v2,raw:"

        // shell protocol v2 packet id（AOSP shell_protocol.h）。
        const val ID_STDIN = 0
        const val ID_STDOUT = 1
        const val ID_STDERR = 2
        const val ID_EXIT = 3
        const val ID_CLOSE_STDIN = 4

        /** 1B id + 4B 小端长度。 */
        const val HEADER_SIZE = 5

        /** 帧长度上限：ADB 单包最大 1MB（api >= 28），超过说明流已错位。 */
        const val MAX_FRAME_BYTES = 1024 * 1024

        /** 单帧 stdin 大小，留足余量避免一次挤爆写窗口。 */
        const val MAX_STDIN_CHUNK = 32 * 1024

        /** 日志里截取输出片段的长度，避免一条日志刷满屏幕。 */
        const val LOG_SNIPPET = 200
        const val BUFFER_SIZE = 4096
        const val STREAM_JOIN_MS = 300L
        const val ID_TIMEOUT_MS = 5_000L

        /** mDNS 发现 `adb-tls-connect` 的等待上限。 */
        const val DISCOVERY_TIMEOUT_MS = 15_000L
    }
}
