import 'package:Aisupass/common/widgets/app_language_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 桌面端设置内容。当前只有语言切换，其余设置项等待业务接入。
///
/// 标题栏与左侧导航由 `DesktopPage` 提供，这里不要自带 Scaffold。
class PcSettingTab extends HookConsumerWidget {
  const PcSettingTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: const <Widget>[AppLanguageSwitch()],
    );
  }
}
