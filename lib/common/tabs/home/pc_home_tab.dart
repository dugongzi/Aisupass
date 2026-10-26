import 'package:Aisupass/common/widgets/app_ai_activation_card.dart';
import 'package:Aisupass/common/widgets/app_device_info_card.dart';
import 'package:Aisupass/common/widgets/app_system_status_cards.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_config_query_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 桌面端首页内容。
///
/// 桌面端用仪表盘式排布：状态卡片保持固定宽度、从左上角铺开，
/// 信息卡片单独占一列，不照搬移动端「居中大标题 + 通栏卡片」的纵向堆叠。
/// 品牌名已由左侧导航栏承担，这里不再重复。
///
/// 标题栏与左侧导航由 `DesktopPage` 提供，这里不要自带 Scaffold。
/// AI 激活状态来自当前配置的真实连通性检测。
class PcHomeTab extends HookConsumerWidget {
  const PcHomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<bool> aiStatusAsync = ref.watch(aiStatusProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(28, 6, 28, 28),
      children: <Widget>[
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: <Widget>[
            SizedBox(
              width: 360,
              child: AppAiActivationCard(
                isActivated: aiStatusAsync.value ?? false,
                isLoading: !aiStatusAsync.hasValue,
              ),
            ),
            const SizedBox(width: 360, child: AppSystemStatusCards()),
          ],
        ),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 480),
          child: AppDeviceInfoCard(),
        ),
      ],
    );
  }
}
