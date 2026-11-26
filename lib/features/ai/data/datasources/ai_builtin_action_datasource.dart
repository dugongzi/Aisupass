import 'package:Aisupass/core/network/api_client.dart';
import 'package:Aisupass/features/ai/domain/constants/builtin_ai_config.dart';
import 'package:uuid/uuid.dart';

/// 内置面板的写入数据源。
///
/// 只发建密钥请求并解析出明文密钥，不做重试与降级判断。
class AiBuiltinActionDatasource {
  AiBuiltinActionDatasource({ApiClient? client})
    : _client = client ?? ApiClient(baseUrl: builtinAiConfigBaseUrl);

  final ApiClient _client;

  /// 创建一把密钥，返回服务端生成的明文密钥；未返回时为空串。
  ///
  /// 只提交名称与分组：不设额度、不设有效期，与内置配置的定位一致。
  /// 带上幂等键，避免网络重试在服务端落成两把密钥。
  Future<String> createKey({
    required String token,
    required String name,
    required int groupId,
  }) async {
    final Object? data = await _client.post(
      '$builtinAiConfigApiPath/keys',
      body: <String, dynamic>{'name': name, 'group_id': groupId},
      headers: <String, String>{'Idempotency-Key': const Uuid().v4()},
      token: token,
    );
    if (data is! Map) return '';
    final Object? key = data['key'];
    return key is String ? key.trim() : '';
  }

  /// 用兑换码充值额度，成功时不返回内容（新余额由调用方重新查询）。
  Future<void> redeemCode({required String token, required String code}) async {
    await _client.post(
      '$builtinAiConfigApiPath/redeem',
      body: <String, dynamic>{'code': code},
      token: token,
    );
  }

  /// 把一把密钥改绑到另一个分组，密钥本身不变。
  ///
  /// 只提交 `group_id`，其余字段（额度、限速、有效期）保持面板上的原值。
  Future<void> updateKeyGroup({
    required String token,
    required int keyId,
    required int groupId,
  }) async {
    await _client.put(
      '$builtinAiConfigApiPath/keys/$keyId',
      body: <String, dynamic>{'group_id': groupId},
      token: token,
    );
  }
}
