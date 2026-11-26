// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coolapk_feed_detail_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoolapkFeedDetailDto _$CoolapkFeedDetailDtoFromJson(
  Map<String, dynamic> json,
) => _CoolapkFeedDetailDto(
  id: json['id'] == null ? '' : stringFromJson(json['id']),
  title: json['title'] as String? ?? '',
  message: json['message'] == null ? '' : plainTextFromJson(json['message']),
  username: json['username'] as String? ?? '',
  uid: json['uid'] == null ? '' : stringFromJson(json['uid']),
  likenum: json['likenum'] == null ? 0 : intFromJson(json['likenum']),
  replynum: json['replynum'] == null ? 0 : intFromJson(json['replynum']),
  datelineText: json['dateline_text'] as String? ?? '',
  deviceTitle: json['device_title'] as String? ?? '',
  tags: json['tags'] == null ? '' : hashTagsFromJson(json['tags']),
  picArr: json['picArr'] == null
      ? const <String>[]
      : stringListFromJson(json['picArr']),
  shareUrl: json['shareUrl'] as String? ?? '',
);

Map<String, dynamic> _$CoolapkFeedDetailDtoToJson(
  _CoolapkFeedDetailDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'message': instance.message,
  'username': instance.username,
  'uid': instance.uid,
  'likenum': instance.likenum,
  'replynum': instance.replynum,
  'dateline_text': instance.datelineText,
  'device_title': instance.deviceTitle,
  'tags': instance.tags,
  'picArr': instance.picArr,
  'shareUrl': instance.shareUrl,
};
