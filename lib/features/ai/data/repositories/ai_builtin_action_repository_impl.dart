import 'package:Aisupass/core/network/api_exception.dart';
import 'package:Aisupass/features/ai/data/datasources/ai_builtin_action_datasource.dart';
import 'package:Aisupass/features/ai/domain/repositories/ai_builtin_action_repository.dart';

/// 内置面板的写入仓储实现。
class AiBuiltinActionRepositoryImpl implements AiBuiltinActionRepository {
  const AiBuiltinActionRepositoryImpl({required this._datasource});

  final AiBuiltinActionDatasource _datasource;

  @override
  Future<String> createKey({
    required String token,
    required String name,
    required int groupId,
  }) async {
    final String key = await _datasource.createKey(
      token: token,
      name: name,
      groupId: groupId,
    );
    if (key.isEmpty) {
      throw const ApiException('接口未返回密钥');
    }
    return key;
  }

  @override
  Future<void> redeemCode({required String token, required String code}) async {
    final String trimmed = code.trim();
    if (trimmed.isEmpty) {
      throw const ApiException('兑换码不能为空');
    }
    await _datasource.redeemCode(token: token, code: trimmed);
  }

  @override
  Future<void> updateKeyGroup({
    required String token,
    required int keyId,
    required int groupId,
  }) async {
    if (keyId <= 0) {
      throw const ApiException('未找到这把密钥，无法更换分组');
    }
    if (groupId <= 0) {
      throw const ApiException('分组无效，无法更换');
    }
    await _datasource.updateKeyGroup(
      token: token,
      keyId: keyId,
      groupId: groupId,
    );
  }
}
