import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

/// AI 设置。当前为占位页，等待业务内容接入。
class AiSettingPage extends StatelessWidget {
  const AiSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(context.l10n.aiSettingTitle)));
  }
}
