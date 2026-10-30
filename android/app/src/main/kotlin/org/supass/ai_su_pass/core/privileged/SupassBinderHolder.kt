package org.supass.ai_su_pass.core.privileged

import android.os.IBinder
import android.util.Log
import org.supass.ai_su_pass.privileged.SupassProtocol
import java.util.concurrent.CopyOnWriteArrayList

/**
 * 宿主进程内保存特权进程推过来的 Binder 代理。
 *
 * 三件事必须在这里做对：
 * 1. **登记时挂死亡通知**：`linkToDeath` 失败说明代理已死，直接拒收；存活校验
 *    留给使用前的 [current]（每次调用都 `pingBinder()`）；
 * 2. **死亡通知**：`linkToDeath` 比轮询快得多，服务被杀时立刻把引用清空并通知订阅者；
 * 3. **只存一份**：服务重启会推新 Binder，旧的要先 `unlinkToDeath`，否则泄漏且可能收到陈旧回调。
 *
 * 注意这里存的是**跨进程代理**，不是实现对象；所有调用都会走 Binder 事务。
 */
internal object SupassBinderHolder {

    private const val TAG = SupassProtocol.TAG

    /** 与 `ShellChannel.uid` 的约定一致：-1 = 未知。 */
    private const val UNKNOWN_UID = -1L

    private val lock = Any()

    @Volatile
    private var binder: IBinder? = null

    /**
     * 登记时记录的对端 uid。
     *
     * 来源是 Provider 里的 `Binder.getCallingUid()`——那是内核给出的真实调用方身份，
     * 比事后 ping 回来的值更权威，而且不需要额外 IPC。没有它，`BinderShellChannel`
     * 只能依赖点火握手时缓存的 uid；一旦 Binder 走了别的路径推进来（或缓存被重置），
     * `uid` 就会一直是 -1，探测阶段会把「已连接」误判成「没有特权身份」。
     */
    @Volatile
    private var binderUid: Long = UNKNOWN_UID

    private var deathRecipient: IBinder.DeathRecipient? = null

    private val listeners = CopyOnWriteArrayList<(IBinder?) -> Unit>()

    /** 接收特权进程推来的 Binder；返回 false 表示代理已死或登记失败。 */
    fun attach(candidate: IBinder, uid: Long = UNKNOWN_UID): Boolean {
        synchronized(lock) {
            if (binder === candidate) {
                if (uid > 0L) binderUid = uid
                return true
            }
            releaseLocked()

            val recipient = IBinder.DeathRecipient {
                Log.w(TAG, "privileged binder died")
                synchronized(lock) {
                    if (binder === candidate) {
                        binder = null
                        binderUid = UNKNOWN_UID
                        deathRecipient = null
                    }
                }
                notifyListeners(null)
            }
            // 这里刻意不做 pingBinder()：此刻对端主线程正阻塞在「推 Binder」的
            // contentResolver.call 上，如果它还没有池线程，同步 ping 会让两边互等。
            // linkToDeath 只向驱动登记，不需要对端线程，足以判断代理是否已死。
            val linked = runCatching { candidate.linkToDeath(recipient, 0) }.isSuccess
            if (!linked) {
                Log.w(TAG, "attach rejected: linkToDeath failed (binder dead?)")
                return false
            }
            binder = candidate
            binderUid = uid
            deathRecipient = recipient
        }

        Log.i(TAG, "privileged binder attached")
        notifyListeners(candidate)
        return true
    }

    /** 登记时记下的对端 uid；没有 Binder 时恒为 -1。零副作用，不发任何 IPC。 */
    fun attachedUid(): Long = if (binder == null) UNKNOWN_UID else binderUid

    /** 取当前可用代理；已死或已被替换时返回 null，并顺手清理陈旧引用。 */
    fun current(): IBinder? {
        val candidate = binder ?: return null
        val alive = runCatching { candidate.pingBinder() }.getOrDefault(false)
        if (alive) return candidate
        synchronized(lock) {
            if (binder === candidate) {
                binder = null
                binderUid = UNKNOWN_UID
                deathRecipient = null
            }
        }
        return null
    }

    /** 订阅 Binder 变更；注册时会立即回调一次当前值，便于订阅方跳过「等下一次事件」。 */
    fun addListener(listener: (IBinder?) -> Unit) {
        listeners += listener
        runCatching { listener(binder) }
    }

    fun removeListener(listener: (IBinder?) -> Unit) {
        listeners -= listener
    }

    /** 主动清空（例如用户断开配对后），并按「已丢失」通知订阅者。 */
    fun clear() {
        synchronized(lock) { releaseLocked() }
        notifyListeners(null)
    }

    private fun releaseLocked() {
        val old = binder
        val recipient = deathRecipient
        binder = null
        binderUid = UNKNOWN_UID
        deathRecipient = null
        if (old != null && recipient != null) {
            runCatching { old.unlinkToDeath(recipient, 0) }
        }
    }

    private fun notifyListeners(value: IBinder?) {
        listeners.forEach { listener ->
            runCatching { listener(value) }.onFailure {
                Log.w(TAG, "binder listener failed: ${it.javaClass.simpleName}")
            }
        }
    }
}
