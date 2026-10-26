import 'dart:math' as math;

import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/ai_activation_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// AI 圆球上方的快捷提权面板。
///
/// 面板常驻组件树，由 [visible] 驱动展开/收起：缩放 + 上移 + 淡入，
/// 同时遮罩层淡入并拦截页面点击，点击遮罩或圆球即可收起。
class AiQuickPanelOverlay extends HookWidget {
  const AiQuickPanelOverlay({
    super.key,
    required this.visible,
    required this.bottomOffset,
    required this.onDismiss,
    required this.onAiEscalate,
    required this.onManualEscalate,
  });

  /// 面板是否展开。
  final bool visible;

  /// 面板底端（水滴尖端）距屏幕底部的距离。
  final double bottomOffset;

  /// 点击遮罩收起面板。
  final VoidCallback onDismiss;

  /// 点击「AI 提权」。
  final VoidCallback onAiEscalate;

  /// 点击「手动提权」。
  final VoidCallback onManualEscalate;

  @override
  Widget build(BuildContext context) {
    final AnimationController controller = useAnimationController(
      duration: const Duration(milliseconds: 280),
      reverseDuration: const Duration(milliseconds: 200),
    );

    useEffect(() {
      if (visible) {
        controller.forward();
      } else {
        controller.reverse();
      }
      return null;
    }, <Object?>[visible]);

    final Animation<double> fade = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
    final Animation<double> pop = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInCubic,
    );

    final double maxWidth = math.min(context.screenWidth - 36.w, 360.w);

    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        final double fadeValue = fade.value.clamp(0.0, 1.0);

        return Stack(
          children: <Widget>[
            // 遮罩：展开时压暗页面并接管点击，点击任意空白处收起。
            Positioned.fill(
              child: IgnorePointer(
                ignoring: !visible,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onDismiss,
                  child: ColoredBox(
                    color: Colors.black.withValues(alpha: 0.30 * fadeValue),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: bottomOffset,
              child: ExcludeSemantics(
                excluding: !visible,
                child: IgnorePointer(
                  ignoring: !visible,
                  child: Opacity(
                    opacity: fadeValue,
                    child: Transform.translate(
                      offset: Offset(0, (1 - fadeValue) * 22.h),
                      child: Transform.scale(
                        // 以水滴尖端为锚点向上生长，收放都贴着圆球。
                        scale: 0.88 + 0.12 * pop.value,
                        alignment: Alignment.bottomCenter,
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: maxWidth),
                            child: _AiQuickPanel(
                              onAiEscalate: onAiEscalate,
                              onManualEscalate: onManualEscalate,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// 水滴形面板主体：渐变描边 + 外发光 + 底部尖角。
class _AiQuickPanel extends HookWidget {
  const _AiQuickPanel({
    required this.onAiEscalate,
    required this.onManualEscalate,
  });

  final VoidCallback onAiEscalate;
  final VoidCallback onManualEscalate;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final bool isDark = context.isDark;
    final double radius = 24.r;
    final double tailHeight = 16.h;
    final double tailHalfWidth = 30.w;

    return CustomPaint(
      painter: _DropletBackdropPainter(
        radius: radius,
        tailHeight: tailHeight,
        tailHalfWidth: tailHalfWidth,
        shadowColor: Colors.black.withValues(alpha: isDark ? 0.55 : 0.20),
        isDark: isDark,
      ),
      foregroundPainter: _DropletBorderPainter(
        radius: radius,
        tailHeight: tailHeight,
        tailHalfWidth: tailHalfWidth,
      ),
      child: ClipPath(
        clipper: _DropletClipper(
          radius: radius,
          tailHeight: tailHeight,
          tailHalfWidth: tailHalfWidth,
        ),
        child: ColoredBox(
          color: colorScheme.surface,
          child: Padding(
            // 底部额外留出尖角高度，内容不会被水滴尾巴挤压。
            padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 16.h + tailHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildHeader(context),
                SizedBox(height: 14.h),
                _AiQuickActionTile(
                  isPrimary: true,
                  icon: Icons.auto_awesome_rounded,
                  title: context.l10n.aiQuickEscalateTitle,
                  description: context.l10n.aiQuickEscalateDesc,
                  onTap: onAiEscalate,
                ),
                SizedBox(height: 10.h),
                _AiQuickActionTile(
                  isPrimary: false,
                  icon: Icons.terminal_rounded,
                  title: context.l10n.manualQuickEscalateTitle,
                  description: context.l10n.manualQuickEscalateDesc,
                  onTap: onManualEscalate,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;

    return Row(
      children: <Widget>[
        Container(
          width: 34.w,
          height: 34.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: aiActivationGradient,
          ),
          child: Icon(Icons.bolt_rounded, size: 20.sp, color: Colors.white),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) =>
                    aiActivationGradient.createShader(bounds),
                child: Text(
                  context.l10n.aiQuickPanelTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                context.l10n.aiQuickPanelSubtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                  color: colorScheme.onSurface.withValues(alpha: 0.50),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 面板内的单个提权入口。
///
/// 主按钮走 AI 渐变描边 + 渐变图标 + 发光，次按钮退为中性命中区，
/// 按下时整体轻微缩放，给到明确的触感反馈。
class _AiQuickActionTile extends HookWidget {
  const _AiQuickActionTile({
    required this.isPrimary,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  /// 是否为主操作（AI 提权）。
  final bool isPrimary;
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final bool isDark = context.isDark;
    final ValueNotifier<bool> pressed = useState<bool>(false);
    final BorderRadius radius = BorderRadius.circular(18.r);

    return Semantics(
      button: true,
      label: title,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => pressed.value = true,
        onTapCancel: () => pressed.value = false,
        onTapUp: (_) => pressed.value = false,
        onTap: onTap,
        child: AnimatedScale(
          scale: pressed.value ? 0.97 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: Container(
            // 主按钮靠 1.4 的 padding 露出外层渐变，形成描边。
            padding: EdgeInsets.all(isPrimary ? 1.4.w : 1.w),
            decoration: BoxDecoration(
              borderRadius: radius,
              gradient: isPrimary ? aiActivationGradient : null,
              color: isPrimary
                  ? null
                  : colorScheme.outline.withValues(
                      alpha: isDark ? 0.28 : 0.14,
                    ),
              boxShadow: isPrimary
                  ? buildAiActivationGlowShadows(isDark: isDark)
                  : null,
            ),
            child: Container(
              padding: EdgeInsets.fromLTRB(12.w, 12.h, 10.w, 12.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17.r),
                color: isPrimary ? null : colorScheme.surface,
                gradient: isPrimary
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          aiActivationGradientColors[0].withValues(
                            alpha: isDark ? 0.18 : 0.13,
                          ),
                          aiActivationGradientColors[1].withValues(
                            alpha: isDark ? 0.13 : 0.09,
                          ),
                          aiActivationGradientColors[2].withValues(
                            alpha: isDark ? 0.10 : 0.07,
                          ),
                        ],
                      )
                    : null,
              ),
              child: Row(
                children: <Widget>[
                  _buildIconBadge(context),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildTitle(context),
                        SizedBox(height: 3.h),
                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.35,
                            color: colorScheme.onSurface.withValues(
                              alpha: isPrimary ? 0.62 : 0.52,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 6.w),
                  _buildTrailing(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconBadge(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final bool isDark = context.isDark;

    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isPrimary ? aiActivationGradient : null,
        color: isPrimary
            ? null
            : colorScheme.primary.withValues(alpha: isDark ? 0.18 : 0.10),
      ),
      child: Icon(
        icon,
        size: 21.sp,
        color: isPrimary ? Colors.white : colorScheme.primary,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final TextStyle style = TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.w800,
      height: 1.2,
    );

    if (!isPrimary) {
      return Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style.copyWith(
          color: context.colorScheme.onSurface.withValues(alpha: 0.90),
        ),
      );
    }

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) => aiActivationGradient.createShader(bounds),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style.copyWith(color: Colors.white),
      ),
    );
  }

  Widget _buildTrailing(BuildContext context) {
    if (!isPrimary) {
      return Icon(
        Icons.chevron_right_rounded,
        size: 20.sp,
        color: context.colorScheme.onSurface.withValues(alpha: 0.32),
      );
    }

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) => aiActivationGradient.createShader(bounds),
      child: Icon(
        Icons.arrow_forward_rounded,
        size: 19.sp,
        color: Colors.white,
      ),
    );
  }
}

/// 水滴形裁剪路径：圆角矩形 + 底部居中的尖角。
Path _buildDropletPath(
  Size size, {
  required double radius,
  required double tailHeight,
  required double tailHalfWidth,
}) {
  final double width = size.width;
  final double height = size.height;
  final double bodyBottom = height - tailHeight;
  final double centerX = width / 2;
  final double r = math.min(radius, math.min(width / 2, bodyBottom / 2));
  final double half = math.min(tailHalfWidth, width * 0.22);

  return Path()
    ..moveTo(r, 0)
    ..lineTo(width - r, 0)
    ..arcToPoint(Offset(width, r), radius: Radius.circular(r))
    ..lineTo(width, bodyBottom - r)
    ..arcToPoint(
      Offset(width - r, bodyBottom),
      radius: Radius.circular(r),
    )
    ..lineTo(centerX + half, bodyBottom)
    // 两段三次贝塞尔收成水滴尖角，左右对称。
    ..cubicTo(
      centerX + half * 0.72,
      bodyBottom + tailHeight * 0.16,
      centerX + half * 0.30,
      bodyBottom + tailHeight * 0.70,
      centerX,
      height,
    )
    ..cubicTo(
      centerX - half * 0.30,
      bodyBottom + tailHeight * 0.70,
      centerX - half * 0.72,
      bodyBottom + tailHeight * 0.16,
      centerX - half,
      bodyBottom,
    )
    ..lineTo(r, bodyBottom)
    ..arcToPoint(Offset(0, bodyBottom - r), radius: Radius.circular(r))
    ..lineTo(0, r)
    ..arcToPoint(Offset(r, 0), radius: Radius.circular(r))
    ..close();
}

class _DropletClipper extends CustomClipper<Path> {
  const _DropletClipper({
    required this.radius,
    required this.tailHeight,
    required this.tailHalfWidth,
  });

  final double radius;
  final double tailHeight;
  final double tailHalfWidth;

  @override
  Path getClip(Size size) {
    return _buildDropletPath(
      size,
      radius: radius,
      tailHeight: tailHeight,
      tailHalfWidth: tailHalfWidth,
    );
  }

  @override
  bool shouldReclip(covariant _DropletClipper oldClipper) {
    return oldClipper.radius != radius ||
        oldClipper.tailHeight != tailHeight ||
        oldClipper.tailHalfWidth != tailHalfWidth;
  }
}

/// 面板投影与渐变光晕，画在裁剪区域之外，避免被自身形状裁掉。
class _DropletBackdropPainter extends CustomPainter {
  const _DropletBackdropPainter({
    required this.radius,
    required this.tailHeight,
    required this.tailHalfWidth,
    required this.shadowColor,
    required this.isDark,
  });

  final double radius;
  final double tailHeight;
  final double tailHalfWidth;
  final Color shadowColor;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = _buildDropletPath(
      size,
      radius: radius,
      tailHeight: tailHeight,
      tailHalfWidth: tailHalfWidth,
    );

    canvas.drawShadow(path, shadowColor, 16, true);

    // 深色模式下压低透明度，避免光晕在暗背景上过曝。
    final double factor = isDark ? 0.6 : 1;
    final Paint glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10)
      ..shader = LinearGradient(
        colors: <Color>[
          for (final Color color in aiActivationGradientColors)
            color.withValues(alpha: 0.38 * factor),
        ],
      ).createShader(Offset.zero & size);

    canvas.drawPath(path, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _DropletBackdropPainter oldDelegate) {
    return oldDelegate.radius != radius ||
        oldDelegate.tailHeight != tailHeight ||
        oldDelegate.tailHalfWidth != tailHalfWidth ||
        oldDelegate.shadowColor != shadowColor ||
        oldDelegate.isDark != isDark;
  }
}

/// 沿水滴轮廓描一圈 AI 渐变边，与底栏缺口、圆球同一套视觉语言。
class _DropletBorderPainter extends CustomPainter {
  const _DropletBorderPainter({
    required this.radius,
    required this.tailHeight,
    required this.tailHalfWidth,
  });

  final double radius;
  final double tailHeight;
  final double tailHalfWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = _buildDropletPath(
      size,
      radius: radius,
      tailHeight: tailHeight,
      tailHalfWidth: tailHalfWidth,
    );

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..shader = aiActivationGradient.createShader(Offset.zero & size);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DropletBorderPainter oldDelegate) {
    return oldDelegate.radius != radius ||
        oldDelegate.tailHeight != tailHeight ||
        oldDelegate.tailHalfWidth != tailHalfWidth;
  }
}
