package org.supass.ai_su_pass.core.bridge.escalation_native

/**
 * 原生侧原因码的唯一来源。
 *
 * 取值必须与 Dart 侧 `EscalationReason` 枚举名**逐字一致**：Dart 解析未知串会落到
 * `unknown`，页面只剩兜底文案，等于把可诊断信息丢掉。集中定义避免各链各写字符串。
 */
internal object EscalationReasons {

    // 平台 / 环境
    const val PLATFORM_UNSUPPORTED = "platformUnsupported"
    const val ANDROID_TOO_OLD = "androidTooOld"
    const val DEVICE_NOT_SUPPORTED = "deviceNotSupported"

    // 探测
    const val PROBE_TIMEOUT = "probeTimeout"
    const val PROBE_FAILED = "probeFailed"

    // 能力缺失
    const val NO_ROOT_BINARY = "noRootBinary"
    const val NO_SELINUX_CONTEXT = "noSelinuxContext"
    const val SELINUX_ENFORCING = "selinuxEnforcing"

    // Shell 层
    const val SHELL_UNAVAILABLE = "shellUnavailable"
    const val SHELL_DENIED = "shellDenied"
    const val SHELL_TIMEOUT = "shellTimeout"

    // 资产
    const val PAYLOAD_MISSING = "payloadMissing"
    const val PAYLOAD_MISMATCH = "payloadMismatch"
    const val CATALOG_CORRUPTED = "catalogCorrupted"

    // 内核
    const val KERNEL_NOT_SUPPORTED = "kernelNotSupported"
    const val KERNEL_MODULE_LOAD_FAILED = "kernelModuleLoadFailed"
    const val KERNEL_VERSION_MISMATCH = "kernelVersionMismatch"

    // 执行
    const val EXECUTE_TIMEOUT = "executeTimeout"
    const val EXECUTE_FAILED = "executeFailed"
    const val VERIFY_FAILED_AT_EXTERNAL = "verifyFailedAtExternal"
    const val VERIFY_TIMEOUT = "verifyTimeout"

    // 恢复
    const val CLEANUP_FAILED = "cleanupFailed"
    const val ENFORCE_RESTORE_FAILED = "enforceRestoreFailed"
    const val RESIDUAL_LEFT = "residualLeft"

    // 宿主
    const val HOST_DISCONNECTED = "hostDisconnected"
    const val HOST_AUTH_FAILED = "hostAuthFailed"
    const val HOST_PAIRING_FAILED = "hostPairingFailed"
}
