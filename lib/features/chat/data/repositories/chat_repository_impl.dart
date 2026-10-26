import 'package:Aisupass/features/ai/data/models/ai_config_dto.dart';
import 'package:Aisupass/features/ai/domain/models/ai_config.dart';
import 'package:Aisupass/features/chat/data/datasources/chat_datasource.dart';
import 'package:Aisupass/features/chat/domain/models/chat_stream_event.dart';
import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/domain/models/chat_turn.dart';
import 'package:Aisupass/features/chat/domain/repositories/chat_repository.dart';

/// 对话仓库实现：Entity -> DTO 后交给数据源请求。
class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl({
    required this._datasource,
  });

  final ChatDatasource _datasource;

  @override
  Stream<ChatStreamEvent> streamChat({
    required AiConfig config,
    required List<ChatTurn> history,
    required List<ChatToolDefinition> tools,
  }) => _datasource.streamChat(
    config: AiConfigDto.fromEntity(config),
    history: history,
    tools: tools,
  );
}
