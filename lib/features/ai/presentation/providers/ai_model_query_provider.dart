import 'package:Aisupass/features/ai/data/datasources/ai_model_query_datasource.dart';
import 'package:Aisupass/features/ai/data/repositories/ai_model_query_repository_impl.dart';
import 'package:Aisupass/features/ai/domain/repositories/ai_model_query_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_model_query_provider.g.dart';

/// 模型目录的只读数据源。
@riverpod
AiModelQueryDatasource aiModelQueryDatasource(Ref ref) {
  return AiModelQueryDatasource();
}

/// 模型目录的查询仓储。
@riverpod
AiModelQueryRepository aiModelQueryRepository(Ref ref) {
  return AiModelQueryRepositoryImpl(
    datasource: ref.watch(aiModelQueryDatasourceProvider),
  );
}
