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
class EscalationMatrixView extends StatelessWidget {
  const EscalationMatrixView({
    super.key,
    required this.matrix,
    this.selectedChain,
  });

  /// 探测得到的完整矩阵。
  final EscalationCapabilityMatrix matrix;

  /// 页面当前选中的链。
  final EscalationChain? selectedChain;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final List<EscalationCapability> capabilities =
        matrix.orderedCapabilities;

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
      children.add(
        EscalationChainTile(
          capability: capabilities[i],
          selected: capabilities[i].chain == selectedChain,
        ),
      );
    }

    return AppSettingsSection(
      title: context.l10n.escalationSectionChains,
      children: children,
    );
  }
}
