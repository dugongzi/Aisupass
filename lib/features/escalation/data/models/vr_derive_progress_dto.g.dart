// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vr_derive_progress_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VrDeriveProgressDto _$VrDeriveProgressDtoFromJson(Map<String, dynamic> json) =>
    _VrDeriveProgressDto(
      phase: (json['phase'] as num?)?.toInt() ?? 0,
      done: (json['done'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$VrDeriveProgressDtoToJson(
  _VrDeriveProgressDto instance,
) => <String, dynamic>{
  'phase': instance.phase,
  'done': instance.done,
  'total': instance.total,
};
