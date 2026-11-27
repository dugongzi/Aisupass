import 'package:flutter/foundation.dart';

/// Stellar 特权服务的当前状态。
///
/// 只描述 Stellar 自己，不引用任何其它通道的概念。
@immutable
class StellarServiceStatus {
  const StellarServiceStatus({
    required this.available,
    required this.uid,
    required this.reason,
  });

  /// 服务端尚未在设备上运行。
  static const String reasonServiceNotRunning = 'serviceNotRunning';

  /// 端口上有本协议服务，但它不认当前 token。
  ///
  /// 典型来源：token 被改过而服务仍按旧值运行。
  static const String reasonTokenMismatch = 'tokenMismatch';

  /// 端口上是旧版（protocol 1）服务，与本端协议不兼容。
  static const String reasonProtocolMismatch = 'protocolMismatch';

  /// 端口被其它进程占用，本应用的服务无法应答。
  static const String reasonPortTaken = 'portTaken';

  /// 服务已运行但本应用未获授权。
  static const String reasonNotAuthorized = 'notAuthorized';

  /// 引导器没能把服务拉起来（ADB 通道不可用、身份不符、包路径取不到等）。
  static const String reasonLaunchFailed = 'launchFailed';

  /// 服务是否可以直接执行命令。
  final bool available;

  /// 服务身份 uid：`2000` = shell，`0` = root，`-1` = 未知。
  final int uid;

  /// 不可用时的原因码；`''` 表示没有故障。
  final String reason;
}
