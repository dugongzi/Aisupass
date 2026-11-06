import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payload_dto.freezed.dart';
part 'payload_dto.g.dart';

/// 载荷清单 DTO，对应 `catalog.json` 的单个条目。
///
/// catalog 里 `kernelVersion` 为 `null` 时由 `@Default('')` 收敛成空串。
@freezed
abstract class PayloadDto with _$PayloadDto {
  const PayloadDto._();

  const factory PayloadDto({
    @Default('') String id,
    @Default('') String library,
    @Default('') String vendor,
    @Default('') String displayName,
    @Default(<String>[]) List<String> models,
    @Default(false) bool kernelUnknown,
    @Default('') String kernelVersion,
    @Default(<String>[]) List<String> kernelCommits,
    @Default('') String buildId,
    @Default(0) int size,
    @Default('') String sha256,
    @Default('') String command,

    /// 助手只能 `dlopen`，形态上跑不了主体的载荷在 catalog 里标 `true`。
    @Default(false) bool standalone,
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
    kernelUnknown: kernelUnknown,
    kernelVersion: kernelVersion,
    kernelCommits: kernelCommits,
    buildId: buildId,
    size: size,
    sha256: sha256,
    command: command,
    standalone: standalone,
    source: source,
  );
}
