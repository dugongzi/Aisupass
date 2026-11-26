import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/core/utils/html_text.dart';
import 'package:Aisupass/core/utils/json_value.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_feed_reply.dart';

part 'coolapk_feed_reply_dto.freezed.dart';
part 'coolapk_feed_reply_dto.g.dart';

/// `/v6/feed/replyList` 单条评论，字段名与服务器返回一致。
@freezed
abstract class CoolapkFeedReplyDto with _$CoolapkFeedReplyDto {
  const CoolapkFeedReplyDto._();

  const factory CoolapkFeedReplyDto({
    @JsonKey(fromJson: stringFromJson) @Default('') String id,
    @JsonKey(fromJson: stringFromJson) @Default('') String fid,
    @JsonKey(fromJson: stringFromJson) @Default('') String uid,
    @Default('') String username,
    @JsonKey(fromJson: stringFromJson) @Default('') String ruid,
    @Default('') String rusername,
    @JsonKey(fromJson: plainTextFromJson) @Default('') String message,
    @JsonKey(fromJson: intFromJson) @Default(0) int likenum,
    @JsonKey(fromJson: intFromJson) @Default(0) int replynum,
    @JsonKey(name: 'dateline_text') @Default('') String datelineText,
    @JsonKey(fromJson: boolFromJson) @Default(false) bool isFeedAuthor,
    @Default('') String userAvatar,
    @Default(<CoolapkFeedReplyDto>[]) List<CoolapkFeedReplyDto> replyRows,
    @JsonKey(fromJson: intFromJson) @Default(0) int replyRowsCount,
  }) = _CoolapkFeedReplyDto;

  /// 服务器条目 → DTO。
  factory CoolapkFeedReplyDto.fromJson(Map<String, dynamic> json) =>
      _$CoolapkFeedReplyDtoFromJson(json);

  /// DTO → 实体，楼中楼一并转换。
  CoolapkFeedReply toEntity() => CoolapkFeedReply(
    id: id,
    fid: fid,
    uid: uid,
    username: username,
    ruid: ruid,
    rusername: rusername,
    message: message,
    likenum: likenum,
    replynum: replynum,
    datelineText: datelineText,
    isFeedAuthor: isFeedAuthor,
    userAvatar: userAvatar,
    replyRows: <CoolapkFeedReply>[
      for (final CoolapkFeedReplyDto row in replyRows) row.toEntity(),
    ],
    replyRowsCount: replyRowsCount,
  );
}
