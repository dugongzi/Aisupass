import 'package:Aisupass/features/coolapk/data/datasources/coolapk_auth_query_datasource.dart';
import 'package:Aisupass/features/coolapk/data/models/coolapk_auth_state_dto.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_auth_state.dart';
import 'package:Aisupass/features/coolapk/domain/repositories/coolapk_auth_query_repository.dart';

/// 酷安登录态查询仓储实现：DTO → Entity 的唯一转换点。
class CoolapkAuthQueryRepositoryImpl implements CoolapkAuthQueryRepository {
  const CoolapkAuthQueryRepositoryImpl({required this._datasource});

  final CoolapkAuthQueryDatasource _datasource;

  @override
  Future<CoolapkAuthState> load() async {
    final CoolapkAuthStateDto dto = await _datasource.loadSaved();
    return dto.toEntity();
  }

  @override
  Future<CoolapkAuthState> readWebViewCookie({
    required List<String> urls,
  }) async {
    final CoolapkAuthStateDto dto = await _datasource.readWebViewCookie(
      urls: urls,
    );
    return dto.toEntity();
  }
}
