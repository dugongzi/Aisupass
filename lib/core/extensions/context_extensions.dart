import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// 国际化快捷入口，用法：`context.l10n.homeTitle`。
extension BuildContextL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  String get languageCode => Localizations.localeOf(this).languageCode;

  bool get isChinese => languageCode == 'zh';

  bool get isEnglish => languageCode == 'en';
}
