import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/features/coolapk/data/models/coolapk_search_result_dto.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_search_batch.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_search_result.dart';

part 'coolapk_search_batch_dto.freezed.dart';
part 'coolapk_search_batch_dto.g.dart';

/// `/v6/search` 响应体，字段名与服务器返回一致。
@freezed
abstract class CoolapkSearchBatchDto with _$CoolapkSearchBatchDto {
  const CoolapkSearchBatchDto._();

  const factory CoolapkSearchBatchDto({
    @Default(<CoolapkSearchResultDto>[]) List<CoolapkSearchResultDto> data,
  }) = _CoolapkSearchBatchDto;

  /// 服务器响应体 → DTO。
  factory CoolapkSearchBatchDto.fromJson(Map<String, dynamic> json) =>
      _$CoolapkSearchBatchDtoFromJson(json);

  /// DTO → 实体，逐条搬运；总命中数取首条带出的 `_queryTotal`。
  CoolapkSearchBatch toEntity() => CoolapkSearchBatch(
    items: <CoolapkSearchResult>[
      for (final CoolapkSearchResultDto item in data) item.toEntity(),
    ],
    serverTotal: data.isEmpty ? 0 : data.first.queryTotal,
  );
}
