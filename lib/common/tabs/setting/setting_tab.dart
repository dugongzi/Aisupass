import 'package:Aisupass/common/widgets/app_language_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 移动端设置内容。当前只有语言切换，其余设置项等待业务接入。
///
/// 标题栏与底栏由 `MainPage` 提供，这里不要自带 Scaffold。
class SettingTab extends HookConsumerWidget {
  const SettingTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      // 底部留白，避免最后一项被悬浮底栏遮住。
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
      children: const <Widget>[AppLanguageSwitch()],
    );
  }
}
