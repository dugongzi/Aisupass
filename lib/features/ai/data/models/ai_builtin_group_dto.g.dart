// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_builtin_group_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiBuiltinGroupDto _$AiBuiltinGroupDtoFromJson(Map<String, dynamic> json) =>
    _AiBuiltinGroupDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      platform: json['platform'] as String? ?? '',
      rateMultiplier: (json['rate_multiplier'] as num?)?.toDouble() ?? 1,
      isExclusive: json['is_exclusive'] as bool? ?? false,
      models:
          (json['models'] as List<dynamic>?)
              ?.map(
                (e) => AiBuiltinModelDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <AiBuiltinModelDto>[],
    );

Map<String, dynamic> _$AiBuiltinGroupDtoToJson(_AiBuiltinGroupDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'platform': instance.platform,
      'rate_multiplier': instance.rateMultiplier,
      'is_exclusive': instance.isExclusive,
      'models': instance.models,
    };
