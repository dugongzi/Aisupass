// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'AiSuPass';

  @override
  String get homeTitle => 'Home';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsGeneralSection => 'General';

  @override
  String get settingsAppearanceSection => 'Appearance';

  @override
  String get themeModeTitle => 'Theme Mode';

  @override
  String get themeModeSystem => 'System';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeDark => 'Dark';

  @override
  String get themeColorTitle => 'Accent Color';

  @override
  String get aiTitle => 'AI';

  @override
  String get activated => 'Activated';

  @override
  String get notActivated => 'Not Activated';

  @override
  String get rootTitle => 'ROOT';

  @override
  String get adbTitle => 'ADB';

  @override
  String get statusDetecting => 'Detecting';

  @override
  String adbActivatedWithType(String types) {
    return 'Activated ($types)';
  }

  @override
  String get adbTypeWifi => 'Wi-Fi';

  @override
  String get adbTypeUsb => 'USB';

  @override
  String get listSeparator => ', ';

  @override
  String get refreshTooltip => 'Refresh';

  @override
  String get deviceInfoTitle => 'Device Info';

  @override
  String get deviceInfoCopy => 'Copy';

  @override
  String get deviceInfoCopied => 'Copied to clipboard';

  @override
  String get deviceInfoUnavailable => 'Failed to read device info';

  @override
  String get deviceOsVersion => 'OS Version';

  @override
  String get deviceApiLevel => 'API Level';

  @override
  String get deviceModel => 'Device Model';

  @override
  String get deviceCpuAbi => 'CPU Architecture';

  @override
  String get deviceKernelVersion => 'Kernel Version';

  @override
  String get deviceSecurityPatch => 'Android Security Update';

  @override
  String get deviceBaseband => 'Baseband Version';

  @override
  String get deviceBuildNumber => 'Build Number';

  @override
  String get deviceSotaVersion => 'SOTA Version';

  @override
  String get deviceSelinux => 'SELinux';

  @override
  String get deviceAppVersion => 'App Version';

  @override
  String get aiSettingTitle => 'AI Settings';

  @override
  String get chatTitle => 'Chat';

  @override
  String get languageTitle => 'Language';

  @override
  String get errorTitle => 'Page Not Found';

  @override
  String errorNotFound(String location) {
    return 'No page found for: $location';
  }

  @override
  String get errorBuildFailed => 'Failed to build route';

  @override
  String get backToHome => 'Back to Home';
}
