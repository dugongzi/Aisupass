package org.supass.ai_su_pass.core.shell

import android.os.SystemClock
import java.io.BufferedInputStream
import java.io.BufferedOutputStream
import java.io.IOException
import java.io.InputStream
import java.net.InetAddress
import java.net.InetSocketAddress
import java.net.Socket
import org.json.JSONObject

/**
 * 回环 Stellar 服务的 shell 通道。
 *
 * Stellar 服务是本应用 fork 出来的独立 C 进程（`libstellar_svc.so --serve`），
 * 以 shell（uid=2000）身份 `bind 127.0.0.1:39187`，跑的是 `/system/bin/sh -c`。
 * 所以在身份与命令语义上与无线 ADB 一致，可以互换——GhostKey / GhostLock 这些
 * 原生侧会话只认 [ShellChannel]，换通道对它们是透明的。
 *
 * 协议：请求一行 ASCII 头 + 二进制体，应答「一行头 + 体」，详见任务文档 `00` §5.3。
 *
 * 与 [org.supass.ai_su_pass.core.adb.AdbShellChannel] 的差异：
 * 1. 没有配对、没有 TLS，鉴权靠 [updateToken] 下发的 64 位十六进制 token；
 * 2. [status] 会真的发一次 `PING <token>` 探活（在设备侧不执行任何命令，
 *    只是协议握手），因为回环 socket 没有「连接管理器」可以读；
 * 3. 失败原因只有本地判定（未配置 token / 连不上 / 应答异常），没有 adbd 的帧语义。
 */
internal class StellarShellChannel : ShellChannel {

    override val source: String get() = SOURCE

    /** 服务端鉴权串；Dart 侧从持久化存储取出后下发。空串表示尚未配置。 */
    @Volatile
    private var token: String = ""

    /** 最近一次探活拿到的 uid；[uid] 本身不再发起连接。 */
    @Volatile
    private var identity: Long = UNKNOWN_UID

    /** 由 Dart 下发 token；值未变时不清缓存，避免每次切页都重探一次。 */
    fun updateToken(value: String) {
        if (value == token) return
        token = value
        identity = UNKNOWN_UID
    }

    /**
     * 探活。
     *
     * 与 ADB 的 `manager.isConnected` 不同，回环 socket 没有可读的连接状态，
     * 只能发一次握手。这里发的 `PING <token>` 在服务端只做 token 比对，
     * 不 fork 任何进程，因此仍然满足「探状态不产生副作用」的约束。
     */
    override fun status(): ShellStatus {
        val probe = probe()
        identity = probe.uid
        return if (probe.ready) ShellStatus.READY else ShellStatus.NOT_CONNECTED
    }

    override val uid: Long get() = identity

    override fun exec(command: String, timeoutMs: Long, stdin: ByteArray?): ShellResult {
        val tokenValue = token
        if (tokenValue.isEmpty()) return notStarted("stellar token missing")

        val commandBytes = command.toByteArray(Charsets.UTF_8)
        val stdinBytes = stdin ?: EMPTY_BYTES
        if (commandBytes.isEmpty()) return notStarted("empty command")
        if (commandBytes.size > CMD_MAX) return notStarted("command too long")
        if (stdinBytes.size > IN_CAP) return notStarted("stdin too long")

        // 超时原样透传：`<= 0` 就是不限时（[ShellChannel] 的既有语义，GhostKey
        // 的阶段命令用它）。通道不替调用方设默认值，也不夹上限——那是策略层的事。
        val unbounded = timeoutMs <= 0L
        val budget = if (unbounded) 0L else timeoutMs
        val startedAt = SystemClock.elapsedRealtime()

        return try {
            Socket().use { socket ->
                socket.connect(InetSocketAddress(LOOPBACK, PORT), CONNECT_TIMEOUT_MS)
                socket.tcpNoDelay = true
                // 正数预算要多留读余量，否则大输出会被当成掉线；不限时则彻底放开。
                socket.soTimeout = if (unbounded) 0 else (budget + REPLY_MARGIN_MS).toInt()

                val sink = BufferedOutputStream(socket.getOutputStream())
                sink.write(
                    "EXEC $tokenValue $budget ${commandBytes.size} ${stdinBytes.size}\n"
                        .toByteArray(Charsets.US_ASCII),
                )
                sink.write(commandBytes)
                if (stdinBytes.isNotEmpty()) sink.write(stdinBytes)
                sink.flush()

                val source = BufferedInputStream(socket.getInputStream())
                val line = readLine(source) ?: return notStarted("no reply")
                val json = JSONObject(line)
                if (json.optInt(FIELD_OK, 0) != 1) {
                    val reason = json.optString(FIELD_REASON, "execRejected")
                    return ShellResult(ShellProtocol.EXIT_NOT_STARTED, "", reason, 0L, false)
                }

                val outLen = json.optInt(FIELD_OUT_LEN, 0).coerceAtLeast(0)
                val errLen = json.optInt(FIELD_ERR_LEN, 0).coerceAtLeast(0)
                val stdout = String(readExact(source, outLen), Charsets.UTF_8)
                val rawErr = String(readExact(source, errLen), Charsets.UTF_8)
                val truncated = json.optInt(FIELD_TRUNCATED, 0) == 1

                ShellResult(
                    exitCode = json.optInt(FIELD_EXIT_CODE, ShellProtocol.EXIT_NOT_STARTED),
                    stdout = stdout,
                    stderr = if (truncated) appendTruncatedNote(rawErr) else rawErr,
                    durationMs = json.optLong(
                        FIELD_DURATION_MS,
                        SystemClock.elapsedRealtime() - startedAt,
                    ),
                    timedOut = json.optInt(FIELD_TIMED_OUT, 0) == 1,
                )
            }
        } catch (t: Throwable) {
            // 连不上、写超时、应答不完整都归到这里：通道不可用，不猜命令是否跑过。
            notStarted(t.javaClass.simpleName)
        }
    }

    /** 一次探活的结论；[uid] 只在与服务端握手成功时有效。 */
    private class Probe(val ready: Boolean, val uid: Long)

    private fun probe(): Probe {
        val tokenValue = token
        if (tokenValue.isEmpty()) return Probe(false, UNKNOWN_UID)

        return try {
            Socket().use { socket ->
                socket.connect(InetSocketAddress(LOOPBACK, PORT), CONNECT_TIMEOUT_MS)
                socket.soTimeout = PROBE_TIMEOUT_MS
                val sink = socket.getOutputStream()
                sink.write("PING $tokenValue\n".toByteArray(Charsets.US_ASCII))
                sink.flush()

                val line = readLine(BufferedInputStream(socket.getInputStream()))
                    ?: return Probe(false, UNKNOWN_UID)
                val json = JSONObject(line)
                val protocol = json.optInt(FIELD_PROTOCOL, 0)
                val uid = json.optLong(FIELD_UID, UNKNOWN_UID)
                Probe(protocol == PROTOCOL_VERSION && uid > 0L, uid)
            }
        } catch (_: Exception) {
            Probe(false, UNKNOWN_UID)
        }
    }

    private fun notStarted(reason: String): ShellResult = ShellResult(
        exitCode = ShellProtocol.EXIT_NOT_STARTED,
        stdout = "",
        stderr = reason,
        durationMs = 0L,
        timedOut = false,
    )

    /** 截断说明与 Dart 侧（任务文档 `04` §5.3）保持同一措辞，上层判定不会分叉。 */
    private fun appendTruncatedNote(stderr: String): String =
        if (stderr.isEmpty()) TRUNCATED_NOTE else "$stderr\n$TRUNCATED_NOTE"

    /** 读一行（到 `\n` 为止，不含换行）；EOF 返回 null。 */
    @Throws(IOException::class)
    private fun readLine(source: InputStream): String? {
        val buffer = StringBuilder()
        while (true) {
            val next = source.read()
            if (next < 0) return if (buffer.isEmpty()) null else buffer.toString()
            if (next == '\n'.code) return buffer.toString()
            if (next != '\r'.code) buffer.append(next.toChar())
            if (buffer.length > MAX_HEAD_BYTES) return null
        }
    }

    /** 读满 [size] 字节；不足即抛异常（协议层长度与实际字节不符）。 */
    @Throws(IOException::class)
    private fun readExact(source: InputStream, size: Int): ByteArray {
        if (size <= 0) return EMPTY_BYTES
        val out = ByteArray(size)
        var filled = 0
        while (filled < size) {
            val got = source.read(out, filled, size - filled)
            if (got < 0) throw IOException("unexpected eof after $filled/$size bytes")
            filled += got
        }
        return out
    }

    private companion object {
        const val SOURCE = "stellar"

        /** 与服务端 `stellar_proto.h` 的 `PROTO_PORT` 一致。 */
        const val PORT = 39187

        /** 回环地址固定 127.0.0.1：服务端只在这一条上监听，`::1` 连不上。 */
        val LOOPBACK: InetAddress = InetAddress.getByAddress(byteArrayOf(127, 0, 0, 1))

        /** 与服务端 `PROTO_VERSION` 一致；不匹配说明端口上是别的东西。 */
        const val PROTOCOL_VERSION = 2

        /** 与服务端 `CMD_MAX` 一致。 */
        const val CMD_MAX = 65536

        /** 与服务端 `IN_CAP` 一致：单条命令标准输入上限 16 MiB。 */
        const val IN_CAP = 16 * 1024 * 1024

        /** 应答头长度上限，防止对端回一堆字节把内存吃光。 */
        const val MAX_HEAD_BYTES = 4096

        const val CONNECT_TIMEOUT_MS = 1_500

        /** 探活要短：进页面就会调，慢了会拖住自检。 */
        const val PROBE_TIMEOUT_MS = 800

        /** 读应答的额外余量，与 Dart 侧 `_replyMargin` 同量级。 */
        const val REPLY_MARGIN_MS = 5_000L

        const val UNKNOWN_UID = -1L

        const val TRUNCATED_NOTE = "[output truncated]"

        // 应答头字段名；集中在这里，改名时不用满文件找字符串。
        const val FIELD_OK = "ok"
        const val FIELD_REASON = "reason"
        const val FIELD_PROTOCOL = "protocol"
        const val FIELD_UID = "uid"
        const val FIELD_EXIT_CODE = "exitCode"
        const val FIELD_TIMED_OUT = "timedOut"
        const val FIELD_DURATION_MS = "durationMs"
        const val FIELD_OUT_LEN = "outLen"
        const val FIELD_ERR_LEN = "errLen"
        const val FIELD_TRUNCATED = "truncated"

        val EMPTY_BYTES = ByteArray(0)
    }
}
