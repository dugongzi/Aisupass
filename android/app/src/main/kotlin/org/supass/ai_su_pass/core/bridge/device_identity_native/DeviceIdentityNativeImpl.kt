package org.supass.ai_su_pass.core.bridge.device_identity_native

import android.content.Context
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.system.Os
import android.system.OsConstants
import java.util.concurrent.Executors

/**
 * 设备身份采集桥接层：只负责取值，不含任何匹配判断。
 *
 * 与 KSuRoot 的 `DeviceSnapshot` 对齐，全部走 App 侧 API，
 * 不绕到 shell 去 `getprop`。
 */
class DeviceIdentityNativeImpl(private val context: Context) : DeviceIdentityNative {

    private companion object {
        /** 内核提交号：`-g` 加 10 位以上十六进制。 */
        val KERNEL_COMMIT: Regex = Regex("-g([0-9a-f]{10,})")

        /**
         * 市场名属性。`Build.MODEL` 在 vivo/iQOO 上是型号代码，
         * catalog 登记的是市场名，所以把常见市场名字段一并拼进身份文本。
         */
        val MARKET_NAME_PROPERTIES: List<String> = listOf(
            "ro.miui.product.name",
            "ro.product.marketname",
        )
    }

    private val executor = Executors.newSingleThreadExecutor()
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun read(callback: (Result<DeviceIdentity>) -> Unit) {
        // `Os.uname()` 与属性读取都算轻量，但统一放后台线程，
        // 与 SystemStatus 的取值时机保持一致。
        executor.execute {
            val identity = readIdentity()
            mainHandler.post { callback(Result.success(identity)) }
        }
    }

    override fun nativeLibraryDir(callback: (Result<String>) -> Unit) {
        val directory = context.applicationInfo.nativeLibraryDir.orEmpty()
        mainHandler.post { callback(Result.success(directory)) }
    }

    /** 释放线程池，由 [org.supass.ai_su_pass.NativeProvider] 在页面销毁时调用。 */
    fun dispose() {
        executor.shutdownNow()
    }

    private fun readIdentity(): DeviceIdentity {
        val release = readKernelRelease()
        return DeviceIdentity(
            identityText = buildIdentityText(),
            kernelRelease = release,
            kernelVersion = release.split("-")[0],
            kernelCommit = KERNEL_COMMIT.find(release)?.groupValues?.getOrNull(1).orEmpty(),
            manufacturer = Build.MANUFACTURER.orEmpty().lowercase(),
            model = Build.MODEL.orEmpty(),
            pageSize = readPageSize(),
        )
    }

    /**
     * 身份文本：多个来源去重后小写空格拼接。
     *
     * 名字落在哪个字段都能命中，纯召回提升，不新增数据。
     */
    private fun buildIdentityText(): String {
        val sources = LinkedHashSet<String>()
        sources.add(Build.MANUFACTURER.orEmpty())
        sources.add(Build.BRAND.orEmpty())
        sources.add(Build.MODEL.orEmpty())
        sources.add(Build.DEVICE.orEmpty())
        sources.add(Build.PRODUCT.orEmpty())
        sources.add(Build.BOARD.orEmpty())
        for (key in MARKET_NAME_PROPERTIES) {
            sources.add(readSystemProperty(key))
        }
        return sources
            .map { it.trim().lowercase() }
            .filter { it.isNotEmpty() }
            .joinToString(" ")
    }

    /**
     * 内核完整版本串。
     *
     * 必须取 `Os.uname().release`：`System.getProperty("os.version")` 读的是
     * `Build.VERSION` 里的编译期常量，与运行中的内核不保证一致。
     */
    private fun readKernelRelease(): String {
        return try {
            Os.uname().release.orEmpty()
        } catch (e: Exception) {
            // 取不到就留空，让上层按「内核未知」处理，绝不瞎猜。
            ""
        }
    }

    /** 分页大小，单位字节。Pigeon 把 Dart `int` 映射成 Kotlin `Long`。 */
    private fun readPageSize(): Long {
        return try {
            Os.sysconf(OsConstants._SC_PAGESIZE).toLong()
        } catch (e: Exception) {
            0L
        }
    }

    /**
     * 读系统属性。
     *
     * `android.os.SystemProperties` 是 @hide 类，编译期不可见，只能反射。
     * 任何失败都返回空串，不向上抛。
     */
    private fun readSystemProperty(key: String): String {
        return try {
            val clazz = Class.forName("android.os.SystemProperties")
            val get = clazz.getMethod("get", String::class.java)
            (get.invoke(null, key) as? String).orEmpty()
        } catch (e: Exception) {
            ""
        }
    }
}
