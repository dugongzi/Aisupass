/// 无线调试开关的三态。
///
/// 不用 `bool?` 的原因：实体与枚举不得出现可空字段，而「读不到」与「关着」
/// 在行为上必须分开——前者不能让 UI 断定用户没开开关。
///
/// 取值与原生 `AdbStatus.wifiState` 逐字对应（见 `SystemStatusNativeImpl.readAdbStatus`）。
enum AdbWifiState {
  /// ROM 未暴露隐藏键，或状态尚未查到：不得据此断言「用户没开无线调试」。
  unknown,

  /// 无线调试已开启。
  on,

  /// 无线调试已关闭：可以据此引导用户去设置页打开。
  off;

  /// 解析原生上报值；无法识别时回落到 [AdbWifiState.unknown]。
  static AdbWifiState fromName(String? value) {
    for (final AdbWifiState item in AdbWifiState.values) {
      if (item.name == value) return item;
    }
    return AdbWifiState.unknown;
  }
}
