import 'package:Aisupass/features/ai/data/datasources/ai_model_query_datasource.dart';
import 'package:Aisupass/features/ai/data/models/ai_config_dto.dart';
import 'package:Aisupass/features/ai/domain/models/ai_config.dart';
import 'package:Aisupass/features/ai/domain/repositories/ai_model_query_repository.dart';

/// 模型目录查询实现：Entity -> DTO 后交给数据源请求。
class AiModelQueryRepositoryImpl implements AiModelQueryRepository {
  const AiModelQueryRepositoryImpl({
    required this._datasource,
  });

  final AiModelQueryDatasource _datasource;

  @override
  Future<List<String>> fetchModels(AiConfig config) =>
      _datasource.fetchModels(AiConfigDto.fromEntity(config));
}
