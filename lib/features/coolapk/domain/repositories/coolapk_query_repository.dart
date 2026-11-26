import 'package:Aisupass/features/coolapk/domain/enums/coolapk_search_type.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_search_batch.dart';

/// 酷安查询仓储接口。
abstract class CoolapkQueryRepository {
  /// 按关键词搜索酷安。
  ///
  /// [type] 为搜索维度，[page] 从 1 开始。
  Future<CoolapkSearchBatch> search({
    required String query,
    CoolapkSearchType type = CoolapkSearchType.feed,
    int page = 1,
  });
}
