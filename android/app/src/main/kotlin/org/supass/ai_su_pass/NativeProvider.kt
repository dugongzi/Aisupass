package org.supass.ai_su_pass

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
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

    fun registerAll(context: Context, messenger: BinaryMessenger) {
        systemStatusImpl?.dispose()
        val statusImpl = SystemStatusNativeImpl(context)
        systemStatusImpl = statusImpl
        SystemStatusNative.setUp(messenger, statusImpl)
    }

    fun dispose() {
        systemStatusImpl?.dispose()
        systemStatusImpl = null
    }
}
