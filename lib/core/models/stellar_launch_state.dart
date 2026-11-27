import 'package:flutter/foundation.dart';

/// 拉起 / 停掉特权服务这一步的进展。
///
/// 只描述「动作本身」，不描述服务运行状态：运行状态由
/// `stellarServiceStatusProvider` 通过探活回答。
@immutable
class StellarLaunchState {
  const StellarLaunchState({
    required this.busy,
    required this.reason,
    this.stopping = false,
  });

  /// 空闲。
  const StellarLaunchState.idle() : busy = false, reason = '', stopping = false;

  /// 正在停止：用于把状态行文案换成「正在停止服务…」。
  const StellarLaunchState.stopping()
    : busy = true,
      reason = '',
      stopping = true;

  /// 有动作在进行（拉起或停止），尚未拿到可用结果。
  final bool busy;

  /// 上一次动作的失败原因码；`''` 表示没有失败。
  final String reason;

  /// [busy] 期间的动作是不是「停止」。
  final bool stopping;

  /// 拉起器不存在：APK 里没有可执行的引导文件，属于打包问题。
  static const String reasonLauncherMissing = 'launcherMissing';

  /// 拉起命令没能执行：执行通道没连上，自动连接也没能把它拉起来。
  static const String reasonNoRunner = 'noRunner';

  /// 还缺配对码：小窗输入模式下要用户在界面里填码，本端自己起不了配对。
  static const String reasonAwaitingCode = 'awaitingCode';

  /// 命令执行了但服务没有在预期时间内应答。
  static const String reasonNotAnswering = 'notAnswering';

  /// 停止没成功：服务没有确认退出，或者端口仍在应答。
  static const String reasonStopFailed = 'stopFailed';

  /// 端口被其它程序占用，服务没能启动。
  static const String reasonPortTaken = 'portTaken';

  /// 端口上是旧版服务且无法自动停止。
  static const String reasonProtocolMismatch = 'protocolMismatch';
}
