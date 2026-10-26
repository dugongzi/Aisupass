import 'package:Aisupass/core/storage/storage_providers.dart';
import 'package:Aisupass/features/chat/data/datasources/chat_session_datasource.dart';
import 'package:Aisupass/features/chat/data/repositories/chat_session_repository_impl.dart';
import 'package:Aisupass/features/chat/domain/models/chat_session.dart';
import 'package:Aisupass/features/chat/domain/models/chat_turn.dart';
import 'package:Aisupass/features/chat/domain/repositories/chat_session_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 会话列表状态：按最近更新时间倒序，外加当前选中会话。
@immutable
class ChatSessionsState {
  const ChatSessionsState({
    this.sessions = const <ChatSession>[],
    this.currentId = '',
    this.loaded = false,
  });

  final List<ChatSession> sessions;
  final String currentId;

  /// 是否已完成首次磁盘读取，未完成前 UI 不展示「暂无会话」。
  final bool loaded;

  ChatSession? get current {
    for (final ChatSession session in sessions) {
      if (session.id == currentId) return session;
    }
    return null;
  }

  ChatSessionsState copyWith({
    List<ChatSession>? sessions,
    String? currentId,
    bool? loaded,
  }) {
    return ChatSessionsState(
      sessions: sessions ?? this.sessions,
      currentId: currentId ?? this.currentId,
      loaded: loaded ?? this.loaded,
    );
  }
}

/// 会话数据源。
final Provider<ChatSessionDatasource> chatSessionDatasourceProvider =
    Provider<ChatSessionDatasource>(
      (Ref ref) => ChatSessionDatasource(
        preferences: ref.watch(preferencesStoreProvider),
      ),
    );

/// 会话仓储。
final Provider<ChatSessionRepository> chatSessionRepositoryProvider =
    Provider<ChatSessionRepository>(
      (Ref ref) => ChatSessionRepositoryImpl(
        datasource: ref.watch(chatSessionDatasourceProvider),
      ),
    );

/// 会话列表控制器。
///
/// 只负责会话的增删改与当前项切换，不参与流式对话本身；
/// 对话内容由 `ChatController` 在每轮结束时通过 [saveTurns] 回写。
final NotifierProvider<ChatSessionsController, ChatSessionsState>
chatSessionsProvider =
    NotifierProvider<ChatSessionsController, ChatSessionsState>(
      ChatSessionsController.new,
    );

class ChatSessionsController extends Notifier<ChatSessionsState> {
  bool _disposed = false;

  ChatSessionRepository get _repository =>
      ref.read(chatSessionRepositoryProvider);

  @override
  ChatSessionsState build() {
    ref.onDispose(() => _disposed = true);
    // 同步 build 无法 await，先返回空态，读盘完成后再刷新。
    Future<void>(_restore);
    return const ChatSessionsState();
  }

  Future<void> _restore() async {
    final List<ChatSession> sessions = await _repository.loadAll();
    if (_disposed) return;

    final String storedId = await _repository.readCurrentId();
    if (_disposed) return;

    final List<ChatSession> sorted = _sort(sessions);
    if (sorted.isEmpty) {
      state = state.copyWith(loaded: true);
      return;
    }

    final bool hasStored = sorted.any(
      (ChatSession session) => session.id == storedId,
    );
    state = ChatSessionsState(
      sessions: sorted,
      currentId: hasStored ? storedId : sorted.first.id,
      loaded: true,
    );
  }

  /// 新建一个空会话并切换过去，返回新会话 id。
  Future<String> createSession() async {
    final DateTime now = DateTime.now();
    final ChatSession session = ChatSession(
      id: 'session-${now.microsecondsSinceEpoch}',
      title: '',
      createdAt: now,
      updatedAt: now,
    );
    final List<ChatSession> sessions = _sort(<ChatSession>[
      session,
      ...state.sessions,
    ]);
    state = state.copyWith(
      sessions: sessions,
      currentId: session.id,
      loaded: true,
    );
    await _repository.writeAll(sessions);
    await _repository.writeCurrentId(session.id);
    return session.id;
  }

  /// 切换当前会话。
  Future<void> select(String id) async {
    if (id == state.currentId) return;
    if (!state.sessions.any((ChatSession session) => session.id == id)) return;
    state = state.copyWith(currentId: id);
    await _repository.writeCurrentId(id);
  }

  /// 重命名会话，空标题视为未命名。
  Future<void> rename(String id, String title) async {
    final List<ChatSession> sessions = <ChatSession>[
      for (final ChatSession session in state.sessions)
        session.id == id ? session.copyWith(title: title.trim()) : session,
    ];
    state = state.copyWith(sessions: sessions);
    await _repository.writeAll(sessions);
  }

  /// 删除会话；删掉当前项时自动切到剩余首项，全部删完则回到空态。
  Future<void> delete(String id) async {
    final List<ChatSession> sessions = state.sessions
        .where((ChatSession session) => session.id != id)
        .toList(growable: false);
    final String nextId = state.currentId == id
        ? (sessions.isEmpty ? '' : sessions.first.id)
        : state.currentId;
    state = state.copyWith(sessions: sessions, currentId: nextId);
    await _repository.writeAll(sessions);
    await _repository.writeCurrentId(nextId);
  }

  /// 回写某个会话的轮次内容。
  ///
  /// 仅在每轮对话结束、停止或重命名时调用，不随 token 落盘；
  /// [title] 只在会话仍无标题时由首条用户消息生成。
  Future<void> saveTurns(
    String id,
    List<ChatTurn> turns, {
    String? title,
  }) async {
    if (state.sessions.every((ChatSession session) => session.id != id)) {
      return;
    }
    final DateTime now = DateTime.now();
    final List<ChatSession> updated = <ChatSession>[
      for (final ChatSession session in state.sessions)
        if (session.id == id)
          session.copyWith(
            turns: turns,
            updatedAt: now,
            title: (session.title.trim().isEmpty && (title ?? '').isNotEmpty)
                ? title
                : session.title,
          )
        else
          session,
    ];
    final List<ChatSession> sorted = _sort(updated);
    state = state.copyWith(sessions: sorted);
    await _repository.writeAll(sorted);
  }

  /// 按最近更新时间倒序排列。
  List<ChatSession> _sort(List<ChatSession> sessions) {
    final List<ChatSession> sorted = <ChatSession>[...sessions];
    sorted.sort(
      (ChatSession a, ChatSession b) => b.updatedAt.compareTo(a.updatedAt),
    );
    return List<ChatSession>.unmodifiable(sorted);
  }
}
