import 'package:Aisupass/features/escalation/domain/enums/escalation_chain.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_reason.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_capability.dart';
import 'package:Aisupass/generated/escalation.g.dart' as pigeon;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'escalation_capability_dto.freezed.dart';
part 'escalation_capability_dto.g.dart';

/// 单条链探测结论的数据传输对象，只在 data 层内流转。
@freezed
abstract class EscalationCapabilityDto with _$EscalationCapabilityDto {
  const EscalationCapabilityDto._();

  const factory EscalationCapabilityDto({
    @Default('') String chain,
    @Default(false) bool available,
    @Default(<String>[]) List<String> reasons,
    @Default(<String, String>{}) Map<String, String> evidence,
  }) = _EscalationCapabilityDto;

  factory EscalationCapabilityDto.fromJson(Map<String, dynamic> json) =>
      _$EscalationCapabilityDtoFromJson(json);

  /// 原生证据里的值可能是任意类型，统一转成字符串，`null` 落成空串。
  factory EscalationCapabilityDto.fromPigeon(pigeon.ChainProbe probe) =>
      EscalationCapabilityDto(
        chain: probe.chain.name,
        available: probe.available,
        reasons: probe.reasons.toList(growable: false),
        evidence: probe.evidence.map(
          (String key, Object? value) =>
              MapEntry<String, String>(key, value?.toString() ?? ''),
        ),
      );

  /// 转为领域实体；链名非法时返回 `null`，由调用方丢弃该行。
  ///
  /// 未知链不能兜底成某条真实链，否则会把「不认识」误当成「可用」。
  EscalationCapability? toEntity() {
    final EscalationChain? parsedChain = EscalationChain.fromName(chain);
    if (parsedChain == null) return null;
    return EscalationCapability(
      chain: parsedChain,
      available: available,
      reasons: reasons.map(EscalationReason.fromCode).toList(growable: false),
      evidence: evidence,
    );
  }
}
