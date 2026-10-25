import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 移动端设置内容。当前只有语言切换，其余设置项等待业务接入。
///
/// 标题栏与底栏由 [MainPage] 提供，这里不要自带 Scaffold。
class SettingTab extends ConsumerWidget {
  const SettingTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Locale locale = ref.watch(localeProvider);

    return ListView(
      // 底部留白，避免最后一项被悬浮底栏遮住。
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
      children: [
        Text(
          context.l10n.languageTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 8.h),
        SegmentedButton<String>(
          segments: [
            ButtonSegment(
              value: 'zh',
              label: Text(context.l10n.languageChinese),
            ),
            ButtonSegment(
              value: 'en',
              label: Text(context.l10n.languageEnglish),
            ),
          ],
          selected: {locale.languageCode},
          onSelectionChanged: (selection) =>
              ref.read(localeProvider.notifier).setLanguage(selection.first),
        ),
      ],
    );
  }
}
