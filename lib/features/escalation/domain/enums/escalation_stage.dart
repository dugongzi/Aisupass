/// 提权执行阶段。
///
/// 对应「探测 → 准备 → 执行 → 校验 → 清理」五动作模型。
/// 原生契约里额外有 `done` 收尾哨兵，映射时不参与本枚举，直接丢弃该步。
enum EscalationStage {
  /// 零副作用探测。
  probe,

  /// 准备运行环境，可重复执行。
  prepare,

  /// 实际产生副作用的一步，必须带超时。
  execute,

  /// 依据外部状态判定成败。
  verify,

  /// 等价于 finally 的收尾，必须覆盖所有异常路径。
  cleanup;

  /// 顺序序号，用于时间线渲染。
  int get order => index;

  /// 从持久化字符串还原，未知值回退到 [EscalationStage.probe]。
  static EscalationStage fromName(String? value) {
    for (final EscalationStage stage in EscalationStage.values) {
      if (stage.name == value) return stage;
    }
    return EscalationStage.probe;
  }
}
