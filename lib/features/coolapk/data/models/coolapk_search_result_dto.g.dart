// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coolapk_search_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoolapkSearchResultDto _$CoolapkSearchResultDtoFromJson(
  Map<String, dynamic> json,
) => _CoolapkSearchResultDto(
  entityType: json['entityType'] as String? ?? '',
  id: json['id'] as String? ?? '',
  title: json['title'] as String? ?? '',
  message: json['message'] == null ? '' : plainTextFromJson(json['message']),
  username: json['username'] as String? ?? '',
  uid: json['uid'] as String? ?? '',
  url: json['url'] as String? ?? '',
  shareUrl: json['shareUrl'] as String? ?? '',
  likenum: json['likenum'] == null ? 0 : intFromJson(json['likenum']),
  replynum: json['replynum'] == null ? 0 : intFromJson(json['replynum']),
  datelineText: json['dateline_text'] as String? ?? '',
  deviceTitle: json['device_title'] as String? ?? '',
  tags: json['tags'] == null ? '' : hashTagsFromJson(json['tags']),
  picArr: json['picArr'] == null
      ? const <String>[]
      : stringListFromJson(json['picArr']),
  queryTotal: json['_queryTotal'] == null
      ? 0
      : intFromJson(json['_queryTotal']),
);

Map<String, dynamic> _$CoolapkSearchResultDtoToJson(
  _CoolapkSearchResultDto instance,
) => <String, dynamic>{
  'entityType': instance.entityType,
  'id': instance.id,
  'title': instance.title,
  'message': instance.message,
  'username': instance.username,
  'uid': instance.uid,
  'url': instance.url,
  'shareUrl': instance.shareUrl,
  'likenum': instance.likenum,
  'replynum': instance.replynum,
  'dateline_text': instance.datelineText,
  'device_title': instance.deviceTitle,
  'tags': instance.tags,
  'picArr': instance.picArr,
  '_queryTotal': instance.queryTotal,
};
