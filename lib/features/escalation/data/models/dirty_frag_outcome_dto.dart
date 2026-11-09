import 'package:Aisupass/features/escalation/domain/enums/dirty_frag_kind.dart';
import 'package:Aisupass/features/escalation/domain/models/dirty_frag_outcome.dart';
import 'package:Aisupass/generated/dirty_frag.g.dart' as pigeon;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dirty_frag_outcome_dto.freezed.dart';
part 'dirty_frag_outcome_dto.g.dart';

/// 原生一次轮询快照。
///
/// 前 7 个字段与 `pigeon.DirtyFragChunk` 一一对应；`kind` / `log` / `reason`
/// 不在原生侧产生，由仓储实现用 `copyWith` 填入后再 [toEntity]。
@freezed
abstract class DirtyFragOutcomeDto with _$DirtyFragOutcomeDto {
  const DirtyFragOutcomeDto._();

  const factory DirtyFragOutcomeDto({
    @Default('') String sessionId,
    @Default('') String output,
    @Default(-1) int exitCode,
    @Default(0) int durationMs,
    @Default(false) bool timedOut,
    @Default('') String resolvedVrOffset,

    /// 原生侧异常类名；空串表示无异常。
    @Default('') String failure,

    /// 终局分类。默认 [DirtyFragKind.running]，由仓储实现覆盖。
    @Default(DirtyFragKind.running) DirtyFragKind kind,

    /// 累积输出。中间块为空串，终局块由仓储实现填入。
    @Default('') String log,

    /// 受理失败原因码；受理成功时为空串。
    @Default('') String reason,
  }) = _DirtyFragOutcomeDto;

  factory DirtyFragOutcomeDto.fromJson(Map<String, dynamic> json) =>
      _$DirtyFragOutcomeDtoFromJson(json);

  /// 原生快照 → DTO。
  factory DirtyFragOutcomeDto.fromNative(pigeon.DirtyFragChunk chunk) =>
      DirtyFragOutcomeDto(
        sessionId: chunk.sessionId,
        output: chunk.output,
        exitCode: chunk.exitCode,
        durationMs: chunk.durationMs,
        timedOut: chunk.timedOut,
        resolvedVrOffset: chunk.resolvedVrOffset,
        failure: chunk.failure,
      );

  /// 转成领域实体。无参数：判定结果先落进本 DTO 的 [kind] / [log] / [reason]。
  DirtyFragOutcome toEntity() => DirtyFragOutcome(
    kind: kind,
    sessionId: sessionId,
    output: output,
    log: log,
    exitCode: exitCode,
    durationMs: durationMs,
    timedOut: timedOut,
    resolvedVrOffset: resolvedVrOffset,
    reason: reason,
  );
}
