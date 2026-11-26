package org.supass.ai_su_pass.core.adb

import android.content.Context
import android.util.Log

/**
 * 无线 ADB 的「曾经成功建链」记录。
 *
 * 只回答一个问题：本机是否至少成功建立过一次 adb shell 连接。
 * 与 [AdbKeyStore] 的分工：那边管密钥是否存在，这边管设备是否信任过这把密钥。
 * 二者不等价——配对失败也会留下密钥文件。
 *
 * 为什么单独落 SharedPreferences：无线调试关闭时 mDNS 不广播，
 * 「重连失败」无法反推「没配对过」；必须有一个与开关状态无关的持久事实。
 */
internal class AdbPairingHistory(context: Context) {

    private val prefs = context.applicationContext
        .getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    /** 是否至少成功建链过一次。 */
    val everConnected: Boolean get() = prefs.getBoolean(KEY_EVER_CONNECTED, false)

    /** 最近一次建链成功的时间戳（`System.currentTimeMillis()`）；0 表示从未。 */
    val lastLinkedAt: Long get() = prefs.getLong(KEY_LAST_LINKED_AT, 0L)

    /** 记录一次成功建链。只在 uid 有效时调用。 */
    fun markConnected() {
        val now = System.currentTimeMillis()
        prefs.edit()
            .putBoolean(KEY_EVER_CONNECTED, true)
            .putLong(KEY_LAST_LINKED_AT, now)
            .apply()
        Log.i(TAG, "markConnected everConnected=true at=$now")
    }

    /** 设备端撤销授权后调用：必须重新配对，历史不再成立。 */
    fun markRevoked() {
        prefs.edit()
            .putBoolean(KEY_EVER_CONNECTED, false)
            .remove(KEY_LAST_LINKED_AT)
            .apply()
        Log.w(TAG, "markRevoked everConnected=false")
    }

    private companion object {
        const val TAG = "AdbShell"
        const val PREFS_NAME = "adb_state"
        const val KEY_EVER_CONNECTED = "ever_connected"
        const val KEY_LAST_LINKED_AT = "last_linked_at"
    }
}
