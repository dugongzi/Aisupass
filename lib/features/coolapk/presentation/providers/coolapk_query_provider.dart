import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:Aisupass/core/network/dio_client.dart';
import 'package:Aisupass/features/coolapk/data/datasources/coolapk_query_datasource.dart';
import 'package:Aisupass/features/coolapk/data/repositories/coolapk_query_repository_impl.dart';
import 'package:Aisupass/features/coolapk/domain/enums/coolapk_search_type.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_search_batch.dart';
import 'package:Aisupass/features/coolapk/domain/repositories/coolapk_query_repository.dart';

part 'coolapk_query_provider.g.dart';

/// 酷安查询数据源。
@riverpod
CoolapkQueryDatasource coolapkQueryDatasource(Ref ref) =>
    CoolapkQueryDatasource(dio: createAppDio());

/// 酷安查询仓储。
@riverpod
CoolapkQueryRepository coolapkQueryRepository(Ref ref) =>
    CoolapkQueryRepositoryImpl(
      datasource: ref.watch(coolapkQueryDatasourceProvider),
    );

/// 一次酷安搜索。
///
/// 关键词、维度与页码都是入参，结果不缓存：社区内容实时变动。
@riverpod
Future<CoolapkSearchBatch> coolapkSearch(
  Ref ref, {
  required String query,
  CoolapkSearchType type = CoolapkSearchType.feed,
  int page = 1,
}) => ref
    .watch(coolapkQueryRepositoryProvider)
    .search(query: query, type: type, page: page);
