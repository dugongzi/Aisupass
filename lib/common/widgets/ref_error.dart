import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 通用错误态：提示文案 + 重试按钮。
///
/// [onRetry] 一般绑定 `ref.invalidate(provider)`，由调用方决定刷新哪个 Provider。
class RefError extends HookWidget {
  const RefError({super.key, required this.onRetry, this.message});

  /// 重试回调，禁止传空实现。
  final VoidCallback onRetry;

  /// 自定义错误文案，为空时使用通用加载失败提示。
  final String? message;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.cloud_off_rounded,
              size: 34.sp,
              color: scheme.onSurfaceVariant.withValues(alpha: 0.72),
            ),
            SizedBox(height: 14.h),
            Text(
              message ?? l10n.commonLoadFailed,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5.sp,
                height: 1.5,
                color: scheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 18.h),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh_rounded, size: 17.sp),
              label: Text(l10n.commonRetry),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(0, 38.h),
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11.r),
                ),
                textStyle: TextStyle(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
