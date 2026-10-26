import 'package:Aisupass/features/chat/domain/models/chat_session.dart';

/// 对话会话的读写仓储。
abstract class ChatSessionRepository {
  Future<List<ChatSession>> loadAll();

  Future<String> readCurrentId();

  Future<void> writeAll(List<ChatSession> sessions);

  Future<void> writeCurrentId(String id);
}
