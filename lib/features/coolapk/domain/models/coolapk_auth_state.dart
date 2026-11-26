import 'package:freezed_annotation/freezed_annotation.dart';

part 'coolapk_auth_state.freezed.dart';

/// 酷安登录态。
///
/// 由 WebView 登录会话产生：读取 Cookie 后与服务端确认会话是否换发，
/// 确认通过才落盘。
@freezed
abstract class CoolapkAuthState with _$CoolapkAuthState {
  const CoolapkAuthState._();

  const factory CoolapkAuthState({
    /// 登录后完整的 Cookie 串，形如 `SESSID=abc; uid=123`。
    required String cookie,

    /// 账号 id，由 `/v6/user/profile` 确认；空串即未登录。
    required String uid,

    /// 昵称。
    required String username,

    /// 易盾验证码的 `validate` 票据，随 Cookie 一起发给服务端。
    ///
    /// 风控拦下 `/v6/feed/detail` 时，过完验证拿到票据写在这里；
    /// 空串表示还没过验证。
    required String captchaValidate,

    /// 票据保存时间（毫秒时间戳）。
    ///
    /// 验证卡片用它判断「用户是这次才过的验证」：只有保存时间晚于卡片
    /// 出现的时刻才算完成，避免把上一次遗留的票据当成刚验证过。
    required int captchaSavedAt,

    /// 抓取时间（毫秒时间戳），仅用于展示登录时刻。
    required int savedAt,
  }) = _CoolapkAuthState;

  /// 未登录：全部字段为空。
  static const CoolapkAuthState guest = CoolapkAuthState(
    cookie: '',
    uid: '',
    username: '',
    captchaValidate: '',
    captchaSavedAt: 0,
    savedAt: 0,
  );

  /// 是否有可用的登录会话。
  ///
  /// 只看 Cookie 是否为空：落盘前已确认过会话换发，空 Cookie 即未登录。
  bool get isLoggedIn => cookie.isNotEmpty;
}

/// 需要登录酷安才能继续。
///
/// [marker] 是给界面用的稳定标识：工具失败时 `error` 固定以它开头，
/// 对话卡片据此渲染登录入口；模型也能从同一段文字读到「该提示用户登录」。
class CoolapkAuthRequiredException implements Exception {
  const CoolapkAuthRequiredException([this.message = marker]);

  /// 固定前缀，不参与本地化，否则界面判不出来。
  static const String marker = 'COOLAPK_AUTH_REQUIRED';

  final String message;

  @override
  String toString() => message;
}
