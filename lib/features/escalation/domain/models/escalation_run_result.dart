import 'package:freezed_annotation/freezed_annotation.dart';

part 'escalation_run_result.freezed.dart';

/// 一次提权执行的结果证据。判定结论由 [success] 承载。
@freezed
abstract class EscalationRunResult with _$EscalationRunResult {
  const EscalationRunResult._();

  const factory EscalationRunResult({
    /// 是否判定为提权成功（退出码与两条日志标记同时满足）。
    required bool success,

    /// 命令退出码；`-1` 表示没跑起来。
    required int exitCode,

    /// 标准输出。
    required String stdout,

    /// 标准错误。
    required String stderr,

    /// 耗时（毫秒）。
    required int durationMs,

    /// 是否因超时被掐断。
    required bool timedOut,
  }) = _EscalationRunResult;
}
