import 'package:Aisupass/features/coolapk/data/datasources/coolapk_auth_action_datasource.dart';
import 'package:Aisupass/features/coolapk/data/models/coolapk_auth_state_dto.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_auth_state.dart';
import 'package:Aisupass/features/coolapk/domain/repositories/coolapk_auth_action_repository.dart';

/// 酷安登录态写入仓储实现：Entity → DTO 后交给数据源落盘。
class CoolapkAuthActionRepositoryImpl implements CoolapkAuthActionRepository {
  const CoolapkAuthActionRepositoryImpl({required this._datasource});

  final CoolapkAuthActionDatasource _datasource;

  @override
  Future<void> save(CoolapkAuthState state) =>
      _datasource.save(CoolapkAuthStateDto.fromEntity(state));

  @override
  Future<void> clear() => _datasource.clear();
}
