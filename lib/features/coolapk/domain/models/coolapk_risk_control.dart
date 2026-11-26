/// 酷安接口被风控拦下，需要过一次人机验证。
///
/// 与 `CoolapkAuthRequiredException` 是两回事——用户已经登录也会拿到它：
/// 响应是 HTTP 200，body 里 `messageStatus: err_request_captcha_v2`，
/// `messageExtra` 带上网易易盾的 `captchaId`。
///
/// 通过一次验证拿到 `validate` 票据后写进 Cookie，接口即放行。
class CoolapkRiskControlException implements Exception {
  const CoolapkRiskControlException(
    this.message, {
    this.captchaId = '',
    this.captchaType = '',
  });

  /// 固定前缀，不参与本地化，界面与模型都靠它区分「该提示登录」与「要过验证码」。
  static const String marker = 'COOLAPK_RISK_CONTROL';

  final String message;

  /// 易盾验证码业务 id，非空才能拉起验证组件。
  final String captchaId;

  /// 验证码类型，目前只有 `NEC`（网易易盾）。
  final String captchaType;

  /// 是否还能靠过验证码恢复；false 表示是别的风控原因。
  bool get captchaRequired => captchaId.isNotEmpty;

  @override
  String toString() => captchaId.isEmpty
      ? message
      : '$message captchaId=$captchaId captchaType=$captchaType';
}
