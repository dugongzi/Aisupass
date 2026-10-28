/// 一次提权运行的最终结论。
///
/// 判定只看外部状态，退出码永不参与。
enum EscalationOutcome {
  /// 外部状态已达成目标。
  success,

  /// 目标达成但存在遗留，或清理未完全成功。
  partial,

  /// 未达成目标，且未观察到危险状态。
  failed,

  /// 未达成目标且留下危险状态（如 SELinux 未能恢复）。
  unsafe,

  /// 当前平台或设备不支持该链。
  unsupported,

  /// 运行记录已创建但一个阶段都没跑（用于崩溃恢复后区分「未开始」与「失败」）。
  notStarted;

  /// 是否属于「结束态」（不含 [notStarted]）。
  bool get isFinished => this != EscalationOutcome.notStarted;

  /// 从持久化字符串还原，未知值回退到 [EscalationOutcome.notStarted]。
  static EscalationOutcome fromName(String? value) {
    for (final EscalationOutcome outcome in EscalationOutcome.values) {
      if (outcome.name == value) return outcome;
    }
    return EscalationOutcome.notStarted;
  }
}
