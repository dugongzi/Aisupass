package org.supass.ai_su_pass.core.adb

import android.content.Context
import android.os.Build
import android.os.SystemClock
import android.util.Log
import io.github.muntashirakon.adb.AbsAdbConnectionManager
import io.github.muntashirakon.adb.android.AdbMdns
import java.net.InetAddress
import java.net.InetSocketAddress
import java.net.Socket
import java.security.PrivateKey
import java.security.cert.Certificate
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicReference

/**
 * libadb 连接管理器：把「配对」和「连接」两件事收敛到一处。
 *
 * 继承 [AbsAdbConnectionManager] 只需要回答三个问题：用哪把私钥、配哪张证书、
 * 叫什么名字。协议本身（SPAKE2 配对、TLS、AUTH 签名、ADB 报文）全部由库处理，
 * 本类不碰任何协议细节。
 *
 * 三个必须记住的库行为：
 * 1. [AbsAdbConnectionManager] 默认超时是 `Long.MAX_VALUE`，不显式设置的话
 *    `connect()` 会永久阻塞，因此构造时就 `setTimeout`；
 * 2. `close()` 会 `PrivateKey.destroy()`，所以这里**从不缓存密钥对象**，
 *    每次 `getPrivateKey()` / `getCertificate()` 都从 [AdbKeyStore] 重读；
 * 3. `connect(host, port)` 在已连接时直接返回 false，不会重连；调用方需要先
 *    [disconnectQuietly] 或确认 `isConnected` 为 false。
 */
internal class AdbConnectionManager(
    context: Context,
    private val keyStore: AdbKeyStore = AdbKeyStore(context),
) : AbsAdbConnectionManager() {

    private val appContext: Context = context.applicationContext

    init {
        // 只用于决定 ADB 协议版本与单包大小（api >= 28 → 0x01000001 / 1MB）。
        setApi(Build.VERSION.SDK_INT)
        // 连接等待上限。默认 Long.MAX_VALUE 会把 UI 线程以外的执行线程永久挂住。
        setTimeout(CONNECT_TIMEOUT_MS, TimeUnit.MILLISECONDS)
        // 设备未授权时直接抛 AdbAuthenticationFailedException，而不是静默返回 false，
        // 这样上层能区分「设备拒绝」与「网络不通」。
        setThrowOnUnauthorised(true)
    }

    /** 准备密钥；配对与连接都要求磁盘上已有可用凭据。 */
    fun ensureCredentials(): Boolean = keyStore.ensure()

    /** 配对：把 6 位配对码交换成设备侧对本机公钥的信任。 */
    fun pairDevice(host: String, port: Int, code: String): Boolean {
        check(ensureCredentials()) { "adb credentials unavailable" }
        val startedAt = SystemClock.elapsedRealtime()
        return try {
            pair(host, port, code).also {
                Log.i(
                    TAG,
                    "pairDevice $host:$port -> $it (${SystemClock.elapsedRealtime() - startedAt}ms)",
                )
            }
        } catch (t: Throwable) {
            // 只留下异常类名不足以定位：SPAKE2 失败、TLS 失败、码错误在库里是不同异常，
            // 把完整堆栈打出来，下一次就能直接看出断在哪。
            Log.e(TAG, "pairDevice $host:$port threw", t)
            throw t
        }
    }

    /** 按已发现的地址直接连接（配对成功后走这里）。 */
    fun connectDevice(host: String, port: Int): Boolean {
        check(ensureCredentials()) { "adb credentials unavailable" }
        val startedAt = SystemClock.elapsedRealtime()
        return try {
            connect(host, port).also {
                Log.i(
                    TAG,
                    "connectDevice $host:$port -> $it (${SystemClock.elapsedRealtime() - startedAt}ms)",
                )
            }
        } catch (t: Throwable) {
            Log.e(TAG, "connectDevice $host:$port threw", t)
            throw t
        }
    }

    /**
     * 用 mDNS 发现 `adb-tls-connect` 端点并连接。
     *
     * 无线调试的**配对端口**和**连接端口**不是同一个，用户在配对弹窗里只能看到配对端口，
     * 所以配对成功后用库内置的 mDNS 发现真正的连接端点，而不是猜端口。
     */
    fun connectDiscovered(timeoutMs: Long): Boolean {
        check(ensureCredentials()) { "adb credentials unavailable" }
        val startedAt = SystemClock.elapsedRealtime()
        return try {
            connectTls(appContext, timeoutMs).also {
                Log.i(
                    TAG,
                    "connectDiscovered -> $it (${SystemClock.elapsedRealtime() - startedAt}ms)",
                )
            }
        } catch (t: Throwable) {
            Log.e(TAG, "connectDiscovered threw", t)
            throw t
        }
    }

    /**
     * 启动 `adb-tls-pairing` 端点的持续发现，返回可与「等用户输码」并行的句柄。
     *
     * 为什么必须并行：`_adb-tls-pairing._tcp` 只在系统「使用配对码配对设备」对话框
     * 打开期间广播。等用户把码提交上来再开始发现，对话框往往已经关闭、服务已经停止
     * 广播，结果就是永远等不到端点，用户看到「输完码没下文」。
     */
    fun startPairingDiscovery(): PairingDiscovery =
        PairingDiscovery(appContext).also { it.start() }

    /**
     * 一次性发现 `adb-tls-pairing` 端点（配对端口 + 地址）。
     *
     * 配对端口每次开关无线调试都会变，让用户从系统弹窗里抄下来既容易抄错、又必须切屏
     * （切屏会让配对对话框失效）。系统本身会广播 `_adb-tls-pairing._tcp`，直接发现它，
     * 界面就只需要一个 6 位码输入框。
     *
     * @return 已发现的端点；超时或发现失败返回 null，由调用方决定兜底策略。
     */
    fun discoverPairingEndpoint(timeoutMs: Long): InetSocketAddress? {
        val discovery = startPairingDiscovery()
        return try {
            discovery.await(timeoutMs)
        } finally {
            discovery.close()
        }
    }

    /**
     * 先做一次短超时的 TCP 可达性探测。
     *
     * `pair()` / `connect()` 内部用的是无超时的 `new Socket(host, port)`，
     * 地址填错时会卡到系统默认超时（可能长达两分钟）。配对页拿到的是用户手输的
     * IP 与端口，先探一下能让错误立刻反馈，也避免长期占用执行线程。
     */
    fun canReach(host: String, port: Int, timeoutMs: Int = REACH_TIMEOUT_MS): Boolean = runCatching {
        Socket().use { socket ->
            socket.connect(InetSocketAddress(host, port), timeoutMs)
        }
        true
    }.onFailure {
        // 地址为空、IPv6 带 scope、端口没人监听都会走到这里，原因必须留下来，
        // 否则上层只看到一个 false，分不清是「解析不出地址」还是「端口不通」。
        Log.w(TAG, "canReach $host:$port failed: ${it.javaClass.simpleName}: ${it.message}")
    }.getOrDefault(false)

    /**
     * 断开连接但**不销毁磁盘凭据**。
     *
     * 不能用 `close()`：那会把当前这把私钥 destroy 掉（磁盘文件不受影响，
     * 但仍在使用的对象会变成废钥）。这里只关连接。
     */
    fun disconnectQuietly() {
        runCatching { if (isConnected) disconnect() }
    }

    override fun getPrivateKey(): PrivateKey =
        keyStore.load()?.privateKey ?: throw IllegalStateException("adb key not ready")

    override fun getCertificate(): Certificate =
        keyStore.load()?.certificate ?: throw IllegalStateException("adb key not ready")

    override fun getDeviceName(): String = keyStore.deviceName

    private companion object {
        /** 配对链路统一日志标签；logcat 里筛这一个就够了。 */
        const val TAG = "AdbShell"

        /** 连接等待上限；配对后再连接通常 1 秒内完成，15 秒足够覆盖慢设备。 */
        const val CONNECT_TIMEOUT_MS = 15_000L

        /** 可达性探测上限；只用于快速失败，不代表实际连接耗时。 */
        const val REACH_TIMEOUT_MS = 3_000
    }
}

/**
 * 一次 `_adb-tls-pairing._tcp` 发现会话。
 *
 * [AdbMdns] 会持续回调端口变化，这里只保留**最新**一帧：用户在系统设置里关掉再打开
 * 配对对话框时端口会变，沿用第一次发现的旧端口只会连到一个已经关闭的服务上。
 *
 * [error] 记录「为什么没发现」。[AdbMdns] 的 `onStartDiscoveryFailed` /
 * `onResolveFailed` 全是空实现，不自己记下来，上层就只知道「没找到」，
 * 无法区分「配对对话框没开」和「本机 mDNS 挂了」。
 */
internal class PairingDiscovery(context: Context) : AutoCloseable {

    private val latest = AtomicReference<InetSocketAddress?>(null)

    /** 是否曾经发现过端点；用于日志区分「从没出现」和「出现过又消失」。 */
    @Volatile
    private var everFound = false

    /** 发现失败原因；`null` 表示还没失败。 */
    @Volatile
    var error: String? = null
        private set

    private val listener = object : AdbMdns.OnAdbDaemonDiscoveredListener {
        // 库里的方法签名是 `onPortChanged(InetAddress?, Int)`：服务消失时地址为空，
        // 端口为 -1。
        override fun onPortChanged(address: InetAddress?, port: Int) {
            Log.i(TAG, "mdns onPortChanged address=$address port=$port")
            if (address == null || port <= 0) {
                // 服务消失 = 系统「使用配对码配对设备」对话框已关闭。
                // 必须立刻清掉端点：留着旧端口，上层就会拿着一份已经没人监听的
                // 地址去握手，白白消耗掉用户刚刚输入的那次配对码。
                if (latest.getAndSet(null) != null) {
                    Log.w(TAG, "mdns pairing service lost (pairing dialog closed)")
                }
                return
            }
            everFound = true
            // 始终覆盖为最新端点：配对对话框重开时端口会变。
            latest.set(InetSocketAddress(address, port))
        }
    }

    private val mdns = AdbMdns(context.applicationContext, AdbMdns.SERVICE_TYPE_TLS_PAIRING, listener)

    /** 已发现的最新端点；尚未发现时为 `null`，可随时无锁读取。 */
    val endpoint: InetSocketAddress? get() = latest.get()

    /** 开始发现；系统 mDNS 直接抛异常时记原因，等待方读到 [error] 会立即返回。 */
    fun start() {
        try {
            Log.i(TAG, "mdns start _adb-tls-pairing._tcp")
            mdns.start()
        } catch (t: Throwable) {
            // 部分 ROM 的 NsdManager 会直接抛；发现失败按「没有端点」处理，不是致命错误。
            Log.e(TAG, "mdns start threw", t)
            error = t.javaClass.simpleName
        }
    }

    /**
     * 等待端点出现。
     *
     * 发现是**持续运行**的（回调会不断覆盖 [latest]），所以这里只能轮询当前值，
     * 不能用一次性 latch：服务消失后端点会被清空，latch 却早已放行，读到的还是旧端口。
     *
     * @return 已发现的端点；超时、被中断或启动失败返回 null。
     */
    fun await(timeoutMs: Long): InetSocketAddress? {
        val deadline = SystemClock.elapsedRealtime() + timeoutMs
        while (true) {
            latest.get()?.let {
                Log.i(TAG, "mdns await resolved $it")
                return it
            }
            if (error != null) return null
            val remaining = deadline - SystemClock.elapsedRealtime()
            if (remaining <= 0L) {
                // 一路等到超时都没收到回调：多半是配对对话框没开（服务不广播），
                // 或系统 mDNS 在本机被限流。
                Log.w(TAG, "mdns await timed out after ${timeoutMs}ms everFound=$everFound")
                return null
            }
            try {
                Thread.sleep(minOf(AWAIT_SLICE_MS, remaining))
            } catch (_: InterruptedException) {
                Log.w(TAG, "mdns await interrupted")
                Thread.currentThread().interrupt()
                if (error == null) error = DISCOVERY_INTERRUPTED
                return null
            }
        }
    }

    override fun close() {
        Log.i(TAG, "mdns stop")
        runCatching { mdns.stop() }
    }

    private companion object {
        /** 与外层同一个标签，logcat 里按 `AdbShell` 一次过滤整条配对链路。 */
        const val TAG = "AdbShell"

        /** 轮询当前端点的间隔；只影响发现延迟，对 CPU 无压力。 */
        const val AWAIT_SLICE_MS = 200L

        /** 等待发现被中断。 */
        const val DISCOVERY_INTERRUPTED = "discoveryInterrupted"
    }
}
