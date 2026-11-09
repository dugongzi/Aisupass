// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vr_offset_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VrOffsetResultDto _$VrOffsetResultDtoFromJson(Map<String, dynamic> json) =>
    _VrOffsetResultDto(
      ok: json['ok'] as bool? ?? false,
      member: (json['member'] as num?)?.toInt() ?? 0,
      release: json['release'] as String? ?? '',
      error: json['error'] as String? ?? '',
    );

Map<String, dynamic> _$VrOffsetResultDtoToJson(_VrOffsetResultDto instance) =>
    <String, dynamic>{
      'ok': instance.ok,
      'member': instance.member,
      'release': instance.release,
      'error': instance.error,
    };
