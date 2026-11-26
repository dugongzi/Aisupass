package org.supass.ai_su_pass.core.bridge.coolapk_auth_native

import android.os.Handler
import android.os.Looper
import android.webkit.CookieManager

/**
 * 酷安登录 Cookie 桥接层：读取与清空 WebView 会话里的 Cookie。
 */
class CoolapkAuthNativeImpl : CoolapkAuthNative {

    private val mainHandler = Handler(Looper.getMainLooper())

    override fun readCookie(urls: List<String>, callback: (Result<CoolapkCookie>) -> Unit) {
        mainHandler.post {
            callback(Result.success(CoolapkCookie(cookie = readCookies(urls))))
        }
    }

    override fun clearCookie(callback: (Result<Unit>) -> Unit) {
        val manager = CookieManager.getInstance()
        // 回调可能在任意线程，统一回主线程。
        manager.removeAllCookies {
            manager.flush()
            mainHandler.post { callback(Result.success(Unit)) }
        }
    }

    /**
     * 按域名依次读取并合并。
     *
     * 先 flush 再读：Android 的 Cookie 落盘是异步的，不 flush 可能读到
     * 上一次的快照。
     */
    private fun readCookies(urls: List<String>): String {
        val merged = LinkedHashMap<String, String>()
        val manager = CookieManager.getInstance()
        manager.flush()
        for (url in urls) {
            val header = manager.getCookie(url) ?: continue
            for (segment in header.split(";")) {
                val part = segment.trim()
                if (part.isEmpty()) continue
                val index = part.indexOf('=')
                if (index <= 0) continue
                val key = part.substring(0, index).trim()
                val value = part.substring(index + 1).trim()
                if (key.isEmpty() || value.isEmpty()) continue
                // 同名 Cookie 保留第一个，避免后面的空壳覆盖登录态。
                if (!merged.containsKey(key)) merged[key] = value
            }
        }
        return merged.entries.joinToString("; ") { "${it.key}=${it.value}" }
    }
}
