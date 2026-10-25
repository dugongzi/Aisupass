import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// AI 配置页的分组卡片：图标 + 标题 + 可选右侧操作 + 内容。
///
/// 视觉与设置页分组保持一致：`surface` 底色、细描边、轻阴影，
/// 桌面端收成小圆角。
class AiSectionCard extends HookWidget {
  const AiSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.trailing,
    this.onHeaderTap,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;
  final Widget? trailing;
  final VoidCallback? onHeaderTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    final bool isDark = context.isDark;
    final double radius = isDesktopPlatform ? 12 : 20.r;

    final Widget header = Row(
      children: <Widget>[
        Icon(icon, size: 18.sp, color: scheme.primary),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: context.textTheme.titleMedium?.color,
            ),
          ),
        ),
        ?trailing,
      ],
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: scheme.outline.withValues(alpha: isDark ? 0.30 : 0.14),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: scheme.shadow.withValues(alpha: isDark ? 0.20 : 0.035),
            blurRadius: isDesktopPlatform ? 10 : 18,
            offset: Offset(0, isDesktopPlatform ? 3 : 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (onHeaderTap == null)
            header
          else
            InkWell(
              onTap: onHeaderTap,
              borderRadius: BorderRadius.circular(10.r),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: header,
              ),
            ),
          SizedBox(height: 12.h),
          ...children,
        ],
      ),
    );
  }
}
