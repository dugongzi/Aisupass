import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// 手动提权页。
///
/// 从底栏圆球的快捷面板进入，当前只保留标题，内容待接入。
class ManualEscalationPage extends HookWidget {
  const ManualEscalationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.escalationTitle)),
      body: const SizedBox.shrink(),
    );
  }
}
