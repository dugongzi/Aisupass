import 'package:Aisupass/features/escalation/domain/models/device_identity.dart';
import 'package:Aisupass/generated/device_identity.g.dart' as pigeon;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_identity_dto.freezed.dart';
part 'device_identity_dto.g.dart';

/// 设备身份 DTO，承接 Pigeon 回传的原始取值。
@freezed
abstract class DeviceIdentityDto with _$DeviceIdentityDto {
  const DeviceIdentityDto._();

  const factory DeviceIdentityDto({
    @Default('') String identityText,
    @Default('') String kernelRelease,
    @Default('') String kernelVersion,
    @Default('') String kernelCommit,
    @Default('') String manufacturer,
    @Default('') String model,
    @Default(0) int pageSize,
  }) = _DeviceIdentityDto;

  factory DeviceIdentityDto.fromJson(Map<String, dynamic> json) =>
      _$DeviceIdentityDtoFromJson(json);

  /// 从原生桥接结果构造。
  factory DeviceIdentityDto.fromNative(pigeon.DeviceIdentity identity) =>
      DeviceIdentityDto(
        identityText: identity.identityText,
        kernelRelease: identity.kernelRelease,
        kernelVersion: identity.kernelVersion,
        kernelCommit: identity.kernelCommit,
        manufacturer: identity.manufacturer,
        model: identity.model,
        pageSize: identity.pageSize,
      );

  /// 转成领域实体。
  DeviceIdentity toEntity() => DeviceIdentity(
    identityText: identityText,
    kernelRelease: kernelRelease,
    kernelVersion: kernelVersion,
    kernelCommit: kernelCommit,
    manufacturer: manufacturer,
    model: model,
    pageSize: pageSize,
  );
}
