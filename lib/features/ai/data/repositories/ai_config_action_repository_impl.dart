import 'package:Aisupass/features/ai/data/datasources/ai_config_action_datasource.dart';
import 'package:Aisupass/features/ai/data/datasources/ai_config_query_datasource.dart';
import 'package:Aisupass/features/ai/data/models/ai_config_dto.dart';
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
