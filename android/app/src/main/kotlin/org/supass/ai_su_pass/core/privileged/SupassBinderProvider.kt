package org.supass.ai_su_pass.core.privileged

import android.content.ContentProvider
import android.content.ContentValues
import android.database.Cursor
import android.net.Uri
import android.os.Binder
import android.os.Bundle
import android.os.IBinder
import android.util.Log
import org.supass.ai_su_pass.privileged.SupassProtocol

/**
 * 特权进程把 Binder 推回宿主进程的唯一入口。
 *
 * 方向不要写反：不是 App 去「取」，而是 `app_process` 拉起的特权进程主动
 * `contentResolver.call(...)` 把 IBinder 塞进 Bundle 推过来。
 *
 * 两道校验缺一不可：
 * 1. Manifest 上的 `android:permission` —— 声明式拦截，但部分 ROM 会裁剪
 *    `INTERACT_ACROSS_USERS_FULL`，不能只靠它；
 * 2. `Binder.getCallingUid()` —— 这里必须再判一次，只有 root(0) / shell(2000) 才收。
 */
class SupassBinderProvider : ContentProvider() {

    override fun onCreate(): Boolean = true

    override fun call(method: String, arg: String?, extras: Bundle?): Bundle? {
        if (method != SupassProtocol.METHOD_SEND_BINDER) {
            Log.w(TAG, "unknown method=$method")
            return null
        }

        val callingUid = Binder.getCallingUid()
        if (callingUid != UID_ROOT && callingUid != UID_SHELL) {
            Log.w(TAG, "reject sendBinder from uid=$callingUid")
            return reject("uid=$callingUid not privileged")
        }

        val candidate = runCatching { extras?.getBinder(SupassProtocol.KEY_BINDER) }
            .onFailure { Log.w(TAG, "read binder failed: ${it.javaClass.simpleName}") }
            .getOrNull()
        if (candidate == null) {
            Log.w(TAG, "reject sendBinder: no binder in extras")
            return reject("no binder in extras")
        }

        // 把内核给出的真实调用方 uid 一并登记：宿主后续判定「有没有特权身份」
        // 就靠它，不需要再额外 ping 一次。
        val attached = SupassBinderHolder.attach(candidate, callingUid.toLong())
        if (!attached) {
            Log.w(TAG, "reject sendBinder: binder attach failed")
            return reject("binder attach failed")
        }

        Log.i(TAG, "binder accepted from uid=$callingUid")
        return Bundle().apply {
            putBoolean(SupassProtocol.KEY_ACK, true)
            putInt(SupassProtocol.KEY_VERSION, SupassProtocol.VERSION)
        }
    }

    /**
     * 拒绝回执。
     *
     * 必须带上原因：拒绝发生在本进程，特权进程只收到一个 false，
     * 不把原因捎回去，它落盘的日志里就只剩「被拒」，等于没有信息。
     */
    private fun reject(reason: String): Bundle = Bundle().apply {
        putBoolean(SupassProtocol.KEY_ACK, false)
        putString(SupassProtocol.KEY_REASON, reason)
    }

    override fun query(
        uri: Uri,
        projection: Array<out String>?,
        selection: String?,
        selectionArgs: Array<out String>?,
        sortOrder: String?,
    ): Cursor? = null

    override fun getType(uri: Uri): String? = null

    override fun insert(uri: Uri, values: ContentValues?): Uri? = null

    override fun delete(uri: Uri, selection: String?, selectionArgs: Array<out String>?): Int = 0

    override fun update(
        uri: Uri,
        values: ContentValues?,
        selection: String?,
        selectionArgs: Array<out String>?,
    ): Int = 0

    private companion object {
        const val TAG = SupassProtocol.TAG

        /** 允许推 Binder 的调用方身份：root(0) / shell(2000)。 */
        const val UID_ROOT = 0
        const val UID_SHELL = 2000
    }
}
