import 'package:Aisupass/features/escalation/domain/enums/escalation_reason.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_stage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'escalation_step_record.freezed.dart';

/// 单个阶段的执行记录。
///
/// [ok] 只表示「该阶段自身未抛异常」，不代表提权成败；成败由 [EscalationOutcome] 表达。
@freezed
abstract class EscalationStepRecord with _$EscalationStepRecord {
  const EscalationStepRecord._();

  const factory EscalationStepRecord({
    required EscalationStage stage,
    required int startedAtMs,
    required int durationMs,
    required bool ok,
    required List<EscalationReason> reasons,
    required Map<String, String> evidence,
  }) = _EscalationStepRecord;
}
