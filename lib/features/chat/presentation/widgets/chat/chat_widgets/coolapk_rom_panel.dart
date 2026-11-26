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

/// 模型找到的下载地址。
class CoolapkDownloadOffer {
  const CoolapkDownloadOffer({
    required this.feedId,
    required this.urls,
    required this.note,
  });

  /// 来源帖子 id。
  final String feedId;

  /// 下载地址列表，至少一条。
  final List<String> urls;

  /// 模型给出的补充说明，可为空。
  final String note;
}

/// 酷安下载卡片：列出模型从帖子或评论里找到的地址。
///
/// 地址由模型判断并传入，本组件只负责呈现与交给系统打开，
/// 不在本地做任何链接识别。
class CoolapkDownloadPanel extends HookWidget {
  const CoolapkDownloadPanel({super.key, required this.offer});

  final CoolapkDownloadOffer offer;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDesktopPlatform;
    final ColorScheme colors = context.colorScheme;
    final AppLocalizations l10n = context.l10n;

    // 网盘与直链都要交给系统处理，应用内 WebView 接不住下载会话。
    Future<void> open(String url) async {
      final bool ok = await CoolapkLink.openUrl(url);
      if (!context.mounted) return;
      if (ok) return;
      await Clipboard.setData(ClipboardData(text: url));
      if (!context.mounted) return;
      ToastMessage.error(l10n.chatCoolapkDownloadFailed);
    }

    Future<void> openPost() async {
      final bool ok = await CoolapkLink.openFeed(offer.feedId);
      if (!context.mounted) return;
      if (ok) return;
      await Clipboard.setData(
        ClipboardData(text: CoolapkLink.web(offer.feedId)),
      );
      if (!context.mounted) return;
      ToastMessage.error(l10n.chatCoolapkOpenFailed);
    }

    Future<void> copy(String url) async {
      await Clipboard.setData(ClipboardData(text: url));
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
                Icons.download_rounded,
                size: isDesktop ? 15 : 15.sp,
                color: AppColors.coolapk,
              ),
              SizedBox(width: isDesktop ? 6 : 6.w),
              Expanded(
                child: Text(
                  l10n.chatCoolapkRomFound(offer.urls.length),
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
          if (offer.note.isNotEmpty) ...<Widget>[
            SizedBox(height: isDesktop ? 6 : 6.h),
            Text(
              offer.note,
              style: TextStyle(
                fontSize: isDesktop ? 11.5 : 11.5.sp,
                height: 1.45,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
          SizedBox(height: isDesktop ? 8 : 8.h),
          for (final String url in offer.urls)
            _LinkRow(
              url: url,
              onOpen: () => open(url),
              onCopy: () => copy(url),
            ),
          SizedBox(height: isDesktop ? 10 : 10.h),
          // 只有一个「打开原帖」按钮：地址可能有多个，绑在第一个上的
          // 下载按钮会误导用户以为只有一条可选，点上面的链接行更直接。
          SizedBox(
            height: isDesktop ? 36 : 36.h,
            child: OutlinedButton.icon(
              onPressed: openPost,
              icon: Icon(Icons.forum_outlined, size: isDesktop ? 14 : 14.sp),
              label: Text(
                l10n.chatCoolapkOpenPost,
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
                  borderRadius: BorderRadius.circular(isDesktop ? 10 : 10.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 单条地址：等宽显示，点击直接交给系统打开，右侧可复制。
class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.url,
    required this.onOpen,
    required this.onCopy,
  });

  final String url;
  final VoidCallback onOpen;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDesktopPlatform;
    final ColorScheme colors = context.colorScheme;

    return InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(isDesktop ? 6 : 6.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: isDesktop ? 4 : 4.h),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                url,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: isDesktop ? 11.5 : 11.5.sp,
                  height: 1.4,
                  color: AppColors.coolapk,
                ),
              ),
            ),
            IconButton(
              onPressed: onCopy,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 24, height: 24),
              iconSize: isDesktop ? 14 : 14.sp,
              color: colors.onSurfaceVariant.withValues(alpha: 0.7),
              icon: const Icon(Icons.copy_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

/// 从 `coolapk_offer_download` 的调用参数里读出下载信息；不完整时返回 null。
///
/// 参数是模型流式拼出来的 JSON，非法或缺少地址时不渲染卡片。
CoolapkDownloadOffer? coolapkDownloadOfferOf(ChatToolCall call) {
  if (call.status != ChatToolStatus.succeeded) return null;
  final Map<String, dynamic> arguments = _decode(call.argumentsJson);

  final String feedId = (arguments['feedId'] ?? '').toString().trim();
  if (feedId.isEmpty) return null;

  final Object? raw = arguments['urls'];
  final List<String> urls = <String>[
    if (raw is List)
      for (final Object? item in raw)
        if (item is String && item.trim().isNotEmpty) item.trim(),
  ];
  if (urls.isEmpty) return null;

  return CoolapkDownloadOffer(
    feedId: feedId,
    urls: urls,
    note: (arguments['note'] ?? '').toString().trim(),
  );
}

/// 解析 JSON 文本，非法或为空时返回空对象。
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
