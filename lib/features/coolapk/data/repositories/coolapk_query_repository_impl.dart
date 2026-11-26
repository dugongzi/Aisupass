import 'package:Aisupass/features/coolapk/data/datasources/coolapk_query_datasource.dart';
import 'package:Aisupass/features/coolapk/data/models/coolapk_search_batch_dto.dart';
import 'package:Aisupass/features/coolapk/domain/enums/coolapk_search_type.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_search_batch.dart';
import 'package:Aisupass/features/coolapk/domain/repositories/coolapk_query_repository.dart';

/// 酷安查询仓储实现：DTO → Entity 的唯一转换点。
class CoolapkQueryRepositoryImpl implements CoolapkQueryRepository {
  const CoolapkQueryRepositoryImpl({required this._datasource});

  final CoolapkQueryDatasource _datasource;

  @override
  Future<CoolapkSearchBatch> search({
    required String query,
    CoolapkSearchType type = CoolapkSearchType.feed,
    int page = 1,
  }) async {
    final CoolapkSearchBatchDto dto = await _datasource.search(
      query: query,
      type: type,
      page: page,
    );
    return dto.toEntity();
  }
}
