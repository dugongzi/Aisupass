import 'package:dio/dio.dart';

import 'package:Aisupass/core/network/network_exception.dart';
import 'package:Aisupass/core/utils/coolapk_token.dart';

/// 酷安接口拒绝、返回体异常或请求前置条件不满足。
///
/// 与 `CoolapkAuthRequiredException`、`CoolapkRiskControlException` 并列，
/// 区别是本异常不做分型：调用方只需要「失败了 + 原因文案」。
class CoolapkSearchException implements Exception {
  const CoolapkSearchException(this.message, {this.statusCode});

  /// 已尽量取服务端返回的可读文案。
  final String message;

  /// HTTP 状态码，传输层失败时才有值。
  final int? statusCode;

  @override
  String toString() =>
      statusCode == null ? message : '$message (HTTP $statusCode)';
}

/// 酷安接口的一次原始响应：HTTP 状态码 + 已解析的 JSON 体。
///
/// 风控响应是 HTTP 200，真正的状态码在 `body['code']`，因此两者都要带出去。
typedef CoolapkRawResponse = ({int status, Map<String, dynamic> body});

/// 酷安查询数据源：只发请求、只回原始 JSON。
///
/// 接口清单与访问条件：
/// - `/v6/search`：关键词搜索，游客可读。
/// - `/v6/feed/detail`：动态正文，需要登录。
/// - `/v6/feed/replyList`：全部评论 / 楼中楼，需要登录。
/// - `/v6/user/profile`：按 uid 查资料，不校验 Cookie。
///
/// 「被风控拦截 / 要求登录 / 返回体结构不对」属于业务判断，全部放在
/// `CoolapkQueryRepositoryImpl`；本类只负责签名头、查询参数与传输层错误归一化。
///
/// [cookie] 来自 WebView 登录，非空时随请求发出；为空即游客态。
/// [captchaValidate] 是过完易盾验证拿到的票据，按 `validate` Cookie 发出。
class CoolapkQueryDatasource {
  CoolapkQueryDatasource({
    required this._dio,
    String cookie = '',
    String captchaValidate = '',
  }) : _cookie = cookie.trim(),
       _captchaValidate = captchaValidate.trim();

  final Dio _dio;
  final String _cookie;
  final String _captchaValidate;

  static const String _searchEndpoint = 'https://api.coolapk.com/v6/search';
  static const String _feedDetailEndpoint =
      'https://api.coolapk.com/v6/feed/detail';
  static const String _replyListEndpoint =
      'https://api.coolapk.com/v6/feed/replyList';

  /// 当前账号资料。必须带 `uid`：该接口是「按 uid 查资料」，
  /// 不带 uid 时对任何身份都返回「用户不存在」，读不出会话本身。
  static const String _profileEndpoint =
      'https://api.coolapk.com/v6/user/profile';

  /// 设备指纹在数据源实例内固定，避免每次请求换设备被风控。
  late final String _deviceCode = coolapkGuestDeviceCode();

  /// `/v6/search` 原始响应。
  Future<CoolapkRawResponse> fetchSearch({
    required String keyword,
    required String type,
    int page = 1,
  }) => _get(_searchEndpoint, <String, String>{
    'type': type,
    'searchValue': keyword,
    'page': '$page',
    'showAnonymous': '-1',
  });

  /// `/v6/feed/detail` 原始响应。
  Future<CoolapkRawResponse> fetchFeedDetail({required String feedId}) =>
      _get(_feedDetailEndpoint, <String, String>{'id': feedId});

  /// `/v6/feed/replyList` 原始响应。
  ///
  /// [replyId] 为空时取动态顶层评论；非空时改为翻该评论的楼中楼。
  /// 两条路径的参数结构不同：楼中楼以评论 id 为主体、`feedType` 换成
  /// `feed_reply`，不是给评论列表加过滤条件。
  Future<CoolapkRawResponse> fetchReplies({
    required String feedId,
    int page = 1,
    String replyId = '',
  }) {
    final String parent = replyId.trim();
    final Map<String, String> query = parent.isEmpty
        ? <String, String>{
            'id': feedId,
            // 必须是 lastupdate_desc：传 reply 这类自造值服务端不认，
            // 但照样回 200 + 空数组，表现的像是「帖子没有评论」。
            'listType': 'lastupdate_desc',
            'page': '$page',
            'discussMode': '1',
            'feedType': 'feed',
            'fromFeedAuthor': '0',
          }
        : <String, String>{
            // 楼中楼只发这三个参数，多带的自造参数会被静默忽略成空列表。
            'id': parent,
            'page': '$page',
            'feedType': 'feed_reply',
          };
    return _get(_replyListEndpoint, query);
  }

  /// `/v6/user/profile` 原始响应。
  ///
  /// [cookie] 显式传入：登录抓取阶段新 Cookie 还没落盘，不能用实例上那份。
  Future<CoolapkRawResponse> fetchProfile({
    required String uid,
    required String cookie,
  }) => _get(_profileEndpoint, <String, String>{
    'uid': uid,
  }, cookie: cookie.trim());

  /// 发一次签名请求并返回状态码与 JSON 体。
  ///
  /// [cookie] 为空串以外的值时覆盖实例上的登录 Cookie。
  Future<CoolapkRawResponse> _get(
    String endpoint,
    Map<String, String> queryParameters, {
    String? cookie,
  }) async {
    final Response<dynamic> response;
    try {
      response = await _dio.get<dynamic>(
        endpoint,
        queryParameters: queryParameters,
        options: Options(
          responseType: ResponseType.json,
          validateStatus: (int? status) => status != null && status < 500,
          headers: coolapkHeaders(
            deviceCode: _deviceCode,
            cookie: cookie ?? _cookie,
            captchaValidate: _captchaValidate,
          ),
        ),
      );
    } on DioException catch (error) {
      // 传输层失败已由全局拦截器归一化，这里只做异常类型的转换。
      final NetworkException cause = toNetworkException(error);
      throw CoolapkSearchException(cause.message, statusCode: cause.statusCode);
    }

    final int status = response.statusCode ?? 0;
    final dynamic body = response.data;
    if (body is! Map) {
      throw CoolapkSearchException('酷安返回了非 JSON 内容', statusCode: status);
    }
    return (status: status, body: body.cast<String, dynamic>());
  }
}
