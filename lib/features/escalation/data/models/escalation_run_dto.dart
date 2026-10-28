import 'package:Aisupass/features/escalation/domain/enums/escalation_chain.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_outcome.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_reason.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_stage.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_run_record.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_step_record.dart';
import 'package:Aisupass/generated/escalation.g.dart' as pigeon;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'escalation_run_dto.freezed.dart';
part 'escalation_run_dto.g.dart';

/// 单个阶段记录的数据传输对象。
@freezed
abstract class EscalationStepDto with _$EscalationStepDto {
  const EscalationStepDto._();

  const factory EscalationStepDto({
    @Default('') String stage,
    @Default(0) int startedAtMs,
    @Default(0) int durationMs,
    @Default(false) bool ok,
    @Default(<String>[]) List<String> reasons,
    @Default(<String, String>{}) Map<String, String> evidence,
  }) = _EscalationStepDto;

  factory EscalationStepDto.fromJson(Map<String, dynamic> json) =>
      _$EscalationStepDtoFromJson(json);

  factory EscalationStepDto.fromPigeon(pigeon.RunStep step) =>
      EscalationStepDto(
        stage: step.stage.name,
        startedAtMs: step.startedAtMs,
        durationMs: step.durationMs,
        ok: step.ok,
        reasons: step.reasons.toList(growable: false),
        evidence: step.evidence.map(
          (String key, Object? value) =>
              MapEntry<String, String>(key, value?.toString() ?? ''),
        ),
      );

  factory EscalationStepDto.fromEntity(EscalationStepRecord entity) =>
      EscalationStepDto(
        stage: entity.stage.name,
        startedAtMs: entity.startedAtMs,
        durationMs: entity.durationMs,
        ok: entity.ok,
        reasons: entity.reasons
            .map((EscalationReason reason) => reason.code)
            .toList(growable: false),
        evidence: entity.evidence,
      );

  EscalationStepRecord toEntity() => EscalationStepRecord(
    stage: EscalationStage.fromName(stage),
    startedAtMs: startedAtMs,
    durationMs: durationMs,
    ok: ok,
    reasons: reasons.map(EscalationReason.fromCode).toList(growable: false),
    evidence: evidence,
  );
}

/// 一次提权运行的数据传输对象，整表序列化后落盘。
@freezed
abstract class EscalationRunDto with _$EscalationRunDto {
  const EscalationRunDto._();

  const factory EscalationRunDto({
    @Default('') String runId,
    @Default('') String chain,
    @Default('') String outcome,
    @Default(<EscalationStepDto>[]) List<EscalationStepDto> steps,
    @Default(0) int startedAtMs,
    @Default(0) int finishedAtMs,
    @Default(false) bool residual,
  }) = _EscalationRunDto;

  factory EscalationRunDto.fromJson(Map<String, dynamic> json) =>
      _$EscalationRunDtoFromJson(json);

  /// 由原生快照构造。
  ///
  /// 原生不返回最终结论，[outcome] 必须由 Dart 侧 verify 逻辑判定后写入；
  /// 原生 `done` 收尾哨兵不参与领域阶段，直接丢弃该步。
  factory EscalationRunDto.fromPigeon(
    pigeon.RunSnapshot snapshot, {
    required EscalationOutcome outcome,
    required int startedAtMs,
    required int finishedAtMs,
    required bool residual,
  }) => EscalationRunDto(
    runId: snapshot.runId,
    chain: snapshot.chain.name,
    outcome: outcome.name,
    steps: snapshot.steps
        .where((pigeon.RunStep step) => step.stage != pigeon.EscalationStage.done)
        .map(EscalationStepDto.fromPigeon)
        .toList(growable: false),
    startedAtMs: startedAtMs,
    finishedAtMs: finishedAtMs,
    residual: residual,
  );

  factory EscalationRunDto.fromEntity(EscalationRunRecord entity) =>
      EscalationRunDto(
        runId: entity.runId,
        chain: entity.chain.name,
        outcome: entity.outcome.name,
        steps: entity.steps
            .map(EscalationStepDto.fromEntity)
            .toList(growable: false),
        startedAtMs: entity.startedAtMs,
        finishedAtMs: entity.finishedAtMs,
        residual: entity.residual,
      );

  /// 转为领域实体；链名非法时返回 `null`，由调用方丢弃该行。
  EscalationRunRecord? toEntity() {
    final EscalationChain? parsedChain = EscalationChain.fromName(chain);
    if (parsedChain == null) return null;
    return EscalationRunRecord(
      runId: runId,
      chain: parsedChain,
      outcome: EscalationOutcome.fromName(outcome),
      steps: steps
          .map((EscalationStepDto step) => step.toEntity())
          .toList(growable: false),
      startedAtMs: startedAtMs,
      finishedAtMs: finishedAtMs,
      residual: residual,
    );
  }
}
