import 'package:freezed_annotation/freezed_annotation.dart';

part 'coolapk_feed_reply.freezed.dart';

/// 一条酷安评论，字段与 `/v6/feed/replyList` 返回一一对应。
///
/// 顶层评论通过 [replyRows] 带上若干楼中楼，超过 [replyRowsCount] 的部分
/// 需要按 [id] 另行翻页。
@freezed
abstract class CoolapkFeedReply with _$CoolapkFeedReply {
  const CoolapkFeedReply._();

  const factory CoolapkFeedReply({
    /// 评论 id，翻楼中楼时作为 `replyId` 传入。
    required String id,

    /// 所属动态 id。
    required String fid,

    /// 评论者 uid。
    required String uid,

    /// 评论者昵称。
    required String username,

    /// 被回复者 uid，顶层评论为空。
    required String ruid,

    /// 被回复者昵称，顶层评论为空。
    required String rusername,

    /// 评论正文，DTO 已去掉 HTML 标签与转义。
    required String message,

    /// 点赞数。
    required int likenum,

    /// 该评论的回复总数（含未展开的楼中楼）。
    required int replynum,

    /// 相对时间文案，如「前天」。
    required String datelineText,

    /// 是否为动态作者本人的评论。
    required bool isFeedAuthor,

    /// 评论者头像地址。
    required String userAvatar,

    /// 已展开的楼中楼，通常只有前几条。
    required List<CoolapkFeedReply> replyRows,

    /// 楼中楼总数；大于 [replyRows] 长度说明还有没展开的。
    required int replyRowsCount,
  }) = _CoolapkFeedReply;
}
