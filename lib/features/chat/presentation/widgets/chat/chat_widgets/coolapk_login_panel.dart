import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/routes/app_route.dart';
import 'package:Aisupass/core/themes/app_colors.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/chat/domain/enums/chat_tool_status.dart';
import 'package:Aisupass/features/chat/domain/models/chat_tool_call.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_auth_state.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// 酷安登录提示卡片。
///
/// 出现时机：某个酷安工具因为未登录被服务端拦下，数据源把它升级成
/// [CoolapkAuthRequiredException]，工具随之失败。<br>
/// 风控验证码走 `CoolapkRiskPanel`，两者不要混用。
/// 这里给用户一个直接入口，而不是让他自己找设置。
class CoolapkLoginPanel extends StatelessWidget {
  const CoolapkLoginPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDesktopPlatform;
    final ColorScheme colors = context.colorScheme;
    final AppLocalizations l10n = context.l10n;

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
                Icons.lock_outline_rounded,
                size: isDesktop ? 15 : 15.sp,
                color: AppColors.coolapk,
              ),
              SizedBox(width: isDesktop ? 6 : 6.w),
              Expanded(
                child: Text(
                  l10n.chatCoolapkLoginRequiredTitle,
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
          Text(
            l10n.chatCoolapkLoginRequiredHint,
            style: TextStyle(
              fontSize: isDesktop ? 11.5 : 11.5.sp,
              height: 1.45,
              color: colors.onSurfaceVariant,
            ),
          ),
          SizedBox(height: isDesktop ? 10 : 10.h),
          SizedBox(
            height: isDesktop ? 36 : 36.h,
            child: FilledButton.icon(
              // 桌面端没有 WebView，抓不到登录会话，只能去 Android 上登录。
              onPressed: isDesktop
                  ? null
                  : () => context.push(AppRoute.coolapkLogin),
              icon: Icon(Icons.login_rounded, size: isDesktop ? 15 : 15.sp),
              label: Text(
                l10n.chatCoolapkLoginAction,
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
                disabledBackgroundColor: AppColors.coolapk.withValues(
                  alpha: 0.4,
                ),
                disabledForegroundColor: AppColors.onCoolapk.withValues(
                  alpha: 0.7,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 判断这次工具失败是不是「未登录」，是则返回待渲染的登录卡片。
Widget? coolapkLoginPanelFor(ChatToolCall call) {
  if (call.status != ChatToolStatus.failed) return null;
  if (!call.error.contains(CoolapkAuthRequiredException.marker)) return null;
  return const CoolapkLoginPanel();
}
