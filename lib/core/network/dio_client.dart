import 'package:dio/dio.dart';

import 'package:Aisupass/core/network/network_error_interceptor.dart';
import 'package:Aisupass/core/network/network_log_interceptor.dart';

/// 默认连接超时。
const Duration kDefaultConnectTimeout = Duration(seconds: 15);

/// 默认发送超时。
const Duration kDefaultSendTimeout = Duration(seconds: 15);

/// 默认接收超时。
const Duration kDefaultReceiveTimeout = Duration(seconds: 20);

/// 统一的 JSON 请求头，作为所有请求的基线。
const Map<String, String> kDefaultJsonHeaders = <String, String>{
  Headers.acceptHeader: Headers.jsonContentType,
  Headers.contentTypeHeader: Headers.jsonContentType,
};

/// 创建全应用共用的 Dio。
///
/// 统一了三件事，避免各数据源自己 `Dio(BaseOptions(...))` 造成口径漂移：
/// 1. 请求格式——默认按 JSON 收发、只放行 2xx、带统一超时；
/// 2. 全局拦截器——日志（仅 debug）与错误归一化各挂一个；
/// 3. 可覆写——[connectTimeout] 等入参用于个别接口的超时/头差异。
Dio createAppDio({
  String baseUrl = '',
  Duration connectTimeout = kDefaultConnectTimeout,
  Duration receiveTimeout = kDefaultReceiveTimeout,
  Duration sendTimeout = kDefaultSendTimeout,
  Map<String, String> headers = const <String, String>{},
  ResponseType responseType = ResponseType.json,
  ValidateStatus? validateStatus,
}) {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
      responseType: responseType,
      headers: <String, String>{...kDefaultJsonHeaders, ...headers},
      validateStatus: validateStatus ?? _acceptSuccessOnly,
    ),
  );

  dio.interceptors.addAll(<Interceptor>[
    const NetworkLogInterceptor(),
    const NetworkErrorInterceptor(),
  ]);

  return dio;
}

/// 只接受 2xx；其余交给 [NetworkErrorInterceptor] 归一化为失败。
bool _acceptSuccessOnly(int? status) =>
    status != null && status >= 200 && status < 300;
