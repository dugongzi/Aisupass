package org.supass.ai_su_pass.core.bridge.root_manager_native

import android.content.Context
import android.content.pm.ApplicationInfo
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.util.Log
import java.io.ByteArrayOutputStream
import java.io.File
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.Executors
import org.supass.ai_su_pass.core.root.KsudLocator

/**
 * root 管理器扫描桥接层：只负责列出候选，不含选择与移交逻辑。
 *
 * 判据全部交给 [KsudLocator]：应用 `lib/arm64` 下必须躺着 arm64 可执行 ELF，且二进制里带
 * `post-fs-data` / `boot-completed` / `late-load` 三段子命令文本（ksud 与 init 的固定契约）。
 * 没有它，`late-load` 根本无从谈起，列出来只会让用户选了才失败。
 *
 * 本类不写死任何包名或库文件名。
 */
class RootManagerNativeImpl(private val context: Context) : RootManagerNative {

    private companion object {
        const val TAG = "RootManagerScan"

        /** 图标转 PNG 的边长，按 UI 最大显示尺寸取。 */
        const val ICON_SIZE = 192

        /**
         * 扫描并发度：按可用 CPU 取，封顶 8。
         *
         * 判定以文件系统为主（stat + 少量块读），属于 IO 等待型；并发能把百来个应用的
         * 总耗时压到接近单个慢应用的水平，又不至于把低端机的 IO 队列打爆。
         */
        val SCAN_THREADS = Runtime.getRuntime().availableProcessors().coerceIn(2, 8)
    }

    private val executor = Executors.newSingleThreadExecutor()
    private val mainHandler = Handler(Looper.getMainLooper())

    /**
     * 图标 PNG 字节缓存：`包名@APK时间戳` -> 字节。
     *
     * 图标只跟 APK 版本有关，跟 ksud 路径同生命周期，所以用同样的 stamp 作 key。
     * 不加这层的话，每次扫描都要对命中的管理器重新 `createBitmap` + `draw` + PNG 压缩，
     * 实测 2 个图标就要 10–14 ms，而热扫的判定本身只要 6–8 ms——图标反而成了最大单项。
     */
    private val iconCache = ConcurrentHashMap<String, ByteArray>()

    override fun scan(callback: (Result<List<RootManagerInfo>>) -> Unit) {
        // `getInstalledApplications` 与图标解码都是 PackageManager 的 IPC，
        // 统一放后台线程，与 SystemStatus 的取值时机保持一致。
        executor.execute {
            // 扫描抛异常时也要回调，否则上层永远停在 loading。
            val managers = runCatching { scanManagers() }
                .onFailure { Log.e(TAG, "扫描管理器失败", it) }
                .getOrDefault(emptyList())
            mainHandler.post { callback(Result.success(managers)) }
        }
    }

    override fun resolveKsudPath(
        packageName: String,
        callback: (Result<String>) -> Unit,
    ) {
        // 命中固定名时只是一次文件打开；走随机名指纹才需要读文件，放后台。
        executor.execute {
            val path = runCatching { KsudLocator.locate(context, packageName) }
                .getOrDefault("")
            mainHandler.post { callback(Result.success(path)) }
        }
    }

    /** 释放线程池，由 [org.supass.ai_su_pass.NativeProvider] 在页面销毁时调用。 */
    fun dispose() {
        executor.shutdownNow()
        iconCache.clear()
    }

    private fun scanManagers(): List<RootManagerInfo> {
        // 先重置统计，让日志只反映本次扫描（冷/热一眼能分辨）。
        KsudLocator.resetStats()
        val t0 = SystemClock.elapsedRealtime()

        val packageManager = context.packageManager
        val self = context.packageName
        val installed = try {
            packageManager.getInstalledApplications(0)
        } catch (_: Exception) {
            // 包可见性被系统收紧时这里会抛，按「一个都没有」处理。
            Log.w(TAG, "getInstalledApplications 失败，按空列表处理")
            emptyList<ApplicationInfo>()
        }
        // 这一步在大 ROM（几百个应用）上本身就要几十毫秒，单独计时便于定位瓶颈。
        val pmMs = SystemClock.elapsedRealtime() - t0

        val visible = installed.filter { it.packageName != self }
        if (visible.isEmpty()) {
            Log.i(TAG, "扫描完成：没有可见应用")
            return emptyList()
        }

        // 并发判定，避免串行扫上百个应用时卡到用户以为扫不出来。
        //
        // 每个应用都走**完整判据**：固定名 `libksud.so` 优先，没有则扫目录里的改名库
        // （arm64 可执行 ELF + `post-fs-data`/`boot-completed`/`late-load` 三契约）。
        //
        // 不做「只查固定名、全空才补查」的级联：那样会把只用改名库的管理器漏掉
        // ——设备上同时装了 KernelSU（固定名）和某个改名库 fork 时，只查固定名就只剩一个。
        // 正确性优先，冷扫多花的那一秒由缓存吸收（热扫走缓存，仍是个位数毫秒）。
        val judgeStart = SystemClock.elapsedRealtime()
        val hits = judgeConcurrently(visible) { KsudLocator.hasKsud(it) }
        // 判定耗时才是这套算法本身的成本，与 PackageManager、图标解码分开看。
        val judgeMs = SystemClock.elapsedRealtime() - judgeStart

        // 图标只对命中的少数做，且带缓存，单列一段。
        val iconStart = SystemClock.elapsedRealtime()
        val found = hits.map { info ->
            RootManagerInfo(
                packageName = info.packageName,
                displayName = runCatching {
                    packageManager.getApplicationLabel(info).toString()
                }.getOrDefault(info.packageName),
                icon = cachedIcon(info),
            )
        }
        val iconMs = SystemClock.elapsedRealtime() - iconStart

        // 一次汇总：数量 + 三段耗时 + 冷热比。冷扫（fresh == 总数）才是真实性能。
        val totalMs = SystemClock.elapsedRealtime() - t0
        Log.i(
            TAG,
            "扫描完成：可见应用 ${visible.size} 个，命中管理器 ${found.size} 个，" +
                "耗时 ${totalMs}ms（包管理 ${pmMs}ms / 判定 ${judgeMs}ms / 图标 ${iconMs}ms），" +
                KsudLocator.stats(),
        )
        return found.sortedBy { it.displayName.lowercase() }
    }

    /**
     * 在一批应用上并发跑一个判据，收集为 true 的那些。
     *
     * 不加 `inline`：`predicate` 要被放进 `pool.submit { }` 这个跨线程的 lambda 里，
     * inline 会让编译器无法排除非局部返回（除非声明 `crossinline`）。这里每轮只调用
     * 两次，内联带来的收益为零，保持普通函数更简单。
     */
    private fun judgeConcurrently(
        targets: List<ApplicationInfo>,
        predicate: (ApplicationInfo) -> Boolean,
    ): List<ApplicationInfo> {
        val pool = Executors.newFixedThreadPool(minOf(SCAN_THREADS, targets.size))
        return try {
            targets
                .map { info -> pool.submit<ApplicationInfo?> { if (predicate(info)) info else null } }
                .mapNotNull { future -> runCatching { future.get() }.getOrNull() }
        } finally {
            pool.shutdownNow()
        }
    }

    /** 取图标 PNG 字节，按「包名 + APK 时间戳」缓存；APK 换了自动重取。 */
    private fun cachedIcon(info: ApplicationInfo): ByteArray {
        val stamp = info.sourceDir?.let { File(it).lastModified() } ?: 0L
        val key = "${info.packageName}@$stamp"

        iconCache[key]?.let { return it }

        val icon = iconBytes(runCatching { context.packageManager.getApplicationIcon(info) }
            .getOrNull())
        // 只缓存非空的：取图标失败时留空，下次扫描再试，避免把瞬时失败固化下来。
        if (icon.isNotEmpty()) {
            // 顺手清掉同一包名的旧 stamp，避免应用反复升级后缓存无限增长。
            iconCache.keys.removeAll { it.startsWith("${info.packageName}@") }
            iconCache[key] = icon
        }
        return icon
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
