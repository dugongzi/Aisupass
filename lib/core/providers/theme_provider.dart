import 'package:Aisupass/core/storage/preferences_store.dart';
import 'package:Aisupass/core/storage/storage_providers.dart';
import 'package:Aisupass/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 主题设置：模式（跟随系统 / 浅色 / 深色）+ 主题色。
@immutable
class AppThemeSettings {
  const AppThemeSettings({required this.themeMode, required this.seedColor});

  final ThemeMode themeMode;
  final Color seedColor;

  AppThemeSettings copyWith({ThemeMode? themeMode, Color? seedColor}) =>
      AppThemeSettings(
        themeMode: themeMode ?? this.themeMode,
        seedColor: seedColor ?? this.seedColor,
      );
}

/// 当前主题设置，持久化在 [PreferencesStore] 里。
///
/// 默认跟随系统、默认主题色；启动后异步读回上次选择，读不到就保持默认。
class ThemeSettingsNotifier extends Notifier<AppThemeSettings> {
  static const _modeKey = 'theme_mode';
  static const _seedKey = 'theme_seed_color';

  @override
  AppThemeSettings build() {
    Future.microtask(_load);
    return const AppThemeSettings(
      themeMode: ThemeMode.system,
      seedColor: AppColors.seed,
    );
  }

  PreferencesStore get _store => ref.read(preferencesStoreProvider);

  Future<void> _load() async {
    try {
      final String mode = await _store.read<String>(
        _modeKey,
        defaultValue: 'system',
      );
      final int seed = await _store.read<int>(
        _seedKey,
        defaultValue: AppColors.seed.toARGB32(),
      );
      state = AppThemeSettings(
        themeMode: _modeOf(mode),
        seedColor: Color(seed),
      );
    } catch (_) {
      // 存储不可用时保持默认主题，不阻塞界面。
    }
  }

  /// 切换主题模式并落盘。
  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == state.themeMode) return;
    state = state.copyWith(themeMode: mode);
    await _store.write<String>(_modeKey, _modeName(mode));
  }

  /// 切换主题色并落盘。
  Future<void> setSeedColor(Color color) async {
    if (color == state.seedColor) return;
    state = state.copyWith(seedColor: color);
    await _store.write<int>(_seedKey, color.toARGB32());
  }

  ThemeMode _modeOf(String name) => switch (name) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  String _modeName(ThemeMode mode) => switch (mode) {
    ThemeMode.light => 'light',
    ThemeMode.dark => 'dark',
    ThemeMode.system => 'system',
  };
}

final themeSettingsProvider =
    NotifierProvider<ThemeSettingsNotifier, AppThemeSettings>(
      ThemeSettingsNotifier.new,
    );
