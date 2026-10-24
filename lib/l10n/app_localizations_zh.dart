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
  String get desktopHomeTitle => '首页（桌面端）';

  @override
  String get settingsTitle => '设置';

  @override
  String get desktopSettingsTitle => '设置（桌面端）';

  @override
  String get aiSettingTitle => 'AI 设置';

  @override
  String get chatTitle => '对话';

  @override
  String get languageTitle => '语言';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => '英文';

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
