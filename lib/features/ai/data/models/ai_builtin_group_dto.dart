import 'package:Aisupass/features/ai/data/models/ai_builtin_model_dto.dart';
import 'package:Aisupass/features/ai/domain/models/ai_builtin_group.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_builtin_group_dto.freezed.dart';
part 'ai_builtin_group_dto.g.dart';

/// 模型广场里单个分组的传输对象。
@freezed
abstract class AiBuiltinGroupDto with _$AiBuiltinGroupDto {
  const AiBuiltinGroupDto._();

  const factory AiBuiltinGroupDto({
    @Default(0) int id,
    @Default('') String name,
    @Default('') String description,
    @Default('') String platform,
    @JsonKey(name: 'rate_multiplier') @Default(1) double rateMultiplier,
    @JsonKey(name: 'is_exclusive') @Default(false) bool isExclusive,
    @Default(<AiBuiltinModelDto>[]) List<AiBuiltinModelDto> models,
  }) = _AiBuiltinGroupDto;

  factory AiBuiltinGroupDto.fromJson(Map<String, dynamic> json) =>
      _$AiBuiltinGroupDtoFromJson(json);

  /// 转成领域实体，模型清单逐个转换。
  AiBuiltinGroup toEntity() => AiBuiltinGroup(
    id: id,
    name: name,
    description: description,
    platform: platform,
    rateMultiplier: rateMultiplier,
    isExclusive: isExclusive,
    models: models
        .map((AiBuiltinModelDto item) => item.toEntity())
        .toList(growable: false),
  );
}
