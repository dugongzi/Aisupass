import 'package:Aisupass/core/storage/preferences_store.dart';
import 'package:Aisupass/core/storage/secure_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 普通配置存储：主题、语言、上次选择等非敏感数据。
final preferencesStoreProvider = Provider<PreferencesStore>(
  (ref) => PreferencesStore(),
);

/// 敏感凭据存储：AI API Key、登录 Token 等。
final secureStoreProvider = Provider<SecureStore>((ref) => SecureStore());
