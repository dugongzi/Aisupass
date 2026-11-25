// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imported_payload_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ImportedPayloadDto _$ImportedPayloadDtoFromJson(Map<String, dynamic> json) =>
    _ImportedPayloadDto(
      displayName: json['displayName'] as String? ?? '',
      devicePath: json['devicePath'] as String? ?? '',
      standalone: json['standalone'] as bool? ?? false,
      arguments: json['arguments'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ImportedPayloadDtoToJson(_ImportedPayloadDto instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'devicePath': instance.devicePath,
      'standalone': instance.standalone,
      'arguments': instance.arguments,
      'size': instance.size,
    };
