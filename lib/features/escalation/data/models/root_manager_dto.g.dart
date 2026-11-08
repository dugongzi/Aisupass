// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'root_manager_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RootManagerDto _$RootManagerDtoFromJson(Map<String, dynamic> json) =>
    _RootManagerDto(
      packageName: json['packageName'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      icon:
          (json['icon'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
    );

Map<String, dynamic> _$RootManagerDtoToJson(_RootManagerDto instance) =>
    <String, dynamic>{
      'packageName': instance.packageName,
      'displayName': instance.displayName,
      'icon': instance.icon,
    };
