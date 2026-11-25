import 'package:Aisupass/features/escalation/domain/models/imported_payload.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'imported_payload_dto.freezed.dart';
part 'imported_payload_dto.g.dart';

/// 自定义载荷的存储 DTO，对应 `StorageKeys.escalationImportedPayloads`
/// 里 JSON 数组的单个条目。
@freezed
abstract class ImportedPayloadDto with _$ImportedPayloadDto {
  const ImportedPayloadDto._();

  const factory ImportedPayloadDto({
    @Default('') String displayName,
    @Default('') String devicePath,
    @Default(false) bool standalone,
    @Default('') String arguments,
    @Default(0) int size,
  }) = _ImportedPayloadDto;

  factory ImportedPayloadDto.fromJson(Map<String, dynamic> json) =>
      _$ImportedPayloadDtoFromJson(json);

  /// 转成领域实体。
  ImportedPayload toEntity() => ImportedPayload(
    displayName: displayName,
    devicePath: devicePath,
    standalone: standalone,
    arguments: arguments,
    size: size,
  );

  /// 实体 → DTO，写入存储前使用。
  factory ImportedPayloadDto.fromEntity(ImportedPayload payload) =>
      ImportedPayloadDto(
        displayName: payload.displayName,
        devicePath: payload.devicePath,
        standalone: payload.standalone,
        arguments: payload.arguments,
        size: payload.size,
      );
}
