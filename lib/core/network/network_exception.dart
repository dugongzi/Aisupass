import 'package:dio/dio.dart';

/// 网络失败归类，便于调用方按类型分支。
enum NetworkErrorKind {
  /// 连接、发送或接收超时。
  timeout,

  /// 无法建立连接（断网、DNS 解析失败、证书不合法等）。
  connection,

  /// 请求被主动取消。
  cancelled,

  /// 服务端返回非 2xx。
  badResponse,

  /// 响应体不是约定的 JSON。
  badFormat,

  /// 其它未归类异常。
  unknown,
}

/// 统一网络异常。
///
/// Dio 的传输异常、HTTP 错误码与响应格式错误都收敛到这一个类型；
/// [message] 优先取服务端返回的错误文案，取不到时按 [kind] 给兜底描述。
class NetworkException implements Exception {
  const NetworkException({
    required this.kind,
    required this.message,
    this.statusCode,
    this.uri,
  });

  /// 由 [DioException] 归一化；其中已带 [NetworkException] 时直接复用。
  factory NetworkException.fromDio(DioException error) {
    final Object? inner = error.error;
    if (inner is NetworkException) return inner;

    final Response<dynamic>? response = error.response;
    final int? statusCode = response?.statusCode;
    final NetworkErrorKind kind = switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => NetworkErrorKind.timeout,
      DioExceptionType.badCertificate ||
      DioExceptionType.connectionError => NetworkErrorKind.connection,
      DioExceptionType.cancel => NetworkErrorKind.cancelled,
      DioExceptionType.badResponse => NetworkErrorKind.badResponse,
      DioExceptionType.unknown => NetworkErrorKind.unknown,
    };
    final String serverMessage = _serverMessage(response?.data);

    return NetworkException(
      kind: kind,
      message: serverMessage.isNotEmpty
          ? serverMessage
          : _fallbackMessage(kind, statusCode, error.message),
      statusCode: statusCode,
      uri: error.requestOptions.uri,
    );
  }

  final NetworkErrorKind kind;

  /// 可读失败原因，可直接展示。
  final String message;

  /// HTTP 状态码；未拿到响应时为 `null`。
  final int? statusCode;

  /// 出错的请求地址。
  final Uri? uri;

  @override
  String toString() {
    final String status = statusCode == null ? '' : ' (HTTP $statusCode)';
    return 'NetworkException(${kind.name})$status: $message';
  }

  /// 按失败类型给兜底描述，仅在服务端没给文案时使用。
  static String _fallbackMessage(
    NetworkErrorKind kind,
    int? statusCode,
    String? dioMessage,
  ) => switch (kind) {
    NetworkErrorKind.timeout => '请求超时',
    NetworkErrorKind.connection => '连接失败',
    NetworkErrorKind.cancelled => '请求已取消',
    NetworkErrorKind.badResponse =>
      statusCode == null ? '请求失败' : '服务端返回 HTTP $statusCode',
    NetworkErrorKind.badFormat => '响应不是 JSON',
    NetworkErrorKind.unknown => dioMessage ?? '未知网络错误',
  };

  /// 从服务端错误体里取可读文案；HTML 错误页与空串一律视为没有文案。
  static String _serverMessage(Object? body) {
    if (body is Map) {
      for (final String key in const <String>[
        'message',
        'msg',
        'error',
        'error_description',
        'errorMessage',
      ]) {
        final Object? value = body[key];
        if (value is String && value.trim().isNotEmpty) return value.trim();
      }
      return '';
    }
    if (body is String) {
      final String text = body.trim();
      if (text.isEmpty || text.startsWith('<')) return '';
      return text.length <= 120 ? text : '${text.substring(0, 120)}…';
    }
    return '';
  }
}

/// 把任意异常归一化为 [NetworkException]。
NetworkException toNetworkException(Object error) {
  if (error is NetworkException) return error;
  if (error is DioException) return NetworkException.fromDio(error);
  return NetworkException(
    kind: NetworkErrorKind.unknown,
    message: error.toString(),
  );
}
