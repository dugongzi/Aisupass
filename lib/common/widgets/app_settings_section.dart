import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 设置页分组卡片：小标题 + 圆角卡片容器。
///
/// 分组内容由 [children] 提供，与底栏共用同一套视觉语言：
/// `surface` 底色 + 细描边 + 轻阴影。
class AppSettingsSection extends HookWidget {
  const AppSettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final bool isDark = context.isDark;
    // 桌面端卡片更收敛：小圆角、轻阴影，避免移动端那种厚重悬浮感。
    final bool isDesktop = isDesktopPlatform;
    final double radius = isDesktop ? 12 : 20.r;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 10.h),
          child: Text(
            title,
            style: context.textTheme.labelSmall?.copyWith(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.72),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: isDark ? 0.30 : 0.14),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDesktop
                      ? (isDark ? 0.18 : 0.03)
                      : (isDark ? 0.22 : 0.04),
                ),
                blurRadius: isDesktop ? 10 : 18,
                offset: Offset(0, isDesktop ? 3 : 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}
