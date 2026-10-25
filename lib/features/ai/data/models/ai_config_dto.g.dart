// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiConfigDto _$AiConfigDtoFromJson(Map<String, dynamic> json) => _AiConfigDto(
  id: json['id'] as String? ?? '',
  name: json['name'] as String? ?? '',
  apiUrl: json['apiUrl'] as String? ?? '',
  modelName: json['modelName'] as String? ?? '',
  maxToken: json['maxToken'] == null ? 0 : _parseMaxToken(json['maxToken']),
  temperature: json['temperature'] == null
      ? -1
      : _parseTemperature(json['temperature']),
  apiType: json['apiType'] == null
      ? AiApiType.openai
      : _parseApiType(json['apiType']),
);

Map<String, dynamic> _$AiConfigDtoToJson(_AiConfigDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'apiUrl': instance.apiUrl,
      'modelName': instance.modelName,
      'maxToken': instance.maxToken,
      'temperature': instance.temperature,
      'apiType': _apiTypeToJson(instance.apiType),
    };
