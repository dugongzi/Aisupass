import 'dart:async';
import 'dart:developer' show log;

import 'package:Aisupass/features/ai/domain/models/ai_config.dart';
import 'package:Aisupass/features/chat/domain/enums/chat_notice.dart';
import 'package:Aisupass/features/chat/domain/enums/chat_role.dart';
import 'package:Aisupass/features/chat/domain/enums/chat_tool_status.dart';
import 'package:Aisupass/features/chat/domain/models/chat_stream_event.dart';
import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/domain/models/chat_tool_call.dart';
import 'package:Aisupass/features/chat/domain/models/chat_turn.dart';
import 'package:Aisupass/features/chat/domain/models/chat_usage.dart';
import 'package:Aisupass/features/chat/domain/repositories/chat_action_repository.dart';
import 'package:Aisupass/features/chat/presentation/controllers/chat_tool_session.dart';

/// 单个会话的一轮流式执行。
///
/// 一轮发送可能包含多次模型调用：模型发起工具调用 → 本地执行 → 结果回填 →
/// 自动续跑，直到模型给出最终回答或达到轮次上限。会话与 `ChatState` 分离后，
/// 非当前会话也可以持续接收流并累积轮次。
class ChatStreamSession {
  ChatStreamSession({
    required this.sessionId,
    required List<ChatTurn> initialTurns,
    this.title,
  }) : turns = <ChatTurn>[...initialTurns];

  final String sessionId;

  /// 首条消息生成的会话标题，仅在落盘时由会话自己决定是否采用。
  final String? title;

  /// 当前累积的轮次，外部只读。
  List<ChatTurn> turns;

  /// 是否仍在执行，终局后置 false。
  bool running = true;

  /// 是否已被外部中止。
  bool cancelled = false;

  /// 已挂起、等用户操作的轮次 id；空串表示没有挂起。
  ///
  /// 由挂起分支直接写入，不靠轮次上的 notice 反推，
  /// 避免 UI 侧拿到一个被后续状态覆盖掉的值。
  String awaitTurnId = '';

  /// 挂起时 Run loop 停在这里；UI 完成后放行。
  ///
  /// 用 Completer 原地阻塞而不是「结束本轮再重发请求」：上下文与工具结果
  /// 都还在内存里，放行后直接续跑下一轮，不需要重新组装历史。
  Completer<void>? _userAction;

  /// 轮次变化回调，由持有者同步给 UI 状态。
  void Function(List<ChatTurn> turns)? onChanged;

  StreamSubscription<ChatStreamEvent>? _subscription;
  Completer<void>? _pending;

  /// 当前轮次内「协议下标 → toolCalls 位置」的映射。
  ///
  /// OpenAI 用 tool_calls 下标，Anthropic 用 content block 下标，
  /// 两者都不保证从 0 连续，因此必须单独映射。
  final Map<int, int> _toolSlots = <int, int>{};

  int _sequence = 0;

  /// UI 侧调用：用户已完成操作，放行挂起的那一轮。
  ///
  /// 返回是否真的放行了；重复调用与无挂起时都返回 false。
  bool resumeFromUser() {
    if (awaitTurnId.isEmpty) return false;
    final Completer<void>? pending = _userAction;
    _userAction = null;
    if (pending == null || pending.isCompleted) return false;
    pending.complete();
    return true;
  }

  /// 中止请求并释放订阅；已收到的内容保留在 [turns] 中。
  void cancel() {
    cancelled = true;
    _subscription?.cancel();
    _subscription = null;
    final Completer<void>? waiting = _pending;
    _pending = null;
    if (waiting != null && !waiting.isCompleted) waiting.complete();
    final Completer<void>? user = _userAction;
    _userAction = null;
    if (user != null && !user.isCompleted) user.complete();
  }

  /// 跑完整轮请求；异常由调用方兜底。
  Future<void> run({
    required ChatActionRepository repository,
    required AiConfig config,
    required List<ChatToolDefinition> tools,
  }) async {
    // 不设轮次上限：模型自己决定何时收尾，由用户随时停止或取消。
    while (true) {
      final String turnId = _nextId();
      final Stopwatch watch = Stopwatch()..start();
      _toolSlots.clear();
      turns = <ChatTurn>[
        ...turns,
        ChatTurn(
          id: turnId,
          role: ChatRole.assistant,
          text: '',
          reasoning: '',
          toolCalls: const <ChatToolCall>[],
          streaming: true,
          error: '',
          notice: ChatNotice.none,
          createdAt: DateTime.now(),
          duration: Duration.zero,
          usage: ChatUsage.empty,
        ),
      ];
      _publish();

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
      if (cancelled) return;

      final ChatTurn? turn = _turnById(turnId);
      if (turn == null || turn.hasError) return;

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
      final bool awaitsUser = await _executeTools(turnId, tools);
      // 只在 debug 打：定位「工具已声明 awaitsUser 却没挂起」到底是哪一环丢了。
      assert(() {
        final ChatTurn? t = _turnById(turnId);
        final String calls =
            (t?.toolCalls ?? const <ChatToolCall>[])
                .map(
                  (ChatToolCall c) =>
                      '${c.name}[${c.status.name}]='
                      '${c.result.length > 90 ? c.result.substring(0, 90) : c.result}',
                )
                .join(' | ');
        log(
          'chat.pause: turn=$turnId awaitsUser=$awaitsUser calls=$calls',
          name: 'chat.pause',
        );
        return true;
      }());
      if (cancelled) return;

      // 本轮渲染了需要用户操作的组件：原地挂起，等用户完成后再继续。
      if (awaitsUser) {
        awaitTurnId = turnId;
        _updateTurn(
          turnId,
          (ChatTurn item) => item.copyWith(notice: ChatNotice.awaitingUser),
        );
        _userAction = Completer<void>();
        await _userAction!.future;
        _userAction = null;
        awaitTurnId = '';
        if (cancelled) return;
        // 用户已完成：清掉提示，带着本轮工具结果继续下一轮，
        // 不重发请求、不重建会话上下文。
        _updateTurn(
          turnId,
          (ChatTurn item) => item.copyWith(notice: ChatNotice.none),
        );
        continue;
      }
    }
  }

  /// 订阅一轮流式响应，直到收到终止事件或失败。
  Future<void> _streamRound({
    required ChatActionRepository repository,
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
            if (cancelled) return;
            _applyEvent(turnId, event, done);
          },
          onError: (Object error, StackTrace stackTrace) {
            if (cancelled) return;
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

  /// 把单个流式事件合并进当前轮次。
  void _applyEvent(String turnId, ChatStreamEvent event, Completer<void> done) {
    switch (event) {
      case ChatStreamStarted():
        break;

      case ChatTextDelta(:final String text):
        _updateTurn(
          turnId,
          (ChatTurn item) => item.copyWith(text: item.text + text),
        );

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
            calls.add(
              ChatToolCall(
                callId: callId,
                name: name,
                argumentsJson: '',
                status: ChatToolStatus.running,
                result: '',
                error: '',
                duration: Duration.zero,
              ),
            );
          } else {
            calls[slot] = calls[slot].copyWith(
              callId: callId.isEmpty ? calls[slot].callId : callId,
              name: name.isEmpty ? calls[slot].name : name,
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
            calls.add(
              const ChatToolCall(
                callId: '',
                name: '',
                argumentsJson: '',
                status: ChatToolStatus.running,
                result: '',
                error: '',
                duration: Duration.zero,
              ),
            );
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
          return item.copyWith(usage: item.usage + added);
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
  ///
  /// 返回值是「本轮是否有工具声明了必须等用户操作」：由 [ChatToolSession]
  /// 在拿到结果串时当场判定，不依赖回填后的轮次副本。
  Future<bool> _executeTools(
    String turnId,
    List<ChatToolDefinition> tools,
  ) async {
    final ChatTurn? turn = _turnById(turnId);
    if (turn == null) return false;

    return const ChatToolSession().execute(
      calls: turn.toolCalls,
      tools: tools,
      isCancelled: () => cancelled,
      onUpdated: (int position, ChatToolCall call) =>
          _replaceToolCall(turnId, position, call),
    );
  }

  /// 请求用的历史：去掉末尾那个还没拿到任何内容的 assistant 占位轮。
  List<ChatTurn> _requestHistory() {
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
    for (final ChatTurn turn in turns) {
      if (turn.id == id) return turn;
    }
    return null;
  }

  void _updateTurn(String id, ChatTurn Function(ChatTurn) update) {
    final List<ChatTurn> next = <ChatTurn>[...turns];
    final int index = next.indexWhere((ChatTurn turn) => turn.id == id);
    if (index < 0) return;
    next[index] = update(next[index]);
    turns = next;
    _publish();
  }

  void _replaceToolCall(String turnId, int position, ChatToolCall call) {
    _updateTurn(turnId, (ChatTurn item) {
      final List<ChatToolCall> calls = <ChatToolCall>[...item.toolCalls];
      if (position >= calls.length) return item;
      calls[position] = call;
      return item.copyWith(toolCalls: calls);
    });
  }

  void _publish() => onChanged?.call(turns);

  String _nextId() {
    _sequence += 1;
    // 带上时间戳，避免从磁盘恢复的历史会话与新建轮次撞 id。
    return 'turn-${DateTime.now().microsecondsSinceEpoch}-$_sequence';
  }
}
