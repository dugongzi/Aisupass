import 'package:Aisupass/features/ai/domain/models/ai_config.dart';

/// AI 配置的查询契约。
abstract interface class AiConfigQueryRepository {
  /// 读取全部配置（已合并安全存储中的 API Key）。
  Future<List<AiConfig>> loadAll();

  /// 读取当前启用的配置 id，未设置时返回空串。
  Future<String> readCurrentId();

  /// 读取指定配置的 API Key，未设置时返回空串。
  Future<String> readApiKey(String id);

  /// 读取内置配置所选模型，未设置时返回空串。
  Future<String> readBuiltinModel();

  /// 读取内置配置所选协议的枚举名，未设置时返回空串。
  Future<String> readBuiltinApiTypeName();
}
