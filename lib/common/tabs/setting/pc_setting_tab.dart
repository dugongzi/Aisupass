import 'package:Aisupass/common/widgets/app_language_switch.dart';
import 'package:Aisupass/common/widgets/app_settings_section.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 桌面端设置内容。当前只有语言切换，其余设置项等待业务接入。
///
/// 标题栏与左侧导航由 `DesktopPage` 提供，这里不要自带 Scaffold。
class PcSettingTab extends HookWidget {
  const PcSettingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20.w),
      children: <Widget>[
        AppSettingsSection(
          title: context.l10n.settingsGeneralSection,
          children: const <Widget>[AppLanguageSwitch()],
        ),
      ],
    );
  }
}
