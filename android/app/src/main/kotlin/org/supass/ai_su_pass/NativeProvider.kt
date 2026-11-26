package org.supass.ai_su_pass

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import org.supass.ai_su_pass.core.bridge.adb_shell_native.AdbShellNative
import org.supass.ai_su_pass.core.bridge.adb_shell_native.AdbShellNativeImpl
import org.supass.ai_su_pass.core.bridge.coolapk_auth_native.CoolapkAuthNative
import org.supass.ai_su_pass.core.bridge.coolapk_auth_native.CoolapkAuthNativeImpl
import org.supass.ai_su_pass.core.bridge.cve98260_native.Cve98260Native
import org.supass.ai_su_pass.core.bridge.cve98260_native.Cve98260NativeImpl
import org.supass.ai_su_pass.core.bridge.cve98260_native.Cve98260ProfileNative
import org.supass.ai_su_pass.core.bridge.cve98260_native.Cve98260ProfileNativeImpl
import org.supass.ai_su_pass.core.bridge.cve98260_native.Cve98260RunLogNative
import org.supass.ai_su_pass.core.bridge.cve98260_native.Cve98260RunLogNativeImpl
import org.supass.ai_su_pass.core.bridge.device_identity_native.DeviceIdentityNative
import org.supass.ai_su_pass.core.bridge.device_identity_native.DeviceIdentityNativeImpl
import org.supass.ai_su_pass.core.bridge.dirty_frag_native.DirtyFragNative
import org.supass.ai_su_pass.core.bridge.dirty_frag_native.DirtyFragNativeImpl
import org.supass.ai_su_pass.core.bridge.ghost_lock_native.GhostLockNative
import org.supass.ai_su_pass.core.bridge.ghost_lock_native.GhostLockNativeImpl
import org.supass.ai_su_pass.core.bridge.ghost_lock_native.GhostLockProfileEditNative
import org.supass.ai_su_pass.core.bridge.ghost_lock_native.GhostLockProfileEditNativeImpl
import org.supass.ai_su_pass.core.bridge.ghost_lock_native.GhostLockProfileNative
import org.supass.ai_su_pass.core.bridge.ghost_lock_native.GhostLockProfileNativeImpl
import org.supass.ai_su_pass.core.bridge.root_manager_native.RootManagerNative
import org.supass.ai_su_pass.core.bridge.root_manager_native.RootManagerNativeImpl
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
    private var rootManagerImpl: RootManagerNativeImpl? = null
    private var dirtyFragImpl: DirtyFragNativeImpl? = null
    private var ghostLockImpl: GhostLockNativeImpl? = null
    private var ghostLockProfileImpl: GhostLockProfileNativeImpl? = null
    private var ghostLockProfileEditImpl: GhostLockProfileEditNativeImpl? = null
    private var cve98260Impl: Cve98260NativeImpl? = null
    private var cve98260ProfileImpl: Cve98260ProfileNativeImpl? = null
    private var runLogImpl: Cve98260RunLogNativeImpl? = null

    fun registerAll(context: Context, messenger: BinaryMessenger) {
        // 无状态，不持有 Context；读 WebView 的 Cookie 用。
        CoolapkAuthNative.setUp(messenger, CoolapkAuthNativeImpl())

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

        rootManagerImpl?.dispose()
        val managerImpl = RootManagerNativeImpl(context.applicationContext)
        rootManagerImpl = managerImpl
        RootManagerNative.setUp(messenger, managerImpl)

        dirtyFragImpl?.dispose()
        val fragImpl = DirtyFragNativeImpl(context.applicationContext)
        dirtyFragImpl = fragImpl
        DirtyFragNative.setUp(messenger, fragImpl)

        cve98260Impl?.dispose()
        val ghostKeyImpl = Cve98260NativeImpl(context.applicationContext, shellImpl)
        cve98260Impl = ghostKeyImpl
        Cve98260Native.setUp(messenger, ghostKeyImpl)

        cve98260ProfileImpl?.dispose()
        val profileImpl = Cve98260ProfileNativeImpl(context.applicationContext)
        cve98260ProfileImpl = profileImpl
        Cve98260ProfileNative.setUp(messenger, profileImpl)

        runLogImpl?.dispose()
        val runLogNativeImpl = Cve98260RunLogNativeImpl(context.applicationContext)
        runLogImpl = runLogNativeImpl
        Cve98260RunLogNative.setUp(messenger, runLogNativeImpl)

        ghostLockImpl?.dispose()
        val lockImpl = GhostLockNativeImpl(context.applicationContext, shellImpl)
        ghostLockImpl = lockImpl
        GhostLockNative.setUp(messenger, lockImpl)

        ghostLockProfileImpl?.dispose()
        val lockProfileImpl = GhostLockProfileNativeImpl(context.applicationContext)
        ghostLockProfileImpl = lockProfileImpl
        GhostLockProfileNative.setUp(messenger, lockProfileImpl)

        ghostLockProfileEditImpl?.dispose()
        val lockProfileEditImpl = GhostLockProfileEditNativeImpl(context.applicationContext)
        ghostLockProfileEditImpl = lockProfileEditImpl
        GhostLockProfileEditNative.setUp(messenger, lockProfileEditImpl)
    }

    fun dispose() {
        systemStatusImpl?.dispose()
        systemStatusImpl = null
        adbShellImpl?.dispose()
        adbShellImpl = null
        deviceIdentityImpl?.dispose()
        deviceIdentityImpl = null
        rootManagerImpl?.dispose()
        rootManagerImpl = null
        dirtyFragImpl?.dispose()
        dirtyFragImpl = null
        cve98260Impl?.dispose()
        cve98260Impl = null
        cve98260ProfileImpl?.dispose()
        cve98260ProfileImpl = null
        runLogImpl?.dispose()
        runLogImpl = null
        ghostLockImpl?.dispose()
        ghostLockImpl = null
        ghostLockProfileImpl?.dispose()
        ghostLockProfileImpl = null
        ghostLockProfileEditImpl?.dispose()
        ghostLockProfileEditImpl = null
    }
}
