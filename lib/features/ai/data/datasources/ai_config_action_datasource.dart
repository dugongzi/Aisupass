import 'dart:convert';

import 'package:Aisupass/core/storage/preferences_store.dart';
import 'package:Aisupass/core/storage/secure_store.dart';
import 'package:Aisupass/features/ai/data/datasources/ai_config_query_datasource.dart';
import 'package:Aisupass/features/ai/data/models/ai_config_dto.dart';

/// AI 配置的写入数据源。
///
/// 只负责落盘：整表覆盖、API Key 写入/删除、当前配置 id 写入。
/// 读取由 [AiConfigQueryDatasource] 负责，两者不混用。
class AiConfigActionDatasource {
  const AiConfigActionDatasource({
    required this._preferences,
    required this._secure,
  });

  final PreferencesStore _preferences;
  final SecureStore _secure;

  Future<void> writeAll(List<AiConfigDto> configs) {
    final String raw = jsonEncode(
      configs.map((AiConfigDto item) => item.toJson()).toList(growable: false),
    );
    return _preferences.write<String>(AiConfigQueryDatasource.listKey, raw);
  }

  Future<void> writeApiKey(String id, String apiKey) => _secure.write<String>(
    AiConfigQueryDatasource.apiKeyKey(id),
    apiKey,
  );

  Future<void> deleteApiKey(String id) =>
      _secure.delete(AiConfigQueryDatasource.apiKeyKey(id));

  Future<void> writeCurrentId(String id) => _preferences.write<String>(
    AiConfigQueryDatasource.currentIdKey,
    id,
  );
}
