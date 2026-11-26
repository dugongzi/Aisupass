import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/core/utils/html_text.dart';
import 'package:Aisupass/core/utils/json_value.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_feed_detail.dart';

part 'coolapk_feed_detail_dto.freezed.dart';
part 'coolapk_feed_detail_dto.g.dart';

/// `/v6/feed/detail` 的动态对象，字段名与服务器返回一致。
@freezed
abstract class CoolapkFeedDetailDto with _$CoolapkFeedDetailDto {
  const CoolapkFeedDetailDto._();

  const factory CoolapkFeedDetailDto({
    @JsonKey(fromJson: stringFromJson) @Default('') String id,
    @Default('') String title,
    @JsonKey(fromJson: plainTextFromJson) @Default('') String message,
    @Default('') String username,
    @JsonKey(fromJson: stringFromJson) @Default('') String uid,
    @JsonKey(fromJson: intFromJson) @Default(0) int likenum,
    @JsonKey(fromJson: intFromJson) @Default(0) int replynum,
    @JsonKey(name: 'dateline_text') @Default('') String datelineText,
    @JsonKey(name: 'device_title') @Default('') String deviceTitle,
    @JsonKey(fromJson: hashTagsFromJson) @Default('') String tags,
    @JsonKey(fromJson: stringListFromJson)
    @Default(<String>[])
    List<String> picArr,
    @Default('') String shareUrl,
  }) = _CoolapkFeedDetailDto;

  /// 服务器条目 → DTO。
  factory CoolapkFeedDetailDto.fromJson(Map<String, dynamic> json) =>
      _$CoolapkFeedDetailDtoFromJson(json);

  /// DTO → 实体，字段一对一搬运。
  CoolapkFeedDetail toEntity() => CoolapkFeedDetail(
    id: id,
    title: title,
    message: message,
    username: username,
    uid: uid,
    likenum: likenum,
    replynum: replynum,
    datelineText: datelineText,
    deviceTitle: deviceTitle,
    tags: tags,
    picArr: picArr,
    shareUrl: shareUrl,
  );
}
