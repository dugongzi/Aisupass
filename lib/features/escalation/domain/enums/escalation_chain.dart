/// 提权链。
///
/// 声明顺序即破坏性优先级：`index` 越小越安全。链选择时按顺序取第一个可用的链，
/// 因此**不得调整**枚举顺序。
enum EscalationChain {
  /// 检测设备当前是否已具备 Root 权限，零破坏。
  rootCheck,

  /// 通过加载内核模块提权。
  kernelModule,

  /// 使用本地载荷完成提权。
  payload,

  /// 利用内核漏洞获得临时提权。
  kernelExploit,

  /// 通过 PageCache 写入提权。
  pageCache,

  /// 纯演示链，不改变任何系统状态。
  fake;

  /// 破坏性优先级，数值越小越安全。
  int get priority => index;

  /// 是否需要外部资产（载荷、内核模块等）。
  bool get requiresExternalAsset => switch (this) {
    EscalationChain.rootCheck => false,
    EscalationChain.kernelModule => true,
    EscalationChain.payload => true,
    EscalationChain.kernelExploit => true,
    EscalationChain.pageCache => true,
    EscalationChain.fake => false,
  };

  /// 危险等级：0 低、1 中、2 高。
  int get dangerLevel => switch (this) {
    EscalationChain.rootCheck => 0,
    EscalationChain.kernelModule => 2,
    EscalationChain.payload => 2,
    EscalationChain.kernelExploit => 2,
    EscalationChain.pageCache => 1,
    EscalationChain.fake => 0,
  };

  /// 是否为演示链。
  bool get isDemo => this == EscalationChain.fake;

  /// 从原生契约的链名还原，未知值返回 `null`。
  ///
  /// 使用可空返回而非兜底，避免把未知链误判成某条真实链。
  static EscalationChain? fromName(String? value) {
    for (final EscalationChain chain in EscalationChain.values) {
      if (chain.name == value) return chain;
    }
    return null;
  }
}
