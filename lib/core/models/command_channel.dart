/// 命令通道：AI 工具执行命令、以及设备状态卡片所走的链路。
///
/// 两条通道互斥，由用户在设置里选择，选择结果持久化。
enum CommandChannel {
  /// 无线 ADB 自配对通道（uid=2000），同时提供常驻 pty 终端。
  adb,

  /// 应用内特权服务通道，不需要用户安装任何外部应用。
  stellar;

  /// 解析存储值；无法识别时回落到 [CommandChannel.adb]。
  static CommandChannel fromName(String? value) {
    for (final CommandChannel item in CommandChannel.values) {
      if (item.name == value) return item;
    }
    return CommandChannel.adb;
  }
}
