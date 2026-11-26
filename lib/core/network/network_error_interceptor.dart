import 'package:dio/dio.dart';

import 'package:Aisupass/core/network/network_exception.dart';

/// 错误归一化拦截器。
///
/// 两件事：把 [DioException] 统一挂上 [NetworkException]，让上层不必各写一份
/// 错误映射；以及把「声明要 JSON、却拿到纯文本」的响应（网关页、HTML 错误页）
/// 在进入数据源之前就判为失败。
class NetworkErrorInterceptor extends Interceptor {
  const NetworkErrorInterceptor();

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final dynamic data = response.data;
    final bool expectsJson =
        response.requestOptions.responseType == ResponseType.json;
    // 空响应体放行，交给数据源按自己的格式判断。
    if (expectsJson && data is String && data.trim().isNotEmpty) {
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: NetworkException(
            kind: NetworkErrorKind.badFormat,
            message: '响应不是 JSON',
            statusCode: response.statusCode,
            uri: response.requestOptions.uri,
          ),
        ),
      );
      return;
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        message: err.message,
        error: toNetworkException(err),
        stackTrace: err.stackTrace,
      ),
    );
  }
}
