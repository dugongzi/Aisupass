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
import 'package:Aisupass/features/escalation/domain/enums/escalation_reason.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_capability.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_capability_matrix.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_run_record.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_step_record.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_record_provider.dart';
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

/// 会话级执行状态：哪些会话正在接收流，以及哪个后台会话刚刚跑完。
@immutable
class ChatJobsState {
  const ChatJobsState({this.running = const <String>{}, this.completed});

  /// 正在接收流（前台或后台）的会话 id。
  final Set<String> running;

  /// 最近一个在后台跑完、用户还没看到的会话 id，供 UI 弹一次提示后清空。
  final String? completed;
}

/// 后台任务状态，供会话列表的「接收中」动画与完成通知使用。
final NotifierProvider<ChatJobsController, ChatJobsState> chatJobsProvider =
    NotifierProvider<ChatJobsController, ChatJobsState>(
      ChatJobsController.new,
    );

class ChatJobsController extends Notifier<ChatJobsState> {
  @override
  ChatJobsState build() => const ChatJobsState();

  /// 会话开始接收流。
  void started(String id) {
    if (state.running.contains(id)) return;
    state = ChatJobsState(
      running: <String>{...state.running, id},
      completed: state.completed,
    );
  }

  /// 会话正常结束；用户正停留在该会话时不需要额外提示。
  void finished(String id) => _remove(id);

  /// 会话在后台跑完；记录一次完成通知，等 UI 展示后调用 [acknowledge]。
  void finishedInBackground(String id) {
    state = ChatJobsState(
      running: <String>{...state.running}..remove(id),
      completed: id,
    );
  }

  /// 会话被停止或删除，直接摘掉状态，不产生通知。
  void dropped(String id) => _remove(id);

  /// UI 已展示完成提示。
  void acknowledge(String id) {
    if (state.completed != id) return;
    state = ChatJobsState(running: state.running);
  }

  void _remove(String id) {
    if (!state.running.contains(id)) return;
    state = ChatJobsState(
      running: <String>{...state.running}..remove(id),
      completed: state.completed,
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

/// 指定提权链的工具参数 Schema。
const Map<String, dynamic> _chainArgumentSchema = <String, dynamic>{
  'type': 'object',
  'properties': <String, dynamic>{
    'chain': <String, dynamic>{
      'type': 'string',
      'description':
          'Chain id, one of: shellChannel, kernelModule, payload, '
          'kernelExploit, pageCache.',
    },
  },
  'required': <String>['chain'],
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
        ChatToolDefinition(
          name: 'get_escalation_capabilities',
          description:
              'Read the read-only escalation capability matrix of the current '
              'device: a hardware fingerprint plus one entry per escalation '
              'chain with availability, reason codes and raw evidence.',
          parameters: _noArgumentsSchema,
          execute: (Map<String, dynamic> arguments) async {
            final EscalationCapabilityMatrix matrix = await ref.read(
              escalationCapabilityMatrixProvider.future,
            );
            return jsonEncode(<String, Object?>{
              'fingerprint': <String, Object?>{
                'androidSdk': matrix.fingerprint.androidSdk,
                'abi': matrix.fingerprint.abi,
                'kernelVersion': matrix.fingerprint.kernelVersion,
                'selinuxEnforcing': matrix.fingerprint.selinuxEnforcing,
              },
              'chains': <Map<String, Object?>>[
                for (final EscalationCapability capability
                    in matrix.orderedCapabilities)
                  <String, Object?>{
                    'chain': capability.chain.name,
                    'available': capability.available,
                    'reasons': <String>[
                      for (final EscalationReason reason in capability.reasons)
                        reason.code,
                    ],
                    'evidence': capability.evidence,
                  },
              ],
              'firstAvailable': matrix.firstAvailable?.chain.name,
            });
          },
        ),
        ChatToolDefinition(
          name: 'get_chain_status',
          description:
              'Read the read-only availability status of one escalation chain, '
              'including reason codes and raw evidence. Returns '
              '{"error": "unknownChain"} when the chain id is not recognized.',
          parameters: _chainArgumentSchema,
          execute: (Map<String, dynamic> arguments) async {
            final String chainName = (arguments['chain'] as String?) ?? '';
            final EscalationCapabilityMatrix matrix = await ref.read(
              escalationCapabilityMatrixProvider.future,
            );
            final EscalationCapability? capability = matrix.capabilityOf(
              chainName,
            );
            if (capability == null) {
              return jsonEncode(<String, Object?>{'error': 'unknownChain'});
            }
            return jsonEncode(<String, Object?>{
              'chain': capability.chain.name,
              'available': capability.available,
              'reasons': <String>[
                for (final EscalationReason reason in capability.reasons)
                  reason.code,
              ],
              'evidence': capability.evidence,
            });
          },
        ),
        ChatToolDefinition(
          name: 'get_last_execution',
          description:
              'Read the most recent escalation run summary, including chain, '
              'final outcome, duration, residual flag and per-stage ok flags. '
              'Returns {"empty": true} when no run has been recorded.',
          parameters: _noArgumentsSchema,
          execute: (Map<String, dynamic> arguments) async {
            final List<EscalationRunRecord> records = await ref.read(
              escalationRecordsProvider.future,
            );
            if (records.isEmpty) {
              return jsonEncode(<String, Object?>{'empty': true});
            }
            final EscalationRunRecord record = records.first;
            return jsonEncode(<String, Object?>{
              'runId': record.runId,
              'chain': record.chain.name,
              'outcome': record.outcome.name,
              'startedAtMs': record.startedAtMs,
              'durationMs': record.durationMs,
              'residual': record.residual,
              'steps': <Map<String, Object?>>[
                for (final EscalationStepRecord step in record.steps)
                  <String, Object?>{'stage': step.stage.name, 'ok': step.ok},
              ],
            });
          },
        ),
      ];
    });

/// 对话控制器。
///
/// 一轮发送可能包含多次模型调用：模型发起工具调用 → 本地执行 → 结果回填 →
/// 自动续跑，直到模型给出最终回答或达到轮次上限。
///
/// 每个会话的执行上下文独立保存在 [_jobs] 里，切换会话不会中断正在进行的
/// 流式请求；后台会话跑完后自动落盘，切回时直接看到最终内容。
final NotifierProvider<ChatController, ChatState> chatControllerProvider =
    NotifierProvider<ChatController, ChatState>(ChatController.new);

/// 单个会话的后台执行上下文。
///
/// 与 `ChatState` 分离后，非当前会话也可以持续接收流并累积轮次。
class _StreamJob {
  _StreamJob({
    required this.sessionId,
    required List<ChatTurn> initialTurns,
    this.title,
  }) : turns = <ChatTurn>[...initialTurns];

  final String sessionId;

  /// 首条消息生成的会话标题，仅在落盘时由会话自己决定是否采用。
  final String? title;

  List<ChatTurn> turns;
  bool running = true;
  bool cancelled = false;
  StreamSubscription<ChatStreamEvent>? subscription;
  Completer<void>? pending;

  /// 当前轮次内「协议下标 → toolCalls 位置」的映射。
  ///
  /// OpenAI 用 tool_calls 下标，Anthropic 用 content block 下标，
  /// 两者都不保证从 0 连续，因此必须单独映射。
  final Map<int, int> toolSlots = <int, int>{};

  /// 中止请求并释放订阅；已收到的内容保留在 [turns] 中。
  void cancel() {
    cancelled = true;
    subscription?.cancel();
    subscription = null;
    final Completer<void>? waiting = pending;
    pending = null;
    if (waiting != null && !waiting.isCompleted) waiting.complete();
  }
}

class ChatController extends Notifier<ChatState> {
  /// 单次发送最多允许的模型调用轮次，避免工具调用死循环。
  static const int _maxRounds = 6;

  /// 正在后台运行的会话，按会话 id 索引。
  final Map<String, _StreamJob> _jobs = <String, _StreamJob>{};

  int _sequence = 0;

  @override
  ChatState build() {
    ref.onDispose(() {
      for (final _StreamJob job in _jobs.values) {
        job.cancel();
      }
      _jobs.clear();
    });

    // 会话列表异步读盘完成后，把当前会话的内容同步进来。
    ref.listen<ChatSessionsState>(chatSessionsProvider, (
      ChatSessionsState? previous,
      ChatSessionsState next,
    ) {
      _syncSession(next);
    });

    final ChatSessionsState initial = ref.read(chatSessionsProvider);
    final _StreamJob? job = _jobs[initial.currentId];
    return ChatState(
      sessionId: initial.currentId,
      turns: job?.turns ?? initial.current?.turns ?? const <ChatTurn>[],
      streaming: job?.running ?? false,
    );
  }

  /// 发送一条用户消息，并自动跑完后续工具调用。
  Future<void> send(String input) async {
    final String text = input.trim();
    if (text.isEmpty) return;
    if (_jobs[state.sessionId]?.running ?? false) return;

    final AiConfig? config = ref.read(aiConfigProvider).value?.current;
    if (config == null) {
      state = state.copyWith(issue: ChatIssue.noConfig);
      return;
    }

    final String sessionId = await _ensureSession();
    if (sessionId.isEmpty || _jobs.containsKey(sessionId)) return;

    // 标题只在会话还没有任何轮次时生成，避免覆盖用户手动改过的名字。
    final String? title = state.turns.isEmpty ? _deriveTitle(text) : null;

    final _StreamJob job = _StreamJob(
      sessionId: sessionId,
      initialTurns: <ChatTurn>[
        ...state.turns,
        ChatTurn(id: _nextId(), role: ChatRole.user, text: text),
      ],
      title: title,
    );
    _jobs[sessionId] = job;
    ref.read(chatJobsProvider.notifier).started(sessionId);
    state = ChatState(
      sessionId: sessionId,
      turns: job.turns,
      streaming: true,
    );

    await _runJob(job, config);
  }

  /// 中止当前会话的流；其他会话的后台任务不受影响，已收到的内容保留。
  void stop() {
    final String id = state.sessionId;
    final _StreamJob? job = _jobs.remove(id);
    if (job == null) return;

    job.running = false;
    job.cancel();
    ref.read(chatJobsProvider.notifier).dropped(id);
    // 把中断的那一轮标记为已结束，避免后台收尾时又把「生成中」写回 UI。
    job.turns = <ChatTurn>[
      for (final ChatTurn turn in job.turns)
        turn.streaming ? turn.copyWith(streaming: false) : turn,
    ];
    state = state.copyWith(turns: job.turns, streaming: false);
    // job 已从 _jobs 摘除，必须显式传快照才能落盘，
    // 避免停止后直接退出应用丢掉已收到的内容。
    unawaited(_flushSession(id, snapshot: job.turns));
  }

  /// 重新生成指定回答：丢弃该轮及其后的内容，重发它之前最近的用户消息。
  Future<void> regenerate(String turnId) async {
    final String sessionId = state.sessionId;
    if (sessionId.isEmpty) return;
    if (_jobs[sessionId]?.running ?? false) return;

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

    final _StreamJob job = _StreamJob(
      sessionId: sessionId,
      initialTurns: turns.sublist(0, index),
    );
    _jobs[sessionId] = job;
    ref.read(chatJobsProvider.notifier).started(sessionId);
    state = state.copyWith(turns: job.turns, streaming: true);

    await _runJob(job, config);
  }

  /// 新建一个空会话并切换过去；当前会话的后台任务继续执行。
  Future<void> startNewSession() async {
    await _flushSession(state.sessionId);
    await ref.read(chatSessionsProvider.notifier).createSession();
  }

  /// 切换到指定会话；离开的会话若有未完成的回答，会继续在后台跑。
  Future<void> selectSession(String id) async {
    if (id == state.sessionId) return;
    await _flushSession(state.sessionId);
    await ref.read(chatSessionsProvider.notifier).select(id);
  }

  /// 删除指定会话，删除当前项时自动切到剩余会话。
  Future<void> deleteSession(String id) async {
    _jobs.remove(id)?.cancel();
    ref.read(chatJobsProvider.notifier).dropped(id);
    await ref.read(chatSessionsProvider.notifier).delete(id);
  }

  /// 重命名指定会话。
  Future<void> renameSession(String id, String title) =>
      ref.read(chatSessionsProvider.notifier).rename(id, title);

  /// 把某个会话尚未收尾的后台内容立即落盘。
  ///
  /// 只在会话仍有后台任务（或显式给出快照）时写入，避免普通切换会话
  /// 也刷新「最近更新时间」把列表顺序打乱。
  Future<void> _flushSession(
    String id, {
    List<ChatTurn>? snapshot,
  }) async {
    if (id.isEmpty) return;
    final List<ChatTurn> turns =
        snapshot ?? _jobs[id]?.turns ?? const <ChatTurn>[];
    if (turns.isEmpty) return;

    String? title;
    for (final ChatTurn turn in turns) {
      if (turn.isUser) {
        title = _deriveTitle(turn.text);
        break;
      }
    }
    await ref
        .read(chatSessionsProvider.notifier)
        .saveTurns(id, turns, title: title);
  }

  /// 跑完一个会话的整轮请求，并在收尾时落盘。
  Future<void> _runJob(_StreamJob job, AiConfig config) async {
    try {
      await _runRounds(job, config, ref.read(chatToolsProvider));
    } finally {
      job.running = false;
      job.cancel();

      // 任务可能在收尾前被 stop / delete 接管，此时结果已由调用方处理，
      // 这里不能再覆盖写入，否则会冲掉新内容或被删掉的会话。
      final bool owns = identical(_jobs[job.sessionId], job);
      if (owns) {
        // 收尾前先判断用户是否还停留在该会话，决定要不要弹完成通知。
        final bool visible = job.sessionId == state.sessionId;
        _jobs.remove(job.sessionId);
        if (visible) {
          state = _stopStreaming(
            state.copyWith(turns: job.turns, streaming: false),
          );
        }
        await ref
            .read(chatSessionsProvider.notifier)
            .saveTurns(job.sessionId, job.turns, title: job.title);

        final ChatJobsController jobs = ref.read(chatJobsProvider.notifier);
        if (visible) {
          jobs.finished(job.sessionId);
        } else {
          jobs.finishedInBackground(job.sessionId);
        }
      }
    }
  }

  /// 保证存在当前会话；首次发送时懒创建。
  Future<String> _ensureSession() async {
    if (state.sessionId.isNotEmpty) return state.sessionId;
    return ref.read(chatSessionsProvider.notifier).createSession();
  }

  /// 会话列表变化时同步轮次；仅在当前会话切换时生效。
  void _syncSession(ChatSessionsState next) {
    if (next.currentId == state.sessionId) return;

    // 目标会话若还在后台跑，优先用它内存里的最新内容。
    final _StreamJob? job = _jobs[next.currentId];
    state = ChatState(
      sessionId: next.currentId,
      turns: job?.turns ?? next.current?.turns ?? const <ChatTurn>[],
      streaming: job?.running ?? false,
    );
  }

  /// 把后台任务的最新轮次推给 UI；只有当前会话需要刷新。
  void _publish(_StreamJob job) {
    // 任务被 stop / 删除接管后仍会走完收尾逻辑，此时不能再覆盖新内容。
    if (!identical(_jobs[job.sessionId], job)) return;
    if (job.sessionId != state.sessionId) return;
    state = state.copyWith(turns: job.turns);
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
    _StreamJob job,
    AiConfig config,
    List<ChatToolDefinition> tools,
  ) async {
    final ChatRepository repository = ref.read(chatRepositoryProvider);

    for (int round = 1; round <= _maxRounds; round += 1) {
      final String turnId = _nextId();
      final Stopwatch watch = Stopwatch()..start();
      job.toolSlots.clear();
      job.turns = <ChatTurn>[
        ...job.turns,
        ChatTurn(
          id: turnId,
          role: ChatRole.assistant,
          streaming: true,
          createdAt: DateTime.now(),
        ),
      ];
      _publish(job);

      await _streamRound(
        job: job,
        repository: repository,
        config: config,
        tools: tools,
        turnId: turnId,
      );
      watch.stop();
      _updateTurn(
        job,
        turnId,
        (ChatTurn item) => item.copyWith(duration: watch.elapsed),
      );
      if (job.cancelled) return;

      final ChatTurn? turn = _turnById(job, turnId);
      if (turn == null || turn.error != null) return;

      if (turn.toolCalls.isEmpty) {
        if (turn.text.trim().isEmpty) {
          _updateTurn(
            job,
            turnId,
            (ChatTurn item) =>
                item.copyWith(notice: ChatNotice.emptyReply, streaming: false),
          );
        } else {
          _updateTurn(
            job,
            turnId,
            (ChatTurn item) => item.copyWith(streaming: false),
          );
        }
        return;
      }

      _updateTurn(
        job,
        turnId,
        (ChatTurn item) => item.copyWith(streaming: false),
      );
      await _executeTools(job, turnId, tools);
      if (job.cancelled) return;

      if (round >= _maxRounds) {
        _updateTurn(
          job,
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
    required _StreamJob job,
    required ChatRepository repository,
    required AiConfig config,
    required List<ChatToolDefinition> tools,
    required String turnId,
  }) async {
    final Completer<void> done = Completer<void>();
    job.pending = done;

    job.subscription = repository
        .streamChat(
          config: config,
          history: _requestHistory(job),
          tools: tools,
        )
        .listen(
          (ChatStreamEvent event) {
            if (job.cancelled) return;
            _applyEvent(job, turnId, event, done);
          },
          onError: (Object error, StackTrace stackTrace) {
            if (job.cancelled) return;
            _updateTurn(
              job,
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
    job.pending = null;
    job.subscription = null;
  }

  void _applyEvent(
    _StreamJob job,
    String turnId,
    ChatStreamEvent event,
    Completer<void> done,
  ) {
    switch (event) {
      case ChatStreamStarted():
        break;

      case ChatTextDelta(:final String text):
        _updateTurn(
          job,
          turnId,
          (ChatTurn item) => item.copyWith(text: item.text + text),
        );

      case ChatReasoningDelta(:final String text):
        _updateTurn(
          job,
          turnId,
          (ChatTurn item) => item.copyWith(reasoning: item.reasoning + text),
        );

      case ChatToolCallStarted(
        :final int index,
        :final String callId,
        :final String name,
      ):
        _updateTurn(job, turnId, (ChatTurn item) {
          final List<ChatToolCall> calls = <ChatToolCall>[...item.toolCalls];
          final int? slot = job.toolSlots[index];
          if (slot == null) {
            job.toolSlots[index] = calls.length;
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
        _updateTurn(job, turnId, (ChatTurn item) {
          final List<ChatToolCall> calls = <ChatToolCall>[...item.toolCalls];
          int? slot = job.toolSlots[index];
          if (slot == null) {
            // 少数网关不发首帧，直接给参数片段，这里补一个占位调用。
            slot = calls.length;
            job.toolSlots[index] = slot;
            calls.add(const ChatToolCall(callId: '', name: ''));
          }
          final ChatToolCall call = calls[slot];
          calls[slot] = call.copyWith(
            argumentsJson: call.argumentsJson + fragment,
          );
          return item.copyWith(toolCalls: calls);
        });

      case ChatStreamUsage(:final int promptTokens, :final int completionTokens):
        _updateTurn(job, turnId, (ChatTurn item) {
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
          job,
          turnId,
          (ChatTurn item) => item.copyWith(error: message, streaming: false),
        );
        if (!done.isCompleted) done.complete();
    }
  }

  /// 顺序执行本轮的全部工具调用，并把结果回填到同一轮次上。
  Future<void> _executeTools(
    _StreamJob job,
    String turnId,
    List<ChatToolDefinition> tools,
  ) async {
    final ChatTurn? turn = _turnById(job, turnId);
    if (turn == null) return;

    final List<ChatToolCall> calls = turn.toolCalls;
    for (int i = 0; i < calls.length; i += 1) {
      if (job.cancelled) return;
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

      _replaceToolCall(job, turnId, i, updated);
    }
  }

  /// 请求用的历史：去掉末尾那个还没拿到任何内容的 assistant 占位轮。
  List<ChatTurn> _requestHistory(_StreamJob job) {
    final List<ChatTurn> turns = job.turns;
    if (turns.isEmpty) return const <ChatTurn>[];
    final ChatTurn last = turns.last;
    if (last.role == ChatRole.assistant &&
        last.text.isEmpty &&
        last.toolCalls.isEmpty) {
      return turns.sublist(0, turns.length - 1);
    }
    return turns;
  }

  ChatTurn? _turnById(_StreamJob job, String id) {
    for (final ChatTurn turn in job.turns) {
      if (turn.id == id) return turn;
    }
    return null;
  }

  void _updateTurn(
    _StreamJob job,
    String id,
    ChatTurn Function(ChatTurn) update,
  ) {
    final List<ChatTurn> turns = <ChatTurn>[...job.turns];
    final int index = turns.indexWhere((ChatTurn turn) => turn.id == id);
    if (index < 0) return;
    turns[index] = update(turns[index]);
    job.turns = turns;
    _publish(job);
  }

  void _replaceToolCall(
    _StreamJob job,
    String turnId,
    int position,
    ChatToolCall call,
  ) {
    _updateTurn(job, turnId, (ChatTurn item) {
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
