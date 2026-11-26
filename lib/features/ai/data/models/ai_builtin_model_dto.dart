import 'package:Aisupass/features/ai/domain/models/ai_builtin_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_builtin_model_dto.freezed.dart';
part 'ai_builtin_model_dto.g.dart';

/// 模型计费的传输对象。
///
/// 服务端在部分模型上直接返回 `pricing: null`，这里用可空的嵌套 DTO 承接，
/// 由外层字段的 `@Default` 兜底成 0 价，不给上层留可空值。
@freezed
abstract class AiBuiltinPricingDto with _$AiBuiltinPricingDto {
  const factory AiBuiltinPricingDto({
    @JsonKey(name: 'input_price') @Default(0) double inputPrice,
    @JsonKey(name: 'output_price') @Default(0) double outputPrice,
  }) = _AiBuiltinPricingDto;

  factory AiBuiltinPricingDto.fromJson(Map<String, dynamic> json) =>
      _$AiBuiltinPricingDtoFromJson(json);
}

/// 模型广场里单个模型的传输对象。
@freezed
abstract class AiBuiltinModelDto with _$AiBuiltinModelDto {
  const AiBuiltinModelDto._();

  const factory AiBuiltinModelDto({
    @Default('') String name,
    @Default('') String platform,
    @Default(AiBuiltinPricingDto()) AiBuiltinPricingDto pricing,
  }) = _AiBuiltinModelDto;

  factory AiBuiltinModelDto.fromJson(Map<String, dynamic> json) =>
      _$AiBuiltinModelDtoFromJson(json);

  /// 转成领域实体；缺价格时由嵌套 DTO 的默认值收敛为 0。
  AiBuiltinModel toEntity() => AiBuiltinModel(
    name: name,
    platform: platform,
    inputPrice: pricing.inputPrice,
    outputPrice: pricing.outputPrice,
  );
}
