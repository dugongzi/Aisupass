import 'package:Aisupass/features/escalation/domain/enums/root_manager.dart';

/// 移交结果的四种形态，与上游 `RootHandoff.kt:78-99` 的 `HandoffResult`
/// 一一对应。
///
/// 之所以要分型而不是继续用一句 `stderr`：最常见的一种失败是「管理器没装」，
/// 这种情况下用户唯一能自救的动作是去下载页把管理器装上，把四种形态压成
/// 一个字符串就丢掉了这个出路。
enum HandoffKind {
  /// 成功：命令退 0，且输出里没有已知失败关键字。
  success,

  /// 管理器没装：`/data/app` 下没有该包名的 `libksud.so`。
  managerMissing,

  /// 没有 root 权限：只提示，不尝试移交。
  noRoot,

  /// 命令跑了但失败。
  failed,
}

/// 一次「把临时 root 移交给管理器」的结果。
///
/// 与 [EscalationRunResult] 分开是刻意的：载荷执行是「后台起 + 轮询日志」，
/// 移交是「一条命令等它跑完」，两种结果的判据与字段都不同，共用一个类型
/// 只会让两边的语义互相稀释。上游同样把它们拆成两套。
class HandoffOutcome {
  const HandoffOutcome({
    required this.kind,
    required this.manager,
    this.ksudPath = '',
    this.exitCode = -1,
    this.output = '',
    this.durationMs = 0,
    this.timedOut = false,
  });

  /// 结果形态，UI 按它分支。
  final HandoffKind kind;

  /// 本次移交的目标管理器。
  final RootManager manager;

  /// 脚本定位到的 `libksud.so` 路径，只有 [HandoffKind.success] 时可靠。
  final String ksudPath;

  /// 命令退出码；`-1` 表示命令没跑起来。
  final int exitCode;

  /// 命令两路输出的合并结果，原样给用户核对。
  final String output;

  /// 耗时（毫秒）。
  final int durationMs;

  /// 是否因超时被掐断。
  final bool timedOut;

  /// 是否移交成功。
  bool get success => kind == HandoffKind.success;
}
