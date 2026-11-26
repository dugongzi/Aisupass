import 'package:Aisupass/features/coolapk/domain/models/coolapk_auth_state.dart';

/// 酷安登录态的写入仓储接口。
abstract class CoolapkAuthActionRepository {
  /// 保存登录态。
  Future<void> save(CoolapkAuthState state);

  /// 清除登录态（退出登录）。
  Future<void> clear();
}
