package org.supass.ai_su_pass.core.bridge.cve98260_native

import android.content.Context
import android.os.Handler
import android.os.Looper
import java.io.File
import java.util.concurrent.Executors
import org.supass.ai_su_pass.core.bridge.adb_shell_native.AdbShellNativeImpl
import org.supass.ai_su_pass.core.root.KsudLocator
import org.supass.ai_su_pass.core.shell.ShellStatus
import org.supass.ai_su_pass.cve98260.AssetConfigLoader
import org.supass.ai_su_pass.cve98260.BuiltinProfileCatalog
import org.supass.ai_su_pass.cve98260.Cve98260Session
import org.supass.ai_su_pass.cve98260.KernelProfileSerializer
import org.supass.ai_su_pass.cve98260.ota.ImportedProfileSelection
import org.supass.ai_su_pass.cve98260.ota.ImportedProfileStore

/**
 * GhostKey native bridge: parameter validation, thread dispatch and result
 * shipping only.
 *
 * All decisions live in [Cve98260Session]; this class never builds commands and
 * never rewrites exit codes. It reuses the already paired connection from
 * [AdbShellNativeImpl] instead of creating a second channel.
 */
class Cve98260NativeImpl(
    private val context: Context,
    private val shell: AdbShellNativeImpl,
) : Cve98260Native {

    private companion object {
        const val BIN_NAME = "libcve98260.so"
        const val PROBE_TIMEOUT_MS = 5_000L
        const val SHELL_UID = 2000L
    }

    private val catalog = BuiltinProfileCatalog(
        AssetConfigLoader(context.applicationContext),
        ImportedProfileStore(context.applicationContext),
        ImportedProfileSelection(context.applicationContext),
    )

    private val sessionExecutor = Executors.newSingleThreadExecutor()

    private val preflightExecutor = Executors.newSingleThreadExecutor()

    private val mainHandler = Handler(Looper.getMainLooper())

    private val sessions = LinkedHashMap<String, Cve98260Session>()

    override fun preflight(callback: (Result<Cve98260Preflight>) -> Unit) {
        preflightExecutor.execute {
            val result = runCatching { buildPreflight() }
            mainHandler.post { callback(result) }
        }
    }

    override fun start(
        request: Cve98260Request,
        callback: (Result<Cve98260StartResult>) -> Unit,
    ) {
        sessionExecutor.execute {
            val result = runCatching { accept(request) }
            mainHandler.post { callback(result) }
        }
    }

    override fun poll(
        sessionId: String,
        callback: (Result<Cve98260Chunk>) -> Unit,
    ) {
        sessionExecutor.execute {
            val chunk = synchronized(sessions) {
                val session = sessions[sessionId]
                if (session == null) {
                    Cve98260Chunk(
                        sessionId = sessionId,
                        events = emptyList(),
                        log = "",
                        finished = true,
                        exitCode = -1L,
                        timedOut = false,
                        durationMs = 0L,
                        failure = "unknown session",
                    )
                } else {
                    session.poll().also { if (it.finished) sessions.remove(sessionId) }
                }
            }
            mainHandler.post { callback(Result.success(chunk)) }
        }
    }

    override fun cancel(sessionId: String, callback: (Result<Unit>) -> Unit) {
        val session = synchronized(sessions) { sessions[sessionId] }
        session?.cancel()
        mainHandler.post { callback(Result.success(Unit)) }
    }

    fun dispose() {
        synchronized(sessions) { sessions.clear() }
        sessionExecutor.shutdownNow()
        preflightExecutor.shutdownNow()
    }

    private fun buildPreflight(): Cve98260Preflight {
        val channel = shell.shellChannel
        val connected = channel.status() == ShellStatus.READY
        var uid = -1L
        var seccomp = -1L
        var release = ""
        if (connected) {
            uid = channel.exec("id -u", PROBE_TIMEOUT_MS, null)
                .stdout.trim().toLongOrNull() ?: -1L
            seccomp = parseSeccomp(
                channel.exec("grep ^Seccomp: /proc/\$\$/status", PROBE_TIMEOUT_MS, null).stdout,
            )
            release = channel.exec("uname -r", PROBE_TIMEOUT_MS, null).stdout.trim()
        }
        val bin = File(context.applicationInfo.nativeLibraryDir, BIN_NAME)
        return Cve98260Preflight(
            adbConnected = connected,
            shellUid = uid,
            seccomp = seccomp,
            release = release,
            profileMatched = release.isNotEmpty() && catalog.match(release) != null,
            binaryPresent = bin.isFile,
        )
    }

    private fun accept(request: Cve98260Request): Cve98260StartResult {
        synchronized(sessions) {
            if (sessions.isNotEmpty()) return rejected("alreadyRunning")
        }
        val channel = shell.shellChannel
        if (channel.status() != ShellStatus.READY) return rejected("noAdb")
        if (channel.uid != SHELL_UID) return rejected("notShell")

        val seccomp = parseSeccomp(
            channel.exec("grep ^Seccomp: /proc/\$\$/status", PROBE_TIMEOUT_MS, null).stdout,
        )
        if (seccomp != 0L) return rejected("seccompFiltered")

        val bin = File(context.applicationInfo.nativeLibraryDir, BIN_NAME)
        if (!bin.isFile) return rejected("missingBinary")

        val release = channel.exec("uname -r", PROBE_TIMEOUT_MS, null).stdout.trim()
        if (release.isEmpty()) return rejected("noProfile")
        val profile = catalog.match(release) ?: return rejected("noProfile")

        val blob = KernelProfileSerializer.serialize(profile)
        val session = Cve98260Session(
            request = request,
            binPath = bin.absolutePath,
            profileBlob = blob,
            ksudPath = resolveKsud(request.managerPackage),
            channel = channel,
        )
        synchronized(sessions) { sessions[session.sessionId] = session }
        session.start()
        return Cve98260StartResult(
            accepted = true,
            sessionId = session.sessionId,
            reason = "",
        )
    }

    /**
     * 末段要加载的 ksud。
     *
     * 只有一个来源：全局选中的那个管理器自带的 ksud（固定名优先，随机名靠指纹 +
     * 实测 `late-load --help`）。找不到就返回空串，由会话层把 KSU 阶段标成失败，
     * 不拿包内那份顶替——那会绕过用户的选择。
     */
    private fun resolveKsud(managerPackage: String): String =
        KsudLocator.locate(context, managerPackage)

    private fun parseSeccomp(stdout: String): Long {
        val line = stdout.lineSequence().firstOrNull { it.startsWith("Seccomp:") } ?: return -1L
        return line.substringAfter(':').trim().toLongOrNull() ?: -1L
    }

    private fun rejected(reason: String): Cve98260StartResult =
        Cve98260StartResult(accepted = false, sessionId = "", reason = reason)
}
