import 'package:Aisupass/common/widgets/app_settings_section.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_reason.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_stage.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_step_record.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/escalation_texts.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 五阶段执行时间线。
///
/// `probe/prepare/execute/verify/cleanup` 始终固定渲染，
/// 未到达的阶段用 `--` 占位，避免运行过程中列表高度反复跳动。
class EscalationTimeline extends StatelessWidget {
  const EscalationTimeline({
    super.key,
    required this.steps,
    required this.isRunning,
  });

  /// 已到达的阶段记录，按原生推送顺序排列。
  final List<EscalationStepRecord> steps;

  /// 当前是否仍在运行；运行中未到达的阶段统一显示为待执行。
  final bool isRunning;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDesktopPlatform;
    final List<EscalationStage> stages = EscalationStage.values;

    return AppSettingsSection(
      title: context.l10n.escalationSectionTimeline,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 14 : 14.w,
            vertical: isDesktop ? 12 : 12.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (int i = 0; i < stages.length; i += 1)
                _TimelineRow(
                  stage: stages[i],
                  step: _findStep(stages[i]),
                  isLast: i == stages.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// 查找指定阶段的记录；未执行到时返回 `null`。
  EscalationStepRecord? _findStep(EscalationStage stage) {
    for (final EscalationStepRecord step in steps) {
      if (step.stage == stage) return step;
    }
    return null;
  }
}

/// 单行时间线：状态点 + 连接线 + 阶段名 + 耗时。
class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.stage,
    required this.step,
    required this.isLast,
  });

  final EscalationStage stage;
  final EscalationStepRecord? step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;
    final EscalationStepRecord? record = step;
    final bool reached = record != null;
    final bool ok = record?.ok ?? false;

    final Color stateColor = reached
        ? (ok ? colors.primary : colors.error)
        : colors.onSurfaceVariant.withValues(alpha: 0.38);

    final IconData stateIcon = reached
        ? (ok ? Icons.check_circle_rounded : Icons.error_rounded)
        : Icons.radio_button_unchecked_rounded;

    final List<EscalationReason> reasons =
        record?.reasons ?? const <EscalationReason>[];

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            width: isDesktop ? 20 : 20.w,
            child: Column(
              children: <Widget>[
                Icon(
                  stateIcon,
                  size: isDesktop ? 16 : 16.sp,
                  color: stateColor,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: isDesktop ? 1.5 : 1.5.w,
                      color: colors.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: isDesktop ? 10 : 10.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : (isDesktop ? 14 : 14.h),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          escalationStageText(l10n, stage),
                          style: TextStyle(
                            fontSize: isDesktop ? 12.5 : 12.5.sp,
                            fontWeight: reached
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: reached
                                ? colors.onSurface
                                : colors.onSurfaceVariant.withValues(
                                    alpha: 0.55,
                                  ),
                          ),
                        ),
                      ),
                      Text(
                        reached ? '${record.durationMs} ms' : '--',
                        style: TextStyle(
                          fontSize: isDesktop ? 11 : 11.sp,
                          fontFeatures: const <FontFeature>[
                            FontFeature.tabularFigures(),
                          ],
                          color: colors.onSurfaceVariant.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (reasons.isNotEmpty) ...<Widget>[
                    SizedBox(height: isDesktop ? 3 : 3.h),
                    Text(
                      reasons
                          .map(
                            (EscalationReason reason) =>
                                escalationReasonText(l10n, reason),
                          )
                          .join(' · '),
                      style: TextStyle(
                        fontSize: isDesktop ? 10.5 : 10.5.sp,
                        height: 1.35,
                        color: colors.error.withValues(alpha: 0.78),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
