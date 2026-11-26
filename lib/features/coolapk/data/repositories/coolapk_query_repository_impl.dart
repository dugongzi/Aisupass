import 'dart:convert';

import 'package:Aisupass/core/utils/json_value.dart';
import 'package:Aisupass/features/coolapk/data/datasources/coolapk_query_datasource.dart';
import 'package:Aisupass/features/coolapk/data/models/coolapk_account_dto.dart';
import 'package:Aisupass/features/coolapk/data/models/coolapk_feed_detail_dto.dart';
import 'package:Aisupass/features/coolapk/data/models/coolapk_feed_reply_dto.dart';
import 'package:Aisupass/features/coolapk/data/models/coolapk_search_batch_dto.dart';
import 'package:Aisupass/features/coolapk/domain/enums/coolapk_search_type.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_account.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_auth_state.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_feed_detail.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_feed_reply.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_risk_control.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_search_batch.dart';
import 'package:Aisupass/features/coolapk/domain/repositories/coolapk_query_repository.dart';

/// 酷安查询仓储实现：业务判定与 DTO → Entity 的唯一转换点。
///
/// 数据源只回原始 JSON，这里负责：
/// - 入参校验（空 id、空关键词）
/// - 拦截分型（风控验证码 / 设备身份异常 / 未登录）
/// - 返回体结构断言
/// - DTO 构造与实体转换
class CoolapkQueryRepositoryImpl implements CoolapkQueryRepository {
  const CoolapkQueryRepositoryImpl({required this._datasource});

  final CoolapkQueryDatasource _datasource;

  @override
  Future<CoolapkAccount?> fetchProfileByUid({
    required String uid,
    required String cookie,
  }) async {
    final String id = uid.trim();
    if (id.isEmpty) return null;

    final CoolapkRawResponse raw = await _datasource.fetchProfile(
      uid: id,
      cookie: cookie,
    );
    final Object? data = raw.body['data'];
    if (data is! Map) return null;
    return CoolapkAccountDto.fromJson(data.cast<String, dynamic>()).toEntity();
  }

  @override
  Future<CoolapkSearchBatch> search({
    required String query,
    CoolapkSearchType type = CoolapkSearchType.feed,
    int page = 1,
  }) async {
    final String keyword = query.trim();
    if (keyword.isEmpty) {
      throw const CoolapkSearchException('搜索关键词不能为空');
    }

    final CoolapkRawResponse raw = await _datasource.fetchSearch(
      keyword: keyword,
      type: type.name,
      page: page,
    );
    _throwIfBlocked(raw);
    _requireList(raw.body, '酷安未返回可用的搜索数据');
    return CoolapkSearchBatchDto.fromJson(raw.body).toEntity();
  }

  @override
  Future<CoolapkFeedDetail> fetchFeedDetail({required String feedId}) async {
    final String id = feedId.trim();
    if (id.isEmpty) {
      throw const CoolapkSearchException('动态 id 不能为空');
    }

    final CoolapkRawResponse raw = await _datasource.fetchFeedDetail(
      feedId: id,
    );
    _throwIfBlocked(raw);

    final Object? data = raw.body['data'];
    // 正常是一个对象；个别版本会包成长度为 1 的数组，这里一并兼容。
    final Map<String, dynamic>? entry = data is Map
        ? data.cast<String, dynamic>()
        : data is List && data.isNotEmpty && data.first is Map
        ? (data.first as Map).cast<String, dynamic>()
        : null;
    if (entry == null) {
      final String message = (raw.body['message'] ?? '').toString().trim();
      throw CoolapkSearchException(message.isEmpty ? '酷安未返回可用的动态详情' : message);
    }
    return CoolapkFeedDetailDto.fromJson(entry).toEntity();
  }

  @override
  Future<List<CoolapkFeedReply>> fetchReplies({
    required String feedId,
    int page = 1,
    String replyId = '',
  }) async {
    final String id = feedId.trim();
    if (id.isEmpty) {
      throw const CoolapkSearchException('动态 id 不能为空');
    }

    final CoolapkRawResponse raw = await _datasource.fetchReplies(
      feedId: id,
      page: page,
      replyId: replyId,
    );
    _throwIfBlocked(raw);

    final List<dynamic> data = _requireList(raw.body, '酷安未返回可用的评论数据');
    return <CoolapkFeedReply>[
      for (final Object? entry in data)
        if (entry is Map)
          CoolapkFeedReplyDto.fromJson(entry.cast<String, dynamic>())
              .toEntity(),
    ];
  }

  /// 把服务端的两种拦截拆开，交给不同上层处理。
  ///
  /// - `err_request_captcha_v2` / 文案含「验证码」：网易易盾风控，登录了也照拦，
  ///   抛 [CoolapkRiskControlException]，带上 `captchaId` 让界面拉起验证组件。
  /// - `-415`：设备身份被判为公共 / 游客设备，同属风控。
  /// - 401 或文案含「登录」：确实是没登录，抛 [CoolapkAuthRequiredException]。
  ///
  /// 注意风控响应是 HTTP 200，真正的状态码在 body 的 `code` 字段里，
  /// 所以这里只看 body。
  void _throwIfBlocked(CoolapkRawResponse raw) {
    final Map<String, dynamic> json = raw.body;
    final String message = (json['message'] ?? '').toString();
    final String messageStatus = (json['messageStatus'] ?? '').toString();
    final int code = intFromJson(json['code'], fallback: raw.status);

    if (messageStatus == 'err_request_captcha_v2' || message.contains('验证码')) {
      final Map<String, dynamic> extra = _messageExtra(json);
      throw CoolapkRiskControlException(
        'COOLAPK_RISK_CONTROL: 酷安要求先过人机验证（code=$code）',
        captchaId: (extra['captchaId'] ?? '').toString().trim(),
        captchaType: (extra['captchaType'] ?? '').toString().trim(),
      );
    }
    if (code == -415) {
      throw const CoolapkRiskControlException(
        'COOLAPK_RISK_CONTROL: 酷安判定设备身份异常（code=-415）',
      );
    }
    if (raw.status == 401 || code == 401 || message.contains('登录')) {
      throw const CoolapkAuthRequiredException(
        'COOLAPK_AUTH_REQUIRED: 酷安要求登录后才能继续，请提示用户先登录酷安',
      );
    }
  }

  /// 解析 `messageExtra`：服务器有时给对象，有时给一段 JSON 字符串。
  Map<String, dynamic> _messageExtra(Map<String, dynamic> json) {
    final Object? raw = json['messageExtra'];
    if (raw is Map) return raw.cast<String, dynamic>();
    if (raw is String && raw.trim().isNotEmpty) {
      try {
        final Object? decoded = jsonDecode(raw);
        if (decoded is Map) return decoded.cast<String, dynamic>();
      } on FormatException {
        return const <String, dynamic>{};
      }
    }
    return const <String, dynamic>{};
  }

  /// 断言响应体的 `data` 是数组，否则按服务端文案抛错。
  List<dynamic> _requireList(Map<String, dynamic> json, String fallback) {
    final dynamic data = json['data'];
    if (data is List) return data;
    final String message = (json['message'] ?? '').toString().trim();
    throw CoolapkSearchException(message.isEmpty ? fallback : message);
  }
}
