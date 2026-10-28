import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 遗留状态告警横幅。
///
/// 只在最近一次运行留下了未清理状态时出现，提示用户先处理再继续，
/// 避免在脏状态下重复执行导致问题叠加。
class EscalationResidualBanner extends StatelessWidget {
  const EscalationResidualBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 14 : 14.w,
        vertical: isDesktop ? 10 : 10.h,
      ),
      decoration: BoxDecoration(
        color: colors.errorContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(isDesktop ? 10 : 12.r),
        border: Border.all(color: colors.error.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.warning_amber_rounded,
            size: isDesktop ? 18 : 18.sp,
            color: colors.error,
          ),
          SizedBox(width: isDesktop ? 8 : 8.w),
          Expanded(
            child: Text(
              context.l10n.escalationResidualWarning,
              style: TextStyle(
                fontSize: isDesktop ? 12 : 12.sp,
                height: 1.4,
                color: colors.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
