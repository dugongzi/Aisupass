import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 通用状态卡片：图标 + 标题 + 状态文案。
///
/// 与 AI 激活卡片同尺寸节奏，但激活态只用主题色描边和淡底，
/// 不与 AI 卡片的专属渐变抢视觉重心。
class AppStatusCard extends HookWidget {
  const AppStatusCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isActivated,
    this.isLoading = false,
  });

  final String title;

  /// 状态文案，如「已激活」「已激活（无线、有线）」。
  final String subtitle;

  final IconData icon;
  final bool isActivated;

  /// 检测中：图标与文案降级为中性，避免闪烁出错误状态。
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final bool isDark = context.isDark;
    final bool highlight = isActivated && !isLoading;

    return Container(
      constraints: BoxConstraints(minHeight: 76.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: highlight
            ? colorScheme.primary.withValues(alpha: isDark ? 0.14 : 0.08)
            : colorScheme.onSurface.withValues(alpha: isDark ? 0.06 : 0.04),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: highlight
              ? colorScheme.primary.withValues(alpha: 0.45)
              : colorScheme.outline.withValues(alpha: isDark ? 0.24 : 0.12),
        ),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 26.sp,
            color: highlight
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant.withValues(alpha: 0.62),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    color: colorScheme.onSurface.withValues(alpha: 0.90),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                    color: highlight
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.56),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
