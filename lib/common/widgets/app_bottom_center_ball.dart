import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/ai_activation_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 底栏正中的圆球。
///
/// 渐变描边 + 外发光，内部是主题表面色，与 AI 激活卡片同一套视觉语言。
/// 尺寸需与 [AppBottomBar] 的 `fabSize` 保持一致，否则缺口对不上。
class AppBottomCenterBall extends HookWidget {
  const AppBottomCenterBall({super.key, required this.size, this.onPressed});

  /// 圆球直径（已按 `.w` 缩放后的实际值）。
  final double size;

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
        gradient: aiActivationGradient,
        boxShadow: <BoxShadow>[
          ...buildAiActivationGlowShadows(isDark: isDark),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.14 : 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        // 留出渐变描边，内圈铺表面色，日间白、夜间深灰。
        padding: EdgeInsets.all(2.w),
        child: Material(
          color: colorScheme.surface,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: Center(
              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) =>
                    aiActivationGradient.createShader(bounds),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: size * 0.42,
                  color: Colors.white,
                ),
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
