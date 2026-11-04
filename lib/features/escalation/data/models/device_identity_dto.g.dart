// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_identity_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeviceIdentityDto _$DeviceIdentityDtoFromJson(Map<String, dynamic> json) =>
    _DeviceIdentityDto(
      identityText: json['identityText'] as String? ?? '',
      kernelRelease: json['kernelRelease'] as String? ?? '',
      kernelVersion: json['kernelVersion'] as String? ?? '',
      kernelCommit: json['kernelCommit'] as String? ?? '',
      manufacturer: json['manufacturer'] as String? ?? '',
      model: json['model'] as String? ?? '',
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DeviceIdentityDtoToJson(_DeviceIdentityDto instance) =>
    <String, dynamic>{
      'identityText': instance.identityText,
      'kernelRelease': instance.kernelRelease,
      'kernelVersion': instance.kernelVersion,
      'kernelCommit': instance.kernelCommit,
      'manufacturer': instance.manufacturer,
      'model': instance.model,
      'pageSize': instance.pageSize,
    };
