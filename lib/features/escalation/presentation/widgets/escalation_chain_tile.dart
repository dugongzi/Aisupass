import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_capability.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/escalation_texts.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 能力矩阵中的一行：链名、说明、可用性与危险等级。
///
/// 不可用时整体置灰，并在说明下方给出首个原因码文案；
/// 选中行用主色浅底标识，未选中的行保持透明。
class EscalationChainTile extends StatelessWidget {
  const EscalationChainTile({
    super.key,
    required this.capability,
    this.selected = false,
  });

  /// 当前链的探测结论。
  final EscalationCapability capability;

  /// 是否为页面当前选中的链。
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;
    final bool isDark = context.isDark;
    final bool available = capability.available;

    final Color titleColor = available
        ? colors.onSurface
        : colors.onSurfaceVariant.withValues(alpha: 0.55);
    final Color descColor = available
        ? colors.onSurfaceVariant.withValues(alpha: 0.78)
        : colors.onSurfaceVariant.withValues(alpha: 0.45);

    final Color dangerColor = switch (capability.chain.dangerLevel) {
      <= 0 => colors.primary,
      1 => colors.tertiary,
      _ => colors.error,
    };

    return Container(
      decoration: BoxDecoration(
        color: selected
            ? colors.primary.withValues(alpha: isDark ? 0.16 : 0.07)
            : Colors.transparent,
        border: Border(
          left: BorderSide(
            color: selected ? colors.primary : Colors.transparent,
            width: isDesktop ? 3 : 3.w,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 14 : 14.w,
        vertical: isDesktop ? 12 : 12.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: isDesktop ? 1 : 1.h),
            child: Icon(
              available
                  ? Icons.check_circle_rounded
                  : Icons.remove_circle_outline_rounded,
              size: isDesktop ? 18 : 18.sp,
              color: available
                  ? colors.primary
                  : colors.onSurfaceVariant.withValues(alpha: 0.45),
            ),
          ),
          SizedBox(width: isDesktop ? 10 : 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  escalationChainName(l10n, capability.chain),
                  style: TextStyle(
                    fontSize: isDesktop ? 13.5 : 13.5.sp,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                SizedBox(height: isDesktop ? 2 : 2.h),
                Text(
                  escalationChainDesc(l10n, capability.chain),
                  style: TextStyle(
                    fontSize: isDesktop ? 11.5 : 11.5.sp,
                    height: 1.35,
                    color: descColor,
                  ),
                ),
                if (!available) ...<Widget>[
                  SizedBox(height: isDesktop ? 4 : 4.h),
                  Text(
                    escalationReasonText(l10n, capability.primaryReason),
                    style: TextStyle(
                      fontSize: isDesktop ? 11 : 11.sp,
                      height: 1.35,
                      color: colors.error.withValues(alpha: 0.78),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: isDesktop ? 10 : 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              _ChainBadge(
                text: available
                    ? l10n.escalationAvailable
                    : l10n.escalationUnavailable,
                color: available ? colors.primary : colors.onSurfaceVariant,
              ),
              SizedBox(height: isDesktop ? 6 : 6.h),
              Text(
                escalationDangerText(l10n, capability.chain.dangerLevel),
                style: TextStyle(
                  fontSize: isDesktop ? 10.5 : 10.5.sp,
                  fontWeight: FontWeight.w500,
                  color: dangerColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 可用性徽标：浅色底 + 同色描边，避免在深色主题下过亮。
class _ChainBadge extends StatelessWidget {
  const _ChainBadge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDesktopPlatform;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 8 : 8.w,
        vertical: isDesktop ? 2 : 2.h,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(isDesktop ? 6 : 6.r),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isDesktop ? 10 : 10.sp,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
