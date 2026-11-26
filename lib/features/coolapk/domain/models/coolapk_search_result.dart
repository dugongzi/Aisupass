import 'package:freezed_annotation/freezed_annotation.dart';

part 'coolapk_search_result.freezed.dart';

/// 一条酷安搜索结果，字段与 `/v6/search` 返回一一对应。
@freezed
abstract class CoolapkSearchResult with _$CoolapkSearchResult {
  const CoolapkSearchResult._();

  const factory CoolapkSearchResult({
    /// 条目类型，服务器取值如 `feed` / `user` / `feedTopic`。
    required String entityType,

    /// 条目 id，用户条目为 uid。
    required String id,

    /// 标题，用户条目为昵称，话题为话题名。
    required String title,

    /// 正文，DTO 已去掉 HTML 标签与转义。
    required String message,

    /// 作者昵称。
    required String username,

    /// 作者 uid。
    required String uid,

    /// 网页地址，部分类型才有。
    required String url,

    /// 分享地址，动态才有。
    required String shareUrl,

    /// 点赞数。
    required int likenum,

    /// 回复数。
    required int replynum,

    /// 相对时间文案，如「3小时前」。
    required String datelineText,

    /// 发帖机型。
    required String deviceTitle,

    /// 标签，DTO 已去掉 `#`。
    required String tags,

    /// 配图地址。
    required List<String> picArr,
  }) = _CoolapkSearchResult;
}
