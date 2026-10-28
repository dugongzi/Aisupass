import 'package:Aisupass/features/escalation/domain/enums/escalation_chain.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_reason.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'escalation_capability.freezed.dart';

/// 单条提权链在当前设备上的能力结论。
@freezed
abstract class EscalationCapability with _$EscalationCapability {
  const EscalationCapability._();

  const factory EscalationCapability({
    required EscalationChain chain,
    required bool available,
    required List<EscalationReason> reasons,
    required Map<String, String> evidence,
  }) = _EscalationCapability;

  /// 首个原因，供列表直接展示；无原因时返回 [EscalationReason.unknown]。
  EscalationReason get primaryReason =>
      reasons.isEmpty ? EscalationReason.unknown : reasons.first;
}
