import 'dart:math' as math;

import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/ai_activation_theme.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 底栏单项数据。
class AppBottomBarItem {
  const AppBottomBarItem({
    required this.label,
    required this.outlinedIcon,
    required this.filledIcon,
  });

  final String label;
  final IconData outlinedIcon;
  final IconData filledIcon;
}

/// 移动端悬浮底栏。
///
/// 圆角矩形 + 阴影，左右各留 [12.w] 边距，底部留出安全区，
/// 由根页面通过 `Scaffold.bottomNavigationBar` 挂载。
///
/// 正中留出一个半圆缺口，供 [AppBottomCenterBall] 嵌入；缺口尺寸必须与
/// 圆球保持一致，因此 [fabSize] / [fabOffsetY] 由根页面统一传入。
///
/// [isAiActivated] 为 true 时描边换成 AI 渐变并外发光，与圆球、AI 激活卡片
/// 使用同一套视觉语言。
class AppBottomBar extends HookWidget {
  const AppBottomBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.height = 60,
    this.fabSize = 58,
    this.fabOffsetY = 9,
    this.isAiActivated = false,
  });

  final List<AppBottomBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  /// 设计稿高度（逻辑值，内部按 `.h` 缩放）。
  final double height;

  /// 中间圆球直径（设计稿值）。
  final double fabSize;

  /// 圆球圆心相对底栏顶边的下移距离（设计稿值）。
  final double fabOffsetY;

  /// AI 是否已激活：激活后描边走渐变并加外发光。
  final bool isAiActivated;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final bool isDark = context.isDark;

    final double fabDiameter = fabSize.w;
    final double fabCenterY = fabOffsetY.h;
    final _HalfCircleNotchedShape shape = _HalfCircleNotchedShape(
      cornerRadius: 28.r,
      notchMargin: 1.w,
    );

    return SafeArea(
      top: false,
      minimum: EdgeInsets.fromLTRB(12.w, 0, 12.w, 10.h),
      child: CustomPaint(
        // 投影与发光画在底栏下方，形状本身由 ClipPath 裁出来。
        painter: _BottomBarBackdropPainter(
          shape: shape,
          guestDiameter: fabDiameter,
          guestCenterY: fabCenterY,
          shadowColor: Colors.black.withValues(alpha: isDark ? 0.50 : 0.20),
          elevation: 12,
          isGlowing: isAiActivated,
          isDark: isDark,
        ),
        // 前景描边，沿缺口曲线走一圈，缺口边缘才不会缺线。
        foregroundPainter: _BottomBarBorderPainter(
          shape: shape,
          guestDiameter: fabDiameter,
          guestCenterY: fabCenterY,
          gradient: isAiActivated ? aiActivationGradient : null,
          color: colorScheme.outline.withValues(alpha: isDark ? 0.34 : 0.18),
          strokeWidth: 1.1,
        ),
        child: ClipPath(
          clipper: _BottomBarClipper(
            shape: shape,
            guestDiameter: fabDiameter,
            guestCenterY: fabCenterY,
          ),
          child: ColoredBox(
            color: colorScheme.surface,
            child: SizedBox(
              height: height.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  children: <Widget>[
                    for (int i = 0; i < items.length; i++) ...<Widget>[
                      // 在正中间留出圆球占位，圆球本身由根页面的浮动按钮绘制。
                      if (i == items.length ~/ 2)
                        SizedBox(width: fabDiameter + 18.w),
                      Expanded(
                        child: _BottomBarItem(
                          item: items[i],
                          selected: currentIndex == i,
                          onTap: () => onTap(i),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 带半圆缺口的圆角矩形。
///
/// 缺口是圆球上沿切出来的，圆心位置由 [getOuterPathWithGuestMetrics] 传入，
/// 这样即使圆球比底栏还高也能正确相切。
class _HalfCircleNotchedShape extends NotchedShape {
  const _HalfCircleNotchedShape({
    required this.cornerRadius,
    required this.notchMargin,
  });

  final double cornerRadius;
  final double notchMargin;

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    if (guest == null || !host.overlaps(guest)) {
      return Path()
        ..addRRect(
          RRect.fromRectAndRadius(host, Radius.circular(cornerRadius)),
        );
    }

    return getOuterPathWithGuestMetrics(
      host,
      guestDiameter: guest.width,
      guestCenterY: guest.center.dy,
    );
  }

  Path getOuterPathWithGuestMetrics(
    Rect host, {
    required double guestDiameter,
    required double guestCenterY,
  }) {
    if (guestDiameter <= 0) {
      return Path()
        ..addRRect(
          RRect.fromRectAndRadius(host, Radius.circular(cornerRadius)),
        );
    }

    final double notchRadius = guestDiameter / 2.0 + notchMargin;
    final Offset center = Offset(host.center.dx, guestCenterY);

    // 缺口两侧的过渡长度与细缝，取固定值即可，与圆球尺寸无关。
    const double s1 = 15.0;
    const double s2 = 1.0;

    final double r = notchRadius;
    final double a = -1.0 * r - s2;
    final double b = host.top - center.dy;

    final double n2 = math.sqrt(b * b * r * r * (a * a + b * b - r * r));
    final double p2xA = ((a * r * r) - n2) / (a * a + b * b);
    final double p2xB = ((a * r * r) + n2) / (a * a + b * b);
    final double p2yA = math.sqrt(r * r - p2xA * p2xA);
    final double p2yB = math.sqrt(r * r - p2xB * p2xB);

    final List<Offset> p = List<Offset>.filled(6, Offset.zero);

    p[0] = Offset(a - s1, b);
    p[1] = Offset(a, b);
    final double cmpx = b < 0 ? -1.0 : 1.0;
    p[2] = cmpx * p2yA > cmpx * p2yB
        ? Offset(p2xA, p2yA)
        : Offset(p2xB, p2yB);
    p[3] = Offset(-1.0 * p[2].dx, p[2].dy);
    p[4] = Offset(-1.0 * p[1].dx, p[1].dy);
    p[5] = Offset(-1.0 * p[0].dx, p[0].dy);

    for (int i = 0; i < p.length; i++) {
      p[i] = p[i] + center;
    }

    final Path path = Path();
    path.moveTo(host.left + cornerRadius, host.top);
    path.lineTo(p[0].dx, p[0].dy);
    path.quadraticBezierTo(p[1].dx, p[1].dy, p[2].dx, p[2].dy);
    path.arcToPoint(
      p[3],
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );
    path.quadraticBezierTo(p[4].dx, p[4].dy, p[5].dx, p[5].dy);
    path.lineTo(host.right - cornerRadius, host.top);
    path.arcToPoint(
      Offset(host.right, host.top + cornerRadius),
      radius: Radius.circular(cornerRadius),
    );
    path.lineTo(host.right, host.bottom - cornerRadius);
    path.arcToPoint(
      Offset(host.right - cornerRadius, host.bottom),
      radius: Radius.circular(cornerRadius),
    );
    path.lineTo(host.left + cornerRadius, host.bottom);
    path.arcToPoint(
      Offset(host.left, host.bottom - cornerRadius),
      radius: Radius.circular(cornerRadius),
    );
    path.lineTo(host.left, host.top + cornerRadius);
    path.arcToPoint(
      Offset(host.left + cornerRadius, host.top),
      radius: Radius.circular(cornerRadius),
    );
    path.close();
    return path;
  }
}

class _BottomBarClipper extends CustomClipper<Path> {
  const _BottomBarClipper({
    required this.shape,
    required this.guestDiameter,
    required this.guestCenterY,
  });

  final _HalfCircleNotchedShape shape;
  final double guestDiameter;
  final double guestCenterY;

  @override
  Path getClip(Size size) {
    return shape.getOuterPathWithGuestMetrics(
      Offset.zero & size,
      guestDiameter: guestDiameter,
      guestCenterY: guestCenterY,
    );
  }

  @override
  bool shouldReclip(covariant _BottomBarClipper oldClipper) {
    return oldClipper.shape != shape ||
        oldClipper.guestDiameter != guestDiameter ||
        oldClipper.guestCenterY != guestCenterY;
  }
}

/// 底栏投影与激活态外发光。
///
/// 形状带缺口，`BoxShadow` 套不上，只能沿路径绘制：先用 `drawShadow`
/// 铺投影，再把同一条路径加粗描边并做高斯模糊，形成沿边缘的彩色光晕。
class _BottomBarBackdropPainter extends CustomPainter {
  const _BottomBarBackdropPainter({
    required this.shape,
    required this.guestDiameter,
    required this.guestCenterY,
    required this.shadowColor,
    required this.elevation,
    required this.isGlowing,
    required this.isDark,
  });

  final _HalfCircleNotchedShape shape;
  final double guestDiameter;
  final double guestCenterY;
  final Color shadowColor;
  final double elevation;

  /// 是否绘制 AI 渐变光晕。
  final bool isGlowing;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Path path = shape.getOuterPathWithGuestMetrics(
      rect,
      guestDiameter: guestDiameter,
      guestCenterY: guestCenterY,
    );

    canvas.drawShadow(path, shadowColor, elevation, true);

    if (!isGlowing) return;

    // 深色模式下压低透明度，避免光晕在暗背景上过曝。
    final double factor = isDark ? 0.55 : 1;
    final LinearGradient glowGradient = LinearGradient(
      colors: <Color>[
        for (final Color color in aiActivationGradientColors)
          color.withValues(alpha: 0.42 * factor),
      ],
    );

    final Paint glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9)
      ..shader = glowGradient.createShader(rect);

    canvas.drawPath(path, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _BottomBarBackdropPainter oldDelegate) {
    return oldDelegate.shape != shape ||
        oldDelegate.guestDiameter != guestDiameter ||
        oldDelegate.guestCenterY != guestCenterY ||
        oldDelegate.shadowColor != shadowColor ||
        oldDelegate.elevation != elevation ||
        oldDelegate.isGlowing != isGlowing ||
        oldDelegate.isDark != isDark;
  }
}

class _BottomBarBorderPainter extends CustomPainter {
  const _BottomBarBorderPainter({
    required this.shape,
    required this.guestDiameter,
    required this.guestCenterY,
    required this.gradient,
    required this.color,
    required this.strokeWidth,
  });

  final _HalfCircleNotchedShape shape;
  final double guestDiameter;
  final double guestCenterY;

  /// 非空时用渐变描边，否则用 [color] 单色。
  final LinearGradient? gradient;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Path path = shape.getOuterPathWithGuestMetrics(
      rect,
      guestDiameter: guestDiameter,
      guestCenterY: guestCenterY,
    );

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final LinearGradient? gradient = this.gradient;
    if (gradient != null) {
      paint.shader = gradient.createShader(rect);
    } else {
      paint.color = color;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BottomBarBorderPainter oldDelegate) {
    return oldDelegate.shape != shape ||
        oldDelegate.guestDiameter != guestDiameter ||
        oldDelegate.guestCenterY != guestCenterY ||
        oldDelegate.gradient != gradient ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class _BottomBarItem extends HookWidget {
  const _BottomBarItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AppBottomBarItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final bool isDark = context.isDark;
    final Color iconColor = selected
        ? colorScheme.primary
        : colorScheme.onSurface.withValues(alpha: 0.50);
    final Color labelColor = selected
        ? colorScheme.primary
        : colorScheme.onSurface.withValues(alpha: 0.44);

    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: onTap,
      child: SizedBox(
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: 42.w,
              height: 30.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: selected
                    ? colorScheme.primary.withValues(
                        alpha: isDark ? 0.16 : 0.10,
                      )
                    : Colors.transparent,
              ),
              child: Icon(
                selected ? item.filledIcon : item.outlinedIcon,
                size: 22.sp,
                color: iconColor,
              ),
            ),
            SizedBox(height: 2.h),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontFamily: AppFonts.primary,
                fontSize: 10.sp,
                color: labelColor,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                height: 1.2,
              ),
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
