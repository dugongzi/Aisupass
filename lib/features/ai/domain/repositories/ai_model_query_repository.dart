import 'package:Aisupass/features/ai/domain/models/ai_chat_probe_event.dart';
import 'package:Aisupass/features/ai/domain/models/ai_config.dart';

/// 模型目录的查询契约。
abstract interface class AiModelQueryRepository {
  /// 拉取该配置可用的模型 id 列表，失败时抛 `AiRequestException`。
  Future<List<String>> fetchModels(AiConfig config);

  /// 流式发送一条测试消息，失败信息随事件返回而不抛出。
  Stream<AiChatProbeEvent> streamTestMessage(AiConfig config, String message);
}
