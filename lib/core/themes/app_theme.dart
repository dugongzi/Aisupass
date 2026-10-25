import 'package:Aisupass/core/themes/app_colors.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:flutter/material.dart';

/// 应用主题构建器。
///
/// 亮色与暗色共用一套结构，只切换 [Brightness] 与表面色，
/// 保证底栏、设置卡片等自定义组件在两种模式下观感一致。
class AppTheme {
  AppTheme._();

  /// 亮色主题。
  static ThemeData light(Color seedColor) =>
      _build(seedColor, Brightness.light);

  /// 暗色主题。
  static ThemeData dark(Color seedColor) => _build(seedColor, Brightness.dark);

  static ThemeData _build(Color seedColor, Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    final Color scaffold = isDark
        ? AppColors.darkScaffold
        : AppColors.lightScaffold;
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    ).copyWith(
      surface: isDark ? AppColors.darkSurface : Colors.white,
    );

    return ThemeData(
      colorScheme: colorScheme,
      // 全局字体：阿里妈妈方圆体。
      fontFamily: AppFonts.primary,
      scaffoldBackgroundColor: scaffold,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: scaffold,
        foregroundColor: colorScheme.onSurface,
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withValues(alpha: isDark ? 0.24 : 0.12),
        thickness: 1,
        space: 1,
      ),
    );
  }
}
