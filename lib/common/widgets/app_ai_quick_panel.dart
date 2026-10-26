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
    this.isActivated = false,
  });

  /// 面板是否展开。
  final bool visible;

  /// AI 是否已激活：未激活时描边与外发光退回普通中性色。
  final bool isActivated;

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
                              isActivated: isActivated,
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

/// 水滴形面板主体：激活态渐变描边 + 外发光，未激活时退为中性描边。
class _AiQuickPanel extends HookWidget {
  const _AiQuickPanel({
    required this.isActivated,
    required this.onAiEscalate,
    required this.onManualEscalate,
  });

  /// AI 是否已激活。
  final bool isActivated;
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
        isGlowing: isActivated,
        isDark: isDark,
      ),
      foregroundPainter: _DropletBorderPainter(
        radius: radius,
        tailHeight: tailHeight,
        tailHalfWidth: tailHalfWidth,
        gradient: isActivated ? aiActivationGradient : null,
        color: colorScheme.outline.withValues(alpha: isDark ? 0.34 : 0.18),
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
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h + tailHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildCaption(context),
                SizedBox(height: 10.h),
                _buildActionGroup(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 面板标题退为小节标题：只做分组提示，不与下面的操作项抢层级。
  Widget _buildCaption(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;

    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        context.l10n.aiQuickPanelTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          height: 1.2,
          letterSpacing: 0.2,
          color: colorScheme.onSurface.withValues(alpha: 0.45),
        ),
      ),
    );
  }

  /// 两个入口共用一个圆角容器，中间一条极淡分隔线，
  /// 避免每行各套一层底色造成视觉碎片。
  Widget _buildActionGroup(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final bool isDark = context.isDark;
    final BorderRadius radius = BorderRadius.circular(16.r);

    return ClipRRect(
      borderRadius: radius,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: radius,
          color: colorScheme.onSurface.withValues(alpha: isDark ? 0.05 : 0.035),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _AiQuickActionTile(
              isPrimary: true,
              icon: Icons.auto_awesome_rounded,
              title: context.l10n.aiQuickEscalateTitle,
              description: context.l10n.aiQuickEscalateDesc,
              onTap: onAiEscalate,
            ),
            Divider(
              height: 1,
              thickness: 1,
              indent: 12.w,
              endIndent: 12.w,
              color: colorScheme.onSurface.withValues(
                alpha: isDark ? 0.07 : 0.06,
              ),
            ),
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
    );
  }
}

/// 面板内的单个提权入口。
///
/// 平铺在分组容器里：图标与文字左对齐成一条竖线，右侧统一箭头；
/// 主次只靠图标颜色区分，按下时叠一层极淡高亮，不做缩放与发光。
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

    return Semantics(
      button: true,
      label: title,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => pressed.value = true,
        onTapCancel: () => pressed.value = false,
        onTapUp: (_) => pressed.value = false,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          padding: EdgeInsets.fromLTRB(12.w, 11.h, 12.w, 11.h),
          color: pressed.value
              ? colorScheme.onSurface.withValues(alpha: isDark ? 0.06 : 0.05)
              : Colors.transparent,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 20.sp,
                color: isPrimary
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.55),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        color: colorScheme.onSurface.withValues(alpha: 0.90),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                        color: colorScheme.onSurface.withValues(
                          alpha: isPrimary ? 0.55 : 0.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.chevron_right_rounded,
                size: 17.sp,
                color: colorScheme.onSurface.withValues(alpha: 0.28),
              ),
            ],
          ),
        ),
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

/// 面板投影与外发光，画在裁剪区域之外，避免被自身形状裁掉。
class _DropletBackdropPainter extends CustomPainter {
  const _DropletBackdropPainter({
    required this.radius,
    required this.tailHeight,
    required this.tailHalfWidth,
    required this.shadowColor,
    required this.isGlowing,
    required this.isDark,
  });

  final double radius;
  final double tailHeight;
  final double tailHalfWidth;
  final Color shadowColor;

  /// 是否绘制 AI 渐变光晕，未激活时只留投影。
  final bool isGlowing;
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

    if (!isGlowing) return;

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
        oldDelegate.isGlowing != isGlowing ||
        oldDelegate.isDark != isDark;
  }
}

/// 沿水滴轮廓描一圈边：激活态走 AI 渐变，未激活时用中性描边色。
class _DropletBorderPainter extends CustomPainter {
  const _DropletBorderPainter({
    required this.radius,
    required this.tailHeight,
    required this.tailHalfWidth,
    required this.gradient,
    required this.color,
  });

  final double radius;
  final double tailHeight;
  final double tailHalfWidth;

  /// 非空时用渐变描边，否则用 [color] 单色。
  final LinearGradient? gradient;
  final Color color;

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
      ..strokeWidth = 1.2;

    final LinearGradient? gradient = this.gradient;
    if (gradient != null) {
      paint.shader = gradient.createShader(Offset.zero & size);
    } else {
      paint.color = color;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DropletBorderPainter oldDelegate) {
    return oldDelegate.radius != radius ||
        oldDelegate.tailHeight != tailHeight ||
        oldDelegate.tailHalfWidth != tailHalfWidth ||
        oldDelegate.gradient != gradient ||
        oldDelegate.color != color;
  }
}
