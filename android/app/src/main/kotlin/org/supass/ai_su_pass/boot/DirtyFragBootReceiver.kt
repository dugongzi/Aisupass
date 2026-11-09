package org.supass.ai_su_pass.boot

import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.PowerManager
import android.util.Log
import org.supass.ai_su_pass.dirtyfrag.DirtyFragPrefs
import org.supass.ai_su_pass.dirtyfrag.DirtyFragSession
import java.io.File

/**
 * 开机自启接收器。
 *
 * 只有两个入口条件同时成立才跑：组件是启用态（由设置页开关控制）、
 * `expert_mode` 偏好为真。跑失败就把自己关掉，避免反复重启。
 *
 * 与上游的差别：不写外部日志、不读 `auto_soft_reboot`、不触发软重启。
 */
class DirtyFragBootReceiver : BroadcastReceiver() {

    private companion object {
        const val TAG = "dfroot-boot"

        /** 注入标记，内核侧 hook 成功后才有。 */
        const val MARKER_PATH = "/dev/df"

        /** 轮询间隔与总时长上限。 */
        const val POLL_INTERVAL_MS = 200L

        /**
         * 本侧外层超时。
         *
         * 原生 `exp.c:624` 的整条链路上限是 10 s（`elapsed < 10000`，
         * 覆盖 `/dev/df` → `/dev/dfm6`），D10 已定按源码。这里取 30 s
         * 是留给进程启动与最后一次 poll 的余量，不是「等 30 s 才判失败」。
         */
        const val POLL_TIMEOUT_MS = 30_000L
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (File(MARKER_PATH).exists()) {
            Log.i(TAG, "boot: already armed, skip")
            return
        }
        // 开机阶段只有 DE 存储可读，一律用 device protected 上下文。
        val de = context.createDeviceProtectedStorageContext()
        if (!DirtyFragPrefs.isExpertModeEnabled(de)) {
            Log.i(TAG, "boot: expert mode off, skip")
            return
        }

        val manager = DirtyFragPrefs.readSuManager(de)
        if (manager.isEmpty()) {
            Log.i(TAG, "boot: no su manager recorded, skip")
            disableSelf(context)
            return
        }

        val pm = context.getSystemService(Context.POWER_SERVICE) as PowerManager
        val wakeLock = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "dfroot:boot")
        wakeLock.acquire(POLL_TIMEOUT_MS + 30_000L)
        Thread({
            val ok = try {
                runExploit(de, manager)
            } catch (e: Exception) {
                // 这类异常跨线程抛出会让进程直接崩，必须在这里收住。
                Log.e(TAG, "boot: exception", e)
                false
            } finally {
                wakeLock.release()
            }
            Log.i(TAG, "boot: ok=$ok")
            if (!ok) disableSelf(context)
        }, "dfroot-boot").start()
    }

    /** 跑一次完整链路，只回「退出码是不是 0」。 */
    private fun runExploit(de: Context, manager: String): Boolean {
        // 四个运行参数全部来自设置页，与手动运行走同一份 DE 偏好。
        val defaults = DirtyFragPrefs.readRunDefaults(de)
        val session = DirtyFragSession(de)
        try {
            val outcome = session.start(
                DirtyFragSession.Params(
                    managerPackage = manager,
                    vrDisarm = defaults.vrDisarm,
                    vrAuto = defaults.vrAuto,
                    vrOffset = defaults.vrOffset,
                    softReboot = defaults.softReboot,
                ),
            )
            if (!outcome.accepted) {
                Log.i(TAG, "boot: rejected, reason=${outcome.reason}")
                return false
            }

            val deadline = System.currentTimeMillis() + POLL_TIMEOUT_MS
            while (System.currentTimeMillis() < deadline) {
                val snapshot = session.poll(outcome.sessionId)
                if (snapshot.finished) {
                    Log.i(TAG, "boot: exit=${snapshot.exitCode} ms=${snapshot.durationMs}")
                    return snapshot.exitCode == 0
                }
                Thread.sleep(POLL_INTERVAL_MS)
            }
            Log.i(TAG, "boot: timed out")
            session.cancel(outcome.sessionId)
            return false
        } finally {
            session.dispose()
        }
    }

    /** 失败后把自己关掉，用户在设置页重新打开即可。 */
    private fun disableSelf(context: Context) {
        try {
            context.packageManager.setComponentEnabledSetting(
                ComponentName(context, DirtyFragBootReceiver::class.java),
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                PackageManager.DONT_KILL_APP,
            )
        } catch (e: Exception) {
            Log.e(TAG, "boot: disable self failed", e)
        }
    }
}
