import 'package:Aisupass/core/storage/storage_providers.dart';
import 'package:Aisupass/features/ai/data/datasources/ai_config_action_datasource.dart';
import 'package:Aisupass/features/ai/data/repositories/ai_config_action_repository_impl.dart';
import 'package:Aisupass/features/ai/domain/constants/builtin_ai_config.dart';
import 'package:Aisupass/features/ai/domain/models/ai_config.dart';
import 'package:Aisupass/features/ai/domain/repositories/ai_config_action_repository.dart';
import 'package:Aisupass/features/ai/domain/repositories/ai_config_query_repository.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_config_query_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_config_action_provider.g.dart';

/// AI 配置的写入数据源。
@riverpod
AiConfigActionDatasource aiConfigActionDatasource(Ref ref) {
  return AiConfigActionDatasource(
    preferences: ref.watch(preferencesStoreProvider),
    secure: ref.watch(secureStoreProvider),
  );
}

/// AI 配置的写入仓储。
@riverpod
AiConfigActionRepository aiConfigActionRepository(Ref ref) {
  return AiConfigActionRepositoryImpl(
    queryDatasource: ref.watch(aiConfigQueryDatasourceProvider),
    actionDatasource: ref.watch(aiConfigActionDatasourceProvider),
  );
}

/// 配置的写操作入口。
///
/// 每次落盘后失效查询 Provider，保证 UI 状态与存储一致；
/// 当前配置为空时自动把新配置设为当前项。
class AiConfigActions {
  const AiConfigActions(this._ref);

  final Ref _ref;

  AiConfigActionRepository get _repository =>
      _ref.read(aiConfigActionRepositoryProvider);

  AiConfigQueryRepository get _queryRepository =>
      _ref.read(aiConfigQueryRepositoryProvider);

  /// 新增或更新一条配置，随后刷新配置列表。
  Future<void> save(AiConfig config) async {
    await _repository.save(config);
    if ((await _queryRepository.readCurrentId()).isEmpty) {
      await _repository.writeCurrentId(config.id);
    }
    _ref.invalidate(aiConfigProvider);
  }

  /// 删除指定配置；若删的是当前项，则改指向剩余首项。
  ///
  /// 内置配置不可删除，直接忽略。
  Future<void> remove(String id) async {
    if (isBuiltinAiConfigId(id)) return;

    await _repository.delete(id);
    if (await _queryRepository.readCurrentId() == id) {
      final List<AiConfig> configs = await _queryRepository.loadAll();
      await _repository.writeCurrentId(configs.isEmpty ? '' : configs.first.id);
    }
    _ref.invalidate(aiConfigProvider);
  }

  /// 切换当前启用的配置。
  Future<void> setCurrent(String id) async {
    if (await _queryRepository.readCurrentId() == id) return;
    await _repository.writeCurrentId(id);
    _ref.invalidate(aiConfigProvider);
  }
}

/// 配置写操作入口的 Provider。
///
/// 用 `keepAlive` 保住 [Ref]，避免 `ref.read` 后立即销毁导致异步落盘时失效。
@Riverpod(keepAlive: true)
AiConfigActions aiConfigActions(Ref ref) => AiConfigActions(ref);
