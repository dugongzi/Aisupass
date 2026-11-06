import 'package:freezed_annotation/freezed_annotation.dart';

part 'escalation_run_result.freezed.dart';

/// 一次提权执行的结果证据。判定结论由 [success] 承载。
@freezed
abstract class EscalationRunResult with _$EscalationRunResult {
  const EscalationRunResult._();

  const factory EscalationRunResult({
    /// 是否判定为提权成功（载荷日志标记通过，且 `su -c id` 确认为 uid 0）。
    required bool success,

    /// 命令退出码；`-1` 表示命令没跑起来，或退出码文件没读到。
    ///
    /// 提权链路是「后台起 + 轮询日志」，设备端进程不在前台、回收不到返回值，
    /// 退出码由启动脚本在助手退出后写进 `exploit.rc`，收日志时一并读回。
    /// 也就是说这里可能出现任意非 0 值，不再只有 0 / -1 两档。
    /// **判断成败只看 [success]**。
    required int exitCode,

    /// 标准输出。
    required String stdout,

    /// 标准错误。
    required String stderr,

    /// 耗时（毫秒）。
    required int durationMs,

    /// 是否因停滞或超时被掐断。
    required bool timedOut,
  }) = _EscalationRunResult;

  /// 还没跑起来就失败时的结果。
  ///
  /// 走结构化返回值而不是抛异常：调用方一律按「失败证据」渲染。
  static EscalationRunResult failure(String message) => EscalationRunResult(
    success: false,
    exitCode: -1,
    stdout: '',
    stderr: message,
    durationMs: 0,
    timedOut: false,
  );
}
