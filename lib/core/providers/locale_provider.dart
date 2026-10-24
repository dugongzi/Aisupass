import 'package:Aisupass/core/storage/preferences_store.dart';
import 'package:Aisupass/core/storage/storage_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 当前界面语言，持久化在 [PreferencesStore] 里。
///
/// 默认中文；启动后异步读回上次选择，读不到就保持中文。
class LocaleNotifier extends Notifier<Locale> {
  static const _storageKey = 'locale_language_code';

  @override
  Locale build() {
    Future.microtask(_load);
    return const Locale('zh', 'CN');
  }

  PreferencesStore get _store => ref.read(preferencesStoreProvider);

  Future<void> _load() async {
    try {
      final String code = await _store.read<String>(
        _storageKey,
        defaultValue: 'zh',
      );
      if (code == state.languageCode) return;
      state = _localeOf(code);
    } catch (_) {
      // 存储不可用时保持默认语言，不阻塞界面。
    }
  }

  /// 切换语言并落盘。[code] 只接受 `zh` / `en`。
  Future<void> setLanguage(String code) async {
    state = _localeOf(code);
    await _store.write<String>(_storageKey, code);
  }

  Future<void> toggleLanguage() =>
      setLanguage(state.languageCode == 'zh' ? 'en' : 'zh');

  Locale _localeOf(String code) =>
      code == 'en' ? const Locale('en', 'US') : const Locale('zh', 'CN');
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
