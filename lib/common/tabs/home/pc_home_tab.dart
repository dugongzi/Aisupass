import 'package:Aisupass/common/widgets/app_ai_activation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// 桌面端首页内容。
///
/// 内容区限宽居中，与设置页保持一致的阅读宽度；
/// 标题栏与左侧导航由 `DesktopPage` 提供，这里不要自带 Scaffold。
/// AI 配置功能尚未接入，激活状态暂时固定为未激活。
class PcHomeTab extends HookWidget {
  const PcHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(28, 6, 28, 28),
          children: const <Widget>[AppAiActivationCard(isActivated: true)],
        ),
      ),
    );
  }
}
