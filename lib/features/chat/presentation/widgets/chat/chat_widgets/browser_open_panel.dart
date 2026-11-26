import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/routes/app_route.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

/// 对话内的网页卡片，由 `open_in_browser` 触发渲染。
///
/// 默认用应用内浏览器打开：验证码、登录墙、下载确认都在真实浏览器会话里，
/// 过完之后用户能把当前页、源码或下好的文件直接交回对话。
/// 桌面端没有 WebView，退回系统浏览器。
class BrowserOpenPanel extends HookWidget {
  const BrowserOpenPanel({super.key, required this.url, required this.reason});

  /// 待打开的绝对 URL，已在工具侧校验过协议。
  final String url;

  /// 为什么值得打开这一页；空串时不占位。
  final String reason;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDesktopPlatform;
    final ColorScheme colors = context.colorScheme;
    final AppLocalizations l10n = context.l10n;
    // 点过之后按钮换成「再次打开」，避免用户以为没生效。
    final ValueNotifier<bool> opened = useState<bool>(false);

    final Uri? uri = Uri.tryParse(url);
    final String host = uri?.host ?? '';

    Future<void> open() async {
      if (isDesktop) {
        if (uri == null) return;
        final bool ok = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!context.mounted) return;
        if (ok) {
          opened.value = true;
          return;
        }
        ToastMessage.error(l10n.chatBrowserOpenFailed);
        return;
      }

      opened.value = true;
      context.push(AppRoute.browserPath(url));
    }

    Future<void> copy() async {
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
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(isDesktop ? 10 : 10.r),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.public_rounded,
                size: isDesktop ? 15 : 15.sp,
                color: colors.onSurfaceVariant,
              ),
              SizedBox(width: isDesktop ? 6 : 6.w),
              Expanded(
                child: Text(
                  host.isEmpty ? l10n.chatBrowserPanelTitle : host,
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
          SizedBox(height: isDesktop ? 6 : 6.h),
          SelectableText(
            url,
            maxLines: 2,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: isDesktop ? 11.5 : 11.5.sp,
              height: 1.4,
              color: colors.onSurface.withValues(alpha: 0.82),
            ),
          ),
          if (reason.isNotEmpty) ...<Widget>[
            SizedBox(height: isDesktop ? 6 : 6.h),
            Text(
              reason,
              style: TextStyle(
                fontSize: isDesktop ? 11.5 : 11.5.sp,
                height: 1.45,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
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
                          : (isDesktop
                                ? l10n.chatBrowserOpen
                                : l10n.chatBrowserOpenInApp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isDesktop ? 12.5 : 12.5.sp,
                        fontWeight: FontWeight.w600,
                      ),
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
                    foregroundColor: colors.onSurfaceVariant,
                    side: BorderSide(
                      color: colors.outlineVariant.withValues(alpha: 0.8),
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
