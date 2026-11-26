import 'package:freezed_annotation/freezed_annotation.dart';

part 'coolapk_feed_detail.freezed.dart';

/// 一条酷安动态的完整内容，字段与 `/v6/feed/detail` 返回一一对应。
///
/// 帖子正文里常直接写着网盘下载地址，这是搜索摘录之外的完整版本。
@freezed
abstract class CoolapkFeedDetail with _$CoolapkFeedDetail {
  const CoolapkFeedDetail._();

  const factory CoolapkFeedDetail({
    /// 动态 id。
    required String id,

    /// 标题；普通动态通常只是「某某的动态」。
    required String title,

    /// 正文，DTO 已去掉 HTML 标签与转义。
    required String message,

    /// 作者昵称。
    required String username,

    /// 作者 uid。
    required String uid,

    /// 点赞数。
    required int likenum,

    /// 回复数。
    required int replynum,

    /// 相对时间文案，如「刚刚」。
    required String datelineText,

    /// 发布设备。
    required String deviceTitle,

    /// 话题标签，多个以空格分隔。
    required String tags,

    /// 配图地址。
    required List<String> picArr,

    /// 分享链接。
    required String shareUrl,
  }) = _CoolapkFeedDetail;
}
