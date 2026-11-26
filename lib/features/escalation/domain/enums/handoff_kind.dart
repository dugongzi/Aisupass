/// 「把临时 root 移交给管理器」的结果形态。
///
/// 分型而不是压成一句 stderr：最常见的一种失败是「管理器没装」，
/// 这种情况下用户唯一能自救的动作是去下载页把管理器装上。
enum HandoffKind {
  /// 成功：命令退 0，且输出里没有已知失败关键字。
  success,

  /// 管理器没装：设备上找不到该包名自带的 ksud。
  managerMissing,

  /// 设备上没有 su：载荷还没跑，或跑完没拿到临时 root。
  noSu,

  /// 命令跑了但失败。
  failed;

  /// 安全解析，非法值回落 [failed]。
  static HandoffKind fromName(String? value) {
    for (final HandoffKind kind in HandoffKind.values) {
      if (kind.name == value) return kind;
    }
    return HandoffKind.failed;
  }
}
