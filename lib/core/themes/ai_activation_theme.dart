import 'package:flutter/material.dart';

/// AI 激活卡片的高亮渐变色。
///
/// 从青蓝过渡到紫再到暖橙，用于激活态的描边、图标与标题。
const List<Color> aiActivationGradientColors = <Color>[
  Color(0xFF70D7F9),
  Color(0xFFAD98FF),
  Color(0xFFFFB385),
];

/// 激活态渐变，描边与文字共用。
const LinearGradient aiActivationGradient = LinearGradient(
  colors: aiActivationGradientColors,
);

/// 激活态外发光。
///
/// 深色模式下降低透明度，避免发光在暗背景上过曝。
List<BoxShadow> buildAiActivationGlowShadows({bool isDark = false}) {
  final double factor = isDark ? 0.6 : 1;

  return <BoxShadow>[
    BoxShadow(
      color: aiActivationGradientColors.first.withValues(alpha: 0.3 * factor),
      blurRadius: 15,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: aiActivationGradientColors[1].withValues(alpha: 0.3 * factor),
      blurRadius: 20,
      offset: const Offset(5, 5),
    ),
  ];
}
