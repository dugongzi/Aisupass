import 'package:Aisupass/features/chat/data/datasources/chat_session_datasource.dart';
import 'package:Aisupass/features/chat/domain/models/chat_session.dart';
import 'package:Aisupass/features/chat/domain/repositories/chat_session_repository.dart';

/// 对话会话仓储实现，直接透传给数据源。
class ChatSessionRepositoryImpl implements ChatSessionRepository {
  const ChatSessionRepositoryImpl({required ChatSessionDatasource datasource})
    : _datasource = datasource;

  final ChatSessionDatasource _datasource;

  @override
  Future<List<ChatSession>> loadAll() => _datasource.loadAll();

  @override
  Future<String> readCurrentId() => _datasource.readCurrentId();

  @override
  Future<void> writeAll(List<ChatSession> sessions) =>
      _datasource.writeAll(sessions);

  @override
  Future<void> writeCurrentId(String id) => _datasource.writeCurrentId(id);
}
