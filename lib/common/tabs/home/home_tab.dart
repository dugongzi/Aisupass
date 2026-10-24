import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

/// 移动端首页。当前为占位页，等待业务内容接入。
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(context.l10n.homeTitle)));
  }
}
