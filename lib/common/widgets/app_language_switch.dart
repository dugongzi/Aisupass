import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 语言切换项，供移动端与桌面端设置页共用。
class AppLanguageSwitch extends HookConsumerWidget {
  const AppLanguageSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Locale locale = ref.watch(localeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(context.l10n.languageTitle, style: context.textTheme.titleMedium),
        SizedBox(height: 8.h),
        SegmentedButton<String>(
          segments: <ButtonSegment<String>>[
            ButtonSegment<String>(
              value: 'zh',
              label: Text(context.l10n.languageChinese),
            ),
            ButtonSegment<String>(
              value: 'en',
              label: Text(context.l10n.languageEnglish),
            ),
          ],
          selected: <String>{locale.languageCode},
          onSelectionChanged: (Set<String> selection) =>
              ref.read(localeProvider.notifier).setLanguage(selection.first),
        ),
      ],
    );
  }
}
