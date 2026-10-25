import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// BuildContext 扩展，提供主题、尺寸与国际化快捷入口。
///
/// 用法：`context.l10n.homeTitle`、`context.colorScheme.primary`、`context.isDark`。
extension BuildContextExtensions on BuildContext {
  /// 国际化，用法：`context.l10n.homeTitle`。
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// 当前主题。
  ThemeData get theme => Theme.of(this);

  /// 当前文字主题。
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// 当前颜色方案。
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// 是否深色模式。
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// 屏幕逻辑宽度。
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// 屏幕逻辑高度。
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// 当前语言代码，返回 'zh' 或 'en'。
  String get languageCode => Localizations.localeOf(this).languageCode;

  bool get isChinese => languageCode == 'zh';

  bool get isEnglish => languageCode == 'en';
}
