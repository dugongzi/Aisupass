import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/core/utils/html_text.dart';
import 'package:Aisupass/core/utils/json_value.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_search_result.dart';

part 'coolapk_search_result_dto.freezed.dart';
part 'coolapk_search_result_dto.g.dart';

/// `/v6/search` 单条命中，字段名与服务器返回一致。
///
/// 只做格式化：正文转纯文本、标签去 `#`、配图过滤空值、数值宽松转 int，
/// 全部由 core 层的 `@JsonKey(fromJson:)` 适配器完成，因此
/// [fromJson] 保持一行生成代码，[toEntity] 保持一对一搬运。
@freezed
abstract class CoolapkSearchResultDto with _$CoolapkSearchResultDto {
  const CoolapkSearchResultDto._();

  const factory CoolapkSearchResultDto({
    @Default('') String entityType,
    @Default('') String id,
    @Default('') String title,
    @JsonKey(fromJson: plainTextFromJson) @Default('') String message,
    @Default('') String username,
    @Default('') String uid,
    @Default('') String url,
    @Default('') String shareUrl,
    @JsonKey(fromJson: intFromJson) @Default(0) int likenum,
    @JsonKey(fromJson: intFromJson) @Default(0) int replynum,
    @JsonKey(name: 'dateline_text') @Default('') String datelineText,
    @JsonKey(name: 'device_title') @Default('') String deviceTitle,
    @JsonKey(fromJson: hashTagsFromJson) @Default('') String tags,
    @JsonKey(fromJson: stringListFromJson)
    @Default(<String>[])
    List<String> picArr,
    @JsonKey(name: '_queryTotal', fromJson: intFromJson)
    @Default(0)
    int queryTotal,
  }) = _CoolapkSearchResultDto;

  /// 服务器条目 → DTO。
  factory CoolapkSearchResultDto.fromJson(Map<String, dynamic> json) =>
      _$CoolapkSearchResultDtoFromJson(json);

  /// DTO → 实体，字段一对一搬运。
  CoolapkSearchResult toEntity() => CoolapkSearchResult(
    entityType: entityType,
    id: id,
    title: title,
    message: message,
    username: username,
    uid: uid,
    url: url,
    shareUrl: shareUrl,
    likenum: likenum,
    replynum: replynum,
    datelineText: datelineText,
    deviceTitle: deviceTitle,
    tags: tags,
    picArr: picArr,
  );
}
