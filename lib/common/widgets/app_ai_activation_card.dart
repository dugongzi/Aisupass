import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/ai_activation_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// AI 激活状态卡片。
///
/// 已激活时用渐变描边包一层外发光，图标与标题同步走渐变；
/// 未激活时降级为中性底色，提示先去配置大模型。
class AppAiActivationCard extends HookWidget {
  const AppAiActivationCard({super.key, required this.isActivated});

  final bool isActivated;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final bool isDark = context.isDark;

    return Container(
      constraints: BoxConstraints(minHeight: 96.h),
      // 激活态靠 2 的 padding 露出外层渐变，形成描边。
      padding: isActivated ? EdgeInsets.all(2.w) : EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: isActivated ? aiActivationGradient : null,
        color: isActivated
            ? null
            : colorScheme.onSurface.withValues(alpha: isDark ? 0.08 : 0.05),
        boxShadow: isActivated
            ? buildAiActivationGlowShadows(isDark: isDark)
            : null,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isActivated ? colorScheme.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(isActivated ? 14.r : 16.r),
        ),
        child: Row(
          children: <Widget>[
            _buildIcon(context),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildText(
                    context,
                    context.l10n.aiTitle,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                  SizedBox(height: 4.h),
                  _buildText(
                    context,
                    isActivated
                        ? context.l10n.activated
                        : context.l10n.notActivated,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    final IconData icon = isActivated
        ? Icons.check_rounded
        : Icons.error_outline_rounded;

    if (!isActivated) {
      return Icon(
        icon,
        size: 40.sp,
        color: context.colorScheme.onSurface.withValues(alpha: 0.42),
      );
    }

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) => aiActivationGradient.createShader(bounds),
      child: Icon(icon, size: 40.sp, color: Colors.white),
    );
  }

  /// 激活态用渐变填充文字，未激活态退回中性色。
  Widget _buildText(
    BuildContext context,
    String text, {
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    final TextStyle style = TextStyle(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      height: 1.2,
    );

    if (!isActivated) {
      return Text(
        text,
        style: style.copyWith(
          color: context.colorScheme.onSurface.withValues(
            alpha: fontWeight == FontWeight.w800 ? 0.86 : 0.58,
          ),
        ),
      );
    }

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) => aiActivationGradient.createShader(bounds),
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }
}
