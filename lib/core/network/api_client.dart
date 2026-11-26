import 'package:Aisupass/core/network/api_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// 面板接口的 HTTP 客户端封装。
///
/// 只做三件事：拼鉴权头、解 `{code,message,data}` 信封、把 `DioException`
/// 归一成 [ApiException]。不含任何业务判断，具体接口由各数据源自己声明。
///
/// 仅服务于新接入的内置面板链路；既有各数据源独立创建的 `Dio` 不受影响。
class ApiClient {
  ApiClient({
    required this.baseUrl,
    Duration connectTimeout = const Duration(seconds: 15),
    Duration receiveTimeout = const Duration(seconds: 20),
    Dio? dio,
  }) : _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: baseUrl,
               connectTimeout: connectTimeout,
               receiveTimeout: receiveTimeout,
               // 4xx 也交给信封解析：错误响应体里同样带 code 与 message，
               // 交给上层判断比在这里直接抛更准。
               validateStatus: (int? status) => status != null && status < 500,
             ),
           );

  /// 面板根地址，如 `https://v2.muxueai.pro`。
  final String baseUrl;

  final Dio _dio;

  /// 调试日志前缀，方便在控制台过滤。
  static const String _tag = '[AiBuiltin]';

  /// 发起 GET 请求并返回信封里的 `data` 部分。
  Future<Object?> get(
    String path, {
    Map<String, dynamic>? query,
    String token = '',
  }) => _send(
    () => _dio.get<dynamic>(
      path,
      queryParameters: query,
      options: Options(headers: _headers(token)),
    ),
    path: path,
  );

  /// 发起 POST 请求并返回信封里的 `data` 部分。
  Future<Object?> post(
    String path, {
    Object? body,
    Map<String, String>? headers,
    String token = '',
  }) => _send(
    () => _dio.post<dynamic>(
      path,
      data: body,
      options: Options(
        headers: <String, dynamic>{..._headers(token), ...?headers},
      ),
    ),
    path: path,
  );

  /// 发起 PUT 请求并返回信封里的 `data` 部分。
  Future<Object?> put(
    String path, {
    Object? body,
    Map<String, String>? headers,
    String token = '',
  }) => _send(
    () => _dio.put<dynamic>(
      path,
      data: body,
      options: Options(
        headers: <String, dynamic>{..._headers(token), ...?headers},
      ),
    ),
    path: path,
  );

  /// 组装鉴权头；[token] 为空时不带，供匿名接口使用。
  Map<String, String> _headers(String token) {
    final String trimmed = token.trim();
    if (trimmed.isEmpty) return const <String, String>{};
    return <String, String>{'Authorization': 'Bearer $trimmed'};
  }

  /// 统一执行请求并解包，所有异常归一为 [ApiException]。
  Future<Object?> _send(
    Future<Response<dynamic>> Function() request, {
    required String path,
  }) async {
    late final Response<dynamic> response;
    try {
      response = await request();
    } on DioException catch (error) {
      final Response<dynamic>? failed = error.response;
      final _Envelope? envelope = _readEnvelope(failed?.data);
      _log('✗ $path ${failed?.statusCode ?? error.type.name}');
      throw ApiException(
        envelope?.message.isNotEmpty == true
            ? envelope!.message
            : error.message ?? error.type.name,
        statusCode: failed?.statusCode,
        code: envelope?.code ?? '',
      );
    }
    _log('✓ $path ${response.statusCode}');
    return _unwrap(response);
  }

  /// 解 `{code,message,data}` 信封；`code` 非 0 时按业务失败抛出。
  Object? _unwrap(Response<dynamic> response) {
    final _Envelope? envelope = _readEnvelope(response.data);
    if (envelope == null) {
      throw ApiException('响应格式异常', statusCode: response.statusCode);
    }
    if (!envelope.ok) {
      throw ApiException(
        envelope.message.isEmpty ? '请求失败' : envelope.message,
        statusCode: response.statusCode,
        code: envelope.code,
      );
    }
    return envelope.data;
  }

  /// 从响应体里读出信封字段；结构不符时返回 `null`。
  static _Envelope? _readEnvelope(Object? raw) {
    if (raw is! Map) return null;
    final Object? code = raw['code'];
    final Object? message = raw['message'];
    return _Envelope(
      code: code?.toString() ?? '',
      message: message?.toString() ?? '',
      data: raw['data'],
      ok: code == 0 || code == '0',
    );
  }

  /// 只输出方法与路径，不输出鉴权头与响应体：里面是令牌与密钥。
  static void _log(String message) {
    if (kDebugMode) debugPrint('$_tag $message');
  }
}

/// 服务端统一响应信封的解析结果。
class _Envelope {
  const _Envelope({
    required this.code,
    required this.message,
    required this.data,
    required this.ok,
  });

  final String code;
  final String message;
  final Object? data;
  final bool ok;
}
