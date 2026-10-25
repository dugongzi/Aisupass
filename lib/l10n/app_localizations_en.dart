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
