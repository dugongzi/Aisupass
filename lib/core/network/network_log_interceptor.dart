import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// 请求日志拦截器。
///
/// 只在 debug 构建输出：请求方法、地址、脱敏后的头与截断后的响应体，
/// 避免发布包把签名、Token 或整段正文打进日志。
class NetworkLogInterceptor extends Interceptor {
  const NetworkLogInterceptor({this.tag = '[Http]', this.maxBodyChars = 600});

  /// 日志前缀，方便在控制台过滤。
  final String tag;

  /// 单条响应体的打印上限。
  final int maxBodyChars;

  /// 需要脱敏的请求头，统一按小写比较。
  static const Set<String> _secretHeaders = <String>{
    'authorization',
    'cookie',
    'x-app-token',
    'x-api-key',
    'api-key',
  };

  /// 请求起点挂在 `extra` 上，避免用全局 Map 记录并发的多笔请求。
  static const String _startedAtKey = 'networkLogStartedAt';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      options.extra[_startedAtKey] = DateTime.now();
      debugPrint(
        '$tag -> ${options.method} ${options.uri}\n'
        '$tag    headers: ${_headers(options.headers)}',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      debugPrint(
        '$tag <- ${response.statusCode} ${response.requestOptions.uri} '
        '(${_elapsed(response.requestOptions)}ms)\n'
        '$tag    body: ${_preview(response.data)}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '$tag !! ${err.type.name} ${err.requestOptions.uri} '
        '(${_elapsed(err.requestOptions)}ms): ${err.message}',
      );
    }
    handler.next(err);
  }

  /// 请求耗时（毫秒）；没有起点记录时返回 0。
  int _elapsed(RequestOptions options) {
    final Object? started = options.extra[_startedAtKey];
    if (started is! DateTime) return 0;
    return DateTime.now().difference(started).inMilliseconds;
  }

  /// 头信息脱敏后拼接：敏感值只留长度。
  String _headers(Map<String, dynamic> headers) {
    final List<String> parts = <String>[];
    headers.forEach((String key, Object? value) {
      final String text = '${value ?? ''}';
      final bool secret = _secretHeaders.contains(key.toLowerCase());
      parts.add('$key=${secret ? '<masked:${text.length}>' : text}');
    });
    return parts.join(', ');
  }

  /// 响应体预览：压平换行并按 [maxBodyChars] 截断，避免刷屏。
  String _preview(Object? body) {
    final String flat = (body?.toString() ?? '<null>').replaceAll('\n', r'\n');
    return flat.length <= maxBodyChars
        ? flat
        : '${flat.substring(0, maxBodyChars)}…';
  }
}
