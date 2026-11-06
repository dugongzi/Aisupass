package org.supass.ai_su_pass.core.bridge.device_identity_native

import android.content.Context
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.system.Os
import android.system.OsConstants
import java.util.concurrent.Executors

/**
 * 设备身份采集桥接层：只负责取值，不含任何匹配判断。
 *
 * 全部走 App 侧 API，不绕到 shell 去 `getprop`。
 */
class DeviceIdentityNativeImpl(private val context: Context) : DeviceIdentityNative {

    private companion object {
        /** 内核提交号：`-g` 加 10 位以上十六进制。 */
        val KERNEL_COMMIT: Regex = Regex("-g([0-9a-f]{10,})")

        /**
         * 市场名属性候选，**按可信度排序**。
         *
         * `Build.MODEL` 在 vivo/iQOO 上是型号代码（`V2463A`），catalog 登记的却是
         * 市场名（`iqoo 13`），只拼 `Build.*` 必然召回不到。
         *
         * 注意 `ro.vivo.product.model` **不在**列表里：实测它返回代号 `PD2463`，
         * 当市场名用会把代号显示给用户，属于「猜错比认不出更糟」。
         */
        val MARKET_NAME_PROPERTIES: List<String> = listOf(
            // Android 官方约定（多分区都可能有）
            "ro.product.marketname",
            "ro.product.system.marketname",
            "ro.product.vendor.marketname",
            "ro.product.odm.marketname",
            "ro.product.product.marketname",
            // 通用别名
            "ro.config.marketing_name",
            "ro.config.market_name",
            // 厂商自定义
            "ro.vivo.market.name",
            "ro.oppo.market.name",
            "ro.oplus.market.name",
            "ro.miui.product.name",
            "ro.product.mod_device",
            "ro.config.device_name",
            "ro.huawei.market.name",
            "ro.honor.market.name",
        )

        /** 形如 `V2463A` / `PD2463` / `SM-S918B` 的型号代码：短、无空格、字母数字混排。 */
        val CODE_LIKE: Regex = Regex("^[A-Za-z]{1,4}[-_]?[A-Za-z0-9]{2,10}$")
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
     * 身份文本：`Build.*` 六项 + 市场名，去重后小写空格拼接。
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
        sources.add(marketName().orEmpty())
        return sources
            .map { it.trim() }
            .filter { it.isNotEmpty() }
            .distinct()
            .joinToString(" ")
            .lowercase()
    }

    /**
     * 取市场名：先按属性优先级找，再回落 `Settings.Global.device_name`
     * （蓝牙/热点里的设备名，出厂常写的就是市场名）。
     *
     * 取不到返回 `null`，**不回落**到型号代码——猜错比认不出更糟。
     */
    private fun marketName(): String? {
        for (key in MARKET_NAME_PROPERTIES) {
            val value = readSystemProperty(key).trim()
            if (value.isEmpty()) continue
            // 值本身像型号代码（`PD2463` / `V2463A`）就不认它是市场名。
            if (looksLikeCode(value)) continue
            return value
        }
        return try {
            Settings.Global.getString(context.contentResolver, "device_name")
                ?.trim()
                ?.takeIf { it.isNotEmpty() }
        } catch (e: Exception) {
            null
        }
    }

    /** 名字看起来像型号代码吗？有空格或含小写都判「不像」。 */
    private fun looksLikeCode(name: String): Boolean {
        if (name.isEmpty()) return false
        if (name.contains(' ')) return false
        if (name.any { it.isLowerCase() }) return false
        return CODE_LIKE.matches(name)
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
