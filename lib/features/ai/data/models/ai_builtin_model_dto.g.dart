// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_builtin_model_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiBuiltinPricingDto _$AiBuiltinPricingDtoFromJson(Map<String, dynamic> json) =>
    _AiBuiltinPricingDto(
      inputPrice: (json['input_price'] as num?)?.toDouble() ?? 0,
      outputPrice: (json['output_price'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$AiBuiltinPricingDtoToJson(
  _AiBuiltinPricingDto instance,
) => <String, dynamic>{
  'input_price': instance.inputPrice,
  'output_price': instance.outputPrice,
};

_AiBuiltinModelDto _$AiBuiltinModelDtoFromJson(Map<String, dynamic> json) =>
    _AiBuiltinModelDto(
      name: json['name'] as String? ?? '',
      platform: json['platform'] as String? ?? '',
      pricing: json['pricing'] == null
          ? const AiBuiltinPricingDto()
          : AiBuiltinPricingDto.fromJson(
              json['pricing'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$AiBuiltinModelDtoToJson(_AiBuiltinModelDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'platform': instance.platform,
      'pricing': instance.pricing,
    };
