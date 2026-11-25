import 'package:Aisupass/l10n/app_localizations.dart';

/// 通道未连接：这不是终端里的「故障」，而是还没有链路。
///
/// 顶部提示条已经负责说明并给出重连入口，写进终端只会在连上之后变成一句错的
/// 旧话（「shell 通道未连接」挂在提示符上面，其实早就通了）。
const String kEscalationChannelNotReady = 'channelNotReady';

/// 原生侧会回的原因码。
///
/// 只翻译这几个；其余串是原生抛上来的原始错误，按原样贴出来更有用。
const Set<String> kEscalationReasonCodes = <String>{
  'emptyCommand',
  kEscalationChannelNotReady,
  'streamOpenFailed',
};

String escalationReasonLabel(String code, AppLocalizations l10n) =>
    switch (code) {
      'emptyCommand' => l10n.escalationExecReasonEmpty,
      'channelNotReady' => l10n.escalationExecReasonNotReady,
      'streamOpenFailed' => l10n.escalationExecReasonStreamFailed,
      // 未识别的原因也比「命令没能启动：」后面空着强。
      _ => code,
    };

/// GhostLock 预检的 `profileError` → 可读文案。
///
/// 原生会带前缀区分原因：`profileReleaseMismatch: <表内> != <设备>`（选中的表
/// 与设备内核不是同一构建）、`profileMissing: <文件名>`（生效来源指向的文档没了）；
/// 其余按技术诊断码原样包一层。
String ghostLockProfileErrorText(AppLocalizations l10n, String error) {
  const String mismatch = 'profileReleaseMismatch: ';
  if (error.startsWith(mismatch)) {
    final List<String> parts = error.substring(mismatch.length).split(' != ');
    if (parts.length == 2) {
      return l10n.escalationGhostLockProfileMismatch(parts[0], parts[1]);
    }
  }
  const String missing = 'profileMissing: ';
  if (error.startsWith(missing)) {
    return l10n.escalationGhostLockProfileMissing(
      error.substring(missing.length),
    );
  }
  return l10n.escalationGhostLockProfileInvalid(error);
}

/// GhostLock 会话的本侧诊断码 → 可读文案；未识别的码原样带出来。
String ghostLockFailureText(AppLocalizations l10n, String code) =>
    switch (code) {
      'deviceDisconnected' => l10n.escalationGhostLockFailureDeviceDisconnected,
      'launchFailed' => l10n.escalationGhostLockFailureLaunch,
      'profileWriteFailed' => l10n.escalationGhostLockFailureProfileWrite,
      'nativeNotStarted' => l10n.escalationGhostLockFailureNotStarted,
      _ => l10n.escalationGhostLockFailureCode(code),
    };

/// 载荷启动失败码 → 可读文案；未识别的码原样带出来。
String payloadLaunchFailureText(AppLocalizations l10n, String code) =>
    switch (code) {
      'noCandidate' => l10n.escalationPayloadNoCandidate,
      'libraryDirUnavailable' => l10n.escalationPayloadLibraryDirUnavailable,
      'helperMissing' => l10n.escalationPayloadHelperMissing,
      'payloadMissing' => l10n.escalationPayloadFileMissing,
      'argumentsUnresolved' => l10n.escalationPayloadArgumentsUnresolved,
      _ => code,
    };

/// 退出码行。负数是「没取到」，不是真实退出码。
String escalationExitTag(int code) => code < 0 ? 'exit --' : 'exit $code';

/// GhostKey 拒绝受理的原因码 → 「文案（码）」；未识别的码原样返回。
String ghostKeyNotStartedReason(AppLocalizations l10n, String code) =>
    _withCode(l10n, code, switch (code) {
      'alreadyRunning' => l10n.escalationGhostKeyReasonAlreadyRunning,
      'noAdb' => l10n.escalationGhostKeyReasonNoAdb,
      'notShell' => l10n.escalationGhostKeyReasonNotShell,
      'seccompFiltered' => l10n.escalationGhostKeyReasonSeccomp,
      'missingBinary' => l10n.escalationGhostKeyReasonMissingBinary,
      'noProfile' => l10n.escalationGhostKeyReasonNoProfile,
      'badRequest' => l10n.escalationGhostKeyReasonBadRequest,
      _ => null,
    });

/// DirtyFrag 拒绝受理的原因码 → 「文案（码）」；未识别的码原样返回。
String dirtyFragNotStartedReason(AppLocalizations l10n, String code) =>
    _withCode(l10n, code, switch (code) {
      'alreadyArmed' => l10n.escalationDirtyFragReasonAlreadyArmed,
      'busy' => l10n.escalationDirtyFragReasonBusy,
      'noIpSec' => l10n.escalationDirtyFragReasonNoIpSec,
      'missingBinary' => l10n.escalationDirtyFragReasonMissingBinary,
      'stagingFailed' => l10n.escalationDirtyFragReasonStagingFailed,
      'badRequest' => l10n.escalationDirtyFragReasonBadRequest,
      _ => null,
    });

/// 码留在文案后面，出问题时还能对照原生日志。
String _withCode(AppLocalizations l10n, String code, String? label) =>
    label == null ? code : l10n.escalationReasonWithCode(label, code);

/// GhostLock 字段提交失败 → 可读文案。
///
/// 原生判定「该值会让配置无法解析」时给专用提示，其余原样交给调用方展示。
String ghostLockSubmitErrorText(AppLocalizations l10n, Object error) {
  final String text = error.toString();
  if (text.contains('profileOverrideRejected')) {
    return l10n.escalationGhostLockProfileRejected;
  }
  return text;
}
