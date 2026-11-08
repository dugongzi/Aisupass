package org.supass.ai_su_pass.core.bridge.root_manager_native

import android.content.Context
import android.content.pm.ApplicationInfo
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.os.Handler
import android.os.Looper
import java.io.ByteArrayOutputStream
import java.io.File
import java.util.concurrent.Executors

/**
 * root 管理器扫描桥接层：只负责列出候选，不含选择与移交逻辑。
 *
 * 判据与移交脚本一致：安装目录里有 `libksud.so` 才算管理器。没有这个库，
 * `late-load` 根本无从谈起，列出来只会让用户选了才失败。
 */
class RootManagerNativeImpl(private val context: Context) : RootManagerNative {

    private companion object {
        /** 管理器自带的接管库，与 `HandoffScript.ksudLibrary` 同名。 */
        const val KSUD_LIBRARY = "libksud.so"

        /** 图标转 PNG 的边长，按 UI 最大显示尺寸取。 */
        const val ICON_SIZE = 192
    }

    private val executor = Executors.newSingleThreadExecutor()
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun scan(callback: (Result<List<RootManagerInfo>>) -> Unit) {
        // `getInstalledApplications` 与图标解码都是 PackageManager 的 IPC，
        // 统一放后台线程，与 SystemStatus 的取值时机保持一致。
        executor.execute {
            val managers = scanManagers()
            mainHandler.post { callback(Result.success(managers)) }
        }
    }

    /** 释放线程池，由 [org.supass.ai_su_pass.NativeProvider] 在页面销毁时调用。 */
    fun dispose() {
        executor.shutdownNow()
    }

    private fun scanManagers(): List<RootManagerInfo> {
        val packageManager = context.packageManager
        val self = context.packageName
        val installed = try {
            packageManager.getInstalledApplications(0)
        } catch (_: Exception) {
            // 包可见性被系统收紧时这里会抛，按「一个都没有」处理。
            emptyList<ApplicationInfo>()
        }
        return installed
            .asSequence()
            // 自己也可能带同名库，但它不是管理器。
            .filter { it.packageName != self }
            .filter { hasKsud(it) }
            .map { info ->
                RootManagerInfo(
                    packageName = info.packageName,
                    displayName = packageManager.getApplicationLabel(info).toString(),
                    icon = iconBytes(packageManager.getApplicationIcon(info)),
                )
            }
            .sortedBy { it.displayName.lowercase() }
            .toList()
    }

    /** 安装目录里有没有 `libksud.so`。`extractNativeLibs=false` 时目录为空。 */
    private fun hasKsud(info: ApplicationInfo): Boolean {
        val directory = info.nativeLibraryDir ?: return false
        return File(directory, KSUD_LIBRARY).isFile
    }

    /** 图标转 PNG 字节；解码失败返回空数组，由上层退回通用图标。 */
    private fun iconBytes(icon: Drawable?): ByteArray {
        if (icon == null) return ByteArray(0)
        return try {
            val bitmap = Bitmap.createBitmap(ICON_SIZE, ICON_SIZE, Bitmap.Config.ARGB_8888)
            val canvas = Canvas(bitmap)
            icon.setBounds(0, 0, ICON_SIZE, ICON_SIZE)
            icon.draw(canvas)
            ByteArrayOutputStream().use { out ->
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, out)
                out.toByteArray()
            }
        } catch (_: Exception) {
            ByteArray(0)
        }
    }
}
