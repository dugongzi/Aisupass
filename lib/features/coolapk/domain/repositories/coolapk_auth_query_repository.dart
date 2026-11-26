import 'package:Aisupass/features/coolapk/domain/models/coolapk_auth_state.dart';

/// 酷安登录态的查询仓储接口。
abstract class CoolapkAuthQueryRepository {
  /// 读取本地保存的登录态，未登录时返回 [CoolapkAuthState.guest]。
  Future<CoolapkAuthState> load();

  /// 读取 WebView 当前会话的 Cookie。
  ///
  /// [urls] 要覆盖登录页与主站两个域名，Cookie 按域隔离。
  Future<CoolapkAuthState> readWebViewCookie({required List<String> urls});
}
