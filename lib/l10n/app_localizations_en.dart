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
  String get settingsAiSection => 'AI';

  @override
  String get aiConfigEntrySubtitle => 'Manage model providers and API keys';

  @override
  String get aiConfigTitle => 'AI Configurations';

  @override
  String get aiConfigNew => 'New Configuration';

  @override
  String get aiConfigCurrent => 'Active';

  @override
  String get aiConfigList => 'Configurations';

  @override
  String get aiConfigEmpty =>
      'No AI configuration yet. Tap + in the top right to create one.';

  @override
  String get aiConfigBuiltin => 'Built-in';

  @override
  String get aiConfigBuiltinHint =>
      'The built-in endpoint is fixed. Enter your API key, then refresh to load models.';

  @override
  String get aiConfigGetKey => 'Get API Key';

  @override
  String get aiConfigUse => 'Use';

  @override
  String get aiConfigSwitched => 'Configuration switched';

  @override
  String get aiConfigDelete => 'Delete';

  @override
  String aiConfigDeleteConfirm(String name) {
    return 'Delete configuration \"$name\"?';
  }

  @override
  String get aiConfigDeleted => 'Configuration deleted';

  @override
  String get aiConfigEdit => 'Edit';

  @override
  String get aiConfigEditTitle => 'Edit Configuration';

  @override
  String get aiDelete => 'Delete';

  @override
  String get aiCancel => 'Cancel';

  @override
  String get aiApiKeyMissing => 'API key not set';

  @override
  String get aiModelUnset => 'No model selected';

  @override
  String get aiQuickStart => 'Quick Start';

  @override
  String get aiQuickStartHint =>
      'Pick a provider to fill in the endpoint and protocol';

  @override
  String get aiConnectionSection => 'Connection';

  @override
  String get aiConfigName => 'Configuration Name';

  @override
  String get aiConfigNameHint => 'e.g. DeepSeek Main';

  @override
  String get aiBaseUrl => 'API Base URL';

  @override
  String get aiBaseUrlHint => 'https://api.deepseek.com/v1';

  @override
  String get aiApiKey => 'API Key';

  @override
  String get aiApiKeyHint => 'sk-...';

  @override
  String get aiApiType => 'Protocol';

  @override
  String get aiModelName => 'Model';

  @override
  String get aiModelHint => 'Fetch the model list first';

  @override
  String get aiModelRequired => 'Fetch the model list first';

  @override
  String get aiModelPickHint => 'Pick a model from the fetched list';

  @override
  String get aiModelSelect => 'Select Model';

  @override
  String get aiModelSearch => 'Search models';

  @override
  String get aiModelEmpty => 'No matching models';

  @override
  String get aiModelLoad => 'Fetch Models';

  @override
  String aiModelLoadFailed(String message) {
    return 'Failed to fetch models: $message';
  }

  @override
  String get aiAdvancedSection => 'Advanced';

  @override
  String get aiAdvancedHint =>
      'Max output tokens and temperature; leave blank for server defaults';

  @override
  String get aiMaxTokens => 'Max Output Tokens';

  @override
  String get aiMaxTokensHint => 'Leave blank for default';

  @override
  String get aiTemperature => 'Temperature';

  @override
  String get aiTemperatureHint => '0 - 2, leave blank for default';

  @override
  String get aiConnIdle => 'Connectivity is verified before saving';

  @override
  String get aiConnTesting => 'Verifying connection…';

  @override
  String aiConnOk(int count) {
    return 'Connected, $count models available';
  }

  @override
  String aiConnFailed(String message) {
    return 'Connection failed: $message';
  }

  @override
  String get aiSave => 'Save';

  @override
  String get aiSaveSuccess => 'Configuration saved';

  @override
  String aiSaveFailed(String message) {
    return 'Failed to save: $message';
  }

  @override
  String get aiFieldRequired => 'This field is required';

  @override
  String get aiInvalidUrl =>
      'Enter an address starting with http:// or https://';

  @override
  String aiErrorAuth(int code) {
    return 'Invalid API key or insufficient permission (HTTP $code)';
  }

  @override
  String get aiErrorNotFound =>
      'Endpoint not found, check the API URL (HTTP 404)';

  @override
  String aiErrorHttp(int code, String message) {
    return 'Request failed (HTTP $code): $message';
  }

  @override
  String aiErrorNetwork(String message) {
    return 'Network request failed: $message';
  }

  @override
  String get chatTitle => 'Chat';

  @override
  String get aiQuickPanelTitle => 'AI Escalation';

  @override
  String get aiQuickPanelSubtitle => 'Choose a way to gain root access';

  @override
  String get aiQuickEscalateTitle => 'AI Escalation';

  @override
  String get aiQuickEscalateDesc =>
      'Analyze your device and generate an exploit plan automatically';

  @override
  String get manualQuickEscalateTitle => 'Manual Escalation';

  @override
  String get manualQuickEscalateDesc =>
      'Run custom commands and scripts step by step';

  @override
  String get manualQuickEscalateComingSoon =>
      'Manual escalation is coming soon';

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

  @override
  String get commonLoadFailed => 'Failed to load, please try again';

  @override
  String get commonRetry => 'Retry';
}
