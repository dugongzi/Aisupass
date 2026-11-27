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
  String get settingsAboutSection => 'About';

  @override
  String get settingsAboutVersionTitle => 'Version';

  @override
  String get settingsAboutWebsiteTitle => 'Website';

  @override
  String get updateCheckTitle => 'Check for Updates';

  @override
  String updateCurrentVersion(String version, String buildNumber) {
    return 'Current version $version ($buildNumber)';
  }

  @override
  String get updateAvailableTitle => 'New Version Available';

  @override
  String updateAvailableVersion(String version) {
    return 'Version $version';
  }

  @override
  String get updateNotesTitle => 'What\'s New';

  @override
  String get updateNotesFallback => 'No release notes';

  @override
  String get updateNow => 'Update Now';

  @override
  String get updateLater => 'Later';

  @override
  String get updateLatest => 'You\'re up to date';

  @override
  String get updateCheckFailed =>
      'Failed to check for updates. Try again later.';

  @override
  String get updateNotConfigured => 'Update endpoint not configured';

  @override
  String get announcementTitle => 'Latest Notice';

  @override
  String get announcementClose => 'Got it';

  @override
  String get announcementTutorial => 'Get Tutorial';

  @override
  String get settingsAboutRepoTitle => 'Repository';

  @override
  String get settingsAboutLicenseTitle => 'License';

  @override
  String get settingsAboutLicenseSubtitle => 'GNU General Public License v3.0';

  @override
  String get openSourceLicensePageTitle => 'Licenses';

  @override
  String get licenseDocProjectTitle => 'Project License';

  @override
  String get licenseDocThirdPartyTitle => 'Third-party';

  @override
  String get licenseDocApacheTitle => 'Apache-2.0';

  @override
  String get licenseDocGpl2Title => 'GPL-2.0';

  @override
  String get settingsAboutThirdPartyTitle => 'Third-party Notices';

  @override
  String get settingsAboutThirdPartySubtitle =>
      'Component credits and licenses';

  @override
  String get openSourceLicenseLoadFailed => 'Failed to load license text';

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
  String get adbWifiOff => 'Wireless debugging is off';

  @override
  String get adbGoEnableWifi => 'Turn on wireless debugging';

  @override
  String get adbWifiOffHintFirst => 'Come back here and enter the pairing code';

  @override
  String get adbWifiOffHintPaired => 'It reconnects automatically once enabled';

  @override
  String get adbReconnecting => 'Reconnecting…';

  @override
  String get adbWifiDetectedConnected =>
      'Wireless debugging enabled; reconnected';

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
  String get aiBuiltinGetKey => 'Get key in app';

  @override
  String get aiBuiltinGroupUnbound => 'Group: not bound';

  @override
  String aiBuiltinCurrentGroup(String name) {
    return 'Group: $name';
  }

  @override
  String get aiBuiltinLoginTitle => 'Sign in to Muxue';

  @override
  String get aiBuiltinLoginDesktopUnsupported =>
      'The in-app browser is available on Android only. Sign in with a system browser, then enter the API key here.';

  @override
  String get aiBuiltinOpenSite => 'Open sign-in page';

  @override
  String get aiBuiltinLoginGuideTitle => 'Register or sign in here';

  @override
  String get aiBuiltinLoginGuideBody =>
      'Email must be QQ / Gmail / 163. Make sure the account has credit. Existing accounts can sign in directly.';

  @override
  String get aiBuiltinLoginDetected => 'Signed in, loading groups';

  @override
  String get aiBuiltinCreating => 'Creating key';

  @override
  String get aiBuiltinLoginDoneTitle => 'Key saved to the built-in config';

  @override
  String get aiBuiltinLoginFailedTitle => 'Action not completed';

  @override
  String get aiBuiltinLoginLoadFailed => 'Page failed to load';

  @override
  String get aiBuiltinLoginLoadTimeout =>
      'Page load timed out. Check your network and retry.';

  @override
  String get aiBuiltinRetry => 'Retry';

  @override
  String get aiBuiltinReload => 'Reload page';

  @override
  String get aiBuiltinCancel => 'Cancel';

  @override
  String get aiBuiltinContinue => 'Continue';

  @override
  String get aiBuiltinPlatformTitle => 'Choose a provider';

  @override
  String get aiBuiltinPlatformSearchHint => 'Search providers';

  @override
  String get aiBuiltinPlatformEmpty =>
      'No providers available. You can enter a key manually.';

  @override
  String aiBuiltinPlatformMeta(int groups, int models) {
    return '$groups groups · $models models';
  }

  @override
  String get aiBuiltinGroupTitle => 'Choose a group';

  @override
  String get aiBuiltinGroupSearchHint => 'Search groups';

  @override
  String get aiBuiltinGroupEmpty =>
      'No groups under this provider. Go back and pick another provider.';

  @override
  String get aiBuiltinMonitorHint =>
      'Groups differ a lot in stability. Check the channel status first and pick the group with the most green (online) nodes.';

  @override
  String get aiBuiltinMonitorOpen => 'Channel status';

  @override
  String get aiBuiltinGroupExclusive => 'Exclusive';

  @override
  String aiBuiltinGroupMeta(String rate, int count) {
    return 'rate x$rate · $count models';
  }

  @override
  String get aiBuiltinModelTitle => 'Choose a model';

  @override
  String get aiBuiltinModelSearchHint => 'Search models';

  @override
  String get aiBuiltinModelEmpty =>
      'No model in this group. Go back and pick another group.';

  @override
  String get aiBuiltinCopyKey => 'Copy key';

  @override
  String get aiBuiltinKeyCopied => 'Key copied';

  @override
  String get aiBuiltinFinish => 'Done';

  @override
  String get aiBuiltinCreateInWeb => 'Create manually on the web';

  @override
  String get aiBuiltinWalletTitle => 'Account credit';

  @override
  String get aiBuiltinWalletBalance => 'Current credit';

  @override
  String get aiBuiltinWalletLow =>
      'Credit is low. Top up soon or requests will start failing.';

  @override
  String get aiBuiltinWalletGetCredit => 'Get credit';

  @override
  String get aiBuiltinWalletRedeem => 'Redeem code';

  @override
  String get aiBuiltinWalletRefresh => 'Refresh credit';

  @override
  String get aiBuiltinWalletFailed => 'Failed to load credit';

  @override
  String get aiBuiltinWalletRelogin => 'Sign in again';

  @override
  String get aiBuiltinWalletRedeemTitle => 'Redeem code';

  @override
  String get aiBuiltinWalletRedeemHint => 'Enter the redeem code';

  @override
  String get aiBuiltinWalletRedeemConfirm => 'Redeem';

  @override
  String get aiBuiltinWalletRedeemSuccess => 'Redeemed. Credit refreshed.';

  @override
  String aiBuiltinWalletRedeemFailed(String message) {
    return 'Redeem failed: $message';
  }

  @override
  String get aiBuiltinChangeGroup => 'Switch group';

  @override
  String get aiBuiltinChangeGroupNoKey =>
      'Get the key first, then you can switch groups';

  @override
  String aiBuiltinChangeGroupSuccess(String name) {
    return 'Switched to $name';
  }

  @override
  String aiBuiltinChangeGroupNeedModel(String name) {
    return 'Switched to $name. Pick a model again.';
  }

  @override
  String aiBuiltinChangeGroupFailed(String message) {
    return 'Failed to switch group: $message';
  }

  @override
  String get aiKeyFormatTitle => 'Key may be in the wrong format';

  @override
  String get aiKeyFormatBody =>
      'The key you entered does not start with sk-, so it may not work. Get one in one tap with Muxue AI instead of finding a key yourself.';

  @override
  String get aiKeyFormatGoBuiltin => 'Open Muxue AI settings';

  @override
  String get aiKeyFormatSkip => 'Not now';

  @override
  String get aiProbeNotOkTitle => 'Status code is not 200';

  @override
  String aiProbeNotOkBody(int code) {
    return 'The test returned status code $code. The current group\'s channels may be unhealthy. View channel status?';
  }

  @override
  String get aiProbeSaveAnyway => 'Save anyway';

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
  String get aiReset => 'Reset';

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
  String get chatNoticeAwaitingUser =>
      'Waiting for you to finish above, then continuing';

  @override
  String get chatNoticeEmptyReply => 'The model returned no content';

  @override
  String get chatIssueNoConfig => 'Finish setting up an AI config first';

  @override
  String get chatErrorGoConfig => 'Open AI settings';

  @override
  String get chatEmptyTitle => 'AISUPASS';

  @override
  String get chatEmptyHint =>
      'Tell me what you need and I\'ll work out the best escalation path';

  @override
  String get chatSuggestionRom => 'Find the ROM package for my device';

  @override
  String get chatSuggestionEscalation =>
      'Analyze the escalation options for my device';

  @override
  String get chatSuggestionSupport => 'Get technical support';

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
  String get chatCodeLabel => 'Code';

  @override
  String get chatCodeExpand => 'Show all';

  @override
  String chatCodeLines(int lines) {
    return '$lines lines';
  }

  @override
  String get chatImageLabel => 'Image';

  @override
  String get chatToolReadDevice => 'Read device info';

  @override
  String get chatToolCheckRoot => 'Check ROOT status';

  @override
  String get chatToolCheckAdb => 'Check ADB status';

  @override
  String get chatToolExecAdbShell => 'Run adb shell command';

  @override
  String get chatToolRequestAdbPairing => 'Request wireless debugging pairing';

  @override
  String get chatToolReadStellarStatus => 'Read Stellar service status';

  @override
  String get chatToolWebSearch => 'Search the web';

  @override
  String get chatToolCoolapkLogin => 'Check Coolapk sign-in';

  @override
  String get chatToolCoolapkSearch => 'Search Coolapk';

  @override
  String get chatToolCoolapkFeedDetail => 'Read Coolapk post body';

  @override
  String get chatToolCoolapkFeedAllReplies => 'Read all Coolapk comments';

  @override
  String get chatToolCoolapkOfferDownload => 'Offer Coolapk download links';

  @override
  String get chatCoolapkNoReplies => 'No comments on this post';

  @override
  String get chatCoolapkNoRepliesHint =>
      'The comment list came back empty. Open the original post to check for new replies.';

  @override
  String get chatCoolapkOpenPost => 'Open in Coolapk';

  @override
  String get chatCoolapkOpenFailed =>
      'Coolapk not installed or failed to open, link copied';

  @override
  String get chatCoolapkCaptchaTitle => 'Coolapk wants a captcha';

  @override
  String get chatCoolapkCaptchaHint =>
      'Coolapk put a captcha wall on its post detail endpoint. Clear it once and post bodies plus comments read normally.';

  @override
  String get chatCoolapkCaptchaAction => 'Verify';

  @override
  String get chatCoolapkCaptchaPassedTitle => 'Verification passed';

  @override
  String get chatCoolapkCaptchaPassedHint =>
      'Continuing to read the post, no further action needed.';

  @override
  String get chatCoolapkCaptchaPassedAction => 'Passed';

  @override
  String chatCoolapkRomFound(int count) {
    return 'Found $count download links';
  }

  @override
  String get chatCoolapkDownloadFailed => 'Cannot open directly, link copied';

  @override
  String get chatCoolapkLoginRequiredTitle => 'Coolapk login required';

  @override
  String get chatCoolapkLoginRequiredHint =>
      'This content needs a Coolapk account. Sign in, then ask me to retry.';

  @override
  String get chatCoolapkLoginAction => 'Sign in to Coolapk';

  @override
  String get coolapkLoginTitle => 'Coolapk sign in';

  @override
  String get coolapkLoginHint =>
      'The token is read automatically once you sign in. If nothing happens, tap the button below.';

  @override
  String get coolapkLoginThirdPartyHint =>
      'WeChat and Weibo sign-in hand off to their own apps; come back here after authorising. If nothing opens, use your phone number or password instead.';

  @override
  String get coolapkLoginNotDetected =>
      'No valid sign-in detected. Finish signing in and try again.';

  @override
  String get coolapkLoginCaptureAction => 'I have signed in, read the token';

  @override
  String get coolapkLoginClearCookie => 'Clear login cookie';

  @override
  String get coolapkLoginClearCookieConfirm =>
      'You will need to sign in to Coolapk again.';

  @override
  String get coolapkLoginCookieCleared => 'Login cookie cleared';

  @override
  String get coolapkLoginSucceeded => 'Signed in to Coolapk';

  @override
  String get coolapkCaptchaTitle => 'Coolapk captcha';

  @override
  String get coolapkCaptchaHint =>
      'Slide to finish the check. The page closes itself once it passes.';

  @override
  String get coolapkCaptchaRetry => 'Reload';

  @override
  String get coolapkCaptchaSucceeded =>
      'Verification passed, send your message again';

  @override
  String get coolapkCaptchaFailed => 'Verification failed, please retry';

  @override
  String get coolapkCaptchaSaveFailed =>
      'Could not save the verification result, please retry';

  @override
  String get coolapkCaptchaCopyError => 'Copy error message';

  @override
  String get coolapkCaptchaLoading => 'Loading the verification widget…';

  @override
  String get coolapkCaptchaErrorCopied => 'Error message copied';

  @override
  String get coolapkCaptchaDesktopUnsupported =>
      'The captcha has to be cleared on an Android device.';

  @override
  String get coolapkLoginCaptureFailed =>
      'No login token found. Make sure you are signed in and retry.';

  @override
  String get coolapkLoginDesktopUnsupported =>
      'Coolapk sign in currently works on Android only; other platforms cannot capture the session';

  @override
  String get chatToolOpenInBrowser => 'Open page in browser';

  @override
  String get chatToolFetchWebPage => 'Fetch page source';

  @override
  String get chatBrowserPanelTitle => 'Web page';

  @override
  String get chatBrowserOpen => 'Open in browser';

  @override
  String get chatBrowserOpenInApp => 'Open in app';

  @override
  String get chatBrowserBack => 'Back';

  @override
  String get chatBrowserForward => 'Forward';

  @override
  String get chatBrowserReload => 'Reload';

  @override
  String get chatBrowserHandoffSource => 'Hand page to AI';

  @override
  String get chatBrowserHandoffUrl => 'Send URL only';

  @override
  String get chatBrowserHandoffFile => 'Pick downloaded file';

  @override
  String get chatBrowserDesktopUnsupported =>
      'The in-app browser is Android only; use a system browser and then pick the file back';

  @override
  String get chatBrowserEmptyUrl => 'No URL to open';

  @override
  String get chatBrowserOpenAgain => 'Open again';

  @override
  String get chatBrowserCopyLink => 'Copy link';

  @override
  String get chatBrowserLinkCopied => 'Link copied';

  @override
  String get chatBrowserOpenFailed =>
      'Could not open a browser; copy the link instead';

  @override
  String get chatBrowserLoadFailed => 'Page failed to load';

  @override
  String get chatBrowserLoadTimeout =>
      'Timed out: the site may reject the built-in WebView, or need a sign-in/verification first. Try a system browser';

  @override
  String get chatBrowserRetry => 'Retry';

  @override
  String chatBrowserLoadingPercent(int percent) {
    return 'Loading $percent%';
  }

  @override
  String get chatAdbPanelTitle => 'Wireless debugging';

  @override
  String get chatAdbPairingPending =>
      'Wireless debugging is open; come back after pairing';

  @override
  String get chatAdbPairingFailed => 'Pairing did not finish';

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
  String get chatPromptTitle => 'Prompt library';

  @override
  String get chatPromptLoading => 'Loading prompts…';

  @override
  String get chatPromptEmpty =>
      'No prompts yet. Tap + in the top-right corner to add one';

  @override
  String get chatPromptAdd => 'New prompt';

  @override
  String get chatPromptEdit => 'Edit prompt';

  @override
  String get chatPromptInsert => 'Insert';

  @override
  String get chatPromptDelete => 'Delete prompt';

  @override
  String chatPromptDeleteConfirm(String title) {
    return 'Delete \"$title\"?';
  }

  @override
  String get chatPromptSaved => 'Prompt saved';

  @override
  String get chatPromptDeleted => 'Prompt deleted';

  @override
  String get chatPromptName => 'Title';

  @override
  String get chatPromptNameHint => 'e.g. Analyze the device';

  @override
  String get chatPromptContent => 'Content';

  @override
  String get chatPromptContentHint => 'Enter the prompt to send to the AI';

  @override
  String get chatPromptContentRequired => 'Prompt content cannot be empty';

  @override
  String get chatAttachTitle => 'Add attachment';

  @override
  String get chatAttachImage => 'Choose images';

  @override
  String get chatAttachText => 'Choose text files';

  @override
  String get chatAttachBinary => 'Choose firmware or archive';

  @override
  String chatAttachNoPath(String name) {
    return 'Cannot resolve the local path of $name';
  }

  @override
  String get chatAttachUnsupported => 'Unsupported file type';

  @override
  String chatAttachTooLarge(String name) {
    return 'File is too large: $name';
  }

  @override
  String get chatAttachFailed => 'Failed to add attachment';

  @override
  String chatAttachLimit(int count) {
    return 'Up to $count attachments per message';
  }

  @override
  String get chatManualTitle => 'AI capability manual';

  @override
  String get chatManualSubtitle =>
      'Local capabilities and tools the assistant can call in a chat';

  @override
  String get chatManualConfirmHint =>
      'Tools that change the device ask for your confirmation first; read-only tools run directly';

  @override
  String get chatToolDesc_get_device_info =>
      'Read the model, OS version, kernel, patch level, baseband, ABI and SELinux state';

  @override
  String get chatToolDesc_get_root_status =>
      'Check whether the current process already has ROOT privileges';

  @override
  String get chatToolDesc_get_adb_status =>
      'Check whether the USB and wireless debugging switches are on';

  @override
  String get chatToolDesc_adb_shell_exec =>
      'Run one command on the connected adb shell (uid 2000) and return exit code and output';

  @override
  String get chatToolDesc_adb_pairing_request =>
      'Open the wireless debugging pairing panel and walk through adb pairing';

  @override
  String get chatToolDesc_stellar_service_status =>
      'Read whether the Stellar privileged service is available and which uid it runs as';

  @override
  String get chatToolDesc_web_search =>
      'Search the public web with Bing and return titles, links and snippets';

  @override
  String get chatToolDesc_coolapk_search =>
      'Search Coolapk posts, users and topics for real-device and rooting experience';

  @override
  String get chatToolDesc_coolapk_login =>
      'Check the Coolapk sign-in state; post bodies and full comments need an account, and the user is prompted to sign in when missing';

  @override
  String get chatToolDesc_coolapk_feed_detail =>
      'Read the full body of one Coolapk post; needs an account, and the body often contains the download links directly';

  @override
  String get chatToolDesc_coolapk_feed_all_replies =>
      'Read every comment and nested reply of one Coolapk post; needs an account, and covers posts whose hot-comment list is empty';

  @override
  String get chatToolDesc_coolapk_offer_download =>
      'Hand the user download links found in a post or its comments, and render a card with a jump to the original post';

  @override
  String get chatToolDesc_fetch_web_page =>
      'Download the raw source of a page together with its status code and content type';

  @override
  String get chatToolDesc_open_in_browser =>
      'Open a page in the in-app browser and hand back the URL or page source';

  @override
  String get chatToolDesc_escalation_get_device_identity =>
      'Read the device and kernel identity required for escalation';

  @override
  String get chatToolDesc_escalation_list_payloads =>
      'List the built-in escalation payloads';

  @override
  String get chatToolDesc_escalation_resolve_payload =>
      'Match an escalation payload for this model and kernel';

  @override
  String get chatToolDesc_escalation_list_root_managers =>
      'List the ROOT managers available on this device';

  @override
  String get chatToolDesc_escalation_get_selected_root_manager =>
      'Read the currently selected ROOT manager';

  @override
  String get chatToolDesc_escalation_run_payload =>
      'Run the given escalation payload';

  @override
  String get chatToolDesc_escalation_run_payload_by_id =>
      'Run an escalation payload by its id';

  @override
  String get chatToolDesc_escalation_handoff_root =>
      'Hand the acquired root over to the chosen manager';

  @override
  String get chatToolDesc_escalation_select_root_manager =>
      'Choose the ROOT manager used for the next handoff';

  @override
  String get chatToolDesc_ghost_key_preflight =>
      'GhostKey preflight: ADB, kernel, profile and native library readiness';

  @override
  String get chatToolDesc_ghost_key_get_run_defaults =>
      'Read the GhostKey run defaults';

  @override
  String get chatToolDesc_ghost_key_save_run_defaults =>
      'Save the GhostKey run defaults';

  @override
  String get chatToolDesc_ghost_key_start =>
      'Start one GhostKey temporary root run';

  @override
  String get chatToolDesc_ghost_key_status =>
      'Query the current GhostKey run status';

  @override
  String get chatToolDesc_ghost_key_cancel => 'Abort the running GhostKey flow';

  @override
  String get chatToolDesc_ghost_lock_preflight =>
      'GhostLock preflight: ADB, uid, seccomp, kernel and profile matching';

  @override
  String get chatToolDesc_ghost_lock_start =>
      'Start one GhostLock run and return a session id';

  @override
  String get chatToolDesc_ghost_lock_status =>
      'Read the latest snapshot of a GhostLock run session';

  @override
  String get chatToolDesc_ghost_lock_cancel =>
      'Stop reading the current GhostLock run without killing device processes';

  @override
  String get chatToolDesc_ghost_lock_list_imported_profiles =>
      'List the imported GhostLock profiles';

  @override
  String get chatToolDesc_ghost_lock_list_builtin_releases =>
      'List the built-in GhostLock releases';

  @override
  String get chatToolDesc_ghost_lock_read_imported_profile =>
      'Read the details of one imported profile';

  @override
  String get chatToolDesc_ghost_lock_get_probe_progress =>
      'Query the profile parsing progress';

  @override
  String get chatToolDesc_ghost_lock_list_extracted_images =>
      'List the partitions extracted from an image package';

  @override
  String get chatToolDesc_ghost_lock_get_profile_config =>
      'Read every field of the current profile';

  @override
  String get chatToolDesc_ghost_lock_get_active_source =>
      'Read the currently effective profile source';

  @override
  String get chatToolDesc_ghost_lock_probe_profile =>
      'Parse a kernel image and build a profile';

  @override
  String get chatToolDesc_ghost_lock_save_profile => 'Save the current profile';

  @override
  String get chatToolDesc_ghost_lock_import_profile_text =>
      'Import profile text as a new profile';

  @override
  String get chatToolDesc_ghost_lock_rename_imported_profile =>
      'Rename an imported profile';

  @override
  String get chatToolDesc_ghost_lock_remove_imported_profile =>
      'Delete an imported profile';

  @override
  String get chatToolDesc_ghost_lock_export_imported_profile =>
      'Export an imported profile as text';

  @override
  String get chatToolDesc_ghost_lock_convert_imported_profile =>
      'Convert the format of a profile';

  @override
  String get chatToolDesc_ghost_lock_export_local_file =>
      'Export a profile to a local file';

  @override
  String get chatToolDesc_ghost_lock_update_general_fields =>
      'Edit the general fields of a profile';

  @override
  String get chatToolDesc_ghost_lock_update_advanced_fields =>
      'Edit the advanced fields of a profile';

  @override
  String get chatToolDesc_ghost_lock_update_route =>
      'Edit the route data of a profile';

  @override
  String get chatToolDesc_ghost_lock_update_fallback =>
      'Edit the fallback entries of a profile';

  @override
  String get chatToolDesc_ghost_lock_reset_profile =>
      'Reset the profile to its defaults';

  @override
  String get chatToolDesc_ghost_lock_select_source =>
      'Choose the effective profile source';

  @override
  String get chatToolDesc_ghost_lock_render_profile =>
      'Render a preview of the profile';

  @override
  String get chatToolDesc_ghost_lock_export_profile =>
      'Export the current profile';

  @override
  String get chatToolDesc_ghost_lock_save_modified_profile =>
      'Save the modified profile';

  @override
  String get chatToolDesc_ghost_lock_overwrite_profile =>
      'Overwrite the existing profile';

  @override
  String get chatToolDesc_ghost_lock_begin_edit_session =>
      'Begin a profile editing session';

  @override
  String get chatToolDesc_ghost_lock_reload_edit_session =>
      'Reload the editing session';

  @override
  String get chatToolDesc_ghost_lock_get_edit_session =>
      'Read the current draft of the editing session';

  @override
  String get chatToolDesc_ghost_lock_commit_edit_session =>
      'Commit the changes in the editing session';

  @override
  String get chatToolDesc_ghost_lock_save_edit_session_in_place =>
      'Save the editing session in place';

  @override
  String get chatToolDesc_ghost_lock_save_edit_session_as_new =>
      'Save the editing session as a new profile';

  @override
  String get chatToolDesc_ghost_lock_export_edit_session =>
      'Export the editing session content';

  @override
  String get chatToolDesc_ghost_lock_end_edit_session =>
      'End the editing session';

  @override
  String get chatToolDesc_dirty_frag_is_armed =>
      'Check whether DirtyFrag was already injected in this boot';

  @override
  String get chatToolDesc_dirty_frag_get_run_defaults =>
      'Read the DirtyFrag run defaults';

  @override
  String get chatToolDesc_dirty_frag_get_expert_mode =>
      'Check whether DirtyFrag expert mode is on';

  @override
  String get chatToolDesc_dirty_frag_get_boot_autostart =>
      'Check whether DirtyFrag boot autostart is on';

  @override
  String get chatToolDesc_dirty_frag_get_vr_progress =>
      'Query the VR offset derivation progress';

  @override
  String get chatToolDesc_dirty_frag_save_run_defaults =>
      'Save the DirtyFrag run defaults';

  @override
  String get chatToolDesc_dirty_frag_set_expert_mode =>
      'Toggle DirtyFrag expert mode';

  @override
  String get chatToolDesc_dirty_frag_set_boot_autostart =>
      'Toggle DirtyFrag boot autostart';

  @override
  String get chatToolDesc_dirty_frag_start => 'Start a DirtyFrag escalation';

  @override
  String get chatToolDesc_dirty_frag_status =>
      'Query the current DirtyFrag status';

  @override
  String get chatToolDesc_dirty_frag_cancel => 'Abort the DirtyFrag run';

  @override
  String get chatToolDesc_dirty_frag_derive_vr_offset =>
      'Derive the VR offset from an image or OTA package';

  @override
  String get chatToolDesc_kernel_profile_list_imported =>
      'List the imported kernel profiles';

  @override
  String get chatToolDesc_kernel_profile_list_builtin =>
      'List the built-in kernel profiles';

  @override
  String get chatToolDesc_kernel_profile_read_content =>
      'Read the full content of a kernel profile';

  @override
  String get chatToolDesc_kernel_profile_read_editor =>
      'Read the current content of the kernel profile editor';

  @override
  String get chatToolDesc_kernel_profile_get_active_selection =>
      'Read the currently effective kernel profile';

  @override
  String get chatToolDesc_kernel_profile_import_start =>
      'Start importing and parsing a kernel image';

  @override
  String get chatToolDesc_kernel_profile_import_status =>
      'Query the kernel import progress';

  @override
  String get chatToolDesc_kernel_profile_import_cancel =>
      'Cancel the kernel import';

  @override
  String get chatToolDesc_kernel_profile_remove => 'Delete a kernel profile';

  @override
  String get chatToolDesc_kernel_profile_save_editor =>
      'Save the editor content';

  @override
  String get chatToolDesc_kernel_profile_save_editor_as =>
      'Save the editor content as a new profile';

  @override
  String get chatToolDesc_kernel_profile_render_editor =>
      'Render a preview of the editor content';

  @override
  String get chatToolDesc_kernel_profile_select_user_profile =>
      'Select the effective user profile';

  @override
  String get chatToolDesc_kernel_profile_select_builtin_release =>
      'Select the effective built-in release';

  @override
  String get chatToolDesc_ota_list_catalog =>
      'List the built-in OTA packages for a vendor';

  @override
  String get chatToolDesc_run_log_list_runs =>
      'List historical run logs, newest first';

  @override
  String get chatToolDesc_run_log_read_body => 'Read the body of one run log';

  @override
  String get chatToolDesc_run_log_export_all => 'Export every run log';

  @override
  String get chatToolDesc_run_log_diagnose =>
      'Diagnose a failed run log and report the cause';

  @override
  String get chatToolDesc_run_log_delete => 'Delete one run log';

  @override
  String get chatToolDesc_run_log_clear_all =>
      'Clear every run log except the one being written';

  @override
  String get chatToolDesc_local_file_inspect =>
      'Inspect an attachment inside the app process: size and header format, detecting payload, boot or zip containers';

  @override
  String get chatManualGroupDevice => 'Device & environment';

  @override
  String get chatManualGroupDeviceDesc =>
      'Read the model, OS version, kernel, ROOT state and ADB switches';

  @override
  String get chatManualGroupAdb => 'ADB debugging';

  @override
  String get chatManualGroupAdbDesc =>
      'Run adb shell commands and start wireless debugging pairing';

  @override
  String get chatManualGroupStellar => 'Stellar service';

  @override
  String get chatManualGroupStellarDesc =>
      'Read whether the Stellar privileged service is available and which identity it runs as';

  @override
  String get chatManualGroupWeb => 'Network & browsing';

  @override
  String get chatManualGroupWebDesc =>
      'Search the web, fetch page source, open pages in the in-app browser';

  @override
  String get chatManualGroupEscalation => 'Manual escalation';

  @override
  String get chatManualGroupEscalationDesc =>
      'Match a kernel payload, escalate, and hand root off to a manager';

  @override
  String get chatManualGroupGhostKey => 'GhostKey escalation';

  @override
  String get chatManualGroupGhostKeyDesc =>
      'Preflight and run the GhostKey temporary root flow';

  @override
  String get chatManualGroupGhostLock => 'GhostLock escalation';

  @override
  String get chatManualGroupGhostLockDesc =>
      'Preflight and run the GhostLock escalation flow';

  @override
  String get chatManualGroupGhostLockProfile => 'GhostLock profiles';

  @override
  String get chatManualGroupGhostLockProfileDesc =>
      'Read, edit, parse, import and export GhostLock profiles';

  @override
  String get chatManualGroupDirtyFrag => 'DirtyFrag escalation';

  @override
  String get chatManualGroupDirtyFragDesc =>
      'Kernel exploit, VR disarm and offset derivation';

  @override
  String get chatManualGroupKernel => 'Kernel profiles';

  @override
  String get chatManualGroupKernelDesc =>
      'Import and parse kernel images, manage profiles and pick the active one';

  @override
  String get chatManualGroupOta => 'OTA catalog';

  @override
  String get chatManualGroupOtaDesc =>
      'Look up historical OTA entries as kernel image sources';

  @override
  String get chatManualGroupRunLog => 'Run logs';

  @override
  String get chatManualGroupRunLogDesc =>
      'Read, diagnose, export and clear escalation run logs';

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
  String get escalationTerminalTitle => 'Terminal';

  @override
  String get escalationTerminalEntry => 'Open terminal';

  @override
  String get escalationToolSection => 'Root methods';

  @override
  String get escalationKernelSection => 'Kernel config';

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
    return '$manager is not installed on this device: no ksud found for package $package. Install $manager first, then retry.';
  }

  @override
  String get escalationHandoffNoSu =>
      'No su on this device. Escalate first to get temporary root, then hand off.';

  @override
  String escalationHandoffFailed(int code) {
    return 'Handoff failed (exit code $code)';
  }

  @override
  String get escalationHandoffFailedNoCode =>
      'Handoff failed: the command never ran';

  @override
  String get escalationHandoffReadManagerFailed =>
      'Handoff failed: could not read the selected root manager';

  @override
  String get escalationHandoffNoManager =>
      'No root manager available to hand off to: install a manager that ships ksud, select it from the pill in the top-right corner, then retry.';

  @override
  String get escalationMenuTitle => 'More actions';

  @override
  String get escalationPayloadRootTitle => 'Payload root';

  @override
  String get escalationPayloadAutoMatch => 'Auto-match this device';

  @override
  String get escalationPayloadAutoMatchDesc =>
      'Pick the best entry for model and kernel';

  @override
  String get escalationPayloadImport => 'Import custom payload';

  @override
  String get escalationPayloadImportTitle => 'Import custom payload';

  @override
  String get escalationPayloadImportPickFile => 'Choose payload file';

  @override
  String get escalationPayloadImportName => 'Display name';

  @override
  String get escalationPayloadImportNameHint =>
      'Leave empty to use the file name';

  @override
  String get escalationPayloadImportMode => 'Execution mode';

  @override
  String get escalationPayloadImportModeHelper => 'Helper load';

  @override
  String get escalationPayloadImportModeStandalone => 'Run directly';

  @override
  String get escalationPayloadImportModeHelperDesc =>
      'For .so payloads, loaded by the built-in helper';

  @override
  String get escalationPayloadImportModeStandaloneDesc =>
      'For executables with their own entry point, run with arguments';

  @override
  String get escalationPayloadImportArguments => 'Arguments';

  @override
  String get escalationPayloadImportArgumentsHint => 'Optional';

  @override
  String get escalationPayloadImportConfirm => 'Import';

  @override
  String get escalationPayloadImportNeedFile => 'Choose a payload file first';

  @override
  String get escalationPayloadImportFileMissing =>
      'The local file does not exist';

  @override
  String get escalationPayloadImportFileEmpty => 'The file is empty';

  @override
  String get escalationPayloadImportPushFailed =>
      'Failed to push to the device';

  @override
  String get escalationPayloadDelete => 'Delete';

  @override
  String get escalationPayloadDeleteConfirmTitle => 'Delete custom payload?';

  @override
  String escalationPayloadDeleteConfirmBody(String name) {
    return 'The file for \"$name\" will be removed from the device and this entry will be dropped from the list.';
  }

  @override
  String get escalationPayloadDeleteFailed => 'Delete failed';

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
  String get escalationPayloadNoCandidate =>
      'No payload in the catalog matches this device';

  @override
  String get escalationPayloadLibraryDirUnavailable =>
      'Native library directory unavailable: the .so was not extracted to nativeLibraryDir';

  @override
  String get escalationPayloadHelperMissing =>
      'Helper binary missing or not executable';

  @override
  String get escalationPayloadFileMissing => 'Payload file missing';

  @override
  String get escalationPayloadArgumentsUnresolved =>
      'Payload arguments cannot be resolved on this device';

  @override
  String get escalationMenuClear => 'Clear screen';

  @override
  String get escalationDirtyFragTitle => 'DirtyFrag root';

  @override
  String get escalationDirtyFragFieldManager => 'Manager';

  @override
  String get escalationDirtyFragFieldKernel => 'Kernel';

  @override
  String get escalationDirtyFragFieldVrDisarm => 'VR disarm';

  @override
  String get escalationDirtyFragFieldVrAuto => 'Auto resolve';

  @override
  String get escalationDirtyFragFieldSoftReboot => 'Soft reboot';

  @override
  String get escalationDirtyFragToggleOn => 'on';

  @override
  String get escalationDirtyFragToggleOff => 'off';

  @override
  String get escalationDirtyFragConfirmAction => 'Start';

  @override
  String get escalationDirtyFragConfirmBody =>
      'SELinux is put permissive during the run and the system may be unstable for a short while. A reboot restores it.';

  @override
  String get escalationDirtyFragVrDisarmTitle => 'VR disarm';

  @override
  String get escalationDirtyFragVrDisarmDesc =>
      'vivo devices only; removes the kernel VR protection';

  @override
  String get escalationDirtyFragVrAutoTitle => 'Resolve offset automatically';

  @override
  String get escalationDirtyFragVrAutoDesc =>
      'Derives the offset from kernel BTF; available only with VR disarm on';

  @override
  String get escalationDirtyFragSoftRebootTitle => 'Soft reboot on success';

  @override
  String get escalationDirtyFragSoftRebootDesc =>
      'Reboots once on success so modules load; with boot autorun on, a failed reboot can leave no root at boot';

  @override
  String get escalationDirtyFragVrOffsetLabel => 'Manual offset';

  @override
  String get escalationDirtyFragVrOffsetHint =>
      'Range 1-256; an invalid value aborts before handoff';

  @override
  String get escalationDirtyFragAlreadyArmed =>
      'Already injected in this boot; reboot before running again';

  @override
  String escalationDirtyFragKernelUnsupported(String kernel) {
    return 'Kernel $kernel is not supported';
  }

  @override
  String get escalationDirtyFragKernelUnsupportedShort => '(unsupported)';

  @override
  String get escalationDirtyFragKernelUnknown => 'unknown';

  @override
  String get escalationDirtyFragNoManager =>
      'Pick a manager that ships ksud from the capsule at the top right first';

  @override
  String escalationDirtyFragRunning(String manager) {
    return 'Running DirtyFrag against $manager…';
  }

  @override
  String escalationDirtyFragSucceeded(String manager) {
    return 'Kernel module loaded; root handed off to $manager';
  }

  @override
  String get escalationDirtyFragNotVulnerable =>
      'This kernel does not have the flaw';

  @override
  String get escalationDirtyFragPatchFailed =>
      'Patching failed; see the output above';

  @override
  String get escalationDirtyFragVrFailed =>
      'VR disarm failed; aborted before handoff';

  @override
  String get escalationDirtyFragBootstrapFailed =>
      'Kernel module loaded, but the bootstrap or ksud stage failed';

  @override
  String get escalationDirtyFragTimedOut =>
      'Timed out waiting for the final marker; see the output above';

  @override
  String escalationDirtyFragNotStarted(String reason) {
    return 'Rejected by the native side: $reason';
  }

  @override
  String escalationDirtyFragVrOffsetResolved(String offset) {
    return 'VR offset resolved: $offset';
  }

  @override
  String get escalationDirtyFragVrExtractAction => 'Extract from image/OTA';

  @override
  String escalationDirtyFragVrExtractProgress(String phase, int percent) {
    return '$phase $percent%';
  }

  @override
  String get escalationDirtyFragVrExtractPhaseDownload => 'Download';

  @override
  String get escalationDirtyFragVrExtractPhaseUnpack => 'Unpack';

  @override
  String get escalationDirtyFragVrExtractEmpty =>
      'Fill in a local image path or an OTA link above first';

  @override
  String escalationDirtyFragVrExtractFailed(String error) {
    return 'Extract failed: $error';
  }

  @override
  String get escalationGhostKeyTitle => 'GhostKey Escalation';

  @override
  String escalationGhostKeyRunning(String manager) {
    return 'Starting GhostKey escalation$manager';
  }

  @override
  String get escalationGhostKeyNoAdb => 'adb is not connected';

  @override
  String escalationGhostKeySucceeded(String manager) {
    return 'GhostKey completed, temporary root ready$manager';
  }

  @override
  String get escalationGhostKeyDegraded =>
      'GhostKey completed with low page-offset confidence';

  @override
  String get escalationGhostKeyCalibFailed => 'KASLR slide calibration failed';

  @override
  String get escalationGhostKeyPageOffsetFailed =>
      'Linear-map page-offset calibration failed';

  @override
  String get escalationGhostKeyInjectFailed =>
      'Injection failed: rootd not ready';

  @override
  String get escalationGhostKeyVerifyFailed =>
      'Temporary root channel verification failed';

  @override
  String get escalationGhostKeyKsuFailed =>
      'Temporary root ready, handoff to the manager failed';

  @override
  String get escalationGhostKeyTimedOut => 'GhostKey timed out';

  @override
  String escalationGhostKeyNotStarted(String reason) {
    return 'GhostKey not started: $reason';
  }

  @override
  String get escalationGhostKeyReasonAlreadyRunning =>
      'A run is already in progress';

  @override
  String get escalationGhostKeyReasonNoAdb => 'ADB is not connected';

  @override
  String get escalationGhostKeyReasonNotShell => 'Shell uid is not 2000';

  @override
  String get escalationGhostKeyReasonSeccomp => 'Shell is filtered by seccomp';

  @override
  String get escalationGhostKeyReasonMissingBinary => 'Payload file is missing';

  @override
  String get escalationGhostKeyReasonNoProfile =>
      'No profile for the current kernel version';

  @override
  String get escalationGhostKeyReasonBadRequest => 'Invalid request';

  @override
  String escalationReasonWithCode(String label, String code) {
    return '$label ($code)';
  }

  @override
  String get escalationDirtyFragReasonAlreadyArmed => 'Already armed';

  @override
  String get escalationDirtyFragReasonBusy => 'Another run is in progress';

  @override
  String get escalationDirtyFragReasonNoIpSec => 'IpSec service unavailable';

  @override
  String get escalationDirtyFragReasonMissingBinary =>
      'Manager or payload file missing';

  @override
  String get escalationDirtyFragReasonStagingFailed =>
      'Staging or start failed';

  @override
  String get escalationDirtyFragReasonBadRequest => 'Invalid request';

  @override
  String get escalationGhostKeyFailed => 'GhostKey failed';

  @override
  String get escalationGhostKeyConfirmTitle => 'Confirm GhostKey Escalation';

  @override
  String get escalationGhostKeyConfirmRisk =>
      'This calibrates kernel mappings and injects rootd; the device may be briefly unavailable.';

  @override
  String get escalationGhostKeyConfirmRun => 'Start escalation';

  @override
  String get escalationGhostKeyFieldManager => 'Manager';

  @override
  String get escalationGhostKeyFieldRelease => 'Kernel release';

  @override
  String get escalationGhostKeyFieldShellUid => 'shell uid';

  @override
  String get escalationGhostKeyFieldSeccomp => 'seccomp';

  @override
  String get escalationGhostKeyFieldProfile => 'Profile matched';

  @override
  String get escalationGhostKeyFieldFallback => 'Accept fallback offset';

  @override
  String get escalationGhostKeyValueUnknown => 'Unknown';

  @override
  String get escalationGhostKeyValueNone => 'Not selected';

  @override
  String get escalationGhostKeyValueYes => 'Yes';

  @override
  String get escalationGhostKeyValueNo => 'No';

  @override
  String get escalationGhostKeyToggleOn => 'On';

  @override
  String get escalationGhostKeyToggleOff => 'Off';

  @override
  String get escalationGhostKeyProgressTitle => 'Progress';

  @override
  String escalationGhostKeyDurationSeconds(String seconds) {
    return '$seconds s';
  }

  @override
  String get escalationGhostKeyStageCalibAName => 'KASLR slide calibration';

  @override
  String get escalationGhostKeyStageCalibBName => 'Linear-map calibration';

  @override
  String get escalationGhostKeyStageInjectName => 'Inject rootd';

  @override
  String get escalationGhostKeyStageVerifyName => 'Verify temporary root';

  @override
  String get escalationGhostKeyStageKsuName => 'Hand off to manager';

  @override
  String get escalationGhostKeyStageCalibAHint => 'Locating kernel base';

  @override
  String get escalationGhostKeyStageCalibBHint => 'Calibrating linear map';

  @override
  String get escalationGhostKeyStageInjectHint => 'Injecting rootd';

  @override
  String get escalationGhostKeyStageVerifyHint => 'Verifying root channel';

  @override
  String get escalationGhostKeyStageKsuHint => 'Handing off to the manager';

  @override
  String get escalationGhostLockTitle => 'GhostLock root';

  @override
  String get escalationGhostLockFieldManager => 'Manager';

  @override
  String get escalationGhostLockFieldRelease => 'Kernel';

  @override
  String get escalationGhostLockFieldProfile => 'Kernel table';

  @override
  String get escalationGhostLockFieldRoute => 'Route';

  @override
  String get escalationGhostLockFieldSeccomp => 'Seccomp';

  @override
  String get escalationGhostLockFieldKsud => 'ksud';

  @override
  String get escalationGhostLockValueYes => 'yes';

  @override
  String get escalationGhostLockValueNo => 'no';

  @override
  String get escalationGhostLockValueNone => 'none';

  @override
  String get escalationGhostLockValueUnknown => 'unknown';

  @override
  String get escalationGhostLockSafeModeTitle => 'Safe mode';

  @override
  String get escalationGhostLockSafeModeDesc =>
      'Marks modules under /data/adb/modules as disabled before the run';

  @override
  String get escalationGhostLockConfirmRun => 'Start';

  @override
  String get escalationGhostLockConfirmRisk =>
      'SELinux is put permissive during the run and may stay that way if it fails. A reboot restores it.';

  @override
  String get escalationGhostLockNoAdb =>
      'Wireless debugging is not connected; pair it in settings first';

  @override
  String get escalationGhostLockMissingBinary =>
      'libghostlock.so is missing from the installed build; reinstall the app';

  @override
  String escalationGhostLockNoProfile(String release) {
    return 'No kernel table entry for $release, and no approximate match is attempted';
  }

  @override
  String escalationGhostLockProfileInvalid(String reason) {
    return 'Kernel table could not be decoded: $reason';
  }

  @override
  String escalationGhostLockProfileMismatch(String profile, String device) {
    return 'The selected kernel table declares $profile but this device reports $device; it will not be applied';
  }

  @override
  String escalationGhostLockProfileMissing(String name) {
    return 'The selected document $name no longer exists; it may have been removed or renamed';
  }

  @override
  String get escalationGhostLockSeccompFiltered =>
      'This shell is seccomp-filtered and the chain cannot clear it';

  @override
  String escalationGhostLockRunning(String manager) {
    return 'Running GhostLock$manager…';
  }

  @override
  String escalationGhostLockSucceeded(String manager) {
    return 'Kernel module loaded; handed over to$manager';
  }

  @override
  String get escalationGhostLockAlreadyRooted =>
      'The kernel module already owns this boot; the exploit was skipped';

  @override
  String get escalationGhostLockTempRootOnly =>
      'Temporary root obtained, but the kernel module is not loaded yet';

  @override
  String get escalationGhostLockSeccompBlocked =>
      'The rooted child still runs under a seccomp filter, so the kernel module cannot load';

  @override
  String get escalationGhostLockKsuFailed =>
      'Kernel module load failed; see the ksud output above';

  @override
  String get escalationGhostLockW1Failed =>
      'Disabling SELinux failed; see the output above';

  @override
  String get escalationGhostLockW2Failed =>
      'The credential stage failed; see the output above';

  @override
  String get escalationGhostLockW3Failed =>
      'Clearing seccomp failed; see the output above';

  @override
  String get escalationGhostLockReleaseMismatch =>
      'The kernel table does not match the device kernel; native exited';

  @override
  String get escalationGhostLockDirtyRace =>
      'The race ended dirty and native stopped itself';

  @override
  String get escalationGhostLockTimedOut =>
      'Timed out waiting for the final signal; reading stopped, the device side may still be running';

  @override
  String escalationGhostLockNotStarted(String reason) {
    return 'Rejected by the native side; reason code: $reason';
  }

  @override
  String get escalationGhostLockFailed =>
      'No recognisable final marker; see the output above';

  @override
  String escalationGhostLockFailureCode(String code) {
    return 'Native diagnostic: $code';
  }

  @override
  String get escalationGhostLockFailureDeviceDisconnected =>
      'Lost the device connection (it probably rebooted); tracking stopped, retry after it comes back';

  @override
  String get escalationGhostLockFailureLaunch =>
      'The native process could not be started; see the shell output above';

  @override
  String get escalationGhostLockFailureProfileWrite =>
      'Could not write the kernel table to the device temp directory; check that wireless debugging is still up';

  @override
  String get escalationGhostLockFailureNotStarted =>
      'The native process produced no output; tracking stopped';

  @override
  String get escalationGhostLockStop => 'Stop reading';

  @override
  String get escalationGhostLockProfileEdit => 'Edit kernel table';

  @override
  String get escalationGhostLockProfileTabGeneral => 'General';

  @override
  String get escalationGhostLockProfileTabRoute => 'Route';

  @override
  String get escalationGhostLockProfileTabAdvanced => 'Advanced';

  @override
  String get escalationGhostLockProfileNotProvided => 'not provided';

  @override
  String get escalationGhostLockProfileInvalidField =>
      'This value violates the offset rules';

  @override
  String get escalationGhostLockProfileOverridden => 'modified';

  @override
  String get escalationGhostLockProfileWriteBack => 'Save';

  @override
  String get escalationGhostLockProfileWrittenBack => 'Written to current file';

  @override
  String get escalationGhostLockProfileWriteFailed => 'Write failed';

  @override
  String get escalationGhostLockProfileRejected =>
      'This value would make the profile unparsable; reverted';

  @override
  String get escalationGhostLockProfileSaved => 'Saved';

  @override
  String escalationGhostLockProfileSavedAsNew(String name) {
    return 'Saved as $name';
  }

  @override
  String get escalationGhostLockProfileExport => 'Export to file';

  @override
  String get escalationGhostLockProfileSaveAs => 'Save as my profile';

  @override
  String get escalationGhostLockProfileRouteAuto =>
      'As declared by the profile';

  @override
  String get escalationGhostLockProfileRouteLabel => 'Route';

  @override
  String get escalationGhostLockProfileRouteCurrent => 'In effect';

  @override
  String get escalationGhostLockProfileFallbackLabel => 'Fallback';

  @override
  String get escalationGhostLockProfileFallbackNone => 'No fallback';

  @override
  String get escalationGhostLockProfileFallbackDeclared =>
      'Follow the profile declaration';

  @override
  String get escalationGhostLockProfileNoProfile =>
      'No editable profile for this kernel';

  @override
  String get escalationGhostLockProfileNoWritableDoc =>
      'Nothing to write back to. Use \"Save as my config\" to create one first';

  @override
  String get escalationGhostLockProfileSourceLabel => 'Active source';

  @override
  String get escalationGhostLockProfileSourceDevice => 'Device built-in table';

  @override
  String get escalationGhostLockProfileSourceBuiltin => 'Built-in table';

  @override
  String get escalationGhostLockProfileSourceUser => 'My profile';

  @override
  String escalationGhostLockProfileOverriddenCount(int count) {
    return '$count edited';
  }

  @override
  String get escalationGhostLockProfileTabGeneralHint =>
      'Execution tuning. Leaving the field applies it right away; no separate save needed.';

  @override
  String get escalationGhostLockProfileTabRouteHint =>
      'Pick the injection path. Selecting applies instantly; the advanced fields change with the route.';

  @override
  String get escalationGhostLockProfileRouteGeometryHint =>
      'A route\'s geometry values (waiter_shift, compact_waiter, waiter_off, ...) are only written when the profile was generated for that route. Switching to a route the profile never produced leaves those fields empty, so the runtime may lack its parameters. To change routes, re-parse the image and pick the route there.';

  @override
  String get escalationGhostLockProfileTabAdvancedHint =>
      'Struct and offset fields. Edits apply immediately; empty fields are not yet provided.';

  @override
  String get escalationGhostLockProfileApplied => 'Applied';

  @override
  String get escalationGhostLockProfileWriteBackHint =>
      'Live overrides to local; documents overwritten in place';

  @override
  String get escalationGhostLockProfileWriteBackDisabled =>
      'Built-in profiles are read-only; use Save as';

  @override
  String get escalationGhostLockProfileSaveAsHint =>
      'Create a new user profile, original untouched';

  @override
  String get escalationGhostLockProfileExportHint =>
      'Export the conf to a system file';

  @override
  String get escalationGhostLockProfileSelectSearch => 'Filter by release';

  @override
  String get escalationGhostLockProfileSelectTemplates => 'Reference templates';

  @override
  String get escalationGhostLockImportTitle => 'Import kernel table';

  @override
  String escalationGhostLockImportFailed(String reason) {
    return 'Extract failed: $reason';
  }

  @override
  String get escalationGhostLockImportOverwrite =>
      'An entry for the same kernel exists. Overwrite?';

  @override
  String get escalationGhostLockImportOverwriteAction => 'Overwrite';

  @override
  String escalationGhostLockImportDone(String release) {
    return 'Kernel table for $release generated';
  }

  @override
  String get escalationGhostLockImportedEmpty => 'No kernel table imported yet';

  @override
  String get escalationGhostLockImportedRemove => 'Delete';

  @override
  String get escalationGhostLockImportedParseError => 'File cannot be parsed';

  @override
  String get escalationGhostLockImportedRename => 'Rename';

  @override
  String get escalationGhostLockImportedRenameHint => 'New file name';

  @override
  String get escalationGhostLockImportedExport => 'Export';

  @override
  String get escalationGhostLockImportedEdit => 'Edit';

  @override
  String get escalationGhostLockImportedExported => 'Exported';

  @override
  String get escalationGhostLockMoreActions => 'More actions';

  @override
  String get escalationGhostLockImportText =>
      'Import config (conf / hocon / json / txt, multi-select)';

  @override
  String get escalationGhostLockImportUnsupported =>
      'Nothing to import: only conf / hocon / json / txt UTF-8 text is accepted';

  @override
  String get settingsGhostKeySection => 'GhostKey';

  @override
  String get settingsGhostKeyAcceptFallbackTitle => 'Accept fallback offset';

  @override
  String get settingsGhostKeyAcceptFallbackDesc =>
      'Continue injection when page-offset confidence is low';

  @override
  String get settingsBootAutostartSection => 'Root';

  @override
  String get settingsExpertModeTitle => 'Expert mode';

  @override
  String get settingsExpertModeDesc =>
      'Unlocks autorun and the run settings below';

  @override
  String get settingsBootAutostartTitle => 'Run DirtyFrag on boot';

  @override
  String get settingsBootAutostartTitleLocked =>
      'Run DirtyFrag on boot (enable expert mode first)';

  @override
  String get settingsBootAutostartDesc =>
      'Runs once at boot; turns itself off on failure';

  @override
  String get settingsBootAutostartConfirmTitle => 'Enable boot autorun?';

  @override
  String get settingsBootAutostartConfirmBody =>
      'A failed run at boot can put the device in a reboot loop, leaving recovery or a reflash as the only way out. Confirm only if you understand this.';

  @override
  String get settingsBootAutostartConfirmAction => 'I understand, enable';

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
      'If the notification cannot accept the code, open Settings → General → Pairing code entry and switch to \"Small window\"';

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
  String get settingsShellPairingModeTitle => 'Pairing code entry';

  @override
  String get settingsShellPairingModeDesc =>
      'Choose small-window entry when the notification box does not open (e.g. on Xiaomi), then type the code in the card';

  @override
  String get shellPairingModeNotification => 'Notification';

  @override
  String get shellPairingModeCard => 'Small window';

  @override
  String get shellPairingCodeHint => 'Six-digit code';

  @override
  String get shellPairingCodeSubmit => 'Pair';

  @override
  String get shellPairingCardHint =>
      'Tap \"Pair device with pairing code\" in Settings first, then type the six digits here. Use split screen or a floating window: leaving the app invalidates the code';

  @override
  String get shellPairingOpenDebugSettings =>
      'Open wireless debugging settings';

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
  String get shellReasonAuthRevoked => 'Authorization revoked; pair again';

  @override
  String get shellReasonHostDisconnected => 'Connection lost';

  @override
  String get shellReasonEndpointNotFound =>
      'Pairing service not found. Open \"Pair device with pairing code\" in Settings first, then enter the code again';

  @override
  String get shellReasonPairingTimeout => 'Pairing timed out, please retry';

  @override
  String get shellReasonDeviceRebooted => 'Device rebooted, connection dropped';

  @override
  String get shellReasonCancelled => 'Pairing cancelled';

  @override
  String get shellReasonHostPairingFailed => 'Pairing failed, please retry';

  @override
  String get settingsCommandChannelTitle => 'Command channel';

  @override
  String get settingsCommandChannelDesc =>
      'The link AI tools use to run commands. Switch it here.';

  @override
  String get commandChannelAdb => 'Wireless ADB';

  @override
  String get commandChannelStellar => 'Stellar';

  @override
  String get stellarCardTitle => 'Stellar';

  @override
  String stellarStatusReady(int uid) {
    return 'Service ready (uid $uid)';
  }

  @override
  String get stellarStatusNotReady => 'Service not ready';

  @override
  String get stellarNotReadyHint =>
      'The Stellar privileged service is not ready, so this channel cannot run commands right now. Switch channels in Settings → General → Command channel.';

  @override
  String get stellarStartService => 'Start service';

  @override
  String get stellarLaunching => 'Starting service…';

  @override
  String get stellarLaunchNoRunner =>
      'Connecting to wireless debugging automatically did not work, so the service could not start. Make sure wireless debugging is on, then try again.';

  @override
  String get stellarLaunchLauncherMissing =>
      'The launcher file is missing from the installed package, so the service cannot start.';

  @override
  String get stellarLaunchNotAnswering =>
      'The start request was sent, but the service did not answer in time.';

  @override
  String get stellarLaunchAwaitingCode =>
      'Enter the six-digit wireless debugging pairing code below; the app connects and starts the service automatically.';

  @override
  String get stellarStopService => 'Disconnect service';

  @override
  String get stellarStopping => 'Stopping service…';

  @override
  String get stellarStopFailed =>
      'The service did not respond to the disconnect request and may still be running.';

  @override
  String get escalationTerminalNeedsAdb =>
      'Not connected to wireless debugging.';

  @override
  String get rootManagerPillTooltip => 'Choose root manager';

  @override
  String get rootManagerTitle => 'Root manager';

  @override
  String get rootManagerCurrent => 'Current';

  @override
  String get rootManagerEmpty => 'No root manager found.';

  @override
  String rootManagerSwitched(String manager) {
    return 'Switched to $manager';
  }

  @override
  String rootManagerSaveFailed(String message) {
    return 'Save failed: $message';
  }

  @override
  String get kernelProfileTitle => 'Kernel table';

  @override
  String get kernelProfileEntrySubtitle =>
      'Generate kernel parameters for GhostKey and GhostLock';

  @override
  String get kernelProfilePageDesc =>
      'When the device kernel is not in the built-in table, generate a profile from its boot.img or an OTA. The profile is kept in the private app storage.';

  @override
  String get kernelProfileTabGhostKey => 'GhostKey imported';

  @override
  String get kernelProfileTabGhostKeyBuiltin => 'GhostKey built-in';

  @override
  String get kernelProfileTabGhostLock => 'GhostLock imported';

  @override
  String get kernelProfileTabGhostLockBuiltin => 'GhostLock built-in';

  @override
  String get kernelProfileImportAction => 'Choose image (img / bin / zip)';

  @override
  String get kernelProfileImportChangeFile => 'Change image';

  @override
  String get kernelProfileImportAttachXbl => 'xbl_config.img (optional)';

  @override
  String get kernelProfileImportAttachUefi => 'uefi.img (optional)';

  @override
  String get kernelProfileImportAttachVendorBoot =>
      'vendor_boot.img (optional)';

  @override
  String get kernelProfileImportPhysLabel => 'Physical load address (optional)';

  @override
  String get kernelProfileImportPhysHint => '0x80000000';

  @override
  String get kernelProfileAdvancedTitle => 'Advanced parsing options';

  @override
  String get kernelProfileAdvancedHint =>
      'Usually leave untouched; re-parse after changing';

  @override
  String get kernelProfileImportKallsyms => 'kallsyms file';

  @override
  String get kernelProfileImportIomem => 'iomem file';

  @override
  String get kernelProfileImportRoute => 'Route';

  @override
  String get kernelProfileImportRouteAuto => 'Auto';

  @override
  String get kernelProfileImportAllowMissing =>
      'Treat missing symbols as optional (emit 0)';

  @override
  String get kernelProfileImportNoDisasm =>
      'Skip disassembly derivation (faster, less precise)';

  @override
  String get kernelProfileImportUrlHint => 'OTA link (HTTP/HTTPS)';

  @override
  String get kernelProfileImportParseAction => 'Parse kernel';

  @override
  String get kernelProfileImportNeedInput =>
      'Pick an image or paste a link first';

  @override
  String get kernelProfileImportUnsupportedImage =>
      'Unsupported file: only img / bin / zip images or OTA packages are accepted';

  @override
  String get kernelProfileImportEmptyFile => 'File is empty or unreadable';

  @override
  String get kernelProfileImportInsecureHint =>
      'Skip certificate check (for self-signed links)';

  @override
  String get kernelProfileProbeReady => 'Parsed';

  @override
  String get kernelProfileProbeRouteIncomplete =>
      'Route geometry incomplete; this profile cannot reach the write stage:';

  @override
  String get kernelProfileProbeRouteIncompleteHint =>
      'Stage one is attempted only once and refuses a missing field. Fill in the gaps, or switch to a route this profile fully declares in the Route tab.';

  @override
  String kernelProfileProbeWarnings(int count) {
    return '$count warnings';
  }

  @override
  String get kernelProfileProbeWarningsTitle => 'Parse warnings';

  @override
  String get kernelProfileProbePhys => 'kernel_phys_load';

  @override
  String get kernelProfileProbePhysMissing => 'not found';

  @override
  String get kernelProfileProbePhysUnsetHint =>
      'Written as null when unknown; the runtime falls back to a built-in per-SoC constant. If a run reports a bad address, attach xbl_config.img or fill in the physical base.';

  @override
  String get kernelProfileAttachTitle => 'Optional attachments';

  @override
  String get kernelProfileAttachHint =>
      'Used to fill in kernel_phys_load; usually not needed';

  @override
  String get kernelProfileAttachAttachedCount =>
      'Images attached; re-run the parse to apply';

  @override
  String get kernelProfileAttachAutoHint =>
      'xbl_config, uefi and vendor_boot are extracted from the package as needed; the result lists what was actually extracted.';

  @override
  String get kernelProfileAttachVendorBootHint =>
      'Only needed on MediaTek devices, to supply the DRAM base.';

  @override
  String get kernelProfileAttachPick => 'Choose';

  @override
  String get kernelProfileAttachReplace => 'Replace';

  @override
  String get kernelProfileProbePayloadParts => 'Package partitions';

  @override
  String get kernelProfileProbeAnalysis => 'Kernel analysis';

  @override
  String get kernelProfileProbeAnalysisTitle => 'Kernel analysis';

  @override
  String get kernelProfileImportTargetGhostLock => 'GhostLock';

  @override
  String get kernelProfileImportTargetGhostKey => 'GhostKey';

  @override
  String get kernelProfileInputSourceLocal => 'Local image';

  @override
  String get kernelProfileInputSourceUrl => 'OTA link';

  @override
  String kernelProfileWriteToTarget(String table) {
    return 'Write to $table';
  }

  @override
  String kernelProfileProbeFailed(String reason) {
    return 'Parse failed: $reason';
  }

  @override
  String get kernelProfileBtfHint =>
      'The kernel must carry BTF info; third-party ROMs and older devices may lack the struct offsets';

  @override
  String get kernelProfilePasteExample => 'Paste example';

  @override
  String get kernelProfileWhyBtfTitle => 'Why is BTF required?';

  @override
  String get kernelProfileWhyBtfBody =>
      'The generated profile forges credentials by writing to byte offsets inside struct cred, and those offsets change across kernel versions, so they cannot be hard-coded.\n\nIf the kernel image carries BTF (CONFIG_DEBUG_INFO_BTF), the real layout of task_struct and cred can be read straight from the image. Without BTF, task_cred, task_struct_size and cred_uid cannot be obtained and the profile cannot be generated.\n\nThe link must also support HTTP Range (partial download); otherwise the boot partition cannot be fetched on its own. Vendor OTA images and GKI devices such as Pixel usually satisfy both.';

  @override
  String get kernelProfileDialogClose => 'Got it';

  @override
  String get otaCatalogBrowseAction => 'Built-in ROMs';

  @override
  String get otaCatalogTitle => 'Built-in ROM packages';

  @override
  String get otaCatalogSearchHint => 'Search device or build';

  @override
  String get otaCatalogPickHint =>
      'Tap any version to fill its direct link above';

  @override
  String get otaCatalogEmpty => 'No matching device or build';

  @override
  String otaCatalogVersionCount(int count) {
    return '$count versions';
  }

  @override
  String get otaCatalogBrandGoogle => 'Google';

  @override
  String get otaCatalogBrandRealme => 'realme';

  @override
  String get kernelProfileDetailTitle => 'Kernel parameters';

  @override
  String get kernelProfileDetailOverview => 'Overview';

  @override
  String get kernelProfileDetailOffsets => 'Structure offsets';

  @override
  String get kernelProfileDetailSymbolOffsets => 'Symbol offsets';

  @override
  String get kernelProfileDetailSchema => 'Schema version';

  @override
  String get kernelProfileDetailKernelMajor => 'Kernel major';

  @override
  String get kernelProfileDetailRaw => 'Raw config';

  @override
  String get kernelProfileDetailVulnType => 'Vulnerability';

  @override
  String get kernelProfileDetailPageOffset => 'Page offset';

  @override
  String get kernelProfileDetailSource => 'Source';

  @override
  String get kernelProfileDetailCopy => 'Copy';

  @override
  String get kernelProfileDetailCopied => 'Raw config copied';

  @override
  String get kernelProfileDetailEmpty =>
      'Content unavailable; the file may have been removed';

  @override
  String get kernelProfileEditAction => 'Edit';

  @override
  String get kernelProfileEditTitle => 'Edit kernel parameters';

  @override
  String get kernelProfileEditBasicSection => 'Basic offsets';

  @override
  String get kernelProfileEditAdvancedSection => 'Advanced layout';

  @override
  String get kernelProfileEditInputHint =>
      'Accepts hex (0x...) or decimal; 64-bit addresses show as unsigned';

  @override
  String get kernelProfileEditReleaseLabel => 'Kernel release (read-only)';

  @override
  String get kernelProfileEditReleaseHint =>
      'release is the exact uname -r match key; changing it disables matching';

  @override
  String get kernelProfileEditSource => 'Source';

  @override
  String get kernelProfileEditWriteBack => 'Write back';

  @override
  String get kernelProfileEditWriteBackHint =>
      'Overwrite the current user profile';

  @override
  String get kernelProfileEditSaveAs => 'Save as new profile';

  @override
  String get kernelProfileEditSaveAsHint =>
      'Create a new user document; the original stays';

  @override
  String get kernelProfileEditExport => 'Export to file';

  @override
  String get kernelProfileEditExportHint =>
      'Export the edited result as a local .conf';

  @override
  String get kernelProfileEditDocument => 'Document';

  @override
  String get kernelProfileEditSaveFailed => 'Save failed';

  @override
  String kernelProfileEditSavedAs(String name) {
    return 'Saved as $name';
  }

  @override
  String get kernelProfileActiveBadge => 'Active';

  @override
  String get kernelProfileSetActive => 'Set active';

  @override
  String get kernelProfileClearActive => 'Clear selection';

  @override
  String get kernelProfileActivated => 'Set as active';

  @override
  String get kernelProfileClearedActive => 'Automatic matching restored';

  @override
  String get kernelProfileEditSaved => 'Saved';

  @override
  String get kernelProfileEditNoChange => 'No changes to save';

  @override
  String get kernelProfileEditInvalidField => 'Invalid value found';

  @override
  String kernelProfileEditInvalidFields(String fields) {
    return 'Invalid values: $fields';
  }

  @override
  String get kernelProfileEditExportFailed => 'Export failed';

  @override
  String get kernelProfileEditNotEditable =>
      'Only user-imported profiles can be edited';

  @override
  String get kernelProfilePhaseLocate => 'Locating OTA package';

  @override
  String get kernelProfilePhaseRead => 'Downloading image';

  @override
  String kernelProfileBytesProgress(String done, String total) {
    return '$done / $total';
  }

  @override
  String get kernelProfilePhaseParse => 'Parsing kernel';

  @override
  String get kernelProfilePhaseSave => 'Writing profile';

  @override
  String get kernelProfilePhaseDone => 'Done';

  @override
  String kernelProfileImportSuccess(String release) {
    return 'Profile generated: $release';
  }

  @override
  String get kernelProfileImportFailed => 'Import failed';

  @override
  String get kernelProfileErrorCopy => 'Copy error';

  @override
  String get kernelProfileErrorCopied => 'Error copied';

  @override
  String kernelProfileMissingFields(String fields) {
    return 'Missing required fields: $fields';
  }

  @override
  String get kernelProfileImportedSection => 'Kernel profiles';

  @override
  String get kernelProfileImportedEmpty => 'No imported profile yet';

  @override
  String get kernelProfileBuiltinEmpty => 'No built-in profile';

  @override
  String get kernelProfileDeviceKernel => 'Device kernel';

  @override
  String get kernelProfileEditParams => 'Edit parameters';

  @override
  String get kernelProfileMyProfilesTitle => 'My profiles';

  @override
  String get kernelProfileBuiltinTitle => 'Built-in profiles';

  @override
  String get kernelProfileBuiltinHint => 'Bundled with the app, read-only';

  @override
  String get kernelProfileTemplateHint =>
      'Blank skeleton for inspecting the field layout; cannot take effect';

  @override
  String get kernelProfileMatchesDevice => 'Matches this device';

  @override
  String kernelProfileShowMore(int count) {
    return 'Show more ($count left)';
  }

  @override
  String get kernelProfileStepPick => 'Pick profile';

  @override
  String get kernelProfileStepReview => 'Review source';

  @override
  String get kernelProfileStepApply => 'Apply';

  @override
  String get kernelProfileStepNext => 'Next';

  @override
  String get kernelProfileStepBack => 'Back';

  @override
  String get kernelProfileApplyAction => 'Apply';

  @override
  String get kernelProfileApplied => 'Active profile switched';

  @override
  String get kernelProfileApplyNotEffective =>
      'Selected profile does not apply to this device kernel and will not be used';

  @override
  String get kernelProfileEditorNotEditable =>
      'This kernel has no editable profile';

  @override
  String get kernelProfilePickAgain => 'Pick another';

  @override
  String get kernelProfileEditAfterApply => 'Tune parameters';

  @override
  String get kernelProfileEditAfterApplyHint =>
      'Parameters can only be edited once active: finish this step, then open the editor.';

  @override
  String get kernelProfilePickHint =>
      'Pick the profile to use. The row marked Active is the one in use now.';

  @override
  String get kernelProfileKeySelectHint =>
      'Tap the dot to switch the active profile; without an explicit pick the most recently imported document for this release is used.';

  @override
  String get kernelProfileReviewHint =>
      'Confirm the source below. The editor will edit this one after applying.';

  @override
  String get kernelProfileDeclaredKernel => 'Declared kernel';

  @override
  String get kernelProfileReviewMatch => 'Matches this device, ready to run';

  @override
  String get kernelProfileReviewMismatch =>
      'Does not match this device; the run will be rejected';

  @override
  String get kernelProfileGhostKeyEntry => 'GhostKey profiles';

  @override
  String get kernelProfileGhostLockEntry => 'GhostLock profiles';

  @override
  String get kernelProfileImportEntry => 'Import profile';

  @override
  String get kernelImageExport => 'Export images';

  @override
  String kernelImageExportCount(int count) {
    return 'Export images ($count)';
  }

  @override
  String get kernelImageExportHint =>
      'Save the images extracted during parsing to the phone\'s Downloads folder for reuse or backup.';

  @override
  String get kernelImageExportEmpty => 'No image available to export';

  @override
  String kernelImageExportSaved(String name) {
    return 'Saved $name';
  }

  @override
  String get kernelImageExportFailed => 'Export failed';

  @override
  String get kernelProfileRemove => 'Remove';

  @override
  String get kernelProfileRemoveConfirmTitle => 'Remove this profile?';

  @override
  String kernelProfileRemoveConfirmBody(String release) {
    return '$release will be deleted. If no other profile matches this device, you will need to import again.';
  }

  @override
  String get kernelProfileErrorEmptyPath => 'No file path was provided';

  @override
  String get kernelProfileErrorNotFound => 'File not found or unreadable';

  @override
  String get kernelProfileErrorTooLarge => 'File is too large to parse';

  @override
  String get kernelProfileErrorNotBootImage => 'This is not a boot.img';

  @override
  String get kernelProfileErrorDecode => 'Failed to decompress the kernel';

  @override
  String get kernelProfileErrorIncomplete =>
      'The result was incomplete and was not saved';

  @override
  String get kernelProfileErrorIo => 'Failed to read or write the file';

  @override
  String get kernelProfileErrorNoBtf =>
      'This ROM\'s kernel has no BTF info, so struct offsets cannot be derived';

  @override
  String get kernelProfileErrorBadUrl =>
      'Invalid link; an HTTP or HTTPS address is required';

  @override
  String get kernelProfileErrorDownload =>
      'Failed to download or unpack the OTA';

  @override
  String kernelProfileErrorDetail(String detail) {
    return 'Details: $detail';
  }

  @override
  String get kernelProfileErrorOom => 'Out of memory while parsing';

  @override
  String get kernelProfileErrorUnknown => 'Unknown error';

  @override
  String get ghostKeyRunResultRunning => 'Running';

  @override
  String get ghostKeyRunResultSuccess => 'Success';

  @override
  String get ghostKeyRunResultFailed => 'Failed';

  @override
  String get ghostKeyRunResultStopped => 'Stopped';

  @override
  String get ghostKeyRunResultInterrupted => 'Interrupted';

  @override
  String ghostKeyDurationSeconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String ghostKeyDurationMinutesSeconds(int minutes, int seconds) {
    return '${minutes}m ${seconds}s';
  }

  @override
  String get ghostKeyRunLogTitle => 'Run Logs';

  @override
  String get ghostKeyRunLogEntrySubtitle =>
      'Review past runs and failure diagnoses';

  @override
  String ghostKeyRunLogCount(int count) {
    return '$count runs · newest first';
  }

  @override
  String get ghostKeyRunLogEmpty => 'No runs yet';

  @override
  String get ghostKeyRunLogExportAll => 'Export All';

  @override
  String get ghostKeyRunLogExportAllFileName => 'run-logs-all.log';

  @override
  String get ghostKeyRunLogClearAll => 'Clear All Runs';

  @override
  String get ghostKeyRunLogCleared => 'Run logs cleared';

  @override
  String ghostKeyRunLogDetailTitle(int runId) {
    return 'Run #$runId';
  }

  @override
  String get ghostKeyRunLogCopy => 'Copy';

  @override
  String get ghostKeyRunLogCopied => 'Copied to clipboard';

  @override
  String get ghostKeyRunLogSaveAs => 'Save As';

  @override
  String get ghostKeyRunLogSaved => 'Saved';

  @override
  String get ghostKeyRunLogDeleteThis => 'Delete This Run';

  @override
  String ghostKeyRunLogDiagTitlePrefix(String title) {
    return 'Diagnosis: $title';
  }

  @override
  String ghostKeyRunLogDiagCausePrefix(String cause) {
    return 'Possible cause: $cause';
  }

  @override
  String ghostKeyRunLogDiagSuggestionPrefix(String suggestion) {
    return 'Suggestion: $suggestion';
  }

  @override
  String get ghostKeyDiagCalibANoSlideCandidateTitle =>
      'KASLR offset solving failed: no trustworthy kernel base address among the candidates';

  @override
  String get ghostKeyDiagCalibANoSlideCandidateCause1 =>
      'Kernel just finished an OTA / just rebooted; the runtime layout no longer matches the profile assumptions';

  @override
  String get ghostKeyDiagCalibANoSlideCandidateCause2 =>
      'The imported profile does not match the current kernel (boot.img version mismatch)';

  @override
  String get ghostKeyDiagCalibANoSlideCandidateCause3 =>
      'Abnormal background load polluted the k_itimer samples';

  @override
  String get ghostKeyDiagCalibANoSlideCandidateCause4 =>
      'The tracefs sampling window caught no k_itimer records (SELinux blocking / insufficient Shizuku permission / too low background load)';

  @override
  String get ghostKeyDiagCalibANoSlideCandidateSuggestion1 =>
      'Reboot the device and try once more';

  @override
  String get ghostKeyDiagCalibANoSlideCandidateSuggestion2 =>
      'Make sure the profile matches the current kernel version (see the kernel version on the device info row)';

  @override
  String get ghostKeyDiagCalibANoSlideCandidateSuggestion3 =>
      'If it keeps failing, save the run log for investigation';

  @override
  String get ghostKeyDiagCalibANoKitimerRecordsTitle =>
      'KASLR offset solving failed: the multi-size probe collected no k_itimer allocation records';

  @override
  String get ghostKeyDiagCalibANoKitimerRecordsCause1 =>
      'The tracefs kmem_cache_alloc event was never enabled (blocked by SELinux, or abnormal Shizuku authorization / mount)';

  @override
  String get ghostKeyDiagCalibANoKitimerRecordsCause2 =>
      'The local k_itimer struct size is outside the candidate set 0x108 / 0x100 / 0x110 / 0x118, so no size matched';

  @override
  String get ghostKeyDiagCalibANoKitimerRecordsCause3 =>
      'System load was too low during sampling, so timer call sites were not triggered enough';

  @override
  String get ghostKeyDiagCalibANoKitimerRecordsSuggestion1 =>
      'Confirm Shizuku is authorized and tracefs is writable (Settings → Developer options)';

  @override
  String get ghostKeyDiagCalibANoKitimerRecordsSuggestion2 =>
      'Reboot and retry so that sampling completes within a single boot';

  @override
  String get ghostKeyDiagCalibANoKitimerRecordsSuggestion3 =>
      'If it still fails, save the run log (including [calib_a] and arm_kmem_cache_alloc lines) for investigation';

  @override
  String get ghostKeyDiagCalibATracefsUnusableTitle =>
      'tracefs unavailable: mounting / reading kernel trace events failed';

  @override
  String get ghostKeyDiagCalibATracefsUnusableCause1 =>
      'The SELinux policy blocked writes to tracefs';

  @override
  String get ghostKeyDiagCalibATracefsUnusableCause2 =>
      'Shizuku authorization problem (not started, or the permission was revoked)';

  @override
  String get ghostKeyDiagCalibATracefsUnusableCause3 =>
      'Some ROMs strip the tracefs nodes';

  @override
  String get ghostKeyDiagCalibATracefsUnusableSuggestion1 =>
      'Confirm Shizuku is running and has granted permission to this app';

  @override
  String get ghostKeyDiagCalibATracefsUnusableSuggestion2 =>
      'Check whether USB debugging (wireless debugging) is available in Developer options';

  @override
  String get ghostKeyDiagCalibATracefsUnusableSuggestion3 =>
      'Restart Shizuku and retry; if it still fails, save the log for investigation';

  @override
  String get ghostKeyDiagCalibBNoMatchingRecordsTitle =>
      'Page offset solving failed: the base address from calibration A does not match reality';

  @override
  String get ghostKeyDiagCalibBNoMatchingRecordsCause1 =>
      'The KASLR slide from calibration A is wrong (an upstream error; fix calibration A first)';

  @override
  String get ghostKeyDiagCalibBNoMatchingRecordsCause2 =>
      'Kernel memory layout changed between the two calibrations';

  @override
  String get ghostKeyDiagCalibBNoMatchingRecordsSuggestion1 =>
      'Reboot so both calibrations complete within the same boot session';

  @override
  String get ghostKeyDiagCalibBNoMatchingRecordsSuggestion2 =>
      'Re-run the full pipeline (do not skip the calibration steps)';

  @override
  String get ghostKeyDiagCalibBInsufficientSamplesTitle =>
      'Insufficient samples: too few triggered samples to solve the page offset';

  @override
  String get ghostKeyDiagCalibBInsufficientSamplesCause1 =>
      'Background load was too low, so timer call sites were not triggered enough';

  @override
  String get ghostKeyDiagCalibBInsufficientSamplesCause2 =>
      'The device just cold-booted and runtime services are not up yet';

  @override
  String get ghostKeyDiagCalibBInsufficientSamplesSuggestion1 =>
      'Put the device under light use (e.g. play music) and retry';

  @override
  String get ghostKeyDiagCalibBInsufficientSamplesSuggestion2 =>
      'Just run it again; samples are usually more plentiful the second time';

  @override
  String get ghostKeyDiagInjectResidualProcessTitle =>
      'A leftover process from the previous round is still pinning a freed page; injecting again would crash the kernel';

  @override
  String get ghostKeyDiagInjectResidualProcessCause1 =>
      'The previous round never reached cleanup (force-quit / power loss)';

  @override
  String get ghostKeyDiagInjectResidualProcessSuggestion1 =>
      'You must reboot before retrying (killing the leftover process does not help)';

  @override
  String get ghostKeyDiagInjectRootdNotReadyTitle =>
      'The exploit triggered but the root channel was never established: rootd timed out';

  @override
  String get ghostKeyDiagInjectRootdNotReadyCause1 =>
      'The device kernel carries a partial backport of the fix, making the UAF window unstable';

  @override
  String get ghostKeyDiagInjectRootdNotReadyCause2 =>
      'System load skewed the race timing';

  @override
  String get ghostKeyDiagInjectRootdNotReadySuggestion1 =>
      'Reboot and try once or twice more';

  @override
  String get ghostKeyDiagInjectRootdNotReadySuggestion2 =>
      'If it times out at the same point every time, the kernel may already be fixed; record the model and kernel version for feedback';

  @override
  String get ghostKeyDiagInjectOffsetTableMissingTitle =>
      'Kernel offset table not loaded: injection has no profile data';

  @override
  String get ghostKeyDiagInjectOffsetTableMissingCause1 =>
      'No profile was imported, or the imported profile file is corrupt';

  @override
  String get ghostKeyDiagInjectOffsetTableMissingCause2 =>
      'The profile does not match the current kernel and was rejected by the engine';

  @override
  String get ghostKeyDiagInjectOffsetTableMissingSuggestion1 =>
      'Re-import a profile for this kernel version (extracted from boot.img)';

  @override
  String get ghostKeyDiagInjectTaskLeakFailedTitle =>
      'task_struct address leak failed: no matching task_struct slab allocation in the scan window';

  @override
  String get ghostKeyDiagInjectTaskLeakFailedCause1 =>
      'The task_struct cache size disagrees with sizeof(task_struct) from BTF: the cache is created via kmem_cache_create_usercopy(\"task_struct\", arch_task_struct_size, 0x40, ...), where arch_task_struct_size is a runtime variable that vendors may extend via android_arch_task_struct_size= (up to 0x400)';

  @override
  String get ghostKeyDiagInjectTaskLeakFailedCause2 =>
      'The kmem_cache_alloc event was never enabled (tracefs not writable / SELinux denied)';

  @override
  String get ghostKeyDiagInjectTaskLeakFailedCause3 =>
      'A fork landed on a CPU that was not read (scanning covers all real cores, so this should not happen)';

  @override
  String get ghostKeyDiagInjectTaskLeakFailedSuggestion1 =>
      'Reboot the device and try again';

  @override
  String get ghostKeyDiagInjectTaskLeakFailedSuggestion2 =>
      'In the log, [task] raw=0 means the event was not enabled; raw>0 with hits=0 means the size window is wrong — save the [task] sizes= line for investigation';

  @override
  String get ghostKeyDiagVerifyFailedTitle =>
      'Temporary root verification failed: the su check did not pass after the escalation channel came up';

  @override
  String get ghostKeyDiagVerifyFailedCause1 =>
      'The credential rewrite during injection was incomplete (the upstream race only partly succeeded)';

  @override
  String get ghostKeyDiagVerifyFailedCause2 =>
      'The verification subprocess was blocked by SELinux or a system policy';

  @override
  String get ghostKeyDiagVerifyFailedSuggestion1 =>
      'Reboot and re-run the full pipeline';

  @override
  String get ghostKeyDiagVerifyFailedSuggestion2 =>
      'Check the SELinux state (Settings → Developer options); do not force it to Permissive';

  @override
  String get ghostKeyDiagKsuAlreadyLiveTitle =>
      'The kernel module is already resident: the old module is still in memory, so late-load was skipped';

  @override
  String get ghostKeyDiagKsuAlreadyLiveCause1 =>
      'The kernel module injected by the previous escalation is still alive';

  @override
  String get ghostKeyDiagKsuAlreadyLiveSuggestion1 =>
      'Reboot and run again so the manager can see the new takeover';

  @override
  String get ghostKeyDiagKsuAlreadyLiveSuggestion2 =>
      'If you only want root, there is no need to re-run — you already have temporary root';

  @override
  String get ghostKeyDiagKsuModuleAbsentTitle =>
      'KSU late-load failed: the module never appeared in /proc/modules';

  @override
  String get ghostKeyDiagKsuModuleAbsentCause1 =>
      'The root manager / ksud on the device is too old, so the KMI does not match';

  @override
  String get ghostKeyDiagKsuModuleAbsentCause2 =>
      'The kernel restricted the module load path';

  @override
  String get ghostKeyDiagKsuModuleAbsentSuggestion1 =>
      'Update the root manager on the device to the latest version';

  @override
  String get ghostKeyDiagKsuModuleAbsentSuggestion2 =>
      'Retry once; if it keeps failing, save the log and note the manager version';

  @override
  String get ghostKeyDiagKsuKsudMissingTitle =>
      'ksud not found: the selected root manager has no usable ksud';

  @override
  String get ghostKeyDiagKsuKsudMissingCause1 =>
      'No root manager is installed, or none is selected in the capsule';

  @override
  String get ghostKeyDiagKsuKsudMissingCause2 =>
      'That manager\'s ksud is incompatible with this architecture, or its library is corrupted';

  @override
  String get ghostKeyDiagKsuKsudMissingSuggestion1 =>
      'Install a root manager, select it in the top-right capsule, then re-run the pipeline';

  @override
  String get ghostKeyDiagHostShizukuUnavailableTitle =>
      'Shizuku environment problem: the host process cannot start the escalation pipeline';

  @override
  String get ghostKeyDiagHostShizukuUnavailableCause1 =>
      'The Shizuku service is not running (wireless debugging off or adb not connected)';

  @override
  String get ghostKeyDiagHostShizukuUnavailableCause2 =>
      'The user denied the Shizuku authorization for this app';

  @override
  String get ghostKeyDiagHostShizukuUnavailableSuggestion1 =>
      'Open the Shizuku app and make sure the service runs (either wireless debugging or adb)';

  @override
  String get ghostKeyDiagHostShizukuUnavailableSuggestion2 =>
      'Request authorization again inside this app and allow it';

  @override
  String get ghostKeyDiagFallbackExit2Title =>
      'Pipeline terminated (exit=2): KASLR offset solving failed and no known sub-pattern matched';

  @override
  String get ghostKeyDiagFallbackExit2Cause1 =>
      'Calibration A could not derive a trustworthy kernel base from k_itimer samples (the most common failure point)';

  @override
  String get ghostKeyDiagFallbackExit2Cause2 =>
      'The current kernel layout disagrees with the selected profile (recent OTA / reboot, or a mismatched profile version, gives wrong timer_link/cred_link offsets)';

  @override
  String get ghostKeyDiagFallbackExit2Cause3 =>
      'tracefs sampling was interrupted by an environment problem (SELinux blocking / Shizuku authorization lost / abnormal system load)';

  @override
  String get ghostKeyDiagFallbackExit2Cause4 =>
      'Or this failure is a new variant not yet covered by the diagnoser (exit code 2 but the log string matched no rule)';

  @override
  String get ghostKeyDiagFallbackExit2Suggestion1 =>
      'Reboot and retry once — KASLR differs on every boot, so a re-run usually solves it';

  @override
  String get ghostKeyDiagFallbackExit2Suggestion2 =>
      'Make sure you are on the latest build (1.1.5) and the profile was extracted from the device boot.img with a release exactly matching the current kernel';

  @override
  String get ghostKeyDiagFallbackExit2Suggestion3 =>
      'Do not just retry: save the full contents of the Run Log page (especially lines containing [calib_a] / [calib_b]) to help locate kernel compatibility issues';

  @override
  String ghostKeyDiagFallbackGenericTitle(int exit) {
    return 'Pipeline terminated (exit=$exit): no known failure pattern matched';
  }

  @override
  String get ghostKeyDiagFallbackGenericCause1 =>
      'The timing-sensitive race window was missed, or the environment failed temporarily';

  @override
  String get ghostKeyDiagFallbackGenericSuggestion1 =>
      'Do not just retry: copy and save the full contents of the Run Log page to help locate kernel compatibility issues';

  @override
  String get ghostKeyDiagFallbackGenericSuggestion2 =>
      'After repeated failures, reboot and retry; if it still fails, save the run log for investigation';

  @override
  String get settingsFollowAuthorSection => 'Follow the Author';

  @override
  String get settingsCreatorPlatformsTitle => 'Creator Platforms';

  @override
  String get settingsTutorialTitle => 'Tutorials';

  @override
  String get settingsTutorialSubtitle => 'Watch tutorials on creator platforms';

  @override
  String get settingsCommunityGroupTitle => 'Community Group';

  @override
  String get settingsCommunityGroupSubtitle => 'Join the group for help';

  @override
  String get settingsCreatorPlatformsIntro =>
      'Choose a platform to keep up with the latest creator updates.';

  @override
  String get settingsWechatTitle => 'WeChat Channel';

  @override
  String get settingsFeatureWishTitle => 'Feature Wish';

  @override
  String get settingsFeatureWishSubtitle =>
      'Tip the author and wish for a new feature';

  @override
  String get featureWishDialogDesc =>
      'Scan the code to tip the author, then submit your feature idea on GitHub.';

  @override
  String get featureWishIssueButton => 'Submit a Feature Issue';

  @override
  String get featureWishNetworkTip =>
      'Please open it with a proper network environment';

  @override
  String get platformFacebook => 'Facebook';

  @override
  String get platformTiktok => 'TikTok';

  @override
  String get platformDouyin => 'Douyin';

  @override
  String get platformBilibili => 'Bilibili';

  @override
  String get platformYoutube => 'YouTube';
}
