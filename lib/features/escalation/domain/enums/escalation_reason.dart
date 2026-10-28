/// 提权失败或不支持的原因码。
///
/// 原生侧只回字符串，本枚举是唯一的合法闭集；未知字符串一律归入 [unknown]，
/// 保证解析永不抛异常。
enum EscalationReason {
  // 平台 / 环境
  platformUnsupported,
  androidTooOld,
  deviceNotSupported,

  // 探测
  probeTimeout,
  probeFailed,

  // 能力缺失
  noRootBinary,
  noSelinuxContext,
  selinuxEnforcing,

  // Shell 层
  shellUnavailable,
  shellDenied,
  shellTimeout,

  // 资产
  payloadMissing,
  payloadMismatch,
  catalogCorrupted,

  // 内核
  kernelNotSupported,
  kernelModuleLoadFailed,
  kernelVersionMismatch,

  // 执行
  executeTimeout,
  executeFailed,
  verifyFailedAtExternal,
  verifyTimeout,

  // 恢复
  cleanupFailed,
  enforceRestoreFailed,
  residualLeft,

  // 宿主
  hostDisconnected,
  hostAuthFailed,
  hostPairingFailed,

  // 兜底
  unknown;

  /// 与原生契约交换用的字符串编码。
  String get code => name;

  /// 从原生契约的原因码还原，未知值回退到 [EscalationReason.unknown]。
  static EscalationReason fromCode(String? code) {
    for (final EscalationReason reason in EscalationReason.values) {
      if (reason.name == code) return reason;
    }
    return EscalationReason.unknown;
  }
}
