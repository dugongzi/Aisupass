import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/ai_activation_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 应用品牌标题：渐变填充的大写应用名。
///
/// [highlighted] 为 true 时用 AI 激活渐变，与激活卡片的色系呼应；
/// 否则跟随主题色（primary → secondary），切换主题色时标题同步变化。
class AppBrandTitle extends HookWidget {
  const AppBrandTitle({
    super.key,
    this.highlighted = false,
    this.fontSize = 31,
  });

  final bool highlighted;

  /// 设计稿字号，内部按 `.sp` 缩放。
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final List<Color> colors = highlighted
        ? aiActivationGradientColors
        : <Color>[colorScheme.primary, colorScheme.secondary];

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) => LinearGradient(
        colors: colors,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds),
      child: Text(
        context.l10n.appName.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
          color: Colors.white,
        ),
      ),
    );
  }
}
