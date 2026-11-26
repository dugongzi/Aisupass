import 'package:dio/dio.dart';

import 'package:Aisupass/core/network/network_exception.dart';
import 'package:Aisupass/core/utils/coolapk_token.dart';
import 'package:Aisupass/features/coolapk/data/models/coolapk_search_batch_dto.dart';
import 'package:Aisupass/features/coolapk/domain/enums/coolapk_search_type.dart';

/// 酷安接口拒绝或返回体异常时抛出，由 presentation 层转成工具失败。
class CoolapkSearchException implements Exception {
  const CoolapkSearchException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() =>
      statusCode == null ? message : '$message (HTTP $statusCode)';
}

/// 酷安查询数据源：游客态调用 `/v6/search`，签名头由本地现算。
///
/// Dio 由 Provider 装配注入；动态详情 `/v6/feed/detail` 与完整评论
/// `/v6/feed/replyList` 游客态会被要求验证码，不在此封装。
class CoolapkQueryDatasource {
  CoolapkQueryDatasource({required this._dio});

  final Dio _dio;

  static const String _endpoint = 'https://api.coolapk.com/v6/search';

  /// 设备指纹在数据源实例内固定，避免每次请求换设备被风控。
  late final String _deviceCode = coolapkGuestDeviceCode();

  /// 按关键词搜索。[type] 为搜索维度，[page] 从 1 开始。
  Future<CoolapkSearchBatchDto> search({
    required String query,
    CoolapkSearchType type = CoolapkSearchType.feed,
    int page = 1,
  }) async {
    final String keyword = query.trim();
    if (keyword.isEmpty) {
      throw const CoolapkSearchException('搜索关键词不能为空');
    }

    final Response<dynamic> response;
    try {
      response = await _dio.get<dynamic>(
        _endpoint,
        queryParameters: <String, String>{
          'type': type.name,
          'searchValue': keyword,
          'page': '$page',
          'showAnonymous': '-1',
        },
        options: Options(
          responseType: ResponseType.json,
          validateStatus: (int? status) => status != null && status < 500,
          headers: coolapkHeaders(deviceCode: _deviceCode),
        ),
      );
    } on DioException catch (error) {
      // 传输层失败已由全局拦截器归一化，这里只做业务异常的类型转换。
      final NetworkException cause = toNetworkException(error);
      throw CoolapkSearchException(cause.message, statusCode: cause.statusCode);
    }

    final int status = response.statusCode ?? 0;
    final dynamic body = response.data;
    if (body is! Map) {
      throw CoolapkSearchException('酷安返回了非 JSON 内容', statusCode: status);
    }

    final Map<String, dynamic> json = body.cast<String, dynamic>();
    if (json['data'] is! List) {
      final String message = (json['message'] ?? '').toString().trim();
      throw CoolapkSearchException(
        message.isEmpty ? '酷安未返回可用的搜索数据' : message,
        statusCode: status,
      );
    }

    return CoolapkSearchBatchDto.fromJson(json);
  }
}
