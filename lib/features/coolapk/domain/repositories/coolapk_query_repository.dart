import 'package:Aisupass/features/coolapk/domain/enums/coolapk_search_type.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_account.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_feed_detail.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_feed_reply.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_search_batch.dart';

/// 酷安查询仓储接口。
abstract class CoolapkQueryRepository {
  /// 按 uid 拉取账号资料，用于补昵称。
  ///
  /// 该接口不校验 Cookie，游客也能查任意 uid，因此它**不能**用来判断登录态；
  /// 登录态以 Cookie 里是否带 uid 为准。查不到返回 `null`。
  Future<CoolapkAccount?> fetchProfileByUid({
    required String uid,
    required String cookie,
  });

  /// 按关键词搜索酷安。
  ///
  /// [type] 为搜索维度，[page] 从 1 开始。
  Future<CoolapkSearchBatch> search({
    required String query,
    CoolapkSearchType type = CoolapkSearchType.feed,
    int page = 1,
  });

  /// 拉取动态详情（正文）。需要登录。
  ///
  /// [feedId] 为动态 id；游客态会被风控拦下。
  Future<CoolapkFeedDetail> fetchFeedDetail({required String feedId});

  /// 拉取动态的全部评论（含楼中楼）。需要登录。
  ///
  /// [feedId] 为动态 id，[page] 从 1 开始；[replyId] 非空时翻该评论的楼中楼。
  Future<List<CoolapkFeedReply>> fetchReplies({
    required String feedId,
    int page = 1,
    String replyId = '',
  });
}
