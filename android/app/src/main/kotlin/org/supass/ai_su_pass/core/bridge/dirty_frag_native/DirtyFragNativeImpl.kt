package org.supass.ai_su_pass.core.bridge.dirty_frag_native

import android.content.ComponentName
import android.content.Context
import android.content.pm.PackageManager
import java.io.File
import org.supass.ai_su_pass.dirtyfrag.DirtyFragPrefs
import org.supass.ai_su_pass.dirtyfrag.DirtyFragSession
import org.supass.ai_su_pass.dirtyfrag.DirtyFragVrExtractor

/**
 * DirtyFrag 原生桥的分发层：把通道调用转给 [DirtyFragSession] 与 [DirtyFragPrefs]。
 *
 * 不做退出码判定，不拼命令，不读偏好文本。
 */
class DirtyFragNativeImpl(private val context: Context) : DirtyFragNative {

    private companion object {
        /** 注入标记，内核侧 hook 成功后才存在。 */
        const val MARKER_PATH = "/dev/df"

        /** 开机接收器的全限定名；由 `06` 实现，这里用字符串引用避免编译期依赖。 */
        const val BOOT_RECEIVER =
            "org.supass.ai_su_pass.boot.DirtyFragBootReceiver"
    }

    private val session = DirtyFragSession(context.applicationContext)

    override fun isArmed(callback: (Result<Boolean>) -> Unit) {
        callback(Result.success(File(MARKER_PATH).exists()))
    }

    override fun isExpertModeEnabled(callback: (Result<Boolean>) -> Unit) {
        callback(
            runCatching { DirtyFragPrefs.isExpertModeEnabled(context.applicationContext) },
        )
    }

    override fun setExpertModeEnabled(enabled: Boolean, callback: (Result<Unit>) -> Unit) {
        callback(
            runCatching {
                DirtyFragPrefs.setExpertModeEnabled(context.applicationContext, enabled)
            },
        )
    }

    override fun isBootAutostartEnabled(callback: (Result<Boolean>) -> Unit) {
        val component = ComponentName(context.packageName, BOOT_RECEIVER)
        callback(
            Result.success(
                try {
                    context.packageManager.getComponentEnabledSetting(component) ==
                        PackageManager.COMPONENT_ENABLED_STATE_ENABLED
                } catch (e: IllegalArgumentException) {
                    // 06 未落地前组件不存在，按未启用处理。
                    false
                } catch (e: SecurityException) {
                    false
                },
            ),
        )
    }

    override fun setBootAutostartEnabled(enabled: Boolean, callback: (Result<Unit>) -> Unit) {
        val component = ComponentName(context.packageName, BOOT_RECEIVER)
        callback(
            runCatching {
                context.packageManager.setComponentEnabledSetting(
                    component,
                    if (enabled) {
                        PackageManager.COMPONENT_ENABLED_STATE_ENABLED
                    } else {
                        PackageManager.COMPONENT_ENABLED_STATE_DISABLED
                    },
                    PackageManager.DONT_KILL_APP,
                )
            },
        )
    }

    override fun getRunDefaults(callback: (Result<DirtyFragRunDefaults>) -> Unit) {
        callback(
            runCatching {
                val defaults = DirtyFragPrefs.readRunDefaults(context.applicationContext)
                DirtyFragRunDefaults(
                    defaults.vrDisarm,
                    defaults.vrAuto,
                    defaults.vrOffset.toLong(),
                    defaults.softReboot,
                )
            },
        )
    }

    override fun setRunDefaults(
        defaults: DirtyFragRunDefaults,
        callback: (Result<Unit>) -> Unit,
    ) {
        callback(
            runCatching {
                DirtyFragPrefs.writeRunDefaults(
                    context.applicationContext,
                    DirtyFragPrefs.RunDefaults(
                        vrDisarm = defaults.vrDisarm,
                        vrAuto = defaults.vrAuto,
                        vrOffset = defaults.vrOffset.toInt(),
                        softReboot = defaults.softReboot,
                    ),
                )
            },
        )
    }

    override fun start(
        request: DirtyFragRequest,
        callback: (Result<DirtyFragStartResult>) -> Unit,
    ) {
        callback(
            runCatching {
                val outcome = session.start(
                    DirtyFragSession.Params(
                        managerPackage = request.managerPackage,
                        vrDisarm = request.vrDisarm,
                        vrAuto = request.vrAuto,
                        vrOffset = request.vrOffset.toInt(),
                        softReboot = request.softReboot,
                    ),
                )
                DirtyFragStartResult(outcome.accepted, outcome.sessionId, outcome.reason)
            },
        )
    }

    override fun poll(sessionId: String, callback: (Result<DirtyFragChunk>) -> Unit) {
        callback(
            runCatching {
                val snapshot = session.poll(sessionId)
                DirtyFragChunk(
                    snapshot.sessionId,
                    snapshot.output,
                    snapshot.finished,
                    snapshot.exitCode.toLong(),
                    snapshot.timedOut,
                    snapshot.durationMs,
                    snapshot.resolvedVrOffset,
                    snapshot.failure,
                )
            },
        )
    }

    override fun cancel(sessionId: String, callback: (Result<Unit>) -> Unit) {
        callback(runCatching { session.cancel(sessionId) })
    }

    override fun deriveVrOffset(
        input: String,
        insecure: Boolean,
        callback: (Result<VrDeriveResult>) -> Unit,
    ) {
        // nativeDerive 会阻塞到下载与解包结束，必须离开通道线程。
        Thread({
            val result = try {
                val json = DirtyFragVrExtractor.nativeDerive(
                    input,
                    context.cacheDir.absolutePath,
                    insecure,
                )
                if (json.startsWith("{\"ok\":true")) {
                    Result.success(VrDeriveResult(json, ""))
                } else {
                    Result.success(VrDeriveResult("", json))
                }
            } catch (e: Exception) {
                Result.failure(e)
            }
            callback(result)
        }, "dfroot-vrext").start()
    }

    override fun vrDeriveProgress(callback: (Result<String>) -> Unit) {
        val text = try {
            Result.success(DirtyFragVrExtractor.nativeProgress())
        } catch (e: Exception) {
            Result.failure<String>(e)
        }
        callback(text)
    }

    /** 释放会话与子进程，由 [org.supass.ai_su_pass.NativeProvider] 在页面销毁时调用。 */
    fun dispose() {
        session.dispose()
    }
}
