import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 底栏单项数据。
class AppBottomBarItem {
  const AppBottomBarItem({
    required this.label,
    required this.outlinedIcon,
    required this.filledIcon,
  });

  final String label;
  final IconData outlinedIcon;
  final IconData filledIcon;
}

/// 移动端悬浮底栏。
///
/// 圆角矩形 + 阴影，左右各留 [12.w] 边距，底部留出安全区，
/// 由根页面通过 `Scaffold.bottomNavigationBar` 挂载。
class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.height = 60,
  });

  final List<AppBottomBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  /// 设计稿高度（逻辑值，内部按 `.h` 缩放）。
  final double height;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      minimum: EdgeInsets.fromLTRB(12.w, 0, 12.w, 10.h),
      child: Material(
        color: colorScheme.surface,
        elevation: 12,
        shadowColor: Colors.black.withValues(alpha: isDark ? 0.50 : 0.20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.r),
          side: BorderSide(
            color: colorScheme.outline.withValues(
              alpha: isDark ? 0.34 : 0.18,
            ),
            width: 1.1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: height.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              children: <Widget>[
                for (int i = 0; i < items.length; i++)
                  Expanded(
                    child: _BottomBarItem(
                      item: items[i],
                      selected: currentIndex == i,
                      onTap: () => onTap(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  const _BottomBarItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AppBottomBarItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color iconColor = selected
        ? colorScheme.primary
        : colorScheme.onSurface.withValues(alpha: 0.50);
    final Color labelColor = selected
        ? colorScheme.primary
        : colorScheme.onSurface.withValues(alpha: 0.44);

    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: onTap,
      child: SizedBox(
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: 42.w,
              height: 30.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: selected
                    ? colorScheme.primary.withValues(
                        alpha: isDark ? 0.16 : 0.10,
                      )
                    : Colors.transparent,
              ),
              child: Icon(
                selected ? item.filledIcon : item.outlinedIcon,
                size: 22.sp,
                color: iconColor,
              ),
            ),
            SizedBox(height: 2.h),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontFamily: AppFonts.primary,
                fontSize: 10.sp,
                color: labelColor,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                height: 1.2,
              ),
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
