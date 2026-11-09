package org.supass.ai_su_pass.dirtyfrag

import android.content.Context
import android.content.SharedPreferences

/**
 * `dfroot` 偏好的读写。
 *
 * 与 `bootstrap.c` 的 `PREFS_PATH` 指向同一个 XML。
 *
 * 两类键分工明确：
 * - **运行结果类**（`su_manager` / `soft_reboot`）：每次 `start` 时由
 *   `DirtyFragSession` 写入，`bootstrap.c` 读取，不是用户偏好。
 * - **用户偏好类**（`expert_mode` / `vr_disarm` / `vr_auto` / `vr_offset`）：
 *   只在设置页改动，开机链路读它们组 `Params`。
 */
object DirtyFragPrefs {

    private const val FILE = "dfroot"
    private const val KEY_EXPERT_MODE = "expert_mode"
    private const val KEY_SU_MANAGER = "su_manager"
    private const val KEY_SOFT_REBOOT = "soft_reboot"
    private const val KEY_VR_DISARM = "vr_disarm"
    private const val KEY_VR_AUTO = "vr_auto"
    private const val KEY_VR_OFFSET = "vr_offset"

    /** 开机未解锁时只有 DE 存储可读，一律走 device protected 上下文。 */
    private fun store(context: Context): SharedPreferences =
        context.createDeviceProtectedStorageContext()
            .getSharedPreferences(FILE, Context.MODE_PRIVATE)

    fun isExpertModeEnabled(context: Context): Boolean =
        store(context).getBoolean(KEY_EXPERT_MODE, false)

    fun setExpertModeEnabled(context: Context, enabled: Boolean) {
        store(context).edit().putBoolean(KEY_EXPERT_MODE, enabled).apply()
    }

    /** bootstrap 只认偏好里的 `su_manager` / `soft_reboot`，每次运行前写一次。 */
    fun writeRunParams(context: Context, managerPackage: String, softReboot: Boolean) {
        store(context).edit()
            .putString(KEY_SU_MANAGER, managerPackage)
            .putBoolean(KEY_SOFT_REBOOT, softReboot)
            .apply()
    }

    /** 没有 `su_manager` 时返回空串。 */
    fun readSuManager(context: Context): String =
        store(context).getString(KEY_SU_MANAGER, "").orEmpty()

    fun readSoftReboot(context: Context): Boolean =
        store(context).getBoolean(KEY_SOFT_REBOOT, false)

    /** 设置页四个开关的当前值；`vrOffset` 为 0 表示从未设过。 */
    fun readRunDefaults(context: Context): RunDefaults {
        val p = store(context)
        return RunDefaults(
            vrDisarm = p.getBoolean(KEY_VR_DISARM, false),
            // 默认 true：绝大多数机型靠 BTF 自动解，不需要手工算偏移。
            vrAuto = p.getBoolean(KEY_VR_AUTO, true),
            vrOffset = p.getInt(KEY_VR_OFFSET, 0),
            softReboot = p.getBoolean(KEY_SOFT_REBOOT, false),
        )
    }

    /**
     * 写设置页四个开关。
     *
     * `soft_reboot` 与 `writeRunParams` 共用同一个键：设置页改的就是
     * 「下次运行/开机时要不要软重启」，没有第二份真相。
     */
    fun writeRunDefaults(context: Context, defaults: RunDefaults) {
        store(context).edit()
            .putBoolean(KEY_VR_DISARM, defaults.vrDisarm)
            .putBoolean(KEY_VR_AUTO, defaults.vrAuto)
            .putInt(KEY_VR_OFFSET, defaults.vrOffset)
            .putBoolean(KEY_SOFT_REBOOT, defaults.softReboot)
            .apply()
    }

    /**
     * 偏好层的运行默认值。
     *
     * 用本包自己的 data class 而不是 Pigeon 的 `DirtyFragRunDefaults`：
     * `dirtyfrag` 包必须能脱离 Flutter 侧独立编译（开机广播走这条路），
     * 反向依赖 `core.bridge` 会让「执行体不依赖 Pigeon」这条红线失效。
     * 与 Pigeon 类型的互转只发生在 `DirtyFragNativeImpl`。
     */
    data class RunDefaults(
        val vrDisarm: Boolean,
        val vrAuto: Boolean,
        val vrOffset: Int,
        val softReboot: Boolean,
    )
}
