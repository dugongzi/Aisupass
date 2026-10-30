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
  String get chatEmptyTitle => 'AI Escalation Assistant';

  @override
  String get chatEmptyHint =>
      'Describe your device and I will inspect it before suggesting an escalation plan';

  @override
  String get chatSuggestionDevice => 'Analyze my device';

  @override
  String get chatSuggestionRoot => 'Is this device already rooted?';

  @override
  String get chatSuggestionPlan => 'Recommend an escalation plan';

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
      'Escalate using currently known exploits';

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
  String get escalationTitle => 'Escalation';

  @override
  String get escalationSubtitle =>
      'Probe device capabilities and run escalation chains';

  @override
  String get escalationSectionDevice => 'Device';

  @override
  String get escalationSectionChains => 'Capability Matrix';

  @override
  String get escalationSectionTimeline => 'Timeline';

  @override
  String get escalationAvailable => 'Available';

  @override
  String get escalationUnavailable => 'Unavailable';

  @override
  String get escalationStart => 'Start';

  @override
  String get escalationCancel => 'Cancel';

  @override
  String get escalationRetry => 'Retry';

  @override
  String get escalationNoAvailableChain =>
      'No escalation chain is available on this device';

  @override
  String get escalationPlatformUnsupported =>
      'Escalation is not supported on this platform';

  @override
  String get escalationConfirmTitle => 'Run escalation?';

  @override
  String get escalationConfirmBody =>
      'This may modify system state and leave residue on failure.';

  @override
  String get escalationDangerLow => 'Low risk';

  @override
  String get escalationDangerMedium => 'Medium risk';

  @override
  String get escalationDangerHigh => 'High risk';

  @override
  String get escalationResidualWarning =>
      'A previous run left residual state; clean it up first';

  @override
  String get escalationHostConnecting => 'Connecting to privilege host…';

  @override
  String get escalationHostDisconnected => 'Privilege host disconnected';

  @override
  String get escalationPairingStart => 'Pair via wireless debugging';

  @override
  String get escalationPairingNotice =>
      'Enter the code in the notification shade without switching apps — leaving this screen invalidates the system pairing dialog.';

  @override
  String get escalationPairingWaiting =>
      'Waiting for the pairing code in notifications…';

  @override
  String get escalationPairingConnecting =>
      'Code accepted, establishing the debug connection…';

  @override
  String get escalationPairingSucceeded =>
      'Paired, privileged process is ready';

  @override
  String get escalationPairingFailed => 'Pairing failed';

  @override
  String get escalationIgniteStarting =>
      'Paired, starting the privileged process…';

  @override
  String get escalationIgniteRunning => 'Starting the privileged process…';

  @override
  String get escalationIgniteRetry => 'Retry starting privileged process';

  @override
  String get escalationIgniteFailed =>
      'Paired, but the privileged process did not start';

  @override
  String get escalationHostReady => 'Host ready (uid=2000)';

  @override
  String get escalationHostNotStarted =>
      'Host not started, it will launch after pairing';

  @override
  String get escalationHostDisconnect => 'Disconnect host';

  @override
  String get escalationHostDisconnecting => 'Disconnecting…';

  @override
  String get escalationHostDisconnectHint =>
      'The privileged process exits after disconnecting; pair again to relaunch it';

  @override
  String get escalationRunning => 'Running';

  @override
  String get escalationFailureDetail => 'Reason';

  @override
  String get escalationCopy => 'Copy';

  @override
  String get escalationCopied => 'Copied to clipboard';

  @override
  String get escalationExportRecord => 'Export records';

  @override
  String get escalationExportEmpty => 'No records to export';

  @override
  String get escalationRecordEmpty => 'No runs yet';

  @override
  String get escalationChainRootCheckName => 'Existing root check';

  @override
  String get escalationChainRootCheckDesc =>
      'Detect whether root access is already available';

  @override
  String get escalationChainKernelModuleName => 'Kernel module';

  @override
  String get escalationChainKernelModuleDesc =>
      'Gain privileges by loading a kernel module';

  @override
  String get escalationChainPayloadName => 'Payload chain';

  @override
  String get escalationChainPayloadDesc => 'Escalate using a bundled payload';

  @override
  String get escalationChainKernelExploitName => 'Kernel exploit';

  @override
  String get escalationChainKernelExploitDesc =>
      'Gain temporary privileges via a kernel vulnerability';

  @override
  String get escalationChainPageCacheName => 'PageCache';

  @override
  String get escalationChainPageCacheDesc =>
      'Escalate by writing through PageCache';

  @override
  String get escalationChainFakeName => 'Demo chain';

  @override
  String get escalationChainFakeDesc =>
      'Demo only; does not modify system state';

  @override
  String get escalationStageProbe => 'Probe';

  @override
  String get escalationStagePrepare => 'Prepare';

  @override
  String get escalationStageExecute => 'Execute';

  @override
  String get escalationStageVerify => 'Verify';

  @override
  String get escalationStageCleanup => 'Cleanup';

  @override
  String get escalationOutcomeSuccess => 'Succeeded';

  @override
  String get escalationOutcomePartial => 'Partially succeeded';

  @override
  String get escalationOutcomeFailed => 'Failed';

  @override
  String get escalationOutcomeUnsafe => 'Unsafe state';

  @override
  String get escalationOutcomeUnsupported => 'Unsupported';

  @override
  String get escalationOutcomeNotStarted => 'Not started';

  @override
  String get escalationDeviceSdk => 'Android SDK';

  @override
  String get escalationDeviceAbi => 'ABI';

  @override
  String get escalationDeviceKernel => 'Kernel';

  @override
  String get escalationDeviceSelinux => 'SELinux';

  @override
  String get escalationDeviceManufacturer => 'Manufacturer';

  @override
  String get escalationDeviceModel => 'Model';

  @override
  String get escalationReasonPlatformUnsupported =>
      'This chain is not supported on the current platform';

  @override
  String get escalationReasonAndroidTooOld => 'Android version is too old';

  @override
  String get escalationReasonDeviceNotSupported =>
      'Device is not in the supported list';

  @override
  String get escalationReasonProbeTimeout => 'Probe timed out';

  @override
  String get escalationReasonProbeFailed => 'Probe failed';

  @override
  String get escalationReasonNoRootBinary => 'No su binary found';

  @override
  String get escalationReasonNoSelinuxContext => 'No usable SELinux context';

  @override
  String get escalationReasonSelinuxEnforcing => 'SELinux is enforcing';

  @override
  String get escalationReasonShellUnavailable => 'Shell is unavailable';

  @override
  String get escalationReasonShellDenied => 'Shell execution was denied';

  @override
  String get escalationReasonShellTimeout => 'Shell execution timed out';

  @override
  String get escalationReasonPayloadMissing => 'Payload file is missing';

  @override
  String get escalationReasonPayloadMismatch =>
      'Payload does not match this device';

  @override
  String get escalationReasonCatalogCorrupted => 'Asset catalog is corrupted';

  @override
  String get escalationReasonKernelNotSupported => 'Kernel is not supported';

  @override
  String get escalationReasonKernelModuleLoadFailed =>
      'Failed to load the kernel module';

  @override
  String get escalationReasonKernelVersionMismatch => 'Kernel version mismatch';

  @override
  String get escalationReasonExecuteTimeout => 'Execution timed out';

  @override
  String get escalationReasonExecuteFailed => 'Execution failed';

  @override
  String get escalationReasonVerifyFailedAtExternal =>
      'External state verification failed';

  @override
  String get escalationReasonVerifyTimeout => 'Verification timed out';

  @override
  String get escalationReasonCleanupFailed => 'Cleanup failed';

  @override
  String get escalationReasonEnforceRestoreFailed =>
      'Failed to restore SELinux state';

  @override
  String get escalationReasonResidualLeft => 'Residual state left behind';

  @override
  String get escalationReasonHostDisconnected => 'Privilege host disconnected';

  @override
  String get escalationReasonHostAuthFailed =>
      'Privilege host authentication failed';

  @override
  String get escalationReasonHostPairingFailed =>
      'Privilege host pairing failed';

  @override
  String get escalationReasonUnknown => 'Unknown reason';
}
