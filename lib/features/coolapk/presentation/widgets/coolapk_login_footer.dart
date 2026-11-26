import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 酷安登录页的底部操作区：两句说明与抓取按钮。
///
/// 抓取中在按钮内显示转圈，期间不可重复点击。
class CoolapkLoginFooter extends StatelessWidget {
  const CoolapkLoginFooter({
    super.key,
    required this.capturing,
    required this.onCapture,
  });

  /// 是否正在读取并保存会话。
  final bool capturing;

  /// 用户在页面内完成登录后手动触发抓取。
  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final AppLocalizations l10n = context.l10n;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              l10n.coolapkLoginHint,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                height: 1.45,
                color: colors.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              l10n.coolapkLoginThirdPartyHint,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                height: 1.45,
                color: colors.onSurfaceVariant.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: double.infinity,
              height: 42.h,
              child: FilledButton(
                onPressed: capturing ? null : onCapture,
                child: capturing
                    ? SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        l10n.coolapkLoginCaptureAction,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
