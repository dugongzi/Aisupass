package org.supass.ai_su_pass

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import org.supass.ai_su_pass.core.bridge.adb_shell_native.AdbShellNative
import org.supass.ai_su_pass.core.bridge.adb_shell_native.AdbShellNativeImpl
import org.supass.ai_su_pass.core.bridge.device_identity_native.DeviceIdentityNative
import org.supass.ai_su_pass.core.bridge.device_identity_native.DeviceIdentityNativeImpl
import org.supass.ai_su_pass.core.bridge.system_status_native.SystemStatusNative
import org.supass.ai_su_pass.core.bridge.system_status_native.SystemStatusNativeImpl

/**
 * 原生桥接统一注册入口。
 *
 * 新增模块时在这里加一行 `setUp`，MainActivity 不需要改动。
 * 持有 Context 的 Impl 要在 [dispose] 里释放，避免页面重建后泄漏。
 */
object NativeProvider {

    private var systemStatusImpl: SystemStatusNativeImpl? = null
    private var adbShellImpl: AdbShellNativeImpl? = null
    private var deviceIdentityImpl: DeviceIdentityNativeImpl? = null

    fun registerAll(context: Context, messenger: BinaryMessenger) {
        systemStatusImpl?.dispose()
        val statusImpl = SystemStatusNativeImpl(context)
        systemStatusImpl = statusImpl
        SystemStatusNative.setUp(messenger, statusImpl)

        // 复用同一个实例，而不是重建：配对可能是「已弹通知、正在等用户去系统
        // 设置里读码」的状态，重建会把通知接收器连同会话一起丢掉，用户提交的码
        // 就再也送不到，表现成「输入了配对码没下文」。
        val shellImpl = adbShellImpl
            ?: AdbShellNativeImpl(context.applicationContext).also { adbShellImpl = it }
        AdbShellNative.setUp(messenger, shellImpl)

        deviceIdentityImpl?.dispose()
        val identityImpl = DeviceIdentityNativeImpl(context.applicationContext)
        deviceIdentityImpl = identityImpl
        DeviceIdentityNative.setUp(messenger, identityImpl)
    }

    fun dispose() {
        systemStatusImpl?.dispose()
        systemStatusImpl = null
        adbShellImpl?.dispose()
        adbShellImpl = null
        deviceIdentityImpl?.dispose()
        deviceIdentityImpl = null
    }
}
