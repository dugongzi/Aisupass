import 'dart:convert';

import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/app_colors.dart';
import 'package:Aisupass/core/utils/coolapk_link.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/chat/domain/enums/chat_tool_status.dart';
import 'package:Aisupass/features/chat/domain/models/chat_tool_call.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 酷安评论卡片：评论列表第一页就是空的时候挂出。
///
/// 只说「没有评论」这一事实，不给「找不到下载链接」之类的结论：
/// 正文有没有链接由模型读结果决定，不该由「评论为空」倒推。
class CoolapkPostPanel extends HookWidget {
  const CoolapkPostPanel({
    super.key,
    required this.feedId,
    required this.heading,
    required this.hint,
    this.title = '',
    this.summary = '',
  });

  /// 动态 id，用于跳转酷安。
  final String feedId;

  /// 卡片标题，由调用方按工具决定。
  final String heading;

  /// 卡片说明。
  final String hint;

  /// 帖子标题；模型从搜索结果带过来，可为空。
  final String title;

  /// 帖子正文摘要，可为空。
  final String summary;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDesktopPlatform;
    final ColorScheme colors = context.colorScheme;
    final AppLocalizations l10n = context.l10n;
    final ValueNotifier<bool> opened = useState<bool>(false);

    Future<void> open() async {
      final bool ok = await CoolapkLink.openFeed(feedId);
      if (!context.mounted) return;
      if (ok) {
        opened.value = true;
        return;
      }
      await Clipboard.setData(ClipboardData(text: CoolapkLink.web(feedId)));
      if (!context.mounted) return;
      ToastMessage.error(l10n.chatCoolapkOpenFailed);
    }

    Future<void> copy() async {
      await Clipboard.setData(ClipboardData(text: CoolapkLink.web(feedId)));
      if (!context.mounted) return;
      ToastMessage.success(l10n.chatBrowserLinkCopied);
    }

    return Container(
      margin: EdgeInsets.only(
        left: isDesktop ? 8 : 8.w,
        bottom: isDesktop ? 8 : 8.h,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 12 : 12.w,
        vertical: isDesktop ? 10 : 10.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.coolapk.withValues(
          alpha: context.isDark ? 0.14 : 0.07,
        ),
        borderRadius: BorderRadius.circular(isDesktop ? 10 : 10.r),
        border: Border.all(color: AppColors.coolapk.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.forum_rounded,
                size: isDesktop ? 15 : 15.sp,
                color: AppColors.coolapk,
              ),
              SizedBox(width: isDesktop ? 6 : 6.w),
              Expanded(
                child: Text(
                  heading,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isDesktop ? 12 : 12.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          if (title.trim().isNotEmpty) ...<Widget>[
            SizedBox(height: isDesktop ? 8 : 8.h),
            Text(
              title.trim(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isDesktop ? 13 : 13.sp,
                height: 1.35,
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
            ),
          ],
          if (summary.trim().isNotEmpty) ...<Widget>[
            SizedBox(height: isDesktop ? 4 : 4.h),
            Text(
              summary.trim(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isDesktop ? 11.5 : 11.5.sp,
                height: 1.45,
                color: colors.onSurface.withValues(alpha: 0.78),
              ),
            ),
          ],
          SizedBox(height: isDesktop ? 6 : 6.h),
          Text(
            hint,
            style: TextStyle(
              fontSize: isDesktop ? 11.5 : 11.5.sp,
              height: 1.45,
              color: colors.onSurfaceVariant,
            ),
          ),
          SizedBox(height: isDesktop ? 10 : 10.h),
          Row(
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  height: isDesktop ? 36 : 36.h,
                  child: FilledButton.icon(
                    onPressed: open,
                    icon: Icon(
                      Icons.open_in_new_rounded,
                      size: isDesktop ? 15 : 15.sp,
                    ),
                    label: Text(
                      opened.value
                          ? l10n.chatBrowserOpenAgain
                          : l10n.chatCoolapkOpenPost,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isDesktop ? 12.5 : 12.5.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.coolapk,
                      foregroundColor: AppColors.onCoolapk,
                    ),
                  ),
                ),
              ),
              SizedBox(width: isDesktop ? 8 : 8.w),
              SizedBox(
                height: isDesktop ? 36 : 36.h,
                child: OutlinedButton.icon(
                  onPressed: copy,
                  icon: Icon(Icons.copy_rounded, size: isDesktop ? 14 : 14.sp),
                  label: Text(
                    l10n.chatBrowserCopyLink,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: isDesktop ? 12 : 12.sp),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.coolapk,
                    side: BorderSide(
                      color: AppColors.coolapk.withValues(alpha: 0.5),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        isDesktop ? 10 : 10.r,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 仅在「评论接口第一页返回空」时挂卡片，其余情况返回 null。
///
/// 判据要求结果里带 `feedId`：这是评论接口的返回特征，
/// 搜索与正文的结果没有这个字段，不会被误判成「没有评论」。
/// 第二页为空属于正常翻到底，不提示。
Widget? coolapkEmptyCommentsPanelFor({
  required ChatToolCall call,
  required String heading,
  required String hint,
}) {
  if (call.status != ChatToolStatus.succeeded) return null;

  final Map<String, dynamic> arguments = _decode(call.argumentsJson);
  final Map<String, dynamic> result = _decode(call.result);

  final String feedId = (result['feedId'] ?? '').toString().trim();
  if (feedId.isEmpty) return null;

  final int page = _asInt(result['page']) ?? 1;
  final int total = _asInt(result['total']) ?? 0;
  if (page > 1 || total > 0) return null;

  return CoolapkPostPanel(
    feedId: feedId,
    heading: heading,
    hint: hint,
    title: _firstNonEmpty(result['title'], arguments['title']),
    summary: _firstNonEmpty(result['summary'], arguments['summary']),
  );
}

/// 依次取第一个非空字符串；工具结果与入参任一处有值即可。
String _firstNonEmpty(Object? primary, Object? fallback) {
  final String first = (primary ?? '').toString().trim();
  if (first.isNotEmpty) return first;
  return (fallback ?? '').toString().trim();
}

/// 工具参数与结果都是 JSON 文本，非法或为空时按空对象处理。
Map<String, dynamic> _decode(String raw) {
  final String text = raw.trim();
  if (text.isEmpty) return const <String, dynamic>{};
  try {
    final Object? decoded = jsonDecode(text);
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
  } on FormatException {
    return const <String, dynamic>{};
  }
  return const <String, dynamic>{};
}

/// 宽松取整，取不到返回 null。
int? _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value.trim());
  return null;
}
