package org.supass.ai_su_pass.core.bridge.ghost_lock_native

import android.content.Context
import android.os.Handler
import android.os.Looper
import java.io.File
import java.util.concurrent.Executors
import org.supass.ai_su_pass.core.bridge.adb_shell_native.AdbShellNativeImpl
import org.supass.ai_su_pass.core.root.KsudLocator
import org.supass.ai_su_pass.core.shell.ShellStatus
import org.supass.ai_su_pass.cve43499.GhostLockAssets
import org.supass.ai_su_pass.cve43499.GhostLockCatalog
import org.supass.ai_su_pass.cve43499.GhostLockProfileController
import org.supass.ai_su_pass.cve43499.GhostLockProfileEditStore
import org.supass.ai_su_pass.cve43499.GhostLockProfileStore
import org.supass.ai_su_pass.cve43499.GhostLockSession

/**
 * GhostLock 原生桥的分发层：设备自检、受理与轮询转发。
 *
 * 不做退出码判定，不解析日志，不拼 root 脚本；这些分别属于 Dart 判定表与原生。
 * 复用 [AdbShellNativeImpl] 已配对的连接，不建立第二条通道。
 */
class GhostLockNativeImpl(
    private val context: Context,
    private val shell: AdbShellNativeImpl,
) : GhostLockNative {

    private companion object {
        const val BIN_NAME = "libghostlock.so"
        const val PROBE_TIMEOUT_MS = 5_000L
        const val SHELL_UID = 2000L
    }

    private val catalog = GhostLockCatalog(
        GhostLockProfileController(
            assets = GhostLockAssets(context.applicationContext),
            store = GhostLockProfileStore(
                GhostLockProfileStore.directory(context.applicationContext),
            ),
            editStore = GhostLockProfileEditStore(context.applicationContext),
        ),
    )

    private val sessionExecutor = Executors.newSingleThreadExecutor()

    private val preflightExecutor = Executors.newSingleThreadExecutor()

    private val mainHandler = Handler(Looper.getMainLooper())

    private val sessions = LinkedHashMap<String, GhostLockSession>()

    override fun preflight(
        managerPackage: String,
        callback: (Result<GhostLockPreflight>) -> Unit,
    ) {
        preflightExecutor.execute {
            val result = runCatching { buildPreflight(managerPackage) }
            mainHandler.post { callback(result) }
        }
    }

    override fun start(
        request: GhostLockRequest,
        callback: (Result<GhostLockStartResult>) -> Unit,
    ) {
        sessionExecutor.execute {
            val result = runCatching { accept(request) }
            mainHandler.post { callback(result) }
        }
    }

    override fun poll(
        sessionId: String,
        callback: (Result<GhostLockChunk>) -> Unit,
    ) {
        sessionExecutor.execute {
            val chunk = synchronized(sessions) {
                val session = sessions[sessionId]
                if (session == null) {
                    GhostLockChunk(
                        sessionId = sessionId,
                        output = "",
                        finished = true,
                        exitCode = -1L,
                        timedOut = false,
                        durationMs = 0L,
                        failure = "unknownSession",
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

    /** 释放会话与线程池，由 [org.supass.ai_su_pass.NativeProvider] 在页面销毁时调用。 */
    fun dispose() {
        synchronized(sessions) {
            sessions.values.forEach { it.cancel() }
            sessions.clear()
        }
        sessionExecutor.shutdownNow()
        preflightExecutor.shutdownNow()
    }

    private fun buildPreflight(managerPackage: String): GhostLockPreflight {
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
        val matched = if (release.isEmpty()) null else catalog.match(release, false)
        return GhostLockPreflight(
            adbConnected = connected,
            shellUid = uid,
            seccomp = seccomp,
            release = release,
            profileRelease = matched?.getOrNull()?.release.orEmpty(),
            route = matched?.getOrNull()?.route.orEmpty(),
            binaryPresent = File(context.applicationInfo.nativeLibraryDir, BIN_NAME).isFile,
            // 与实际执行同一条解析：只认全局选中管理器自带的 ksud。
            ksudPath = resolveKsud(managerPackage),
            profileError = matched?.exceptionOrNull()?.message.orEmpty(),
        )
    }

    private fun accept(request: GhostLockRequest): GhostLockStartResult {
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
        val matched = catalog.match(release, request.safeMode).getOrElse {
            val message = it.message.orEmpty()
            return rejected(if (message == "noProfile") "noProfile" else "profileInvalid")
        }

        val session = GhostLockSession(
            binPath = bin.absolutePath,
            ksudPath = resolveKsud(request.managerPackage),
            blob = matched.blob,
            channel = channel,
        )
        synchronized(sessions) { sessions[session.sessionId] = session }
        session.start()
        return GhostLockStartResult(
            accepted = true,
            sessionId = session.sessionId,
            reason = "",
        )
    }

    /**
     * 末段要加载的 ksud。
     *
     * 只有一个来源：全局选中的那个管理器自带的 ksud（固定名优先，随机名靠指纹 +
     * 实测 `late-load --help`）。找不到就返回空串，让上层如实报「没有可用的 ksud」，
     * 不拿包内那份顶替——那会绕过用户的选择，也会把失败藏到运行中途。
     */
    private fun resolveKsud(managerPackage: String): String =
        KsudLocator.locate(context, managerPackage)

    private fun parseSeccomp(stdout: String): Long {
        val line = stdout.lineSequence().firstOrNull { it.startsWith("Seccomp:") } ?: return -1L
        return line.substringAfter(':').trim().toLongOrNull() ?: -1L
    }

    private fun rejected(reason: String): GhostLockStartResult =
        GhostLockStartResult(accepted = false, sessionId = "", reason = reason)
}
