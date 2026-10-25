import 'package:Aisupass/common/widgets/app_language_switch.dart';
import 'package:Aisupass/common/widgets/app_settings_section.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 移动端设置内容。当前只有语言切换，其余设置项等待业务接入。
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
          title: context.l10n.settingsGeneralSection,
          children: const <Widget>[AppLanguageSwitch()],
        ),
      ],
    );
  }
}
