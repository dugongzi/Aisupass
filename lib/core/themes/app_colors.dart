import 'package:flutter/material.dart';

/// 应用颜色常量。
class AppColors {
  AppColors._();

  /// 默认主题色。
  static const Color seed = Color(0xFF673AB7);

  /// 主题色候选，设置页调色盘按此顺序展示。
  static const List<Color> themeSeeds = <Color>[
    seed,
    Color(0xFF3F7DF6),
    Color(0xFF2FA8A0),
    Color(0xFF43A047),
    Color(0xFFE0A22E),
    Color(0xFFE2694A),
    Color(0xFFD9538C),
  ];

  /// 浅色模式页面底色，与白色卡片形成层次。
  static const Color lightScaffold = Color(0xFFF5F6F8);

  /// 深色模式页面底色。
  static const Color darkScaffold = Color(0xFF121214);

  /// 深色模式卡片、底栏等表面色。
  static const Color darkSurface = Color(0xFF1C1C1F);
}
