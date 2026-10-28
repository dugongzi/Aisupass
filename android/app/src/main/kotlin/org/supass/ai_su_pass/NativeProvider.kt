package org.supass.ai_su_pass

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import org.supass.ai_su_pass.core.bridge.escalation_native.EscalationNative
import org.supass.ai_su_pass.core.bridge.escalation_native.EscalationNativeImpl
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
    private var escalationImpl: EscalationNativeImpl? = null

    fun registerAll(context: Context, messenger: BinaryMessenger) {
        systemStatusImpl?.dispose()
        val statusImpl = SystemStatusNativeImpl(context)
        systemStatusImpl = statusImpl
        SystemStatusNative.setUp(messenger, statusImpl)

        // 复用同一个配对实现，而不是重建：配对可能是「已弹通知、正在等用户去系统
        // 设置里读码」的状态，重建会把通知接收器连同会话一起丢掉，用户提交的码
        // 就再也送不到，表现成「输入了配对码没下文」。
        val escImpl = escalationImpl
            ?: EscalationNativeImpl(context.applicationContext).also { escalationImpl = it }
        EscalationNative.setUp(messenger, escImpl)
    }

    fun dispose() {
        systemStatusImpl?.dispose()
        systemStatusImpl = null
        escalationImpl?.dispose()
        escalationImpl = null
    }
}
