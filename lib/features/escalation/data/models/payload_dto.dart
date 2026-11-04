import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payload_dto.freezed.dart';
part 'payload_dto.g.dart';

/// 载荷清单 DTO，对应 `catalog.json` 的单个条目。
///
/// catalog 里 `kernelVersion` 为 `null` 时由 `@Default('')` 收敛成空串，
/// 「未知」语义交给实体 getter 还原，因此这里不接 `kernelUnknown` 字段。
@freezed
abstract class PayloadDto with _$PayloadDto {
  const PayloadDto._();

  const factory PayloadDto({
    @Default('') String id,
    @Default('') String library,
    @Default('') String vendor,
    @Default('') String displayName,
    @Default(<String>[]) List<String> models,
    @Default('') String kernelVersion,
    @Default('') String buildId,
    @Default(0) int size,
    @Default('') String sha256,
    @Default('') String command,
    @Default('') String source,
  }) = _PayloadDto;

  factory PayloadDto.fromJson(Map<String, dynamic> json) =>
      _$PayloadDtoFromJson(json);

  /// 转成领域实体。
  Payload toEntity() => Payload(
    id: id,
    library: library,
    vendor: vendor,
    displayName: displayName,
    models: models,
    kernelVersion: kernelVersion,
    buildId: buildId,
    size: size,
    sha256: sha256,
    command: command,
    source: source,
  );
}
