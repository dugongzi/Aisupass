import 'package:Aisupass/features/ai/domain/enums/ai_api_type.dart';
import 'package:Aisupass/features/ai/domain/models/ai_config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_config_dto.freezed.dart';
part 'ai_config_dto.g.dart';

/// AI 配置的数据传输对象，只在 data 层内流转。
///
/// [apiKey] 属于敏感数据，不参与 JSON 序列化，由数据源单独读写安全存储。
@freezed
abstract class AiConfigDto with _$AiConfigDto {
  const AiConfigDto._();

  const factory AiConfigDto({
    @Default('') String id,
    @Default('') String name,
    @Default('') String apiUrl,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String apiKey,
    @Default('') String modelName,
    @JsonKey(fromJson: _parseMaxToken) @Default(0) int maxToken,
    @JsonKey(fromJson: _parseTemperature) @Default(-1) double temperature,
    @JsonKey(fromJson: _parseApiType, toJson: _apiTypeToJson)
    @Default(AiApiType.openai)
    AiApiType apiType,
  }) = _AiConfigDto;

  factory AiConfigDto.fromJson(Map<String, dynamic> json) =>
      _$AiConfigDtoFromJson(json);

  factory AiConfigDto.fromEntity(AiConfig entity) => AiConfigDto(
    id: entity.id,
    name: entity.name,
    apiUrl: entity.apiUrl,
    apiKey: entity.apiKey,
    modelName: entity.modelName,
    maxToken: entity.maxToken,
    temperature: entity.temperature,
    apiType: entity.apiType,
  );

  AiConfig toEntity() => AiConfig(
    id: id,
    name: name,
    apiUrl: apiUrl,
    apiKey: apiKey,
    modelName: modelName,
    maxToken: maxToken,
    temperature: temperature,
    apiType: apiType,
  );
}

int _parseMaxToken(Object? value) =>
    int.tryParse(value?.toString() ?? '') ?? 0;

double _parseTemperature(Object? value) => value is num
    ? value.toDouble()
    : double.tryParse(value?.toString() ?? '') ?? -1;

AiApiType _parseApiType(Object? value) => AiApiType.fromName(value?.toString());

String _apiTypeToJson(AiApiType value) => value.name;
