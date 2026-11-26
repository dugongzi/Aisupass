// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coolapk_account_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoolapkAccountDto _$CoolapkAccountDtoFromJson(Map<String, dynamic> json) =>
    _CoolapkAccountDto(
      uid: json['uid'] == null ? '' : stringFromJson(json['uid']),
      username: json['username'] as String? ?? '',
      userAvatar: json['userAvatar'] as String? ?? '',
    );

Map<String, dynamic> _$CoolapkAccountDtoToJson(_CoolapkAccountDto instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'username': instance.username,
      'userAvatar': instance.userAvatar,
    };
