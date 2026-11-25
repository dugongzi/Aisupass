import 'package:Aisupass/common/tabs/setting/about_setting_section.dart';
import 'package:Aisupass/common/tabs/setting/feature_wish_setting_row.dart';
import 'package:Aisupass/common/tabs/setting/follow_author_setting_section.dart';
import 'package:Aisupass/common/widgets/app_adb_pairing_mode_switch.dart';
import 'package:Aisupass/common/widgets/app_command_channel_switch.dart';
import 'package:Aisupass/common/widgets/app_language_switch.dart';
import 'package:Aisupass/common/widgets/app_settings_section.dart';
import 'package:Aisupass/common/widgets/app_theme_color_picker.dart';
import 'package:Aisupass/common/widgets/app_theme_mode_switch.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_config_entry.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/dirty_frag_boot_switch.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ghost_key_setting_section.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/kernel_profile_setting_row.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/run_log_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 移动端设置内容。
///
/// 标题栏与底栏由 `MainPage` 提供，这里不要自带 Scaffold。
class SettingTab extends HookWidget {
  const SettingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      // 底部留白，避免最后一项被悬浮底栏遮住。
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 100.h),
      children: <Widget>[
        AppSettingsSection(
          title: context.l10n.settingsAiSection,
          children: const <Widget>[AiConfigEntry()],
        ),
        SizedBox(height: 20.h),
        AppSettingsSection(
          title: context.l10n.settingsGeneralSection,
          children: <Widget>[
            AppLanguageSwitch(),
            Divider(height: 1, indent: 62.w, endIndent: 16.w),
            const AppCommandChannelSwitch(),
            Divider(height: 1, indent: 62.w, endIndent: 16.w),
            const AppAdbPairingModeSwitch(),
            Divider(height: 1, indent: 62.w, endIndent: 16.w),
            FeatureWishSettingRow(),
          ],
        ),
        SizedBox(height: 20.h),
        AppSettingsSection(
          title: context.l10n.settingsFollowAuthorSection,
          children: const <Widget>[FollowAuthorSettingSection()],
        ),
        SizedBox(height: 20.h),
        AppSettingsSection(
          title: context.l10n.settingsBootAutostartSection,
          children: <Widget>[
            const DirtyFragBootSwitch(),
            Divider(height: 1, indent: 62.w, endIndent: 16.w),
            const KernelProfileSettingRow(),
            Divider(height: 1, indent: 62.w, endIndent: 16.w),
            const RunLogEntry(),
          ],
        ),
        SizedBox(height: 20.h),
        AppSettingsSection(
          title: context.l10n.settingsGhostKeySection,
          children: const <Widget>[GhostKeySettingSection()],
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
        SizedBox(height: 20.h),
        AppSettingsSection(
          title: context.l10n.settingsAboutSection,
          children: const <Widget>[AboutSettingSection()],
        ),
      ],
    );
  }
}
