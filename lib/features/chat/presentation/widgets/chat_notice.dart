import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 挂在单条消息下方的轻提示，用于错误与非致命提醒。
class ChatInlineNotice extends StatelessWidget {
  const ChatInlineNotice({super.key, required this.text, this.isError = false});

  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;
    final Color color = isError ? colors.error : colors.onSurfaceVariant;

    return Container(
      margin: EdgeInsets.only(top: isDesktop ? 8 : 8.h),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 10 : 10.w,
        vertical: isDesktop ? 8 : 8.h,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isError ? 0.1 : 0.06),
        borderRadius: BorderRadius.circular(isDesktop ? 8 : 8.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            isError ? Icons.error_outline_rounded : Icons.info_outline_rounded,
            size: isDesktop ? 14 : 14.sp,
            color: color,
          ),
          SizedBox(width: isDesktop ? 6 : 6.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: isDesktop ? 12.5 : 12.5.sp,
                height: 1.45,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 会话级问题提示条，例如未完成 AI 配置。
class ChatIssueBanner extends StatelessWidget {
  const ChatIssueBanner({
    super.key,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDark = context.isDark;
    final bool isDesktop = isDesktopPlatform;
    final double radius = isDesktop ? 10 : 10.r;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 24 : 16.w,
        isDesktop ? 6 : 6.h,
        isDesktop ? 24 : 16.w,
        isDesktop ? 4 : 4.h,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 12 : 12.w,
              vertical: isDesktop ? 6 : 4.h,
            ),
            decoration: BoxDecoration(
              color: colors.error.withValues(alpha: isDark ? 0.14 : 0.08),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: colors.error.withValues(alpha: isDark ? 0.3 : 0.22),
              ),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.error_outline_rounded,
                  size: isDesktop ? 15 : 15.sp,
                  color: colors.error,
                ),
                SizedBox(width: isDesktop ? 8 : 8.w),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: isDesktop ? 12.5 : 12.5.sp,
                      height: 1.4,
                      color: colors.error,
                    ),
                  ),
                ),
                if (actionLabel != null && onAction != null)
                  TextButton(
                    onPressed: onAction,
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 8 : 8.w,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: colors.error,
                      textStyle: TextStyle(
                        fontSize: isDesktop ? 12 : 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: Text(actionLabel!),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
