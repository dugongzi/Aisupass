package org.supass.ai_su_pass.dirtyfrag

import android.content.Context
import android.net.IpSecAlgorithm
import android.net.IpSecManager
import android.net.IpSecTransform
import android.os.SystemClock
import java.io.BufferedReader
import java.io.File
import java.io.IOException
import java.io.InputStreamReader
import java.net.DatagramSocket
import java.net.InetAddress
import java.nio.file.Files
import java.nio.file.StandardCopyOption
import java.security.SecureRandom
import java.util.UUID
import java.util.concurrent.ConcurrentHashMap
import kotlin.concurrent.thread

/**
 * DirtyFrag 执行体：不依赖 Pigeon、不依赖 Flutter。
 *
 * 应用进程与开机广播都调它，因此只接受 [Context] 与纯 Kotlin 数据类型。
 */
class DirtyFragSession(private val context: Context) {

    /** 一次运行的入参，与通道层的 `DirtyFragRequest` 字段一一对应。 */
    data class Params(
        val managerPackage: String,
        val vrDisarm: Boolean,
        val vrAuto: Boolean,
        val vrOffset: Int,
        val softReboot: Boolean,
    )

    data class StartOutcome(val accepted: Boolean, val sessionId: String, val reason: String)

    data class Snapshot(
        val sessionId: String,
        val output: String,
        val finished: Boolean,
        val exitCode: Int,
        val timedOut: Boolean,
        val durationMs: Long,
        val resolvedVrOffset: String,
        val failure: String,
    )

    /** 一个会话的运行时状态；写入方是工作线程，读方是通道线程。 */
    private class Session(
        val id: String,
        val startedAt: Long,
        val autoVr: Boolean,
        val process: Process,
    ) {
        val output = StringBuilder()

        var readOffset = 0

        @Volatile
        var finished = false

        @Volatile
        var exitCode = -1

        @Volatile
        var timedOut = false

        @Volatile
        var resolvedVrOffset = ""

        @Volatile
        var failure = ""
    }

    private companion object {
        /** 注入标记，内核侧 hook 成功后才存在。 */
        const val MARKER_PATH = "/dev/df"

        /** 手动偏移的合法上界，与 `exp.c` 的校验一致。 */
        const val MAX_VR_OFFSET = 0x100
    }

    private val sessions = ConcurrentHashMap<String, Session>()

    fun start(params: Params): StartOutcome {
        if (File(MARKER_PATH).exists()) {
            return StartOutcome(false, "", "alreadyArmed")
        }
        if (sessions.values.any { !it.finished }) {
            return StartOutcome(false, "", "busy")
        }
        if (params.managerPackage.isEmpty()) {
            return StartOutcome(false, "", "badRequest")
        }
        if (!params.vrAuto && (params.vrOffset < 1 || params.vrOffset > MAX_VR_OFFSET)) {
            return StartOutcome(false, "", "badRequest")
        }

        val ipsec = context.getSystemService(Context.IPSEC_SERVICE) as? IpSecManager
            ?: return StartOutcome(false, "", "noIpSec")

        // 开机未解锁时只有 DE 存储可读，落位与偏好都走 DE 上下文。
        val de = context.createDeviceProtectedStorageContext()
        val deParent = de.filesDir.parentFile
            ?: return StartOutcome(false, "", "stagingFailed")
        val ownNativeDir = context.applicationInfo.nativeLibraryDir

        val managerNativeDir = try {
            context.packageManager.getApplicationInfo(params.managerPackage, 0).nativeLibraryDir
        } catch (e: Exception) {
            return StartOutcome(false, "", "missingBinary")
        }

        val ksudSrc = File(managerNativeDir, "libksud.so")
        val bootstrapSrc = File(ownNativeDir, "libbootstrap.so")
        val bin = File(ownNativeDir, "libdfroot.so")
        if (!ksudSrc.isFile || !bootstrapSrc.isFile || !bin.isFile) {
            return StartOutcome(false, "", "missingBinary")
        }

        try {
            stageExecutable(ksudSrc, File(deParent, "ksud"))
            stageExecutable(bootstrapSrc, File(deParent, "bootstrap"))
        } catch (e: Exception) {
            return StartOutcome(false, "", "stagingFailed")
        }

        DirtyFragPrefs.writeRunParams(de, params.managerPackage, params.softReboot)

        var encapSock: IpSecManager.UdpEncapsulationSocket? = null
        var spiObj: IpSecManager.SecurityParameterIndex? = null
        var transform: IpSecTransform? = null
        val sessionId = UUID.randomUUID().toString()

        val process: Process
        try {
            val loopback = InetAddress.getByName("127.0.0.1")
            encapSock = ipsec.openUdpEncapsulationSocket()
            spiObj = ipsec.allocateSecurityParameterIndex(loopback)
            val aesKey = ByteArray(32).also { SecureRandom().nextBytes(it) }
            val senderPort = DatagramSocket(0).use { it.localPort }
            transform = IpSecTransform.Builder(context)
                .setEncryption(IpSecAlgorithm(IpSecAlgorithm.CRYPT_AES_CBC, aesKey))
                .setIpv4Encapsulation(encapSock, senderPort)
                .buildTransportModeTransform(loopback, spiObj)

            val argv = buildArgv(bin, encapSock.port, senderPort, spiObj.spi, aesKey, params)
            process = ProcessBuilder(argv).redirectErrorStream(true).start()
        } catch (e: Exception) {
            closeQuietly(transform)
            closeQuietly(spiObj)
            closeQuietly(encapSock)
            return StartOutcome(false, "", "stagingFailed")
        }

        val session = Session(
            id = sessionId,
            startedAt = SystemClock.elapsedRealtime(),
            autoVr = params.vrAuto,
            process = process,
        )
        sessions[sessionId] = session

        val transformRef = transform
        val spiRef = spiObj
        val encapRef = encapSock
        thread(name = "dfroot-session", isDaemon = true) {
            try {
                BufferedReader(InputStreamReader(process.inputStream)).use { reader ->
                    while (true) {
                        val line = reader.readLine() ?: break
                        synchronized(session) {
                            session.output.append(line).append('\n')
                        }
                    }
                }
                session.exitCode = process.waitFor()
            } catch (e: Exception) {
                session.failure = e.javaClass.simpleName
            } finally {
                // 与上游一致：transform → spi → encap 的顺序关闭。
                closeQuietly(transformRef)
                closeQuietly(spiRef)
                closeQuietly(encapRef)
                if (session.autoVr) {
                    session.resolvedVrOffset = readVrOffset(de)
                }
                session.finished = true
            }
        }

        return StartOutcome(true, sessionId, "")
    }

    fun poll(sessionId: String): Snapshot {
        val session = sessions[sessionId]
            ?: return Snapshot(
                sessionId = sessionId,
                output = "",
                finished = true,
                exitCode = -1,
                timedOut = false,
                durationMs = 0,
                resolvedVrOffset = "",
                failure = "unknownSession",
            )

        val output: String
        synchronized(session) {
            output = session.output.substring(session.readOffset)
            session.readOffset = session.output.length
        }

        val snapshot = Snapshot(
            sessionId = sessionId,
            output = output,
            finished = session.finished,
            exitCode = session.exitCode,
            timedOut = session.timedOut,
            durationMs = SystemClock.elapsedRealtime() - session.startedAt,
            resolvedVrOffset = session.resolvedVrOffset,
            failure = session.failure,
        )
        // 终局块取走之后回收会话。
        if (snapshot.finished) sessions.remove(sessionId)
        return snapshot
    }

    fun cancel(sessionId: String) {
        val session = sessions[sessionId] ?: return
        session.timedOut = true
        session.process.destroy()
    }

    fun dispose() {
        for (session in sessions.values) {
            session.timedOut = true
            session.process.destroy()
        }
        sessions.clear()
    }

    private fun buildArgv(
        bin: File,
        encapPort: Int,
        senderPort: Int,
        spi: Int,
        aesKey: ByteArray,
        params: Params,
    ): List<String> {
        val cmd = mutableListOf<String>()
        cmd += bin.absolutePath
        cmd += "--encap-port"
        cmd += encapPort.toString()
        cmd += "--sender-port"
        cmd += senderPort.toString()
        cmd += "--spi"
        cmd += Integer.toUnsignedString(spi)
        cmd += "--aes-key"
        cmd += aesKey.joinToString(separator = "") { String.format("%02x", it) }
        // `--vr-auto` 与 `--vr-off` 只给一个：两者同时出现时 ko 只认 auto。
        if (params.vrDisarm) {
            if (params.vrAuto) {
                cmd += "--vr-auto"
            } else {
                cmd += "--vr-off"
                cmd += params.vrOffset.toString()
            }
        }
        return cmd
    }

    private fun stageExecutable(src: File, dest: File) {
        Files.copy(src.toPath(), dest.toPath(), StandardCopyOption.REPLACE_EXISTING)
        if (!dest.setExecutable(true, false)) {
            throw IOException("setExecutable failed: ${dest.absolutePath}")
        }
    }

    private fun readVrOffset(de: Context): String = try {
        val file = File(de.filesDir, "vr_offset.txt")
        if (!file.isFile) {
            ""
        } else {
            val text = file.readText().trim()
            if (text.isEmpty() || text == "fail") "" else text
        }
    } catch (e: Exception) {
        ""
    }

    private fun closeQuietly(closeable: Any?) {
        when (closeable) {
            null -> return
            is IpSecTransform -> closeable.close()
            is IpSecManager.SecurityParameterIndex -> closeable.close()
            is IpSecManager.UdpEncapsulationSocket -> closeable.close()
        }
    }
}
