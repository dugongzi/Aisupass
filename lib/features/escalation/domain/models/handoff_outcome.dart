import 'package:Aisupass/features/escalation/domain/enums/handoff_kind.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'handoff_outcome.freezed.dart';

/// 一次「把临时 root 移交给管理器」的结果。
@freezed
abstract class HandoffOutcome with _$HandoffOutcome {
  const HandoffOutcome._();

  const factory HandoffOutcome({
    /// 结果形态，UI 按它分支。
    required HandoffKind kind,

    /// 本次移交的目标管理器。
    required RootManager manager,

    /// 本次实际使用的 ksud 路径（脚本回显的那一行），只有 [HandoffKind.success]
    /// 时可靠。
    required String ksudPath,

    /// 命令退出码；`-1` 表示命令没跑起来。
    required int exitCode,

    /// 命令两路输出的合并结果，原样给用户核对。
    required String output,

    /// 耗时（毫秒）。
    required int durationMs,

    /// 是否因超时被掐断。
    required bool timedOut,
  }) = _HandoffOutcome;

  /// 是否移交成功。
  bool get success => kind == HandoffKind.success;
}
