package org.supass.ai_su_pass.core.stellar

import android.os.Process
import java.io.BufferedReader
import java.io.InputStreamReader
import java.io.OutputStreamWriter
import java.net.InetAddress
import java.net.ServerSocket
import java.net.Socket
import java.net.SocketTimeoutException

/**
 * Stellar 特权服务的服务端入口。
 *
 * 由 `libstellar_svc.so` 通过 `app_process` 拉起：本进程以 shell(2000) 或
 * root(0) 身份运行，`setsid` 之后与 adbd 解绑，因此无线调试被关掉也不会掉线。
 *
 * 现阶段只做存活应答：回环端口设备上任何进程都连得上，所以这里**不提供任何
 * 执行能力**，只回答「我是谁、我还在不在」。执行入口要等调用者校验就绪后再接，
 * 不能只凭这个端口认身份。
 */
object StellarServiceHost {

    /** 协议版本；响应字段变化时递增，Dart 侧据此判兼容。 */
    const val PROTOCOL = 1

    /** 探活端口；必须与 svc_launcher.c 的 HOST_PORT 一致。 */
    const val PORT = 39187

    /** 进程名；必须与 svc_launcher.c 的 HOST_TAG 一致。 */
    const val TAG = "aisupass-stellar"

    /** 服务日志路径；必须与 svc_launcher.c 的 HOST_LOG_FILE 一致。 */
    const val LOG_PATH = "/data/local/tmp/aisupass-stellar.log"

    /** 单连接最长等待，防止只连不说的客户端占住循环。 */
    private const val IO_TIMEOUT_MS = 2_000

    /** 积压队列；调用方只有本 App，给 4 个足够。 */
    private const val BACKLOG = 4

    @JvmStatic
    fun main(args: Array<String>) {
        val identity = Process.myUid()
        val self = Process.myPid()
        trace("boot identity=$identity pid=$self")

        val listener = try {
            ServerSocket(PORT, BACKLOG, InetAddress.getByName(LOOPBACK))
        } catch (error: Throwable) {
            // 端口被占说明已有实例在服务，交给探测方确认，这里安静退出。
            trace("port busy: ${error.javaClass.simpleName}")
            return
        }
        listener.soTimeout = IO_TIMEOUT_MS

        var keepServing = true
        while (keepServing) {
            val peer = try {
                listener.accept()
            } catch (_: SocketTimeoutException) {
                continue
            } catch (error: Throwable) {
                trace("accept aborted: ${error.javaClass.simpleName}")
                break
            }
            keepServing = serve(peer, identity, self)
        }

        runCatching { listener.close() }
        trace("bye pid=$self")
    }

    /**
     * 应答一次请求；返回 false 表示收到退出指令。
     *
     * 协议刻意保持单行请求 / 单行响应，便于用 `nc` 之类现成工具手工验证。
     */
    private fun serve(peer: Socket, identity: Int, self: Int): Boolean {
        peer.soTimeout = IO_TIMEOUT_MS
        peer.use { socket ->
            val request = readRequest(socket)
            when (request) {
                "PING" -> respond(
                    socket,
                    """{"protocol":$PROTOCOL,"uid":$identity,"pid":$self}""",
                )
                "STOP" -> {
                    respond(socket, """{"ok":true}""")
                    return false
                }
                else -> respond(socket, """{"error":"unsupported"}""")
            }
        }
        return true
    }

    private fun readRequest(socket: Socket): String = try {
        BufferedReader(InputStreamReader(socket.getInputStream(), Charsets.UTF_8))
            .readLine()
            ?.trim()
            .orEmpty()
    } catch (_: Throwable) {
        ""
    }

    private fun respond(socket: Socket, payload: String) {
        runCatching {
            OutputStreamWriter(socket.getOutputStream(), Charsets.UTF_8).run {
                write(payload)
                write("\n")
                flush()
            }
        }
    }

    /** 输出已由拉起器重定向到 [LOG_PATH]，这里只补时间无关的简单前缀。 */
    private fun trace(message: String) {
        println("[$TAG] $message")
        System.out.flush()
    }

    private const val LOOPBACK = "127.0.0.1"
}
