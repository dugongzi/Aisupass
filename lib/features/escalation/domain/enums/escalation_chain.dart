/// 提权链。
///
/// 只列**提权动作**。「设备当前是否已有 Root」属于环境信息，不是一条链，
/// 因此不在此列——把它当成链会让提权页在还没提权时先测一遍 root。
///
/// 声明顺序即破坏性优先级：`index` 越小越安全，列表按此顺序展示，
/// 因此**不得调整**枚举顺序。
enum EscalationChain {
  /// L1 通道自检：只验证「能否以 shell(2000) 执行命令并写盘」，不涉及任何提权。
  ///
  /// 它是下面四条高权限链的共同前提，所以单独成链，不冒用任何提权链的名字。
  shellChannel,

  /// 通过加载内核模块提权。
  kernelModule,

  /// 使用本地载荷完成提权。
  payload,

  /// 利用内核漏洞获得临时提权。
  kernelExploit,

  /// 通过 PageCache 写入提权。
  pageCache;

  /// 破坏性优先级，数值越小越安全。
  int get priority => index;

  /// 是否需要外部资产（载荷、内核模块等）。
  bool get requiresExternalAsset => switch (this) {
    // 通道自检只用系统自带命令（id / getprop / cat），不依赖任何随包资产。
    EscalationChain.shellChannel => false,
    EscalationChain.kernelModule => true,
    EscalationChain.payload => true,
    EscalationChain.kernelExploit => true,
    EscalationChain.pageCache => true,
  };

  /// 危险等级：0 低、1 中、2 高。
  int get dangerLevel => switch (this) {
    // 只跑 id / getprop / cat 和一个会被删掉的探针文件，没有破坏性动作，
    // 因此不弹破坏性确认框。
    EscalationChain.shellChannel => 0,
    EscalationChain.kernelModule => 2,
    EscalationChain.payload => 2,
    EscalationChain.kernelExploit => 2,
    EscalationChain.pageCache => 1,
  };

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
