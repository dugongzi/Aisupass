// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'escalation_capability_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EscalationCapabilityDto _$EscalationCapabilityDtoFromJson(
  Map<String, dynamic> json,
) => _EscalationCapabilityDto(
  chain: json['chain'] as String? ?? '',
  available: json['available'] as bool? ?? false,
  reasons:
      (json['reasons'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  evidence:
      (json['evidence'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
);

Map<String, dynamic> _$EscalationCapabilityDtoToJson(
  _EscalationCapabilityDto instance,
) => <String, dynamic>{
  'chain': instance.chain,
  'available': instance.available,
  'reasons': instance.reasons,
  'evidence': instance.evidence,
};
