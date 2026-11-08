import 'package:Aisupass/l10n/app_localizations.dart';

/// 原生侧会回的原因码。
///
/// 只翻译这几个；其余串是原生抛上来的原始错误，按原样贴出来更有用。
const Set<String> kEscalationReasonCodes = <String>{
  'emptyCommand',
  'channelNotReady',
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

/// 退出码行。负数是「没取到」，不是真实退出码。
String escalationExitTag(int code) => code < 0 ? 'exit --' : 'exit $code';
