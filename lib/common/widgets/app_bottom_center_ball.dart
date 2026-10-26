import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/ai_activation_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 底栏正中的圆球。
///
/// 已激活时用渐变描边 + 外发光，内部铺主题表面色，与 AI 激活卡片同一套视觉语言；
/// 未激活时退回主题色实心球，不发光，与普通悬浮按钮一致。
/// 尺寸需与 [AppBottomBar] 的 `fabSize` 保持一致，否则缺口对不上。
class AppBottomCenterBall extends HookWidget {
  const AppBottomCenterBall({
    super.key,
    required this.size,
    this.isActivated = false,
    this.onPressed,
  });

  /// 圆球直径（已按 `.w` 缩放后的实际值）。
  final double size;

  /// AI 是否已激活：决定使用 AI 渐变还是主题色。
  final bool isActivated;

  /// 点击回调；为 null 时仅展示，不响应点击。
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final bool isDark = context.isDark;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isActivated ? aiActivationGradient : null,
        color: isActivated ? null : colorScheme.primary,
        boxShadow: <BoxShadow>[
          if (isActivated) ...buildAiActivationGlowShadows(isDark: isDark),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.14 : 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        // 激活态留出渐变描边，内圈铺表面色，日间白、夜间深灰。
        padding: EdgeInsets.all(isActivated ? 2.w : 0),
        child: Material(
          color: isActivated ? colorScheme.surface : Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: Center(
              child: isActivated
                  ? ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (Rect bounds) =>
                          aiActivationGradient.createShader(bounds),
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        size: size * 0.42,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      Icons.auto_awesome_rounded,
                      size: size * 0.42,
                      color: colorScheme.onPrimary,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 把浮动按钮压到底栏上沿附近，让圆球半嵌进缺口。
class AppBottomCenterBallLocation extends FloatingActionButtonLocation {
  const AppBottomCenterBallLocation({required this.offsetY});

  /// 相对默认 `centerDocked` 位置的下移距离。
  final double offsetY;

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final Offset baseOffset = FloatingActionButtonLocation.centerDocked
        .getOffset(scaffoldGeometry);
    return Offset(baseOffset.dx, baseOffset.dy + offsetY);
  }
}
