package org.supass.ai_su_pass.core.adb

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.RemoteInput
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.drawable.Icon
import android.os.Build
import android.util.Log
import org.supass.ai_su_pass.R

/**
 * 配对码输入通知。
 *
 * 存在的唯一理由：系统「使用配对码配对设备」对话框属于 Settings 页面，
 * 一旦把别的 App 切到前台（包括本 App）就会失效、配对码作废。所以输入框
 * 必须以**下拉通知栏**的方式呈现——通知栏是 SystemUI 的覆盖窗口，不改变
 * 前台 Activity，对话框始终存活。
 *
 * 输入走 [RemoteInput]（通知内联回复）：用户点通知上的按钮，直接在通知栏
 * 里输入 6 位码，全程不离开当前屏幕；配对地址与端口由 mDNS 自动发现，
 * 用户不需要抄 IP。
 *
 * 生命周期：**同一时间只允许一条配对通知**，重复 [show] 会先撤掉上一轮，
 * 避免用户把码输进了已经作废的会话。
 */
internal class PairingNotification(context: Context) {

    /**
     * 一律用 applicationContext。
     *
     * 配对时用户会切到系统设置去读码，此刻本 App 的 Activity 可能已经 stop；
     * 一旦 Activity 被系统回收，挂在它上面的 receiver 就跟着失效，用户提交的码
     * 会静默丢失、表现成「输入了没下文」。
     */
    private val context: Context = context.applicationContext

    /** 当前注册的输入接收器；撤通知时必须一起注销，否则会泄漏。 */
    private var receiver: BroadcastReceiver? = null

    /**
     * 本轮是否已收到配对码。只认第一份，避免重复提交把会话搅乱。
     *
     * 接收器在主线程，重置动作来自配对线程，必须 volatile 才能互相可见。
     */
    @Volatile
    private var received = false

    /**
     * 本轮通知的发布者。
     *
     * 留一份引用是为了在「发现端点」「收到码」这些异步节点上**就地**更新文案；
     * 每次都去 `getSystemService` 虽然也能拿到，但多一次系统调用没有意义。
     */
    private var manager: NotificationManager? = null

    /**
     * 弹出配对码输入通知。
     *
     * @param onCode 用户提交配对码后的回调，已在主线程。
     * @return false 表示通知权限未授予、通知发不出去，调用方应按失败处理，
     *         否则 Dart 侧会一直轮询一个永远不会推进的会话。
     */
    fun show(onCode: (String) -> Unit): Boolean {
        val manager = context.getSystemService(NotificationManager::class.java)
        if (manager == null) {
            Log.w(TAG, "show: NotificationManager unavailable")
            return false
        }
        // Android 13+ 没有 POST_NOTIFICATIONS 时 notify() 会被静默丢弃，提前失败更好排查。
        if (!manager.areNotificationsEnabled()) {
            Log.w(TAG, "show: notifications disabled for this app")
            return false
        }

        ensureChannel(manager)
        dismiss()

        this.manager = manager
        received = false
        val filter = IntentFilter(ACTION_PAIR_CODE)
        val inputReceiver = object : BroadcastReceiver() {
            override fun onReceive(receiverContext: Context?, intent: Intent?) {
                val results = RemoteInput.getResultsFromIntent(intent)
                val raw = results?.getCharSequence(KEY_CODE)?.toString().orEmpty()
                // 只打长度与数字个数，不打明文：既能看出「输入法塞了空格」，
                // 也不会把配对码留在日志里。
                Log.i(TAG, "reply received len=${raw.length} digits=${raw.count { it.isDigit() }}")

                // 系统配对码固定 6 位数字。部分输入法会带空格或连字符，先剔掉非数字；
                // 明显不合法就直接提示重输，别把废码送去跑一次注定失败的 SPAKE2 握手。
                val code = raw.filter { it.isDigit() }
                if (code.length != CODE_LENGTH) {
                    Log.w(TAG, "reply rejected: expected $CODE_LENGTH digits, got ${code.length}")
                    markCodeRejected()
                    return
                }
                if (received) {
                    Log.w(TAG, "reply ignored: code already accepted")
                    return
                }
                received = true
                // 先给出可见反馈：从提交到 TLS 握手结束原本完全静默，看起来就像没反应。
                markReceived()
                onCode(code)
            }
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            // PendingIntent 以本应用身份发送，SystemUI 只是触发者，所以 NOT_EXPORTED 收得到，
            // 同时也挡住外部 App 伪造配对码广播。
            context.registerReceiver(inputReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            @Suppress("UnspecifiedRegisterReceiverFlag")
            context.registerReceiver(inputReceiver, filter)
        }
        receiver = inputReceiver

        manager.notify(
            NOTIFICATION_ID,
            buildNotification(
                context.getString(R.string.pairing_notification_text),
                withInput = true,
            ),
        )
        Log.i(TAG, "pairing notification posted")
        return true
    }

    /**
     * 组装通知。
     *
     * [withInput] 为 true 时挂上 RemoteInput 输入入口；提交过配对码之后必须去掉，
     * 否则用户可能把第二个码输进一个已经开始握手的会话。
     */
    private fun buildNotification(text: String, withInput: Boolean): Notification {
        val builder = Notification.Builder(context, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.stat_sys_data_bluetooth)
            .setContentTitle(context.getString(R.string.pairing_notification_title))
            .setContentText(text)
            // 展开后才能看到完整操作说明；RemoteInput 的输入框在收起态也能点开。
            .setStyle(Notification.BigTextStyle().bigText(text))
            .setOngoing(true)
            .setAutoCancel(false)
            // 只改文案时不要再次振动或发声，也尽量别打断已经展开的输入框。
            .setOnlyAlertOnce(true)
        if (withInput) builder.addAction(buildInputAction())
        return builder.build()
    }

    /**
     * 输入入口。
     *
     * 每次都用同一个 [REQUEST_CODE] + `FLAG_UPDATE_CURRENT`，反复重建也不会留下
     * 多个 PendingIntent；`FLAG_MUTABLE` 是 RemoteInput 回填结果的硬性要求。
     */
    private fun buildInputAction(): Notification.Action {
        val remoteInput = RemoteInput.Builder(KEY_CODE)
            .setLabel(context.getString(R.string.pairing_notification_hint))
            .setAllowFreeFormInput(true)
            .build()
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            REQUEST_CODE,
            Intent(ACTION_PAIR_CODE).setPackage(context.packageName),
            PENDING_FLAGS,
        )
        return Notification.Action.Builder(
            Icon.createWithResource(context, android.R.drawable.ic_menu_send),
            context.getString(R.string.pairing_notification_action),
            pendingIntent,
        ).addRemoteInput(remoteInput).build()
    }

    /**
     * 已发现配对端点：只改文案，**输入入口必须保留**——用户还没输码。
     *
     * 用户看到「已找到设备」才知道 mDNS 那一路是通的，出了问题也知道该看哪一步。
     */
    fun markDeviceFound() {
        val manager = manager ?: return
        if (received) return
        Log.i(TAG, "markDeviceFound")
        runCatching {
            manager.notify(
                NOTIFICATION_ID,
                buildNotification(
                    context.getString(R.string.pairing_notification_device_found),
                    withInput = true,
                ),
            )
        }
    }

    /**
     * 收到的回复里没有配对码：改文案并保留输入入口，让用户能立刻重输。
     *
     * 静默 return 会让用户对着一条毫无变化的通知等满五分钟，是本流程最典型的
     * 「输入了没下文」。
     */
    private fun markCodeRejected() {
        val manager = manager ?: return
        Log.w(TAG, "markCodeRejected: keeping input entry for retry")
        runCatching {
            manager.notify(
                NOTIFICATION_ID,
                buildNotification(
                    context.getString(R.string.pairing_notification_empty_code),
                    withInput = true,
                ),
            )
        }
    }

    /**
     * 提交配对码后把通知切成「正在连接」，并去掉输入入口。
     *
     * 保留同一条通知（同一 ID 覆盖）而不是撤掉：从提交到 TLS 握手结束可能持续十几秒，
     * 通知消失会让用户以为流程已经结束，而它其实还在跑。
     */
    private fun markReceived() {
        val manager = manager ?: return
        Log.i(TAG, "markReceived: switching to connecting")
        runCatching {
            manager.notify(
                NOTIFICATION_ID,
                buildNotification(
                    context.getString(R.string.pairing_notification_received),
                    withInput = false,
                ),
            )
        }
    }

    /**
     * 配对服务已消失（系统「使用配对码配对设备」对话框被关闭）。
     *
     * 对话框一关，`_adb-tls-pairing._tcp` 就不再广播，之前那串配对码也随端口一起作废。
     * 因此这里必须把输入入口恢复出来、并把话说明白；若继续拿旧端口去握手，
     * 只会得到 ECONNREFUSED，用户看到的就是「输入了没下文」。
     */
    fun markPairingDialogClosed() {
        val manager = manager ?: return
        Log.w(TAG, "markPairingDialogClosed: restoring input entry for retry")
        // 允许用户重新提交：上一份码已经作废，不能被「只认第一份」挡住。
        received = false
        runCatching {
            manager.notify(
                NOTIFICATION_ID,
                buildNotification(
                    context.getString(R.string.pairing_notification_dialog_closed),
                    withInput = true,
                ),
            )
        }
    }

    /** 撤通知并注销接收器；配对成功、失败、超时、页面销毁都要调用。 */
    fun dismiss() {
        if (receiver != null || manager != null) Log.i(TAG, "dismiss")
        receiver?.let { runCatching { context.unregisterReceiver(it) } }
        receiver = null
        manager = null
        runCatching {
            context.getSystemService(NotificationManager::class.java)?.cancel(NOTIFICATION_ID)
        }
    }

    private fun ensureChannel(manager: NotificationManager) {
        if (manager.getNotificationChannel(CHANNEL_ID) != null) return
        manager.createNotificationChannel(
            NotificationChannel(
                CHANNEL_ID,
                context.getString(R.string.pairing_channel_name),
                // 用 DEFAULT 而非 LOW：LOW 渠道在部分 ROM 上会被折叠成静默行，
                // 用户看不到「输入配对码」按钮，又只能切回 App，那这套设计就白做了。
                NotificationManager.IMPORTANCE_DEFAULT,
            ).apply {
                description = context.getString(R.string.pairing_channel_description)
                setShowBadge(false)
                enableVibration(false)
                setSound(null, null)
            },
        )
    }

    private companion object {
        const val TAG = "PairingNotification"
        const val CHANNEL_ID = "adb_pairing"
        const val NOTIFICATION_ID = 0x5041
        const val ACTION_PAIR_CODE = "org.supass.ai_su_pass.action.PAIR_CODE"
        const val KEY_CODE = "pairing_code"
        const val REQUEST_CODE = 0x5042

        /** 系统配对码固定 6 位数字，长度不符直接判为输错。 */
        const val CODE_LENGTH = 6

        /** RemoteInput 需要 SystemUI 把结果回填进 PendingIntent，所以必须 mutable。 */
        val PENDING_FLAGS: Int = PendingIntent.FLAG_UPDATE_CURRENT or
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                PendingIntent.FLAG_MUTABLE
            } else {
                0
            }
    }
}
