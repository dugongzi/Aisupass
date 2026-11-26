import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 酷安验证页的底部操作区：错误原文、状态说明与重试按钮。
///
/// 只呈现页面传下来的状态，不持有 WebView 与业务逻辑。
class CoolapkCaptchaFooter extends StatelessWidget {
  const CoolapkCaptchaFooter({
    super.key,
    required this.ready,
    required this.busy,
    required this.failed,
    required this.onRetry,
    required this.onCopyError,
  });

  /// 验证组件是否已渲染完成，决定说明文案。
  final bool ready;

  /// 是否正在提交票据，期间禁用按钮。
  final bool busy;

  /// 失败原因原文，空串表示没有错误。
  final String failed;

  /// 重新加载宿主页并重新注入组件。
  final VoidCallback onRetry;

  /// 复制 [failed] 原文。
  final VoidCallback onCopyError;

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
            if (failed.isNotEmpty) ...<Widget>[
              _CaptchaErrorCard(text: failed, onCopy: onCopyError),
              SizedBox(height: 8.h),
            ],
            Text(
              ready ? l10n.coolapkCaptchaHint : l10n.coolapkCaptchaLoading,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                height: 1.45,
                color: colors.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: double.infinity,
              height: 42.h,
              child: FilledButton(
                onPressed: busy ? null : onRetry,
                child: Text(
                  l10n.coolapkCaptchaRetry,
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

/// 验证失败的错误原文：可选中、可复制，方便直接粘贴反馈。
class _CaptchaErrorCard extends StatelessWidget {
  const _CaptchaErrorCard({required this.text, required this.onCopy});

  final String text;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final AppLocalizations l10n = context.l10n;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colors.errorContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: SelectableText(
              text,
              style: TextStyle(
                fontSize: 11.5.sp,
                height: 1.5,
                color: colors.onErrorContainer,
              ),
            ),
          ),
          SizedBox(width: 6.w),
          Tooltip(
            message: l10n.coolapkCaptchaCopyError,
            child: InkWell(
              onTap: onCopy,
              borderRadius: BorderRadius.circular(6.r),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Icon(
                  Icons.copy_rounded,
                  size: 16.sp,
                  color: colors.onErrorContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
