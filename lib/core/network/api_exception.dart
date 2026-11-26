/// 面板接口调用失败时抛出的异常。
///
/// 由 `ApiClient` 统一产出，携带 HTTP 状态码与服务端业务码，
/// 供上层区分「登录失效」「需要二次验证」与普通业务错误。
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode, this.code = ''});

  /// 可直接展示的原始文案，优先取服务端返回的 `message`。
  final String message;

  /// HTTP 状态码；请求没有拿到响应（断网、超时）时为 `null`。
  final int? statusCode;

  /// 服务端业务码，如 `UNAUTHORIZED`、`STEP_UP_REQUIRED`；无则为空串。
  final String code;

  /// 是否为登录态失效。
  bool get isUnauthorized => statusCode == 401 || code == 'UNAUTHORIZED';

  /// 是否为需要先完成二次验证。
  bool get requiresStepUp => code == 'STEP_UP_REQUIRED';

  @override
  String toString() => message;
}
