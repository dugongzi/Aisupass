import 'package:Aisupass/features/ai/data/datasources/ai_config_query_datasource.dart';
import 'package:Aisupass/features/ai/data/models/ai_config_dto.dart';
import 'package:Aisupass/features/ai/domain/models/ai_config.dart';
import 'package:Aisupass/features/ai/domain/repositories/ai_config_query_repository.dart';

/// 查询仓储实现：DTO -> Entity 的唯一转换点。
class AiConfigQueryRepositoryImpl implements AiConfigQueryRepository {
  const AiConfigQueryRepositoryImpl({
    required this._datasource,
  });

  final AiConfigQueryDatasource _datasource;

  @override
  Future<List<AiConfig>> loadAll() async {
    final List<AiConfigDto> dtos = await _datasource.loadAll();
    return dtos
        .map((AiConfigDto dto) => dto.toEntity())
        .toList(growable: false);
  }

  @override
  Future<String> readCurrentId() => _datasource.readCurrentId();

  @override
  Future<String> readApiKey(String id) => _datasource.readApiKey(id);

  @override
  Future<String> readBuiltinModel() => _datasource.readBuiltinModel();

  @override
  Future<String> readBuiltinApiTypeName() => _datasource.readBuiltinApiTypeName();
}
