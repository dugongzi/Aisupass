/// 内置面板的写入仓储接口。
abstract class AiBuiltinActionRepository {
  /// 在面板上创建一把密钥，返回明文密钥。
  ///
  /// 服务端未返回密钥时抛异常，不返回空串给上层。
  Future<String> createKey({
    required String token,
    required String name,
    required int groupId,
  });

  /// 用兑换码充值额度；失败时抛异常。
  ///
  /// 成功不返回新余额，由调用方重新查询额度，避免依赖可选字段。
  Future<void> redeemCode({required String token, required String code});

  /// 把密钥改绑到另一个分组，密钥本身不变。
  ///
  /// [keyId] 无效或为 0 时抛异常：调用方应当先确认密钥在面板上存在。
  Future<void> updateKeyGroup({
    required String token,
    required int keyId,
    required int groupId,
  });
}
