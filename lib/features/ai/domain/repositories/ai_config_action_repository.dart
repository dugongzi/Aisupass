import 'package:Aisupass/features/ai/domain/models/ai_config.dart';

/// AI 配置的写入契约。
abstract interface class AiConfigActionRepository {
  /// 新增或更新一条配置（按 [AiConfig.id] 匹配）。
  Future<void> save(AiConfig config);

  /// 删除指定配置及其 API Key。
  Future<void> delete(String id);

  /// 记录当前启用的配置 id。
  Future<void> writeCurrentId(String id);
}
