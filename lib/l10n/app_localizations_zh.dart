// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'AiSuPass';

  @override
  String get homeTitle => '首页';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsGeneralSection => '通用';

  @override
  String get settingsAppearanceSection => '外观';

  @override
  String get themeModeTitle => '主题模式';

  @override
  String get themeModeSystem => '跟随系统';

  @override
  String get themeModeLight => '浅色';

  @override
  String get themeModeDark => '深色';

  @override
  String get themeColorTitle => '主题色';

  @override
  String get aiSettingTitle => 'AI 设置';

  @override
  String get chatTitle => '对话';

  @override
  String get languageTitle => '语言';

  @override
  String get errorTitle => '页面不存在';

  @override
  String errorNotFound(String location) {
    return '没有找到页面：$location';
  }

  @override
  String get errorBuildFailed => '路由构建失败';

  @override
  String get backToHome => '返回首页';
}
