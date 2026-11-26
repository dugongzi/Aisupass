package org.supass.ai_su_pass.core.root

import android.content.Context
import android.content.pm.ApplicationInfo
import android.util.Log
import java.io.File
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.atomic.AtomicInteger

/**
 * 定位 root 管理器自带的 ksud 可执行文件。
 *
 * 判定 = **布局合法** + **arm64 可执行 ELF** + **ksud 的 CLI 契约**。不认包名、不按库名
 * 认人、不执行文件：
 *
 * - 布局：`nativeLibraryDir` 必须真实落在 `/data/app/<安装目录>/<包名>/lib/arm64`；
 * - ELF：ELF64 + aarch64 + EXEC/DYN + **非零入口点**——只有这种文件才谈得上被 `execv`；
 * - 契约：`post-fs-data` + `boot-completed` + `late-load` 三段子命令文本全中。前两段是
 *   ksud 与 ramdisk init 的固定接口，第三段是我们要跑的命令，跨版本跨 fork 都不变。
 *
 * ## 为什么扫描阶段不做「跑一次 late-load --help」
 *
 * 那个判据在这里**必然失败**：`lib/arm64` 下的 `.so` 权限是 `0644`，应用进程
 * 没有执行位，`ProcessBuilder` 直接抛异常；个别 ROM 给成 `0755` 时反而会真的把进程
 * 拉起来、挂到超时——扫描耗时从百毫秒级变成分钟级就是它造成的。
 *
 * 可执行性验证属于 root 侧（bootstrap / 原生载荷），那里才有权限把 ksud 复制出去
 * 再 `chmod +x`。扫描只回答「有没有 ksud 本体」，不回答「能不能跑起来」。
 *
 * ## 性能
 *
 * 判定链按代价升序，便宜的判据在前、昂贵的有硬上限：
 *
 * | 步骤 | 代价 | 说明 |
 * |---|---|---|
 * | 布局字符串匹配 | 0 次 IO | 系统应用（/system、/apex、/product）全部挡掉 |
 * | 固定名 open + 读 32B | 1 次 open | 命中即返回，**连目录都不列** |
 * | `list()` + 体积筛选 | 1 次 readdir + N 次 stat | N = 目录里 `.so` 的个数 |
 * | ELF 头探测 | 每个候选 1 次 open | 93% 的普通 `.so` 在这一步被排掉 |
 * | 全文指纹 | ≤ [MAX_CONTENT_CANDIDATES] 份 | BMH 字节搜索 |
 *
 * canonical（realpath）只在命中之后做，失败路径上一次都不做——canonical 路径的所有前缀
 * 天然也是 canonical 的，对父目录反复 realpath 纯属浪费。
 *
 * `e_entry != 0` 是主力过滤器：共享库入口点恒为 0，实测 129 个真实 `.so` 里只有 9 个（7%）
 * 能通过，因此真正进入全文扫描的文件极少。
 *
 * 搜索用 Boyer-Moore-Horspool 跳过表直接在字节上跑，**不构造 String**。
 */
object KsudLocator {

    private const val TAG = "KsudLocator"

    /** KernelSU 系管理器的固定库名。 */
    const val LIBRARY_NAME = "libksud.so"

    private const val ELF_HEADER_SIZE = 32
    private const val ELF_TYPE_EXECUTABLE = 2
    private const val ELF_TYPE_SHARED = 3
    private const val ELF_MACHINE_AARCH64 = 183

    /**
     * 随机名候选的体积下限：只用来跳过明显不可能的极小文件。
     *
     * 真正的过滤器是 ELF 的 `e_entry`（见 [isArm64ExecutableHeader]）：共享库入口点恒为
     * 0，实测 129 个真实 `.so` 里只有 7% 通过。所以这里刻意不设高门槛——设成 1 MB
     * 虽然更省，但会漏掉不内嵌 `kernelsu.ko` 的 LKM 版小号 ksud，不值得。
     */
    private const val MIN_RANDOM_LIBRARY_SIZE = 32L * 1024L

    /** 随机名候选的体积上限：超过它不可能是 ksud，直接跳过。 */
    private const val MAX_RANDOM_LIBRARY_SIZE = 24L * 1024L * 1024L

    /**
     * 每个应用最多读几份**全文**。
     *
     * ELF 头已经淘汰掉 93% 的候选，能走到全文扫描的极少；给 2 份是留给「同时带了两份
     * 大号可执行库」的余量，同时把最坏情况的读盘量钉死。
     */
    private const val MAX_CONTENT_CANDIDATES = 2

    /**
     * 块读大小。
     *
     * **不要调大**：64 KB 以上的 `ByteArray` 在 ART 上会进大对象空间（LOS），并发读几个
     * 6 MB 的 ksud 时 1 MB 缓冲 × 8 线程会把 LOS 打满，实测触发了连续三次
     * `Background concurrent mark compact GC`（77 MB LOS）。64 KB 让常驻内存只剩几百 KB。
     */
    private const val READ_CHUNK = 64 * 1024

    /** 包名合法形态，防止把任意串当包名查。 */
    private val PACKAGE_PATTERN = Regex("[A-Za-z][A-Za-z0-9_]*(\\.[A-Za-z][A-Za-z0-9_]*)+")

    /** 标准安装布局的固定前后缀：`/data/app/<安装目录>/<包名>/lib/arm64`。 */
    private const val APP_DIR_PREFIX = "/data/app/"
    private const val NATIVE_DIR_SUFFIX = "/lib/arm64"

    /**
     * 主指纹：`post-fs-data`。
     *
     * 这是 ksud 与 ramdisk init 脚本之间的固定子命令（`ksud post-fs-data`），由内核
     * 模块安装器写进 init，**任何版本、任何 fork 都不会改**——比帮助文案稳定得多
     * （文案会改措辞，契约不会）。同时它足够独特：实测 129 个真实 `.so` 里只有真 ksud
     * 含它，各类提权载荷都没有。
     *
     * 热路径**只搜它**：普通 `.so` 的代价是「每块一次跳跃匹配」。命中之后才核对另外
     * 两条。
     */
    private const val PRIMARY_MARKER = "post-fs-data"

    /** 主指纹命中后必须同时出现的其余 init/CLI 契约。 */
    private val SECONDARY_MARKERS = listOf(
        "boot-completed",
        "late-load",
    )

    /** 预编码的 needle 与 BMH 跳过表：marker 是常量，表只建一次。 */
    private val PRIMARY_NEEDLE = PRIMARY_MARKER.toByteArray(Charsets.ISO_8859_1)
    private val PRIMARY_SKIP = buildSkipTable(PRIMARY_NEEDLE)

    private val SECONDARY_NEEDLES = SECONDARY_MARKERS.map { it.toByteArray(Charsets.ISO_8859_1) }
    private val SECONDARY_SKIPS = SECONDARY_NEEDLES.map(::buildSkipTable)

    /** 跨块重叠长度：最长 needle 减一，保证被块边界切开的串不会漏。 */
    private val OVERLAP = maxOf(PRIMARY_NEEDLE.size, SECONDARY_NEEDLES.maxOf { it.size }) - 1

    /** 包名 -> 判定结果（ksud 绝对路径，空串表示没有）。APK 被重写即失效。 */
    private class Cached(val stamp: Long, val path: String)

    private val cache = ConcurrentHashMap<String, Cached>()

    /** 本轮统计：命中缓存的次数、真正读盘判定的次数。仅用于日志。 */
    private val cacheHits = AtomicInteger(0)
    private val freshScans = AtomicInteger(0)

    /** 清空缓存与统计；包安装/卸载/更新后可主动调用。 */
    fun invalidate() {
        cache.clear()
        resetStats()
    }

    /** 重置统计计数，扫描开始前调用，让日志反映「本次」扫描。 */
    fun resetStats() {
        cacheHits.set(0)
        freshScans.set(0)
    }

    /** 一行统计，形如 `cache=120 fresh=8`。 */
    fun stats(): String = "cache=${cacheHits.get()} fresh=${freshScans.get()}"

    /**
     * 扫描用：应用是否自带 ksud（固定名，或改名库）。
     *
     * 结论按「包名 + APK 时间戳」缓存，热扫时零系统调用。
     */
    fun hasKsud(info: ApplicationInfo): Boolean = !resolve(info).isNullOrEmpty()

    /**
     * 取指定管理器的 ksud 绝对路径；包名非法、未安装或自带库里没有 ksud 时返回空串。
     *
     * 这是「用户选中的那一个」，走完整判据（固定名 → 改名库），失败会留日志。
     * 单个应用的成本无所谓，可以放心做完整搜索。
     */
    fun locate(context: Context, packageName: String): String {
        val pkg = packageName.trim()
        if (!PACKAGE_PATTERN.matches(pkg)) return ""

        val info = runCatching {
            context.packageManager.getApplicationInfo(pkg, 0)
        }.getOrNull() ?: run {
            Log.w(TAG, "$pkg: 未安装或不可见，找不到 ksud")
            return ""
        }

        val path = resolve(info)
        if (path == null) {
            Log.w(TAG, "$pkg: 没找到可用 ksud（原生库目录 ${info.nativeLibraryDir ?: "<空>"}）")
            return ""
        }
        return path
    }

    /** 带缓存的判定入口：同一份 APK 只判定一次；返回有效路径或 `null`，**永不返回空串**。 */
    private fun resolve(info: ApplicationInfo): String? {
        val packageName = info.packageName.orEmpty().trim()
        if (packageName.isEmpty()) return null
        val stamp = apkStamp(info)

        val cached = cache[packageName]
        if (cached != null && cached.stamp == stamp) {
            cacheHits.incrementAndGet()
            // 已经确认过「没有 ksud」：直接否定，不要重扫。
            if (cached.path.isEmpty()) return null
            // 已经确认过「有」：文件还在就复用；文件没了（被清理/换路径）就重扫。
            if (File(cached.path).isFile) return cached.path
        }

        freshScans.incrementAndGet()

        val path = findLibraryPath(info)
        cache[packageName] = Cached(stamp, path.orEmpty())
        return path
    }

    /**
     * APK 落盘时间戳，用于让判定结果随应用升级失效。
     *
     * 不用 `PackageInfo.lastUpdateTime`：那要多一次 `getPackageInfo` 的 IPC，而扫描
     * 会遍历上百个应用。APK 文件在装/更新时必然被重写，时间戳足够区分。
     */
    private fun apkStamp(info: ApplicationInfo): Long =
        info.sourceDir?.let { File(it).lastModified() } ?: 0L

    /**
     * 固定名快路径：`<nativeLibraryDir>/libksud.so` 存在、是 arm64 可执行 ELF、且是该目录下的
     * 直接文件。
     *
     * **canonical 只在这条路径命中后才做**（每轮扫描最多做几次），失败路径上一个都不做。
     * 这是冷扫从 1.4s 降到几十 ms 的关键之一。
     */
    private fun findFixedNamePath(application: ApplicationInfo): String? {
        val directoryPath = application.nativeLibraryDir
            ?.takeIf(String::isNotBlank)
            ?: return null
        // 纯字符串闸门，零系统调用。
        if (!isPlausibleNativeLibraryDir(directoryPath)) return null

        val directory = File(directoryPath)
        val file = File(directory, LIBRARY_NAME)
        // 一次 open：文件不存在时内核直接 ENOENT，没有读盘代价。
        if (!hasArm64ExecutableHeader(file)) return null

        // 命中之后才付 canonical 的代价：确认目录未被软链改写，且文件是目录下的直接成员。
        val canonicalDirectory = runCatching { directory.canonicalFile }.getOrNull() ?: return null
        val canonicalFile = runCatching { file.canonicalFile }.getOrNull() ?: return null
        if (canonicalFile.parentFile != canonicalDirectory) return null
        return canonicalFile.path
    }

    /**
     * 找 ksud：先固定名，再扫目录里的改名库。
     *
     * 两条判据都必须走——只看固定名会漏掉用改名库的 fork，设备上同时装两种管理器时
     * 就只能识别出一个。
     */
    private fun findLibraryPath(application: ApplicationInfo): String? {
        findFixedNamePath(application)?.let { return it }

        val directoryPath = application.nativeLibraryDir
            ?.takeIf(String::isNotBlank)
            ?: return null
        if (!isPlausibleNativeLibraryDir(directoryPath)) return null

        val directory = runCatching { File(directoryPath).canonicalFile }.getOrNull()
            ?: return null
        // canonical 之后复核：真实落点必须仍是 `<包目录>/lib/arm64`。
        if (!isPlausibleNativeLibraryDir(directory.path)) return null

        return findRandomLibrary(directory)?.path
    }

    /**
     * 纯字符串判定「这个路径是不是 `<包目录>/lib/arm64`」。
     *
     * 用前缀/后缀 + 两级切分代替正则：`matchEntire` 每次要建 MatchResult，686 个应用
     * 跑两遍的正则开销比这里全部字符串操作还高。
     */
    private fun isPlausibleNativeLibraryDir(path: String): Boolean {
        if (!path.startsWith(APP_DIR_PREFIX)) return false
        if (!path.endsWith(NATIVE_DIR_SUFFIX)) return false
        val inner = path.substring(
            APP_DIR_PREFIX.length,
            path.length - NATIVE_DIR_SUFFIX.length,
        )
        // 中间必须正好是 `<安装目录>/<包名>` 两段。
        val slash = inner.indexOf('/')
        if (slash <= 0 || slash == inner.length - 1) return false
        if (inner.indexOf('/', slash + 1) >= 0) return false
        // 两段都排除带 `android` 的：安装目录段（`/data/app/android/...` 之类的系统
        // overlay）和包名段（`com.android.*` 这类系统应用）都不是我们要的管理器。
        return !inner.contains("android", ignoreCase = true)
    }

    /**
     * 随机名扫描：目录里每个体积达标的 `.so` 都要过一遍。
     *
     * 不按体积截断候选——截断虽然快，但假设了「ksud 一定是最大的几个文件之一」，
     * 一旦某个 fork 的 lib 目录里还有更大的库，就会漏掉。这里选择把正确性放在前面。
     *
     * 顺序仍按代价升序，把便宜且淘汰率高的判据放前面：
     * 1. `list()`（一次 readdir，不建 File 对象）拿文件名，只要 `.so`；
     * 2. `length()` 体积闸门（一次 stat），按体积降序；
     * 3. 32 字节 ELF 头：实测 93% 的普通 `.so` 在这一步被排掉，**不产生读内容代价**；
     * 4. 直接在目录下（非软链）；
     * 5. 全文指纹（BMH 字节搜索），最多 [MAX_CONTENT_CANDIDATES] 份。
     */
    private fun findRandomLibrary(directory: File): File? {
        // `list()` 只做 readdir，返回文件名；比 `listFiles()` 少建 N 个 File 对象。
        val names = directory.list() ?: return null
        if (names.isEmpty()) return null

        val candidates = names.asSequence()
            .filter { it.endsWith(".so", ignoreCase = true) }
            .mapNotNull { name ->
                val file = File(directory, name)
                // 一次 stat 拿到体积；不落在区间内的直接丢。
                val size = file.length()
                if (size in MIN_RANDOM_LIBRARY_SIZE..MAX_RANDOM_LIBRARY_SIZE) {
                    file to size
                } else {
                    null
                }
            }
            .sortedByDescending { (_, size) -> size }
            .map { (file, _) -> file }
            .toList()
        if (candidates.isEmpty()) return null

        var contentReads = 0
        for (file in candidates) {
            // 32 字节读：普通共享库（无入口点）在这里被排掉，不产生读内容的代价。
            if (!hasArm64ExecutableHeader(file)) continue
            if (!isDirectLibraryFile(file, directory)) continue
            // 到这里才是真正的昂贵操作（全文件扫描），必须封顶。
            if (contentReads++ >= MAX_CONTENT_CANDIDATES) return null
            if (hasKsudFingerprint(file)) return file
        }
        return null
    }

    /** 必须是该目录下的直接文件：挡住指向别处的符号链接。 */
    private fun isDirectLibraryFile(file: File, directory: File): Boolean = runCatching {
        file.isFile && file.canonicalFile.parentFile == directory
    }.getOrDefault(false)

    /**
     * 只读前 32 字节判定 ELF 类型。
     *
     * 用局部标志而不是 `return@use`：`use` 的返回值会被丢弃，`return@use false` 只是让
     * 块提前结束，后面的判定照样执行——读不满 32 字节时靠「全零头必然不是 ELF」侥幸正确，
     * 但语义是错的，这里写清楚。
     */
    private fun hasArm64ExecutableHeader(file: File): Boolean = runCatching {
        val header = ByteArray(ELF_HEADER_SIZE)
        var complete = true
        file.inputStream().use { stream ->
            var read = 0
            while (read < ELF_HEADER_SIZE) {
                val n = stream.read(header, read, ELF_HEADER_SIZE - read)
                if (n <= 0) {
                    complete = false
                    break
                }
                read += n
            }
        }
        complete && isArm64ExecutableHeader(header)
    }.getOrDefault(false)

    /** ELF64 + aarch64 + 可执行/共享 + 有入口点：只有这种文件能被 `execv`。 */
    private fun isArm64ExecutableHeader(header: ByteArray): Boolean {
        if (header.size < ELF_HEADER_SIZE) return false
        val isElf = header[0] == 0x7f.toByte() &&
            header[1] == 'E'.code.toByte() &&
            header[2] == 'L'.code.toByte() &&
            header[3] == 'F'.code.toByte()
        if (!isElf || header[4] != 2.toByte() || header[5] != 1.toByte()) return false
        val type = (header[16].toInt() and 0xff) or ((header[17].toInt() and 0xff) shl 8)
        val machine = (header[18].toInt() and 0xff) or ((header[19].toInt() and 0xff) shl 8)
        val executableType = type == ELF_TYPE_EXECUTABLE || type == ELF_TYPE_SHARED
        // 共享库的 e_entry 恒为 0，只有真正的可执行文件有非零入口点。
        val hasEntryPoint = (24..31).any { header[it] != 0.toByte() }
        return executableType && machine == ELF_MACHINE_AARCH64 && hasEntryPoint
    }

    /**
     * 全文指纹：主指纹 + 其余两条全中。
     *
     * 单次顺序读、块内字节匹配，全程不构造 `String`。其余两条只在主指纹命中后才核对
     * ——普通库在任何一块都不会命中主指纹，因此热路径的开销就是每块一次跳跃匹配。
     *
     * 用显式 `BooleanArray` 记录进度，而不是对集合做 `retainAll`：后者是「保留 predicate
     * 为 true 的元素」，写反就会变成「保留没找到的」，静默地把所有应用判成没有 ksud。
     */
    private fun hasKsudFingerprint(file: File): Boolean {
        if (file.length() > MAX_RANDOM_LIBRARY_SIZE) return false
        return runCatching { scanFingerprint(file) }.getOrDefault(false)
    }

    private fun scanFingerprint(file: File): Boolean {
        val buffer = ByteArray(READ_CHUNK + OVERLAP)
        var carried = 0
        var primaryFound = false
        val secondaryFound = BooleanArray(SECONDARY_NEEDLES.size)
        var secondaryRemaining = SECONDARY_NEEDLES.size

        file.inputStream().use { stream ->
            while (true) {
                val read = stream.read(buffer, carried, READ_CHUNK)
                if (read < 0) break
                val available = carried + read

                if (!primaryFound) {
                    primaryFound = indexOf(buffer, available, PRIMARY_NEEDLE, PRIMARY_SKIP) >= 0
                }
                if (primaryFound) {
                    for (index in SECONDARY_NEEDLES.indices) {
                        if (secondaryFound[index]) continue
                        if (indexOf(
                                buffer,
                                available,
                                SECONDARY_NEEDLES[index],
                                SECONDARY_SKIPS[index],
                            ) >= 0
                        ) {
                            secondaryFound[index] = true
                            secondaryRemaining--
                        }
                    }
                    // 本块内已经凑齐，不必再往后读。
                    if (secondaryRemaining == 0) return true
                }

                // 保留尾部 overlap，跨块边界的串才不会漏。
                carried = minOf(OVERLAP, available)
                System.arraycopy(buffer, available - carried, buffer, 0, carried)
            }
        }
        return false
    }

    /**
     * Boyer-Moore-Horspool：在 [hay] 的前 [hayLen] 字节里找 [needle]。
     *
     * 平均每次失配跳过 `needle.size` 个字节，比逐字节比较快一个数量级；
     * 全程只读 `ByteArray`，零分配、零字符串解码。
     */
    private fun indexOf(hay: ByteArray, hayLen: Int, needle: ByteArray, skip: IntArray): Int {
        val m = needle.size
        if (hayLen < m) return -1
        var i = m - 1
        while (i < hayLen) {
            var k = m - 1
            val base = i - m + 1
            while (k >= 0 && hay[base + k] == needle[k]) k--
            if (k < 0) return base
            i += skip[hay[i].toInt() and 0xff]
        }
        return -1
    }

    /** BMH 失配跳过表：默认跳过整个 needle 长度，命中过的字节按位置收敛。 */
    private fun buildSkipTable(pattern: ByteArray): IntArray {
        val skip = IntArray(256) { pattern.size }
        for (index in 0 until pattern.lastIndex) {
            skip[pattern[index].toInt() and 0xff] = pattern.lastIndex - index
        }
        return skip
    }
}
