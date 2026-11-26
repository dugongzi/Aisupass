import 'package:Aisupass/core/storage/secure_store.dart';
import 'package:Aisupass/features/coolapk/data/datasources/coolapk_auth_query_datasource.dart';
import 'package:Aisupass/features/coolapk/data/models/coolapk_auth_state_dto.dart';
import 'package:Aisupass/generated/coolapk_auth.g.dart' as pigeon;

/// 酷安登录态的写入数据源。
///
/// 键名与 [CoolapkAuthQueryDatasource] 共用，保证读写口径一致。
class CoolapkAuthActionDatasource {
  const CoolapkAuthActionDatasource({
    required this._secure,
    required this._native,
  });

  final SecureStore _secure;
  final pigeon.CoolapkAuthNative _native;

  /// 保存登录态。
  Future<void> save(CoolapkAuthStateDto dto) async {
    await _secure.write<String>(
      CoolapkAuthQueryDatasource.cookieKey,
      dto.cookie,
    );
    await _secure.write<String>(CoolapkAuthQueryDatasource.uidKey, dto.uid);
    await _secure.write<String>(
      CoolapkAuthQueryDatasource.usernameKey,
      dto.username,
    );
    await _secure.write<String>(
      CoolapkAuthQueryDatasource.captchaValidateKey,
      dto.captchaValidate,
    );
    await _secure.write<int>(
      CoolapkAuthQueryDatasource.captchaSavedAtKey,
      dto.captchaSavedAt,
    );
    await _secure.write<int>(
      CoolapkAuthQueryDatasource.savedAtKey,
      dto.savedAt,
    );
  }

  /// 清除登录态与 WebView 里的会话 Cookie。
  Future<void> clear() async {
    await _secure.delete(CoolapkAuthQueryDatasource.cookieKey);
    await _secure.delete(CoolapkAuthQueryDatasource.uidKey);
    await _secure.delete(CoolapkAuthQueryDatasource.usernameKey);
    await _secure.delete(CoolapkAuthQueryDatasource.captchaValidateKey);
    await _secure.delete(CoolapkAuthQueryDatasource.captchaSavedAtKey);
    await _secure.delete(CoolapkAuthQueryDatasource.savedAtKey);
    await _native.clearCookie();
  }
}
