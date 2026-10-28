import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_chain.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/escalation_texts.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 弹出提权二次确认对话框。
///
/// 危险等级达到「中」及以上时由页面调用；确认按钮使用危险色，
/// 让用户在点击前明确知道本次操作的风险等级。
Future<bool> showEscalationConfirmDialog(
  BuildContext context, {
  required EscalationChain chain,
  required int dangerLevel,
}) async {
  final ColorScheme colors = context.colorScheme;
  final bool isDesktop = isDesktopPlatform;
  final Color dangerColor = switch (dangerLevel) {
    <= 0 => colors.primary,
    1 => colors.tertiary,
    _ => colors.error,
  };

  final bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext dialogContext) {
      final AppLocalizations l10n = dialogContext.l10n;
      return AlertDialog(
        title: Text(l10n.escalationConfirmTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    escalationChainName(l10n, chain),
                    style: TextStyle(
                      fontSize: isDesktop ? 13.5 : 13.5.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: isDesktop ? 8 : 8.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 8 : 8.w,
                    vertical: isDesktop ? 2 : 2.h,
                  ),
                  decoration: BoxDecoration(
                    color: dangerColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(isDesktop ? 6 : 6.r),
                  ),
                  child: Text(
                    escalationDangerText(l10n, dangerLevel),
                    style: TextStyle(
                      fontSize: isDesktop ? 10.5 : 10.5.sp,
                      fontWeight: FontWeight.w600,
                      color: dangerColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: isDesktop ? 10 : 10.h),
            Text(
              l10n.escalationConfirmBody,
              style: TextStyle(
                fontSize: isDesktop ? 12 : 12.sp,
                height: 1.45,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.escalationCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: dangerColor),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.escalationStart),
          ),
        ],
      );
    },
  );

  return confirmed ?? false;
}
