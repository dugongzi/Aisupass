import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 回到底部按钮，离开底部时出现，可带未读条数。
class ChatScrollButton extends StatelessWidget {
  const ChatScrollButton({
    super.key,
    required this.visible,
    required this.unread,
    required this.onTap,
  });

  final bool visible;
  final int unread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDark = context.isDark;
    final bool isDesktop = isDesktopPlatform;
    final double size = isDesktop ? 38 : 38.r;

    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 180),
        child: AnimatedScale(
          scale: visible ? 1 : 0.86,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Material(
                color: colors.surface,
                elevation: 3,
                shadowColor: Colors.black.withValues(alpha: isDark ? 0.5 : 0.18),
                shape: CircleBorder(
                  side: BorderSide(
                    color: colors.outline.withValues(
                      alpha: isDark ? 0.3 : 0.16,
                    ),
                  ),
                ),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onTap,
                  child: SizedBox(
                    width: size,
                    height: size,
                    child: Icon(
                      Icons.arrow_downward_rounded,
                      size: isDesktop ? 18 : 18.sp,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              if (unread > 0)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: colors.surface, width: 1.5),
                    ),
                    child: Text(
                      unread > 99 ? '99+' : '$unread',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9.5,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        color: colors.onPrimary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
