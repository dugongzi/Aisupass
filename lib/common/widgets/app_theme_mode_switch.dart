import 'package:Aisupass/common/widgets/app_select.dart';
import 'package:Aisupass/common/widgets/app_setting_icon.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/providers/theme_provider.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 主题模式设置项：跟随系统 / 浅色 / 深色。
///
/// 移动端三个选项一行放不下，标题与分段控件分两行；
/// 桌面端空间充足，改成「标题 + 下拉框」的单行布局。
class AppThemeModeSwitch extends HookConsumerWidget {
  const AppThemeModeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode mode = ref.watch(themeSettingsProvider).themeMode;

    if (isDesktopPlatform) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: <Widget>[
            _buildTitle(context),
            SizedBox(width: 8.w),
            AppSelect<ThemeMode>(
              value: mode,
              items: <AppSelectItem<ThemeMode>>[
                AppSelectItem<ThemeMode>(
                  value: ThemeMode.system,
                  label: context.l10n.themeModeSystem,
                ),
                AppSelectItem<ThemeMode>(
                  value: ThemeMode.light,
                  label: context.l10n.themeModeLight,
                ),
                AppSelectItem<ThemeMode>(
                  value: ThemeMode.dark,
                  label: context.l10n.themeModeDark,
                ),
              ],
              onChanged: (ThemeMode value) =>
                  ref.read(themeSettingsProvider.notifier).setThemeMode(value),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: <Widget>[_buildTitle(context)]),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<ThemeMode>(
              segments: <ButtonSegment<ThemeMode>>[
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.system,
                  label: Text(context.l10n.themeModeSystem),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.light,
                  label: Text(context.l10n.themeModeLight),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.dark,
                  label: Text(context.l10n.themeModeDark),
                ),
              ],
              selected: <ThemeMode>{mode},
              showSelectedIcon: false,
              style: SegmentedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                textStyle: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onSelectionChanged: (Set<ThemeMode> selection) => ref
                  .read(themeSettingsProvider.notifier)
                  .setThemeMode(selection.first),
            ),
          ),
        ],
      ),
    );
  }

  /// 图标胶囊 + 标题，占满剩余宽度，右侧留给控件。
  Widget _buildTitle(BuildContext context) {
    return Expanded(
      child: Row(
        children: <Widget>[
          const AppSettingIcon(icon: Icons.contrast_rounded),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              context.l10n.themeModeTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.titleSmall?.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
