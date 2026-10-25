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
  String get aiTitle => 'AI';

  @override
  String get activated => '已激活';

  @override
  String get notActivated => '未激活';

  @override
  String get rootTitle => 'ROOT';

  @override
  String get adbTitle => 'ADB';

  @override
  String get statusDetecting => '检测中';

  @override
  String get adbActivatedBoth => '已激活（无线、有线）';

  @override
  String get adbActivatedWifi => '已激活（无线）';

  @override
  String get adbActivatedUsb => '已激活（有线）';

  @override
  String get deviceInfoTitle => '设备信息';

  @override
  String get deviceInfoCopy => '复制';

  @override
  String get deviceInfoCopied => '已复制到剪贴板';

  @override
  String get deviceInfoUnavailable => '设备信息读取失败';

  @override
  String get deviceOsVersion => '系统版本';

  @override
  String get deviceApiLevel => 'API Level';

  @override
  String get deviceModel => '设备型号';

  @override
  String get deviceCpuAbi => 'CPU 架构';

  @override
  String get deviceKernelVersion => '内核版本';

  @override
  String get deviceSecurityPatch => 'Android 安全更新';

  @override
  String get deviceBaseband => '基带版本';

  @override
  String get deviceBuildNumber => '版本号';

  @override
  String get deviceSotaVersion => 'SOTA 版本';

  @override
  String get deviceSelinux => 'SELinux';

  @override
  String get deviceAppVersion => '应用版本';

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
