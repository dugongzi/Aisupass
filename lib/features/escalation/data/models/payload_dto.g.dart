// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payload_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PayloadDto _$PayloadDtoFromJson(Map<String, dynamic> json) => _PayloadDto(
  id: json['id'] as String? ?? '',
  library: json['library'] as String? ?? '',
  vendor: json['vendor'] as String? ?? '',
  displayName: json['displayName'] as String? ?? '',
  models:
      (json['models'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  kernelVersion: json['kernelVersion'] as String? ?? '',
  buildId: json['buildId'] as String? ?? '',
  size: (json['size'] as num?)?.toInt() ?? 0,
  sha256: json['sha256'] as String? ?? '',
  command: json['command'] as String? ?? '',
  source: json['source'] as String? ?? '',
);

Map<String, dynamic> _$PayloadDtoToJson(_PayloadDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'library': instance.library,
      'vendor': instance.vendor,
      'displayName': instance.displayName,
      'models': instance.models,
      'kernelVersion': instance.kernelVersion,
      'buildId': instance.buildId,
      'size': instance.size,
      'sha256': instance.sha256,
      'command': instance.command,
      'source': instance.source,
    };
