import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_outcome.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_reason.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/escalation_texts.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 运行结果卡片。
///
/// 颜色语义与领域结论一一对应：
/// 成功取主色、部分成功取强调色、失败/不安全取错误色、
/// 不支持/未开始取中性色，避免用户误解结果严重程度。
class EscalationOutcomeCard extends StatelessWidget {
  const EscalationOutcomeCard({
    super.key,
    required this.outcome,
    required this.reasons,
  });

  /// 结论；为空时整个卡片不渲染。
  final EscalationOutcome? outcome;

  /// 各阶段原因码去重合集。
  final List<EscalationReason> reasons;

  @override
  Widget build(BuildContext context) {
    final EscalationOutcome? result = outcome;
    if (result == null) return const SizedBox.shrink();

    final AppLocalizations l10n = context.l10n;
    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;

    final Color accent = switch (result) {
      EscalationOutcome.success => colors.primary,
      EscalationOutcome.partial => colors.tertiary,
      EscalationOutcome.failed || EscalationOutcome.unsafe => colors.error,
      EscalationOutcome.unsupported ||
      EscalationOutcome.notStarted => colors.onSurfaceVariant,
    };

    final IconData icon = switch (result) {
      EscalationOutcome.success => Icons.verified_rounded,
      EscalationOutcome.partial => Icons.adjust_rounded,
      EscalationOutcome.failed => Icons.cancel_rounded,
      EscalationOutcome.unsafe => Icons.dangerous_rounded,
      EscalationOutcome.unsupported => Icons.block_rounded,
      EscalationOutcome.notStarted => Icons.hourglass_empty_rounded,
    };

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 14 : 14.w,
        vertical: isDesktop ? 12 : 12.h,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(isDesktop ? 10 : 12.r),
        border: Border.all(color: accent.withValues(alpha: 0.32)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: isDesktop ? 20 : 20.sp, color: accent),
          SizedBox(width: isDesktop ? 10 : 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  escalationOutcomeText(l10n, result),
                  style: TextStyle(
                    fontSize: isDesktop ? 13.5 : 13.5.sp,
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
                if (reasons.isNotEmpty) ...<Widget>[
                  SizedBox(height: isDesktop ? 6 : 6.h),
                  for (final EscalationReason reason in reasons)
                    Padding(
                      padding: EdgeInsets.only(bottom: isDesktop ? 2 : 2.h),
                      child: Text(
                        '· ${escalationReasonText(l10n, reason)}',
                        style: TextStyle(
                          fontSize: isDesktop ? 11.5 : 11.5.sp,
                          height: 1.4,
                          color: colors.onSurfaceVariant.withValues(
                            alpha: 0.85,
                          ),
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
