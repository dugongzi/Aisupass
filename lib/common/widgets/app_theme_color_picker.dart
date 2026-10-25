import 'package:Aisupass/common/widgets/app_setting_icon.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/providers/theme_provider.dart';
import 'package:Aisupass/core/themes/app_colors.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 主题色设置项：标题 + 一行色点。
///
/// 移动端色点均分整行，桌面端收成紧凑的一组靠右排列。
class AppThemeColorPicker extends HookConsumerWidget {
  const AppThemeColorPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color selected = ref.watch(themeSettingsProvider).seedColor;
    final bool isDesktop = isDesktopPlatform;

    List<Widget> buildDots(double size, double gap) => <Widget>[
      for (final Color color in AppColors.themeSeeds)
        Padding(
          padding: EdgeInsets.only(right: gap),
          child: _ColorDot(
            color: color,
            size: size,
            selected: color.toARGB32() == selected.toARGB32(),
            onTap: () =>
                ref.read(themeSettingsProvider.notifier).setSeedColor(color),
          ),
        ),
    ];

    if (isDesktop) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: <Widget>[
            Expanded(child: _buildTitle(context)),
            ...buildDots(24, 10),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTitle(context),
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: buildDots(32.w, 0),
          ),
        ],
      ),
    );
  }

  /// 图标胶囊 + 标题。
  Widget _buildTitle(BuildContext context) {
    return Row(
      children: <Widget>[
        const AppSettingIcon(icon: Icons.palette_rounded),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            context.l10n.themeColorTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.titleSmall?.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _ColorDot extends HookWidget {
  const _ColorDot({
    required this.color,
    required this.size,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final double size;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // 浅色主题色上用深色勾，深色主题色上用白勾。
    final Color checkColor =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? Colors.white
        : Colors.black87;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected
                ? context.colorScheme.onSurface.withValues(alpha: 0.72)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: color.withValues(alpha: 0.32),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: selected
            ? Icon(
                Icons.check_rounded,
                size: size * 0.55,
                color: checkColor,
              )
            : null,
      ),
    );
  }
}
