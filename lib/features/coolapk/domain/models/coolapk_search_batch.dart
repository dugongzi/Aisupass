import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/features/coolapk/domain/models/coolapk_search_result.dart';

part 'coolapk_search_batch.freezed.dart';

/// 一批酷安搜索结果。
@freezed
abstract class CoolapkSearchBatch with _$CoolapkSearchBatch {
  const CoolapkSearchBatch._();

  const factory CoolapkSearchBatch({
    required List<CoolapkSearchResult> items,

    /// 服务端给出的总命中数；接口未返回时为 0。
    required int serverTotal,
  }) = _CoolapkSearchBatch;
}
