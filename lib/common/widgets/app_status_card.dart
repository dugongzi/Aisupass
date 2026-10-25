import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 通用状态卡片：图标 + 标题 + 状态文案，右侧可选刷新按钮。
///
/// 激活态铺主题表面色（日间白、夜间深灰）并加主题色描边，
/// 未激活态退为淡中性底，一眼能分出状态。
class AppStatusCard extends HookWidget {
  const AppStatusCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isActivated,
    this.isLoading = false,
    this.isRefreshing = false,
    this.onRefresh,
  });

  final String title;

  /// 状态文案，如「已激活」「已激活（无线、有线）」。
  final String subtitle;

  final IconData icon;
  final bool isActivated;

  /// 检测中：图标与文案降级为中性，避免闪烁出错误状态。
  final bool isLoading;

  /// 刷新中：保留上一次的结果，只禁用刷新按钮。
  final bool isRefreshing;

  /// 重新检测该项状态；为 null 时不显示刷新按钮。
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final bool isDark = context.isDark;
    final bool highlight = isActivated && !isLoading;

    return Container(
      constraints: BoxConstraints(minHeight: 76.h),
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 6.w, 12.h),
      decoration: BoxDecoration(
        // 激活态直接铺主题表面色：日间纯白、夜间深灰，与 AI 卡片保持一致；
        // 未激活态用极淡的中性底，视觉上退到背景里。
        color: highlight
            ? colorScheme.surface
            : colorScheme.onSurface.withValues(alpha: isDark ? 0.06 : 0.04),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: highlight
              ? colorScheme.primary.withValues(alpha: isDark ? 0.42 : 0.28)
              : colorScheme.outline.withValues(alpha: isDark ? 0.24 : 0.12),
        ),
      ),
      // 透明 Material 承载刷新按钮的水波纹，否则会被卡片底色盖住。
      child: Material(
        type: MaterialType.transparency,
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
            if (onRefresh != null) ...<Widget>[
              SizedBox(width: 6.w),
              _RefreshButton(
                onPressed: isRefreshing ? null : onRefresh,
                color: highlight
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.62),
                tooltip: context.l10n.refreshTooltip,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 卡片右下角的刷新按钮，检测中禁用并降低透明度。
class _RefreshButton extends HookWidget {
  const _RefreshButton({
    required this.onPressed,
    required this.color,
    required this.tooltip,
  });

  final VoidCallback? onPressed;
  final Color color;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(Icons.refresh_rounded, size: 18.sp),
      color: color,
      disabledColor: color.withValues(alpha: 0.32),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      constraints: BoxConstraints.tightFor(width: 32.w, height: 32.w),
    );
  }
}
