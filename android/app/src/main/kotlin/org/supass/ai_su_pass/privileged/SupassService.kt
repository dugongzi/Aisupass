package org.supass.ai_su_pass.privileged

import android.os.Binder
import android.os.Bundle
import android.os.IBinder
import android.os.Looper
import android.os.Process
import android.util.Log
import java.io.FileOutputStream
import java.lang.reflect.InvocationTargetException
import java.lang.reflect.Method

/**
 * 特权常驻进程入口，由应用侧通过 ADB shell 执行：
 *
 * ```text
 * CLASSPATH=<base.apk> app_process64 /system/bin --nice-name=supassd \
 *     org.supass.ai_su_pass.privileged.SupassService <authority>
 * ```
 *
 * 启动顺序（顺序本身是安全边界）：
 * 1. 校验自身 uid ∈ {0, 2000}，否则立刻退出——防止被普通 App 拉起后冒充特权进程；
 * 2. `Looper.prepareMainLooper()`
 * 3. 把 [PrivilegedExecBinder] **推给**宿主 Provider（方向不能写反）；
 * 4. 加入 Binder 线程池并常驻。
 *
 * 推 Binder 走的是 `IActivityManager.getContentProviderExternal()`，**不是**
 * `ContentResolver.call()`。原因见 [pushBinder] 的注释：后者要求调用方声明一个
 * 包名，而 `app_process` 进程手里只有 `"android"`，与 uid 2000 永远对不上。
 */
object SupassService {

    @JvmStatic
    fun main(args: Array<String>) {
        // 第一行必须在任何闸门之前写：日志文件里若连这一行都没有，说明进程压根没
        // 跑到 main（类加载失败 / dex 不可读），和「跑到了但被闸门拒绝」是两种
        // 完全不同的故障，上层要能一眼区分。
        note("enter main uid=${Process.myUid()} pid=${Process.myPid()} args=${args.size}")

        // 顶层兜底：任何未捕获异常在这里落盘再退。没有这一层，一次崩溃只会让
        // 日志停在最后一条正常行上，看上去像是「无缘无故没了」。
        try {
            start(args)
        } catch (t: Throwable) {
            note("crash: ${t.javaClass.name}: ${t.message}", error = true)
            note(t.stackTraceToString().take(STACK_LIMIT), error = true)
            Process.killProcess(Process.myPid())
        }
    }

    private fun start(args: Array<String>) {
        val uid = Process.myUid()
        if (uid != UID_ROOT && uid != UID_SHELL) {
            fail(EXIT_NOT_PRIVILEGED, "refusing to start: uid=$uid not in {0,2000}")
        }

        val authority = args.getOrNull(0).orEmpty()
        if (authority.isEmpty()) {
            fail(EXIT_NO_AUTHORITY, "refusing to start: missing provider authority")
        }

        note("start authority=$authority")

        prepareMainLooper()

        val binder = PrivilegedExecBinder()

        // 先让一条后台线程进 Binder 池，再推 Binder。
        // 宿主在 Provider.call 里会立刻对这个代理做 Binder 事务（linkToDeath / ping），
        // 此时本进程若还没有池线程，入站事务无人处理，两边会互相等待。
        Thread({ joinBinderPool("pool-1") }, "supass-binder-1").apply {
            isDaemon = true
            start()
        }

        if (!pushBinder(authority, binder)) {
            fail(EXIT_PUSH_FAILED, "binder delivery failed, giving up")
        }

        note("binder delivered, joining binder thread pool")
        // 主线程也进池：长命令会占住一个池线程，ping 需要另一个线程应答。
        joinBinderPool("main")
        // 正常情况下 joinBinderPool 永不返回；走到这里说明两条入口都不可用。
        fail(EXIT_NO_BINDER_POOL, "no binder thread pool available")
    }

    /**
     * 准备主线程 Looper。
     *
     * 走 [joinBinderPool] 的兜底分支时需要它跑消息循环；提前准备好，失败路径
     * 才不会变成「进程活着但不响应」。已 prepare 过时按就绪处理，不重复调用。
     */
    private fun prepareMainLooper() {
        runCatching { Looper.prepareMainLooper() }
            .onFailure {
                note("prepareMainLooper skipped: ${it.javaClass.simpleName}: ${it.message}")
            }
        note("main looper ready=${Looper.myLooper() != null}")
    }

    /**
     * 把 Binder 推进宿主 Provider。
     *
     * **为什么不用 `ContentResolver.call()`**：那条路要求调用方提供一个「包名」，
     * AMS 收到后会用 `AppOpsManager.checkPackage(callingUid, callingPackage)` 反查，
     * 两者不一致直接抛
     * `SecurityException: Given calling package X does not match caller's uid Y`。
     * `app_process` 进程由 `ActivityThread.systemMain()` 拿到的 Context，包名写死是
     * `"android"`，而本进程 uid 是 2000 —— 这个矛盾在 Context 层无论怎么改字段都
     * 消不掉（改私有字段还会撞 hidden API 限制）。
     *
     * **现在这条路**：`IActivityManager.getContentProviderExternal()` 是 AMS 提供给
     * shell 的特权入口（`adb shell dumpsys` / Shizuku 都走它）。调用方身份由
     * Binder 的 callingUid 决定，也就是真实的 2000，全程不需要声明任何包名。
     * 拿到的 `IContentProvider` 再直接 `call()`，第一个参数传 `null` 包名。
     *
     * 重试是必要的：Provider 所在进程可能刚被系统回收，或在冷启动时还没就绪。
     * 但重试有上限——拉不起来就明确失败，让上层报「特权服务不可用」，不要无限重来。
     */
    private fun pushBinder(authority: String, binder: Binder): Boolean {
        val am = activityManager()
        if (am == null) {
            note("push aborted: IActivityManager unavailable", error = true)
            return false
        }
        val userId = Process.myUid() / UID_PER_USER

        var lastError: String? = null
        repeat(PUSH_ATTEMPTS) { attempt ->
            var reason: String? = null
            var thrown: Throwable? = null
            var delivered = false

            try {
                val holder = getContentProviderExternal(am, authority, userId)
                    ?: throw IllegalStateException("getContentProviderExternal returned null")
                // 返回的是 ContentProviderHolder 而不是 IContentProvider 本身：
                // holder.provider 才是可调用的 Binder 代理，其余字段（info/connection）
                // 是给 ActivityThread.installProvider 用的，这里用不到。
                val provider = readField(holder, "provider")
                    ?: throw IllegalStateException("ContentProviderHolder.provider is null")
                try {
                    // Provider 拒绝时会把原因写在 [SupassProtocol.KEY_REASON] 里；
                    // 这条消息是唯一能解释「为什么被拒」的东西，必须带进日志。
                    @Suppress("DEPRECATION")
                    val extras = Bundle().apply { putBinder(SupassProtocol.KEY_BINDER, binder) }
                    val reply = callProvider(provider, authority, extras)
                    reason = reply?.getString(SupassProtocol.KEY_REASON)
                    delivered = reply?.getBoolean(SupassProtocol.KEY_ACK) == true
                } finally {
                    // 用完即还：AMS 里这张表是按 name 索引的，不还的话下次取会撞见
                    // 同一个 token，甚至被当成泄漏。
                    runCatching { removeContentProviderExternal(am, authority, userId) }
                        .onFailure {
                            note(
                                "removeContentProviderExternal failed: " +
                                    "${it.javaClass.simpleName}: ${it.message}",
                                error = true,
                            )
                        }
                }
            } catch (t: Throwable) {
                thrown = t
            }

            if (delivered) {
                note("push attempt ${attempt + 1}/$PUSH_ATTEMPTS ok")
                return true
            }

            if (thrown != null) {
                // 同一个异常重复 5 次没有信息量，而展示层有长度上限
                // （BinderShellChannel.DETAIL_LIMIT），重复行会把第一条真正的原因挤掉，
                // 现象是「日志停在 uid 20；」。所以只在首次完整记录。
                val signature = describe(thrown)
                val detail = if (signature == lastError) "(same)" else signature
                lastError = signature
                note("push attempt ${attempt + 1}/$PUSH_ATTEMPTS failed: $detail", error = true)
            } else {
                // 调用通了但 Provider 回了 ACK=false：多半是它那边的 uid 二次校验没过。
                note(
                    "push attempt ${attempt + 1}/$PUSH_ATTEMPTS rejected: " +
                        (reason ?: "no ack"),
                    error = true,
                )
            }
            runCatching { Thread.sleep(PUSH_RETRY_MS) }
        }
        return false
    }

    /**
     * 把反射抛出的异常摊平成一行。
     *
     * 反射调用会把真正的异常包一层 `InvocationTargetException`，直接打外层只会看到
     * 一个空 message（上一轮的 `setter=false` 就是这么丢的）。剥到 targetException
     * 才能看见 AMS 到底抛了什么。
     */
    private fun describe(t: Throwable): String {
        val cause = (t as? InvocationTargetException)?.targetException ?: t
        return "${cause.javaClass.name}: ${cause.message}"
    }

    /**
     * 读一个字段，找不到或读不出都返回 null。
     *
     * `ContentProviderHolder`、`AttributionSource` 这类 `@hide` 类的字段名在不同版本
     * 上偶尔会变，所以这里不写死「一定存在」，而是把失败留给调用方报出具体位置。
     */
    private fun readField(target: Any, name: String): Any? = runCatching {
        var cls: Class<*>? = target.javaClass
        while (cls != null) {
            val field = runCatching { cls!!.getDeclaredField(name) }.getOrNull()
            if (field != null) {
                field.isAccessible = true
                return@runCatching field.get(target)
            }
            cls = cls.superclass
        }
        null
    }.getOrNull()

    /** 取 `IActivityManager`。它是系统服务，shell 可以直接拿。 */
    private fun activityManager(): Any? = runCatching {
        val serviceManager = Class.forName("android.os.ServiceManager")
        val binder = serviceManager
            .getMethod("getService", String::class.java)
            .invoke(null, "activity") as IBinder
        val stub = Class.forName("android.app.IActivityManager\$Stub")
        stub.getMethod("asInterface", IBinder::class.java).invoke(null, binder)
    }.onFailure {
        note("IActivityManager unavailable: ${describe(it)}", error = true)
    }.getOrNull()

    /**
     * `IActivityManager.getContentProviderExternal(name, userId, token[, tag])`。
     *
     * 参数个数在不同版本上不一样（tag 是后加的，只用于 AMS 侧调试日志），
     * 这里按方法实际签名适配，不写死版本号。
     */
    private fun getContentProviderExternal(am: Any, name: String, userId: Int): Any? {
        val method = findMethod(am, "getContentProviderExternal")
            ?: run {
                note("IActivityManager.getContentProviderExternal not found", error = true)
                return null
            }
        val args: Array<Any?> = when (method.parameterTypes.size) {
            4 -> arrayOf(name, userId, null, name)
            else -> arrayOf(name, userId, null)
        }
        return runCatching { method.invoke(am, *args) }
            .onFailure { note("getContentProviderExternal failed: ${describe(it)}", error = true) }
            .getOrNull()
    }

    private fun removeContentProviderExternal(am: Any, name: String, userId: Int) {
        val method = findMethod(am, "removeContentProviderExternal") ?: return
        val args: Array<Any?> = when (method.parameterTypes.size) {
            3 -> arrayOf(name, null, userId)
            else -> arrayOf(name, null)
        }
        method.invoke(am, *args)
    }

    /**
     * 在 `IActivityManager` **接口**上按名字找方法。
     *
     * 必须用接口，不能用 `am.javaClass`：跨进程拿到的是 `Stub.Proxy`，它的类上
     * 未必能直接用 `getMethod` 找到同名重载（而且不同 ROM 实现类名不同）。
     * 接口方法是稳定的。
     */
    private fun findMethod(am: Any, name: String): Method? = runCatching {
        Class.forName("android.app.IActivityManager")
            .methods
            .filter { it.name == name }
            .minByOrNull { it.parameterTypes.size }
    }.getOrNull()?.also { it.isAccessible = true }

    /**
     * 调 `IContentProvider.call()`。
     *
     * 签名跨版本变化过三次（包名字符串 → 加 featureId → 换成 AttributionSource），
     * 这里按方法实际签名选分支，并**一律传 null 包名**：
     *
     * - 传 null 时 AMS 的 `checkPackage` 分支直接跳过（那个校验只在
     *   `callingPackage != null` 时执行）；
     * - 身份由 Binder 的 callingUid 决定，也就是真实的 2000，不需要伪造。
     *
     * 这里是上一个 AI 方案的核心，只是把 `IContentProvider` 这个 `@hide` 接口换成
     * 反射访问，省掉 `dev.rikka.hidden` + refine 插件的依赖。
     */
    private fun callProvider(provider: Any, authority: String, extras: Bundle): Bundle? {
        val method = runCatching {
            Class.forName("android.content.IContentProvider")
                .methods
                .filter { it.name == "call" }
                .firstOrNull {
                    val types = it.parameterTypes
                    types.size == 5 && types[0].name == "android.content.AttributionSource"
                }
                ?: Class.forName("android.content.IContentProvider")
                    .methods
                    .filter { it.name == "call" }
                    .maxByOrNull { it.parameterTypes.size }
        }.getOrNull() ?: run {
            note("IContentProvider.call not found", error = true)
            return null
        }

        val types = method.parameterTypes
        val args: Array<Any?> = when {
            // API 31+：call(AttributionSource, authority, method, arg, extras)
            types.size == 5 && types[0].name == "android.content.AttributionSource" -> {
                val source = attributionSource()
                    ?: throw IllegalStateException("cannot build AttributionSource")
                arrayOf(source, authority, SupassProtocol.METHOD_SEND_BINDER, null, extras)
            }
            // API 30：call(callingPkg, featureId, authority, method, arg, extras)
            types.size == 6 ->
                arrayOf(null, null, authority, SupassProtocol.METHOD_SEND_BINDER, null, extras)
            // API 29：call(callingPkg, authority, method, arg, extras)
            types.size == 5 ->
                arrayOf(null, authority, SupassProtocol.METHOD_SEND_BINDER, null, extras)
            // 更早：call(callingPkg, method, arg, extras)
            else -> arrayOf(null, SupassProtocol.METHOD_SEND_BINDER, null, extras)
        }

        method.isAccessible = true
        return method.invoke(provider, *args) as? Bundle
    }

    /**
     * 构造一个「只带 uid、不带包名」的 `AttributionSource`。
     *
     * 包名留空是有意的：它就是上面 [callProvider] 里说的「不声明身份」。
     * 构造器签名在 31/32 上有差异，所以用反射而不是直接 new。
     */
    private fun attributionSource(): Any? = runCatching {
        val builderClass = Class.forName("android.content.AttributionSource\$Builder")
        val builder = builderClass
            .getConstructor(Int::class.javaPrimitiveType)
            .newInstance(Process.myUid())
        builderClass.getMethod("build").invoke(builder)
    }.onFailure {
        note("build AttributionSource failed: ${describe(it)}", error = true)
    }.getOrNull()

    /**
     * 加入 Binder 线程池。
     *
     * `app_process` 起的进程不会自动有 binder 线程，不主动进池的话，
     * 宿主的 `transact()` 会永远等不到应答（表现为客户端超时，而不是报错）。
     * 两个类名都试：不同 Android 版本把入口放在不同位置，且都是隐藏 API。
     */
    private fun joinBinderPool(label: String) {
        val candidates = arrayOf(
            "android.os.Binder" to "joinThreadPool",
            "android.os.BinderInternal" to "joinThreadPool",
        )
        for ((className, methodName) in candidates) {
            val joined = runCatching {
                val cls = Class.forName(className)
                val method: Method = cls.getDeclaredMethod(methodName).apply { isAccessible = true }
                note("$label: join via $className.$methodName")
                method.invoke(null)
                true
            }.onFailure {
                note(
                    "$label: $className.$methodName unavailable: ${it.javaClass.simpleName}",
                    error = true,
                )
            }.getOrDefault(false)
            if (joined) return
        }
        note("$label: no binder pool entry, blocking to keep process alive", error = true)
        // 进程必须活着：宿主会按「binder 是否可达」重拉，直接退出会让现象变成启动失败。
        if (Looper.myLooper() != null) {
            Looper.loop()
            return
        }
        runCatching { Thread.sleep(Long.MAX_VALUE) }
    }

    /**
     * 同时写 logcat 与磁盘日志。
     *
     * 磁盘那份是宿主侧唯一能读回来的通道。不能靠 `System.err`：`app_process`
     * 启动时会把 `System.out/err` 换成写 logcat 的流，字节根本到不了 fd 2，
     * 点火脚本那行 `2>&1` 重定向因此形同虚设。所以这里直接追加写文件。
     *
     * 只写 `Log.e` 的后果是：用户在界面上永远只看到「特权进程未启动」，
     * 至于为什么没启动，谁也说不出来。
     */
    private fun note(message: String, error: Boolean = false) {
        if (error) Log.e(SupassProtocol.TAG, message) else Log.i(SupassProtocol.TAG, message)
        runCatching {
            // 每次开合：日志只有几行，开销可忽略，换来的是崩溃时也不会丢尾巴。
            FileOutputStream(SupassProtocol.HOST_LOG_PATH, true).use { stream ->
                stream.write("${SupassProtocol.TAG}: $message\n".toByteArray())
                stream.flush()
            }
        }
    }

    /** 记录失败原因后立刻退出。返回类型是 [Nothing]，方便在闸门处当作终止语句。 */
    private fun fail(code: Int, message: String): Nothing {
        note("$message (exit=$code)", error = true)
        // halt 不走 shutdown hook、也不会被其它线程卡住，是这里唯一可靠的收尾方式。
        Runtime.getRuntime().halt(code)
        // halt 正常不返回；这行只为满足 `Nothing` 返回类型。
        throw IllegalStateException(message)
    }

    private const val PUSH_ATTEMPTS = 5
    private const val PUSH_RETRY_MS = 500L

    /** 与客户端保持同一组常量：0 = root，2000 = shell。 */
    private const val UID_ROOT = 0
    private const val UID_SHELL = 2000

    /** Android 多用户：userId = uid / 100000。shell(2000) 恒为 0。 */
    private const val UID_PER_USER = 100_000

    /** 仅供日志区分失败位置；不对外暴露。 */
    private const val EXIT_NOT_PRIVILEGED = 10
    private const val EXIT_NO_AUTHORITY = 11
    private const val EXIT_PUSH_FAILED = 13
    private const val EXIT_NO_BINDER_POOL = 14

    /** 崩溃栈落盘的长度上限：宿主只读回尾部 12 行，写太多也没人看。 */
    private const val STACK_LIMIT = 2_000
}
