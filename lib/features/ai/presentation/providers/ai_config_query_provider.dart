import 'package:Aisupass/core/storage/storage_providers.dart';
import 'package:Aisupass/features/ai/data/datasources/ai_config_query_datasource.dart';
import 'package:Aisupass/features/ai/data/repositories/ai_config_query_repository_impl.dart';
import 'package:Aisupass/features/ai/domain/constants/builtin_ai_config.dart';
import 'package:Aisupass/features/ai/domain/enums/ai_api_type.dart';
import 'package:Aisupass/features/ai/domain/models/ai_config.dart';
import 'package:Aisupass/features/ai/domain/repositories/ai_config_query_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_config_query_provider.g.dart';

/// AI 配置列表与当前启用项。
@immutable
class AiConfigState {
  const AiConfigState({required this.configs, required this.currentId});

  /// 全部配置，按存储顺序排列。
  final List<AiConfig> configs;

  /// 当前启用的配置 id，未设置时为空串。
  final String currentId;

  /// 当前启用的配置，未匹配到时回退到首项。
  AiConfig? get current {
    for (final AiConfig config in configs) {
      if (config.id == currentId) return config;
    }
    return configs.isEmpty ? null : configs.first;
  }

  /// 按 id 取配置，找不到返回 `null`。
  AiConfig? byId(String? id) {
    if (id == null || id.isEmpty) return null;
    for (final AiConfig config in configs) {
      if (config.id == id) return config;
    }
    return null;
  }
}

/// AI 配置的只读数据源。
@riverpod
AiConfigQueryDatasource aiConfigQueryDatasource(Ref ref) {
  return AiConfigQueryDatasource(
    preferences: ref.watch(preferencesStoreProvider),
    secure: ref.watch(secureStoreProvider),
  );
}

/// AI 配置的查询仓储。
@riverpod
AiConfigQueryRepository aiConfigQueryRepository(Ref ref) {
  return AiConfigQueryRepositoryImpl(
    datasource: ref.watch(aiConfigQueryDatasourceProvider),
  );
}

/// 读取全部 AI 配置及当前启用项。
///
/// 只读，写操作统一走 `aiConfigActionsProvider`，写完后由写侧失效本 Provider。
@riverpod
Future<AiConfigState> aiConfig(Ref ref) async {
  final AiConfigQueryRepository repository = ref.watch(
    aiConfigQueryRepositoryProvider,
  );
  final List<AiConfig> stored = await repository.loadAll();
  final String storedId = await repository.readCurrentId();

  // 内置配置不落用户列表，读取时拼在最前，保证列表永远至少有一项。
  final AiConfig builtin = buildBuiltinAiConfig(
    apiKey: await repository.readApiKey(builtinAiConfigId),
    modelName: await repository.readBuiltinModel(),
    apiType: AiApiType.fromName(await repository.readBuiltinApiTypeName()),
  );
  final List<AiConfig> configs = <AiConfig>[
    builtin,
    ...stored.where((AiConfig config) => !isBuiltinAiConfig(config)),
  ];

  final String currentId = configs.any(
    (AiConfig config) => config.id == storedId,
  )
      ? storedId
      : configs.first.id;
  return AiConfigState(configs: configs, currentId: currentId);
}
