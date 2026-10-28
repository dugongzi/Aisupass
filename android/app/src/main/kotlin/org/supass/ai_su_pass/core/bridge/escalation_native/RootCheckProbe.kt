package org.supass.ai_su_pass.core.bridge.escalation_native

import android.os.Build
import android.os.Process
import java.io.File

/**
 * `rootCheck` 链的只读静态探测。
 *
 * 只读取应用进程自身有权访问的信号：**不 spawn 子进程、不请求 root、不写任何文件**，
 * 因此可以在 `probeAll` 里无条件调用，满足「零副作用」约束。
 *
 * **只回证据，不给结论**：`available` 恒为 `false`，原因码恒为空；
 * rootCheck 的可用性由 Dart 侧复用现有 `rootStatusProvider`（`su -c id`）判定，
 * 避免同一台设备出现两套口径。
 *
 * 受普通应用可见性限制，`/data/adb` 这类目录通常无法 stat，命中失败只代表「本次看不见」，
 * 不等价于设备没有 Root，因此这些信号只用于排障展示。
 */
internal object RootCheckProbe {

    /** 常见 su 二进制位置，按命中概率排序。 */
    private val suPaths = listOf(
        "/system/bin/su",
        "/system/xbin/su",
        "/sbin/su",
        "/su/bin/su",
        "/data/local/bin/su",
        "/data/local/xbin/su",
        "/vendor/bin/su",
        "/debug_ramdisk/su",
    )

    /** KernelSU 的持久化标记。 */
    private val ksuMarkers = listOf(
        "/data/adb/ksu",
        "/data/adb/ksud",
        "/data/adb/ksu/bin/ksud",
    )

    /** Magisk 的持久化标记。 */
    private val magiskMarkers = listOf(
        "/data/adb/magisk",
        "/sbin/.magisk",
        "/dev/.magisk.unblock",
    )

    /** SELinux 状态开关，内容为 `1` 表示 Enforcing。 */
    private const val SELINUX_ENFORCE_PATH = "/sys/fs/selinux/enforce"

    /**
     * 执行一次静态探测。
     *
     * 返回值只承载证据：`available = false`、`reasons` 为空，结论由 Dart 侧给出。
     */
    fun probe(): ChainProbe {
        val selfUid = Process.myUid()
        val suPath = firstExisting(suPaths)
        val ksuMarker = firstExisting(ksuMarkers)
        val magiskMarker = firstExisting(magiskMarkers)
        val selinuxEnforcing = isSelinuxEnforcing()

        val hasRootHint =
            selfUid == 0 || suPath != null || ksuMarker != null || magiskMarker != null

        val evidence = linkedMapOf<String, Any?>(
            "selfUid" to selfUid.toString(),
            "suPath" to (suPath ?: ""),
            "ksuMarker" to (ksuMarker ?: ""),
            "magiskMarker" to (magiskMarker ?: ""),
            "selinuxEnforcing" to if (selinuxEnforcing) "1" else "0",
            "buildTags" to (Build.TAGS ?: ""),
            // 静态信号是否命中，仅供排障；最终可用性以 Dart 侧 rootStatusProvider 为准。
            "staticHint" to if (hasRootHint) "1" else "0",
            "probeScope" to "staticOnly",
        )

        return ChainProbe(
            chain = EscalationChainId.ROOT_CHECK,
            available = false,
            reasons = emptyList<String>(),
            evidence = evidence,
        )
    }

    /** 返回第一个存在的路径；全部不存在时返回 `null`。 */
    private fun firstExisting(paths: List<String>): String? =
        paths.firstOrNull { File(it).exists() }

    /** 读取 SELinux 状态；文件不可读时按「非强制」处理，避免误判为可用障碍。 */
    private fun isSelinuxEnforcing(): Boolean = try {
        File(SELINUX_ENFORCE_PATH).readText().trim() == "1"
    } catch (_: Exception) {
        false
    }
}
