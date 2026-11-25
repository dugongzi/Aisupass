import 'package:flutter/foundation.dart';

/// 拉起特权服务这一步的进展。
///
/// 只描述「启动动作」本身，不描述服务运行状态：运行状态由
/// `stellarServiceStatusProvider` 通过探活回答。
@immutable
class StellarLaunchState {
  const StellarLaunchState({required this.busy, required this.reason});

  /// 空闲。
  const StellarLaunchState.idle() : busy = false, reason = '';

  /// 拉起命令已发出、尚未拿到可用结果。
  final bool busy;

  /// 上一次拉起的失败原因码；`''` 表示没有失败。
  final String reason;

  /// 拉起器不存在：APK 里没有可执行的引导文件，属于打包问题。
  static const String reasonLauncherMissing = 'launcherMissing';

  /// 拉起命令没能执行：通常是当前没有可用的执行通道。
  static const String reasonNoRunner = 'noRunner';

  /// 命令执行了但服务没有在预期时间内应答。
  static const String reasonNotAnswering = 'notAnswering';
}
