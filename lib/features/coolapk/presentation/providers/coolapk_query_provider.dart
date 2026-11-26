import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:Aisupass/core/network/dio_client.dart';
import 'package:Aisupass/features/coolapk/data/datasources/coolapk_query_datasource.dart';
import 'package:Aisupass/features/coolapk/data/repositories/coolapk_query_repository_impl.dart';
import 'package:Aisupass/features/coolapk/domain/enums/coolapk_search_type.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_auth_state.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_feed_detail.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_feed_reply.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_search_batch.dart';
import 'package:Aisupass/features/coolapk/domain/repositories/coolapk_query_repository.dart';
import 'package:Aisupass/features/coolapk/presentation/providers/coolapk_auth_query_provider.dart';

part 'coolapk_query_provider.g.dart';

/// 酷安查询数据源。
///
/// 登录态与验证码票据变化会重建它，让请求头立即跟上。
@riverpod
CoolapkQueryDatasource coolapkQueryDatasource(Ref ref) =>
    CoolapkQueryDatasource(
      dio: createAppDio(),
      cookie: ref.watch(coolapkAuthCookieProvider),
      captchaValidate: ref.watch(coolapkCaptchaValidateProvider),
    );

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

/// 某条动态的完整内容。
///
/// 需要登录；游客态会抛 [CoolapkAuthRequiredException]。
@riverpod
Future<CoolapkFeedDetail> coolapkFeedDetail(
  Ref ref, {
  required String feedId,
}) => ref.watch(coolapkQueryRepositoryProvider).fetchFeedDetail(feedId: feedId);

/// 某条动态的全部评论（含楼中楼）。
///
/// 需要登录；游客态会抛 [CoolapkAuthRequiredException]。
@riverpod
Future<List<CoolapkFeedReply>> coolapkFeedReplies(
  Ref ref, {
  required String feedId,
  int page = 1,
  String replyId = '',
}) => ref
    .watch(coolapkQueryRepositoryProvider)
    .fetchReplies(feedId: feedId, page: page, replyId: replyId);
