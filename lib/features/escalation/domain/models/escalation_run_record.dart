import 'package:Aisupass/features/escalation/domain/enums/escalation_chain.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_step_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'escalation_run_record.freezed.dart';

/// 一次提权运行的完整记录，整体序列化后落盘。
@freezed
abstract class EscalationRunRecord with _$EscalationRunRecord {
  const EscalationRunRecord._();

  const factory EscalationRunRecord({
    required String runId,
    required EscalationChain chain,
    required EscalationOutcome outcome,
    required List<EscalationStepRecord> steps,
    required int startedAtMs,
    required int finishedAtMs,
    required bool residual,
  }) = _EscalationRunRecord;

  /// 是否仍在运行（[finishedAtMs] 为 0 表示未结束）。
  bool get isRunning => finishedAtMs <= 0;

  /// 总耗时；运行中返回 0。
  int get durationMs => isRunning ? 0 : finishedAtMs - startedAtMs;
}
