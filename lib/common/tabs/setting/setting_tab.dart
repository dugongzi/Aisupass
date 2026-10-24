import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 移动端设置。当前只有语言切换，其余设置项等待业务内容接入。
class SettingTab extends ConsumerWidget {
  const SettingTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Locale locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            context.l10n.languageTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
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
      ),
    );
  }
}
