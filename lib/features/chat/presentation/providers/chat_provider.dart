import 'dart:async';
import 'dart:convert';

import 'package:Aisupass/core/providers/device_info_provider.dart';
import 'package:Aisupass/core/providers/system_status_provider.dart';
import 'package:Aisupass/features/ai/domain/models/ai_config.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_config_query_provider.dart';
import 'package:Aisupass/features/chat/data/datasources/chat_datasource.dart';
import 'package:Aisupass/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:Aisupass/features/chat/domain/models/chat_stream_event.dart';
import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/domain/models/chat_turn.dart';
import 'package:Aisupass/features/chat/domain/repositories/chat_repository.dart';
import 'package:Aisupass/features/chat/presentation/providers/chat_sessions_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 会话级问题，文案由 UI 按语言映射。
enum ChatIssue { noConfig }

/// 对话页状态：完整轮次列表 + 是否正在接收流。
@immutable
class ChatState {
  const ChatState({
    this.sessionId = '',
    this.turns = const <ChatTurn>[],
    this.streaming = false,
    this.issue,
  });

  /// 当前会话 id，空串表示尚未建立会话（首条消息时懒创建）。
  final String sessionId;
  final List<ChatTurn> turns;
  final bool streaming;
  final ChatIssue? issue;

  bool get isEmpty => turns.isEmpty;

  ChatState copyWith({
    String? sessionId,
    List<ChatTurn>? turns,
    bool? streaming,
    ChatIssue? issue,
    bool clearIssue = false,
  }) {
    return ChatState(
      sessionId: sessionId ?? this.sessionId,
      turns: turns ?? this.turns,
      streaming: streaming ?? this.streaming,
      issue: clearIssue ? null : (issue ?? this.issue),
    );
  }
}

/// 对话数据源。
final Provider<ChatDatasource> chatDatasourceProvider =
    Provider<ChatDatasource>((Ref ref) => ChatDatasource());

/// 对话仓储。
final Provider<ChatRepository> chatRepositoryProvider = Provider<ChatRepository>(
  (Ref ref) => ChatRepositoryImpl(datasource: ref.watch(chatDatasourceProvider)),
);

/// 无参数工具的 JSON Schema。
const Map<String, dynamic> _noArgumentsSchema = <String, dynamic>{
  'type': 'object',
  'properties': <String, dynamic>{},
  'additionalProperties': false,
};

/// 提供给模型的本地工具清单。
///
/// 工具只读取设备环境，不执行任何提权动作，保证对话阶段零副作用。
final Provider<List<ChatToolDefinition>> chatToolsProvider =
    Provider<List<ChatToolDefinition>>((Ref ref) {
      return <ChatToolDefinition>[
        ChatToolDefinition(
          name: 'get_device_info',
          description:
              'Read the current Android device environment, including device '
              'model, OS version, kernel version, security patch, baseband, '
              'build number, SOTA version, API level, CPU ABI, SELinux status '
              'and app version. Call this before suggesting an escalation plan.',
          parameters: _noArgumentsSchema,
          execute: (Map<String, dynamic> arguments) async {
            final DeviceSnapshot snapshot = await ref.read(
              deviceSnapshotProvider.future,
            );
            return jsonEncode(<String, String>{
              for (final DeviceInfoItem item in snapshot.items)
                item.field.name: item.value,
            });
          },
        ),
        ChatToolDefinition(
          name: 'get_root_status',
          description:
              'Check whether the current process already has ROOT privileges.',
          parameters: _noArgumentsSchema,
          execute: (Map<String, dynamic> arguments) async {
            final bool rooted = await ref.read(rootStatusProvider.future);
            return jsonEncode(<String, bool>{'rooted': rooted});
          },
        ),
        ChatToolDefinition(
          name: 'get_adb_status',
          description:
              'Check whether ADB over USB or ADB over Wi-Fi is currently '
              'enabled on the device.',
          parameters: _noArgumentsSchema,
          execute: (Map<String, dynamic> arguments) async {
            final status = await ref.read(adbStatusProvider.future);
            return jsonEncode(<String, bool>{
              'usb': status.usb,
              'wifi': status.wifi,
            });
          },
        ),
      ];
    });

/// 对话控制器。
///
/// 一轮发送可能包含多次模型调用：模型发起工具调用 → 本地执行 → 结果回填 →
/// 自动续跑，直到模型给出最终回答或达到轮次上限。
final NotifierProvider<ChatController, ChatState> chatControllerProvider =
    NotifierProvider<ChatController, ChatState>(ChatController.new);

class ChatController extends Notifier<ChatState> {
  /// 单次发送最多允许的模型调用轮次，避免工具调用死循环。
  static const int _maxRounds = 6;

  StreamSubscription<ChatStreamEvent>? _subscription;
  Completer<void>? _pending;
  bool _cancelled = false;
  bool _creatingSession = false;
  int _sequence = 0;

  /// 当前轮次内「协议下标 → toolCalls 位置」的映射。
  ///
  /// OpenAI 用 tool_calls 下标，Anthropic 用 content block 下标，
  /// 两者都不保证从 0 连续，因此必须单独映射。
  final Map<int, int> _toolSlots = <int, int>{};

  @override
  ChatState build() {
    ref.onDispose(() {
      _cancelled = true;
      _subscription?.cancel();
      _subscription = null;
    });

    // 会话列表异步读盘完成后，把当前会话的内容同步进来。
    ref.listen<ChatSessionsState>(chatSessionsProvider, (
      ChatSessionsState? previous,
      ChatSessionsState next,
    ) {
      _syncSession(next);
    });

    final ChatSessionsState initial = ref.read(chatSessionsProvider);
    return ChatState(
      sessionId: initial.currentId,
      turns: initial.current?.turns ?? const <ChatTurn>[],
    );
  }

  /// 发送一条用户消息，并自动跑完后续工具调用。
  Future<void> send(String input) async {
    final String text = input.trim();
    if (text.isEmpty || state.streaming) return;

    final AiConfig? config = ref.read(aiConfigProvider).value?.current;
    if (config == null) {
      state = state.copyWith(issue: ChatIssue.noConfig);
      return;
    }

    _cancelled = false;
    final String sessionId = await _ensureSession();
    if (sessionId.isEmpty || _cancelled) return;

    // 标题只在会话还没有任何轮次时生成，避免覆盖用户手动改过的名字。
    final String? title = state.turns.isEmpty ? _deriveTitle(text) : null;

    state = ChatState(
      sessionId: sessionId,
      turns: <ChatTurn>[
        ...state.turns,
        ChatTurn(id: _nextId(), role: ChatRole.user, text: text),
      ],
      streaming: true,
    );

    try {
      await _runRounds(config, ref.read(chatToolsProvider));
    } finally {
      _cancelled = false;
      _subscription?.cancel();
      _subscription = null;
      _pending = null;
      state = _stopStreaming(state.copyWith(streaming: false));
      if (state.sessionId == sessionId) {
        await ref
            .read(chatSessionsProvider.notifier)
            .saveTurns(sessionId, state.turns, title: title);
      }
    }
  }

  /// 中止当前流；已收到的内容保留。
  void stop() {
    _cancelActiveStream();
    state = _stopStreaming(state.copyWith(streaming: false));
  }

  /// 重新生成指定回答：丢弃该轮及其后的内容，重发它之前最近的用户消息。
  Future<void> regenerate(String turnId) async {
    if (state.streaming) return;

    final List<ChatTurn> turns = state.turns;
    final int index = turns.indexWhere((ChatTurn turn) => turn.id == turnId);
    if (index < 0) return;

    int userIndex = -1;
    for (int i = index - 1; i >= 0; i -= 1) {
      if (turns[i].isUser) {
        userIndex = i;
        break;
      }
    }
    if (userIndex < 0) return;

    final AiConfig? config = ref.read(aiConfigProvider).value?.current;
    if (config == null) {
      state = state.copyWith(issue: ChatIssue.noConfig);
      return;
    }

    final String sessionId = state.sessionId;
    _cancelled = false;
    state = state.copyWith(turns: turns.sublist(0, index), streaming: true);

    try {
      await _runRounds(config, ref.read(chatToolsProvider));
    } finally {
      _cancelled = false;
      _subscription?.cancel();
      _subscription = null;
      _pending = null;
      state = _stopStreaming(state.copyWith(streaming: false));
      if (state.sessionId == sessionId) {
        await ref
            .read(chatSessionsProvider.notifier)
            .saveTurns(sessionId, state.turns);
      }
    }
  }

  /// 新建一个空会话并切换过去。
  Future<void> startNewSession() async {
    stop();
    await ref.read(chatSessionsProvider.notifier).createSession();
  }

  /// 切换到指定会话。
  Future<void> selectSession(String id) async {
    if (id == state.sessionId) return;
    stop();
    await ref.read(chatSessionsProvider.notifier).select(id);
  }

  /// 删除指定会话，删除当前项时自动切到剩余会话。
  Future<void> deleteSession(String id) async {
    if (id == state.sessionId) stop();
    await ref.read(chatSessionsProvider.notifier).delete(id);
  }

  /// 重命名指定会话。
  Future<void> renameSession(String id, String title) =>
      ref.read(chatSessionsProvider.notifier).rename(id, title);

  /// 保证存在当前会话；首次发送时懒创建。
  Future<String> _ensureSession() async {
    if (state.sessionId.isNotEmpty) return state.sessionId;
    _creatingSession = true;
    try {
      return await ref.read(chatSessionsProvider.notifier).createSession();
    } finally {
      _creatingSession = false;
    }
  }

  /// 会话列表变化时同步轮次；仅在当前会话切换时生效。
  void _syncSession(ChatSessionsState next) {
    if (next.currentId == state.sessionId) return;

    // 首条消息懒创建会话也会改变 currentId，此时不能中断本次发送。
    if (_creatingSession) {
      state = state.copyWith(sessionId: next.currentId);
      return;
    }

    _cancelActiveStream();
    state = ChatState(
      sessionId: next.currentId,
      turns: next.current?.turns ?? const <ChatTurn>[],
    );
  }

  /// 中断正在进行的流，不改动 state。
  void _cancelActiveStream() {
    _cancelled = true;
    _subscription?.cancel();
    _subscription = null;
    final Completer<void>? pending = _pending;
    _pending = null;
    if (pending != null && !pending.isCompleted) pending.complete();
  }

  /// 由首条用户消息生成会话标题：取首行，最多 24 个字符。
  String? _deriveTitle(String text) {
    final String firstLine = text
        .split(RegExp(r'[\r\n]'))
        .firstWhere((String line) => line.trim().isNotEmpty, orElse: () => '')
        .trim();
    if (firstLine.isEmpty) return null;
    final List<int> runes = firstLine.runes.toList(growable: false);
    if (runes.length <= 24) return firstLine;
    return String.fromCharCodes(runes.take(24));
  }

  /// 依次跑多轮模型调用，直到没有新的工具调用。
  Future<void> _runRounds(
    AiConfig config,
    List<ChatToolDefinition> tools,
  ) async {
    final ChatRepository repository = ref.read(chatRepositoryProvider);

    for (int round = 1; round <= _maxRounds; round += 1) {
      final String turnId = _nextId();
      final Stopwatch watch = Stopwatch()..start();
      _toolSlots.clear();
      state = state.copyWith(
        turns: <ChatTurn>[
          ...state.turns,
          ChatTurn(
            id: turnId,
            role: ChatRole.assistant,
            streaming: true,
            createdAt: DateTime.now(),
          ),
        ],
      );

      await _streamRound(
        repository: repository,
        config: config,
        tools: tools,
        turnId: turnId,
      );
      watch.stop();
      _updateTurn(
        turnId,
        (ChatTurn item) => item.copyWith(duration: watch.elapsed),
      );
      if (_cancelled) return;

      final ChatTurn? turn = _turnById(turnId);
      if (turn == null || turn.error != null) return;

      if (turn.toolCalls.isEmpty) {
        if (turn.text.trim().isEmpty) {
          _updateTurn(
            turnId,
            (ChatTurn item) =>
                item.copyWith(notice: ChatNotice.emptyReply, streaming: false),
          );
        } else {
          _updateTurn(turnId, (ChatTurn item) => item.copyWith(streaming: false));
        }
        return;
      }

      _updateTurn(turnId, (ChatTurn item) => item.copyWith(streaming: false));
      await _executeTools(turnId, tools);
      if (_cancelled) return;

      if (round >= _maxRounds) {
        _updateTurn(
          turnId,
          (ChatTurn item) =>
              item.copyWith(notice: ChatNotice.toolCallLimit),
        );
        return;
      }
    }
  }

  /// 订阅一轮流式响应，直到收到终止事件或失败。
  Future<void> _streamRound({
    required ChatRepository repository,
    required AiConfig config,
    required List<ChatToolDefinition> tools,
    required String turnId,
  }) async {
    final Completer<void> done = Completer<void>();
    _pending = done;

    _subscription = repository
        .streamChat(
          config: config,
          history: _requestHistory(),
          tools: tools,
        )
        .listen(
          (ChatStreamEvent event) {
            if (_cancelled) return;
            _applyEvent(turnId, event, done);
          },
          onError: (Object error, StackTrace stackTrace) {
            if (_cancelled) return;
            _updateTurn(
              turnId,
              (ChatTurn item) =>
                  item.copyWith(error: error.toString(), streaming: false),
            );
            if (!done.isCompleted) done.complete();
          },
          onDone: () {
            if (!done.isCompleted) done.complete();
          },
          cancelOnError: true,
        );

    await done.future;
    _pending = null;
    _subscription = null;
  }

  void _applyEvent(String turnId, ChatStreamEvent event, Completer<void> done) {
    switch (event) {
      case ChatStreamStarted():
        break;

      case ChatTextDelta(:final String text):
        _updateTurn(turnId, (ChatTurn item) => item.copyWith(text: item.text + text));

      case ChatReasoningDelta(:final String text):
        _updateTurn(
          turnId,
          (ChatTurn item) => item.copyWith(reasoning: item.reasoning + text),
        );

      case ChatToolCallStarted(
        :final int index,
        :final String callId,
        :final String name,
      ):
        _updateTurn(turnId, (ChatTurn item) {
          final List<ChatToolCall> calls = <ChatToolCall>[...item.toolCalls];
          final int? slot = _toolSlots[index];
          if (slot == null) {
            _toolSlots[index] = calls.length;
            calls.add(ChatToolCall(callId: callId, name: name));
          } else {
            calls[slot] = calls[slot].copyWith(
              callId: callId.isEmpty ? null : callId,
              name: name.isEmpty ? null : name,
            );
          }
          return item.copyWith(toolCalls: calls);
        });

      case ChatToolCallArgumentsDelta(:final int index, :final String fragment):
        _updateTurn(turnId, (ChatTurn item) {
          final List<ChatToolCall> calls = <ChatToolCall>[...item.toolCalls];
          int? slot = _toolSlots[index];
          if (slot == null) {
            // 少数网关不发首帧，直接给参数片段，这里补一个占位调用。
            slot = calls.length;
            _toolSlots[index] = slot;
            calls.add(const ChatToolCall(callId: '', name: ''));
          }
          final ChatToolCall call = calls[slot];
          calls[slot] = call.copyWith(
            argumentsJson: call.argumentsJson + fragment,
          );
          return item.copyWith(toolCalls: calls);
        });

      case ChatStreamUsage(:final int promptTokens, :final int completionTokens):
        _updateTurn(turnId, (ChatTurn item) {
          final ChatUsage added = ChatUsage(
            promptTokens: promptTokens,
            completionTokens: completionTokens,
          );
          return item.copyWith(usage: (item.usage ?? const ChatUsage()) + added);
        });

      case ChatStreamFinished():
        if (!done.isCompleted) done.complete();

      case ChatStreamFailed(:final String message):
        _updateTurn(
          turnId,
          (ChatTurn item) => item.copyWith(error: message, streaming: false),
        );
        if (!done.isCompleted) done.complete();
    }
  }

  /// 顺序执行本轮的全部工具调用，并把结果回填到同一轮次上。
  Future<void> _executeTools(
    String turnId,
    List<ChatToolDefinition> tools,
  ) async {
    final ChatTurn? turn = _turnById(turnId);
    if (turn == null) return;

    final List<ChatToolCall> calls = turn.toolCalls;
    for (int i = 0; i < calls.length; i += 1) {
      if (_cancelled) return;
      final ChatToolCall call = calls[i];
      final Stopwatch watch = Stopwatch()..start();

      ChatToolDefinition? definition;
      for (final ChatToolDefinition item in tools) {
        if (item.name == call.name) {
          definition = item;
          break;
        }
      }

      late final ChatToolCall updated;
      if (definition == null) {
        watch.stop();
        updated = call.copyWith(
          status: ChatToolStatus.failed,
          error: 'Unknown tool: ${call.name}',
          duration: watch.elapsed,
        );
      } else {
        try {
          final String result = await definition.execute(
            _decodeArguments(call.argumentsJson),
          );
          watch.stop();
          updated = call.copyWith(
            status: ChatToolStatus.succeeded,
            result: result,
            duration: watch.elapsed,
          );
        } catch (error) {
          watch.stop();
          updated = call.copyWith(
            status: ChatToolStatus.failed,
            error: error.toString(),
            duration: watch.elapsed,
          );
        }
      }

      _replaceToolCall(turnId, i, updated);
    }
  }

  /// 请求用的历史：去掉末尾那个还没拿到任何内容的 assistant 占位轮。
  List<ChatTurn> _requestHistory() {
    final List<ChatTurn> turns = state.turns;
    if (turns.isEmpty) return const <ChatTurn>[];
    final ChatTurn last = turns.last;
    if (last.role == ChatRole.assistant &&
        last.text.isEmpty &&
        last.toolCalls.isEmpty) {
      return turns.sublist(0, turns.length - 1);
    }
    return turns;
  }

  ChatTurn? _turnById(String id) {
    for (final ChatTurn turn in state.turns) {
      if (turn.id == id) return turn;
    }
    return null;
  }

  void _updateTurn(String id, ChatTurn Function(ChatTurn) update) {
    final List<ChatTurn> turns = <ChatTurn>[...state.turns];
    final int index = turns.indexWhere((ChatTurn turn) => turn.id == id);
    if (index < 0) return;
    turns[index] = update(turns[index]);
    state = state.copyWith(turns: turns);
  }

  void _replaceToolCall(String turnId, int position, ChatToolCall call) {
    _updateTurn(turnId, (ChatTurn item) {
      final List<ChatToolCall> calls = <ChatToolCall>[...item.toolCalls];
      if (position >= calls.length) return item;
      calls[position] = call;
      return item.copyWith(toolCalls: calls);
    });
  }

  ChatState _stopStreaming(ChatState current) {
    return current.copyWith(
      turns: <ChatTurn>[
        for (final ChatTurn turn in current.turns)
          turn.streaming ? turn.copyWith(streaming: false) : turn,
      ],
    );
  }

  Map<String, dynamic> _decodeArguments(String raw) {
    final String text = raw.trim();
    if (text.isEmpty) return <String, dynamic>{};
    try {
      final Object? decoded = jsonDecode(text);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } on FormatException {
      return <String, dynamic>{};
    }
    return <String, dynamic>{};
  }

  String _nextId() {
    _sequence += 1;
    // 带上时间戳，避免从磁盘恢复的历史会话与新建轮次撞 id。
    return 'turn-${DateTime.now().microsecondsSinceEpoch}-$_sequence';
  }
}
