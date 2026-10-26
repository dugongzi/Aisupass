import 'package:Aisupass/features/ai/data/datasources/ai_config_action_datasource.dart';
import 'package:Aisupass/features/ai/data/datasources/ai_config_query_datasource.dart';
import 'package:Aisupass/features/ai/data/models/ai_config_dto.dart';
import 'package:Aisupass/features/ai/domain/constants/builtin_ai_config.dart';
import 'package:Aisupass/features/ai/domain/models/ai_config.dart';
import 'package:Aisupass/features/ai/domain/repositories/ai_config_action_repository.dart';

/// 写入仓储实现：Entity -> DTO 的唯一转换点。
///
/// 整表写入需要先拿到现有列表，读取走 Query 数据源，
/// 写入走 Action 数据源，保持两个数据源的职责不混用。
class AiConfigActionRepositoryImpl implements AiConfigActionRepository {
  const AiConfigActionRepositoryImpl({
    required this._queryDatasource,
    required this._actionDatasource,
  });

  final AiConfigQueryDatasource _queryDatasource;
  final AiConfigActionDatasource _actionDatasource;

  @override
  Future<void> save(AiConfig config) async {
    // 内置配置的字段由常量决定，只落用户可改的 Key、模型与协议，不进用户列表。
    if (isBuiltinAiConfig(config)) {
      await _actionDatasource.writeApiKey(config.id, config.apiKey.trim());
      await _actionDatasource.writeBuiltinModel(config.modelName.trim());
      await _actionDatasource.writeBuiltinApiType(config.apiType);
      return;
    }

    final List<AiConfigDto> configs = List<AiConfigDto>.of(
      await _queryDatasource.loadAll(),
    );
    final AiConfigDto dto = AiConfigDto.fromEntity(config);
    final int index = configs.indexWhere(
      (AiConfigDto item) => item.id == dto.id,
    );
    if (index >= 0) {
      configs[index] = dto;
    } else {
      configs.add(dto);
    }

    await _actionDatasource.writeApiKey(dto.id, dto.apiKey.trim());
    await _actionDatasource.writeAll(configs);
  }

  @override
  Future<void> delete(String id) async {
    // 内置配置不可删除，否则列表会失去兜底项。
    if (isBuiltinAiConfigId(id)) return;

    final List<AiConfigDto> configs = List<AiConfigDto>.of(
      await _queryDatasource.loadAll(),
    )..removeWhere((AiConfigDto item) => item.id == id);

    await _actionDatasource.deleteApiKey(id);
    await _actionDatasource.writeAll(configs);
  }

  @override
  Future<void> writeCurrentId(String id) =>
      _actionDatasource.writeCurrentId(id);
}
