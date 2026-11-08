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
  String get aiTestTitle => 'Test';

  @override
  String get aiTestHint =>
      'Send a test message and watch the response stream in.';

  @override
  String get aiTestMessageLabel => 'Test message';

  @override
  String get aiTestMessageDefault => 'Hi';

  @override
  String get aiTestSend => 'Send';

  @override
  String get aiTestStateStreaming => 'Streaming';

  @override
  String get aiTestStateSuccess => 'Success';

  @override
  String get aiTestStateFailed => 'Failed';

  @override
  String get aiTestStateUnknown => 'No response';

  @override
  String get aiTestDuration => 'Duration';

  @override
  String get aiTestReply => 'Reply';

  @override
  String get aiTestError => 'Error';

  @override
  String get aiTestRaw => 'Raw response';

  @override
  String get aiTestCopy => 'Copy';

  @override
  String get aiTestCopied => 'Copied to clipboard';

  @override
  String get aiTestNoKey => 'Enter the API key first';

  @override
  String get aiTestNoModel => 'Select a model first';

  @override
  String get aiTestChunks => 'chunks';

  @override
  String get aiTestFirstToken => 'first token';

  @override
  String get aiTestNotStreamed => 'not streamed';

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
  String get chatInputHint => 'Describe your device, or ask anything';

  @override
  String get chatSend => 'Send';

  @override
  String get chatStop => 'Stop';

  @override
  String get chatNewSession => 'New chat';

  @override
  String get chatReasoning => 'Reasoning';

  @override
  String get chatThinking => 'Thinking…';

  @override
  String get chatThought => 'Thought for a while';

  @override
  String get chatToolRunning => 'Running';

  @override
  String get chatToolSucceeded => 'Done';

  @override
  String get chatToolFailed => 'Failed';

  @override
  String get chatToolArguments => 'Arguments';

  @override
  String get chatToolResult => 'Result';

  @override
  String get chatCopied => 'Copied to clipboard';

  @override
  String get chatNoticeToolLimit => 'Tool call limit reached, try rephrasing';

  @override
  String get chatNoticeEmptyReply => 'The model returned no content';

  @override
  String get chatIssueNoConfig => 'Finish setting up an AI config first';

  @override
  String get chatEmptyTitle => 'AI Device Assistant';

  @override
  String get chatEmptyHint =>
      'Describe your device and I will inspect it before answering';

  @override
  String get chatSuggestionDevice => 'Analyze my device';

  @override
  String get chatSuggestionRoot => 'Is this device already rooted?';

  @override
  String get chatSuggestionPlan => 'How is the ADB status of this device?';

  @override
  String get chatSessions => 'Conversations';

  @override
  String get chatSessionEmpty => 'No conversations';

  @override
  String get chatGenerating => 'Generating…';

  @override
  String chatSessionReady(String title) {
    return '\"$title\" is ready';
  }

  @override
  String get chatUntitled => 'Untitled';

  @override
  String get chatRename => 'Rename';

  @override
  String get chatRenameHint => 'Enter a conversation name';

  @override
  String get chatDeleteSession => 'Delete conversation';

  @override
  String chatDeleteConfirm(String title) {
    return 'This cannot be undone. Delete \"$title\"?';
  }

  @override
  String get chatJustNow => 'Just now';

  @override
  String chatMinutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String chatHoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String chatDaysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String chatToolGroupSummary(int count) {
    return '$count tools executed';
  }

  @override
  String chatToolMoreLines(int count) {
    return 'Show all $count lines';
  }

  @override
  String get chatToolCollapse => 'Collapse';

  @override
  String get chatToolReadDevice => 'Read device info';

  @override
  String get chatToolCheckRoot => 'Check ROOT status';

  @override
  String get chatToolCheckAdb => 'Check ADB status';

  @override
  String chatThoughtFor(String seconds) {
    return 'Thought for ${seconds}s';
  }

  @override
  String chatUsageTokens(int count) {
    return '$count tokens';
  }

  @override
  String chatElapsed(String seconds) {
    return 'Took ${seconds}s';
  }

  @override
  String get chatActionCopy => 'Copy';

  @override
  String get chatActionShare => 'Share';

  @override
  String get chatActionRegenerate => 'Regenerate';

  @override
  String get chatShareFailed => 'Share failed, please try again';

  @override
  String get aiQuickPanelTitle => 'AI Assistant';

  @override
  String get aiQuickChatTitle => 'AI Chat';

  @override
  String get aiQuickChatDesc =>
      'Read the device environment and answer your questions';

  @override
  String get aiQuickEscalationTitle => 'Manual root';

  @override
  String get aiQuickEscalationDesc =>
      'Match a local kernel payload and gain ROOT manually';

  @override
  String get escalationTitle => 'Manual root';

  @override
  String get escalationTerminalClosed =>
      'The shell session has ended — typing again reconnects automatically';

  @override
  String escalationShellConnected(int uid) {
    return 'shell connected (uid=$uid)';
  }

  @override
  String get escalationShellDisconnected =>
      'Not connected — pair wireless debugging on the home screen first';

  @override
  String get escalationInvokeFailed => 'Invocation failed';

  @override
  String get escalationTimedOutTag => ' (timed out)';

  @override
  String get escalationExploitButton => 'Start root';

  @override
  String get escalationExploitStarted => 'Starting root…';

  @override
  String get escalationHandoffSection => 'Hand off root';

  @override
  String get escalationHandoffCurrent => 'Hand off to current manager';

  @override
  String escalationHandoffRunning(String manager) {
    return 'Handing off to $manager…';
  }

  @override
  String escalationHandoffManagerMissing(String manager, String package) {
    return '$manager is not installed on this device: no libksud.so found for package $package. Install $manager first, then retry.';
  }

  @override
  String get escalationHandoffNoRoot =>
      'No root right now: the payload did not succeed, or the temporary root is already gone. Run root from the menu first, then hand off.';

  @override
  String escalationHandoffFailed(int code) {
    return 'Handoff failed (exit code $code). Common causes: manager version does not match the kernel module, permission was denied, or the manager is upgrading.';
  }

  @override
  String get escalationHandoffFailedNoCode =>
      'Handoff failed: the command never ran, so there is no exit code. Check whether permission was denied or the manager is upgrading.';

  @override
  String get escalationHandoffReadManagerFailed =>
      'Handoff failed: could not read the selected root manager';

  @override
  String get escalationMenuTitle => 'More actions';

  @override
  String get escalationMenuPayloadCatalog => 'View payload catalog';

  @override
  String get escalationPayloadCatalogTitle => 'Payload catalog';

  @override
  String escalationPayloadCatalogCount(int count) {
    return '$count entries';
  }

  @override
  String get escalationPayloadCatalogEmpty =>
      'The catalog has no payload entries';

  @override
  String get escalationPayloadCatalogSearch =>
      'Search model, vendor or file name';

  @override
  String get escalationPayloadCatalogNoMatch => 'No payload matches';

  @override
  String get escalationPayloadKernelUnknown => 'Kernel unknown';

  @override
  String get escalationPayloadKernelAgnostic => 'Any kernel';

  @override
  String escalationPayloadManualStarted(String name) {
    return 'Escalating with $name…';
  }

  @override
  String get escalationPayloadConfirmTitle => 'Escalate with this payload?';

  @override
  String get escalationPayloadConfirmModel => 'Model';

  @override
  String get escalationPayloadConfirmVendor => 'Vendor';

  @override
  String get escalationPayloadConfirmKernel => 'Kernel';

  @override
  String get escalationPayloadConfirmLibrary => 'File';

  @override
  String get escalationPayloadConfirmBody =>
      'This payload will actually run on the device and may cause instability or a reboot. Make sure the model and kernel version match before continuing.';

  @override
  String get escalationPayloadConfirmAction => 'Start';

  @override
  String get escalationMenuClear => 'Clear screen';

  @override
  String get escalationCopy => 'Copy selection';

  @override
  String get escalationCopied => 'Selection copied';

  @override
  String get escalationCopyEmpty =>
      'Nothing selected — long-press the terminal to select text first';

  @override
  String escalationOutputTruncated(int bytes) {
    return 'Too much output — the earliest $bytes bytes were dropped (only the newest part is kept)';
  }

  @override
  String escalationExecStartFailed(String reason) {
    return 'Command could not start: $reason';
  }

  @override
  String get escalationExecReasonEmpty => 'empty command';

  @override
  String get escalationExecReasonNotReady => 'shell channel not connected';

  @override
  String get escalationExecReasonStreamFailed =>
      'stream rejected or connection dropped';

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

  @override
  String get shellPairingStart => 'Pair over wireless debugging';

  @override
  String get shellPairingNotice =>
      'Tap, then enter the code shown on the device in the notification';

  @override
  String get shellPairingWaitingCode => 'Waiting for the pairing code…';

  @override
  String get shellPairingPairing => 'Pairing…';

  @override
  String get shellPairingConnecting => 'Code received, connecting…';

  @override
  String get shellPairingCancel => 'Cancel';

  @override
  String get shellPairingRetry => 'Retry';

  @override
  String get shellConnected => 'Shell connected';

  @override
  String shellConnectedUid(int uid) {
    return 'Shell connected (uid=$uid)';
  }

  @override
  String get shellDisconnected => 'Shell not connected';

  @override
  String get shellCopy => 'Copy';

  @override
  String get shellCopied => 'Copied to clipboard';

  @override
  String get shellReasonHostAuthFailed =>
      'Pairing authentication failed, please retry';

  @override
  String get shellReasonHostDisconnected => 'Connection lost';

  @override
  String get shellReasonPairingTimeout => 'Pairing timed out, please retry';

  @override
  String get shellReasonDeviceRebooted => 'Device rebooted, connection dropped';

  @override
  String get shellReasonCancelled => 'Pairing cancelled';

  @override
  String get shellReasonHostPairingFailed => 'Pairing failed, please retry';

  @override
  String get rootManagerPillTooltip => 'Choose root manager';

  @override
  String get rootManagerTitle => 'Root manager';

  @override
  String get rootManagerCurrent => 'Current';

  @override
  String rootManagerSwitched(String manager) {
    return 'Switched to $manager';
  }

  @override
  String rootManagerSaveFailed(String message) {
    return 'Save failed: $message';
  }
}
