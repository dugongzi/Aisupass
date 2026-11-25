import 'package:flutter/foundation.dart';

/// 一条特权命令的执行结果。
///
/// 刻意不引用任何通道的 IPC 类型：特权服务只需要退出码与两路输出，
/// 由装配层把具体通道的结果搬成这个形状。
@immutable
class PrivilegedRunResult {
  const PrivilegedRunResult({
    required this.exitCode,
    required this.stdout,
    required this.stderr,
  });

  /// 退出码；`-1` 表示命令根本没跑起来。
  final int exitCode;

  /// 标准输出。
  final String stdout;

  /// 标准错误。
  final String stderr;

  /// 命令是否真的被执行过。
  bool get started => exitCode != -1;
}
