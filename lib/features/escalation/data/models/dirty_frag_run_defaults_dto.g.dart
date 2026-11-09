// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dirty_frag_run_defaults_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DirtyFragRunDefaultsDto _$DirtyFragRunDefaultsDtoFromJson(
  Map<String, dynamic> json,
) => _DirtyFragRunDefaultsDto(
  vrDisarm: json['vrDisarm'] as bool? ?? false,
  vrAuto: json['vrAuto'] as bool? ?? true,
  vrOffset: (json['vrOffset'] as num?)?.toInt() ?? 0,
  softReboot: json['softReboot'] as bool? ?? false,
);

Map<String, dynamic> _$DirtyFragRunDefaultsDtoToJson(
  _DirtyFragRunDefaultsDto instance,
) => <String, dynamic>{
  'vrDisarm': instance.vrDisarm,
  'vrAuto': instance.vrAuto,
  'vrOffset': instance.vrOffset,
  'softReboot': instance.softReboot,
};
