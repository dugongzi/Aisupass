package org.supass.ai_su_pass.core.bridge.system_status_native

import android.content.Context
import android.content.IntentFilter
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.util.Log
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit

/**
 * 系统状态桥接层：只负责取值，不包含 UI 逻辑。
 *
 * ROOT 检测要执行 `su`，放在后台线程。
 */
class SystemStatusNativeImpl(private val context: Context) : SystemStatusNative {

    private companion object {
        const val TAG = "SystemStatus"

        // 以下三个是 UsbManager 里的 @hide 常量，SDK 编译期不可见，只能写字面量。
        /** UsbManager.ACTION_USB_STATE，sticky 广播。 */
        const val ACTION_USB_STATE = "android.hardware.usb.action.USB_STATE"

        /** UsbManager.USB_CONNECTED。 */
        const val EXTRA_USB_CONNECTED = "connected"

        /** UsbManager.USB_FUNCTION_ADB。 */
        const val EXTRA_USB_FUNCTION_ADB = "adb"
    }

    private val executor = Executors.newSingleThreadExecutor()
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun isRoot(callback: (Result<Boolean>) -> Unit) {
        executor.execute {
            val rooted = detectRoot()
            // Pigeon 的回调回到主线程执行，避免跨线程回调 Channel。
            mainHandler.post { callback(Result.success(rooted)) }
        }
    }

    override fun isAdbEnabled(callback: (Result<AdbStatus>) -> Unit) {
        // 查询 sticky 广播虽快，但与 ROOT 检测共用后台线程，保持一致的取值时机。
        executor.execute {
            val status = readAdbStatus()
            mainHandler.post { callback(Result.success(status)) }
        }
    }

    private fun readAdbStatus(): AdbStatus {
        val resolver = context.contentResolver
        // 总开关。无线调试开启时系统也会把它置 1，所以它只代表 adbd 在跑。
        val adbEnabled = Settings.Global.getInt(resolver, Settings.Global.ADB_ENABLED, 0) == 1
        // `adb_wifi_enabled` 没有公开常量，只能按字符串读。
        val wifi = Settings.Global.getInt(resolver, "adb_wifi_enabled", 0) == 1

        // `sys.usb.state` 在无线调试时同样会变成 `adb`，所以只能靠 USB 是否
        // 真的连着来区分有线。USB_STATE 是 sticky 广播，直接查当前值即可。
        val usbConnected = isUsbConnected()
        val usb = adbEnabled && usbConnected

        Log.i(
            TAG,
            "ADB probe: adb_enabled=$adbEnabled, adb_wifi_enabled=$wifi, " +
                "usb_connected=$usbConnected -> usb=$usb, wifi=$wifi",
        )

        return AdbStatus(usb = usb, wifi = wifi)
    }

    /**
     * USB 是否处于连接状态。
     *
     * 查 `UsbManager.ACTION_USB_STATE` 的 sticky 广播：`connected` 表示线插着
     * 且已枚举，`adbFunction` 表示 USB 当前功能组合里包含 adb。两者同时成立
     * 才算有线调试可用，仅开无线调试时 `connected` 为 false。
     */
    private fun isUsbConnected(): Boolean {
        return try {
            val intent = context.registerReceiver(null, IntentFilter(ACTION_USB_STATE))
                ?: return false

            val connected = intent.getBooleanExtra(EXTRA_USB_CONNECTED, false)
            val adbFunction = intent.getBooleanExtra(EXTRA_USB_FUNCTION_ADB, false)
            Log.i(TAG, "USB state: connected=$connected, adbFunction=$adbFunction")
            connected && adbFunction
        } catch (e: Exception) {
            Log.w(TAG, "USB state read failed", e)
            false
        }
    }

    /** 执行 `su -c id`，超时或未授权都视为未 ROOT。 */
    private fun detectRoot(): Boolean {
        return try {
            val process = Runtime.getRuntime().exec(arrayOf("su", "-c", "id"))
            if (!process.waitFor(1500, TimeUnit.MILLISECONDS)) {
                process.destroy()
                return false
            }
            process.exitValue() == 0
        } catch (e: Exception) {
            false
        }
    }

    /** 释放线程池，由 [org.supass.ai_su_pass.NativeProvider] 在页面销毁时调用。 */
    fun dispose() {
        executor.shutdownNow()
    }
}
