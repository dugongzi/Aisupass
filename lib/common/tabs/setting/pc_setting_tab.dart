import 'package:Aisupass/common/widgets/app_language_switch.dart';
import 'package:Aisupass/common/widgets/app_settings_section.dart';
import 'package:Aisupass/common/widgets/app_theme_color_picker.dart';
import 'package:Aisupass/common/widgets/app_theme_mode_switch.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 桌面端设置内容。当前只有通用与外观两组，其余设置项等待业务接入。
///
/// 内容区限宽并居中，避免宽屏下设置行被拉成整屏宽；
/// 标题栏与左侧导航由 `DesktopPage` 提供，这里不要自带 Scaffold。
class PcSettingTab extends HookWidget {
  const PcSettingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(28, 6, 28, 28),
          children: <Widget>[
            AppSettingsSection(
              title: context.l10n.settingsGeneralSection,
              children: const <Widget>[AppLanguageSwitch()],
            ),
            SizedBox(height: 20.h),
            AppSettingsSection(
              title: context.l10n.settingsAppearanceSection,
              children: <Widget>[
                const AppThemeModeSwitch(),
                Divider(height: 1, indent: 62.w, endIndent: 16.w),
                const AppThemeColorPicker(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
