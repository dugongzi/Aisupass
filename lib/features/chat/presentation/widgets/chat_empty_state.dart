import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 空会话引导：标题、说明与三个可直接发送的建议问题。
class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({super.key, required this.onSuggestion});

  final ValueChanged<String> onSuggestion;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDesktopPlatform;
    final ColorScheme colors = context.colorScheme;
    final List<String> suggestions = <String>[
      context.l10n.chatSuggestionDevice,
      context.l10n.chatSuggestionRoot,
      context.l10n.chatSuggestionPlan,
    ];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 24 : 24.w),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: isDesktop ? 60 : 60.r,
                      height: isDesktop ? 60 : 60.r,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(
                          alpha: context.isDark ? 0.18 : 0.1,
                        ),
                        borderRadius: BorderRadius.circular(
                          isDesktop ? 20 : 20.r,
                        ),
                        border: Border.all(
                          color: colors.primary.withValues(
                            alpha: context.isDark ? 0.26 : 0.14,
                          ),
                        ),
                      ),
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        size: isDesktop ? 26 : 26.sp,
                        color: colors.primary,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 18 : 18.h),
                    Text(
                      context.l10n.chatEmptyTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isDesktop ? 20 : 20.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.onSurface,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 8 : 8.h),
                    Text(
                      context.l10n.chatEmptyHint,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isDesktop ? 13.5 : 13.5.sp,
                        height: 1.55,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 22 : 22.h),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: isDesktop ? 8 : 8.w,
                      runSpacing: isDesktop ? 8 : 8.h,
                      children: <Widget>[
                        for (final String suggestion in suggestions)
                          _SuggestionChip(
                            text: suggestion,
                            onTap: () => onSuggestion(suggestion),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;
    final BorderRadius radius = BorderRadius.circular(999);

    return Material(
      color: colors.surfaceContainerHighest.withValues(
        alpha: context.isDark ? 0.4 : 0.55,
      ),
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 13 : 13.w,
            vertical: isDesktop ? 8 : 8.h,
          ),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: colors.outline.withValues(
                alpha: context.isDark ? 0.24 : 0.14,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.north_east_rounded,
                size: isDesktop ? 13 : 13.sp,
                color: colors.onSurfaceVariant,
              ),
              SizedBox(width: isDesktop ? 5 : 5.w),
              Text(
                text,
                style: TextStyle(
                  fontSize: isDesktop ? 12.5 : 12.5.sp,
                  color: colors.onSurface.withValues(alpha: 0.86),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
