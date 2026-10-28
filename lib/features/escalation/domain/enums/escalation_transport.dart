/// 提权动作的执行通道。
enum EscalationTransport {
  /// 进程内直接执行。
  inProcess,

  /// 经由 adb shell（uid=2000）执行。
  adbShell,

  /// 经由独立提权宿主进程执行。
  privilegeHost;

  /// 从持久化字符串还原，未知值回退到 [EscalationTransport.inProcess]。
  static EscalationTransport fromName(String? value) {
    for (final EscalationTransport transport in EscalationTransport.values) {
      if (transport.name == value) return transport;
    }
    return EscalationTransport.inProcess;
  }
}
