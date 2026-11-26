import 'package:Aisupass/core/storage/secure_store.dart';
import 'package:Aisupass/features/coolapk/data/models/coolapk_auth_state_dto.dart';
import 'package:Aisupass/generated/coolapk_auth.g.dart' as pigeon;

/// 酷安登录态的只读数据源。
///
/// 两个来源：安全存储里的已登录会话，以及 WebView 实时的 Cookie 快照。
/// 令牌属于敏感凭据，单独放 [SecureStore]（Android Keystore 等），
/// 不与普通配置混存。
class CoolapkAuthQueryDatasource {
  const CoolapkAuthQueryDatasource({
    required this._secure,
    required this._native,
  });

  final SecureStore _secure;
  final pigeon.CoolapkAuthNative _native;

  /// Cookie 存储键。
  static const String cookieKey = 'coolapk_auth_cookie';

  /// 账号 id 存储键，有值即代表服务端确认过这个会话。
  static const String uidKey = 'coolapk_auth_uid';

  /// 昵称存储键。
  static const String usernameKey = 'coolapk_auth_username';

  /// 易盾验证码票据存储键。
  static const String captchaValidateKey = 'coolapk_auth_captcha_validate';

  /// 票据保存时间存储键。
  static const String captchaSavedAtKey = 'coolapk_auth_captcha_saved_at';

  /// 抓取时间存储键。
  static const String savedAtKey = 'coolapk_auth_saved_at';

  /// 读取已保存的登录态，没有 Cookie 即未登录。
  Future<CoolapkAuthStateDto> loadSaved() async {
    final String cookie = await _secure.read<String>(cookieKey);
    if (cookie.isEmpty) return const CoolapkAuthStateDto();
    final String uid = await _secure.read<String>(uidKey);
    final String username = await _secure.read<String>(usernameKey);
    final String captchaValidate = await _secure.read<String>(
      captchaValidateKey,
    );
    final int captchaSavedAt = await _secure.read<int>(
      captchaSavedAtKey,
      defaultValue: 0,
    );
    final int savedAt = await _secure.read<int>(savedAtKey, defaultValue: 0);
    return CoolapkAuthStateDto(
      cookie: cookie,
      uid: uid,
      username: username,
      captchaValidate: captchaValidate,
      captchaSavedAt: captchaSavedAt,
      savedAt: savedAt,
    );
  }

  /// 读取 WebView 当前会话的 Cookie。
  ///
  /// [urls] 要覆盖登录页与主站两个域名，Cookie 按域隔离。
  Future<CoolapkAuthStateDto> readWebViewCookie({
    required List<String> urls,
  }) async => CoolapkAuthStateDto.fromNative(await _native.readCookie(urls));
}
