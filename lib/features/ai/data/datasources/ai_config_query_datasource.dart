import 'dart:convert';

import 'package:Aisupass/core/storage/preferences_store.dart';
import 'package:Aisupass/core/storage/secure_store.dart';
import 'package:Aisupass/features/ai/data/models/ai_config_dto.dart';

/// AI 配置的只读数据源。
///
/// 配置本体来自 [PreferencesStore]，API Key 来自 [SecureStore]，
/// 组装成 [AiConfigDto] 交给仓储层，本身不做业务判断。
class AiConfigQueryDatasource {
  const AiConfigQueryDatasource({
    required this._preferences,
    required this._secure,
  });

  /// 配置列表（不含 API Key）的存储键，值为 JSON 字符串。
  static const String listKey = 'ai_config_list';

  /// 当前启用配置 id 的存储键。
  static const String currentIdKey = 'ai_config_current_id';

  /// API Key 的存储键前缀，实际键名为前缀 + 配置 id。
  static const String apiKeyPrefix = 'ai_config_api_key_';

  /// 拼出某条配置的 API Key 存储键。
  static String apiKeyKey(String id) => '$apiKeyPrefix$id';

  final PreferencesStore _preferences;
  final SecureStore _secure;

  Future<List<AiConfigDto>> loadAll() async {
    final String raw = await _preferences.read<String>(
      listKey,
      defaultValue: '',
    );
    if (raw.trim().isEmpty) return const <AiConfigDto>[];

    final Object? decoded = jsonDecode(raw);
    if (decoded is! List) return const <AiConfigDto>[];

    final List<AiConfigDto> configs = <AiConfigDto>[];
    for (final Object? item in decoded) {
      if (item is! Map) continue;
      final Map<String, dynamic> map = item.map(
        (Object? key, Object? value) => MapEntry(key.toString(), value),
      );
      final String id = map['id']?.toString() ?? '';
      if (id.isEmpty) continue;
      final String apiKey = await _secure.read<String>(
        apiKeyKey(id),
        defaultValue: '',
      );
      configs.add(AiConfigDto.fromJson(map).copyWith(apiKey: apiKey));
    }
    return configs;
  }

  Future<String> readCurrentId() =>
      _preferences.read<String>(currentIdKey, defaultValue: '');
}
