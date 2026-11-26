// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coolapk_feed_reply_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoolapkFeedReplyDto _$CoolapkFeedReplyDtoFromJson(
  Map<String, dynamic> json,
) => _CoolapkFeedReplyDto(
  id: json['id'] == null ? '' : stringFromJson(json['id']),
  fid: json['fid'] == null ? '' : stringFromJson(json['fid']),
  uid: json['uid'] == null ? '' : stringFromJson(json['uid']),
  username: json['username'] as String? ?? '',
  ruid: json['ruid'] == null ? '' : stringFromJson(json['ruid']),
  rusername: json['rusername'] as String? ?? '',
  message: json['message'] == null ? '' : plainTextFromJson(json['message']),
  likenum: json['likenum'] == null ? 0 : intFromJson(json['likenum']),
  replynum: json['replynum'] == null ? 0 : intFromJson(json['replynum']),
  datelineText: json['dateline_text'] as String? ?? '',
  isFeedAuthor: json['isFeedAuthor'] == null
      ? false
      : boolFromJson(json['isFeedAuthor']),
  userAvatar: json['userAvatar'] as String? ?? '',
  replyRows:
      (json['replyRows'] as List<dynamic>?)
          ?.map((e) => CoolapkFeedReplyDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <CoolapkFeedReplyDto>[],
  replyRowsCount: json['replyRowsCount'] == null
      ? 0
      : intFromJson(json['replyRowsCount']),
);

Map<String, dynamic> _$CoolapkFeedReplyDtoToJson(
  _CoolapkFeedReplyDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'fid': instance.fid,
  'uid': instance.uid,
  'username': instance.username,
  'ruid': instance.ruid,
  'rusername': instance.rusername,
  'message': instance.message,
  'likenum': instance.likenum,
  'replynum': instance.replynum,
  'dateline_text': instance.datelineText,
  'isFeedAuthor': instance.isFeedAuthor,
  'userAvatar': instance.userAvatar,
  'replyRows': instance.replyRows,
  'replyRowsCount': instance.replyRowsCount,
};
