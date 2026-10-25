import 'package:Aisupass/common/widgets/app_ai_activation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// 桌面端首页内容。
///
/// 桌面端用仪表盘式的卡片网格：卡片保持固定宽度、从左上角排布，
/// 不照搬移动端「居中大标题 + 通栏卡片」的纵向堆叠。
/// 品牌名已由左侧导航栏承担，这里不再重复。
///
/// 标题栏与左侧导航由 `DesktopPage` 提供，这里不要自带 Scaffold。
/// AI 配置功能尚未接入，激活状态暂时固定为已激活。
class PcHomeTab extends HookWidget {
  const PcHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.fromLTRB(28, 6, 28, 28),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 360,
        mainAxisExtent: 96,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      children: const <Widget>[AppAiActivationCard(isActivated: true)],
    );
  }
}
