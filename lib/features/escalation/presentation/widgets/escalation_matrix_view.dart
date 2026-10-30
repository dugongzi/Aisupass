import 'package:Aisupass/common/widgets/app_settings_section.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_chain.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_capability.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_capability_matrix.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/escalation_chain_tile.dart';
import 'package:flutter/material.dart';

/// 能力矩阵容器。
///
/// 按破坏性优先级渲染全部链（顺序由 [EscalationChain.priority] 决定），
/// 让用户清楚「先试哪条、为什么轮不到后面」。
///
/// 这里是页面唯一的选链入口：点哪条链，下面的执行就只跑哪条链。
class EscalationMatrixView extends StatelessWidget {
  const EscalationMatrixView({
    super.key,
    required this.matrix,
    this.selectedChain,
    this.onSelect,
  });

  /// 探测得到的完整矩阵。
  final EscalationCapabilityMatrix matrix;

  /// 当前选中的链。
  final EscalationChain? selectedChain;

  /// 点选某条链；为 `null` 时整体只读（如运行进行中）。
  final ValueChanged<EscalationChain>? onSelect;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final List<EscalationCapability> capabilities = matrix.orderedCapabilities;
    final ValueChanged<EscalationChain>? select = onSelect;

    final List<Widget> children = <Widget>[];
    for (int i = 0; i < capabilities.length; i += 1) {
      if (i > 0) {
        children.add(
          Divider(
            height: 1,
            thickness: 1,
            color: colors.outlineVariant.withValues(alpha: 0.4),
          ),
        );
      }
      final EscalationCapability capability = capabilities[i];
      children.add(
        EscalationChainTile(
          capability: capability,
          selected: capability.chain == selectedChain,
          onTap: select == null ? null : () => select(capability.chain),
        ),
      );
    }

    return AppSettingsSection(
      title: context.l10n.escalationSectionChains,
      children: children,
    );
  }
}
