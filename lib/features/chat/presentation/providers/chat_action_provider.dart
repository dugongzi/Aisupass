import 'dart:async';
import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:Aisupass/core/models/command_channel.dart';
import 'package:Aisupass/core/providers/command_channel_provider.dart';
import 'package:Aisupass/core/providers/device_info_provider.dart';
import 'package:Aisupass/core/providers/system_status_provider.dart';
import 'package:Aisupass/core/storage/storage_providers.dart';
import 'package:Aisupass/features/ai/domain/models/ai_config.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_config_query_provider.dart';
import 'package:Aisupass/features/chat/data/datasources/chat_action_datasource.dart';
import 'package:Aisupass/features/chat/data/datasources/chat_attachment_store.dart';
import 'package:Aisupass/features/chat/data/datasources/chat_session_action_datasource.dart';
import 'package:Aisupass/features/chat/data/repositories/chat_action_repository_impl.dart';
import 'package:Aisupass/features/chat/data/repositories/chat_session_action_repository_impl.dart';
import 'package:Aisupass/features/chat/domain/enums/chat_issue.dart';
import 'package:Aisupass/features/chat/domain/enums/chat_notice.dart';
import 'package:Aisupass/features/chat/domain/enums/chat_role.dart';
import 'package:Aisupass/features/chat/domain/models/chat_attachment.dart';
import 'package:Aisupass/features/chat/domain/models/chat_session.dart';
import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/domain/models/chat_tool_call.dart';
import 'package:Aisupass/features/chat/domain/models/chat_turn.dart';
import 'package:Aisupass/features/chat/domain/models/chat_usage.dart';
import 'package:Aisupass/features/chat/domain/repositories/chat_action_repository.dart';
import 'package:Aisupass/features/chat/domain/repositories/chat_session_action_repository.dart';
import 'package:Aisupass/features/chat/presentation/controllers/chat_stream_session.dart';
import 'package:Aisupass/features/chat/presentation/providers/chat_query_provider.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/adb_tools.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/browser_tools.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/coolapk_tools.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/dirty_frag_tools.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/escalation_action_tools.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/escalation_query_tools.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/ghost_key_tools.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/ghost_lock_profile_tools.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/ghost_lock_tools.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/kernel_profile_tools.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/local_file_tools.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/ota_tools.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/run_log_tools.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/stellar_tools.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/tool_schema.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/web_search_tools.dart';
import 'package:flutter/foundation.dart';

part 'chat_action_provider.g.dart';

/// 对话页状态：完整轮次列表 + 是否正在接收流。
@immutable
class ChatState {
  const ChatState({
    this.sessionId = '',
    this.turns = const <ChatTurn>[],
    this.streaming = false,
    this.issue = ChatIssue.none,
    this.awaitingTurnId = '',
  });

  /// 当前会话 id，空串表示尚未建立会话（首条消息时懒创建）。
  final String sessionId;
  final List<ChatTurn> turns;
  final bool streaming;
  final ChatIssue issue;

  /// 挂起所在轮次的 id；空串表示没有挂起。组件据此保证同一轮只续跑一次。
  final String awaitingTurnId;

  /// 是否有轮次正挂起等用户操作。
  bool get awaitingUser => awaitingTurnId.isNotEmpty;

  bool get isEmpty => turns.isEmpty;

  ChatState copyWith({
    String? sessionId,
    List<ChatTurn>? turns,
    bool? streaming,
    ChatIssue? issue,
    String? awaitingTurnId,
  }) {
    return ChatState(
      sessionId: sessionId ?? this.sessionId,
      turns: turns ?? this.turns,
      streaming: streaming ?? this.streaming,
      issue: issue ?? this.issue,
      awaitingTurnId: awaitingTurnId ?? this.awaitingTurnId,
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
@Riverpod(keepAlive: true)
class ChatJobs extends _$ChatJobs {
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

/// 对话执行数据源。
@riverpod
ChatActionDatasource chatActionDatasource(Ref ref) => ChatActionDatasource();

/// 附件落盘服务：把选中的文件复制到应用私有目录。
@riverpod
ChatAttachmentStore chatAttachmentStore(Ref ref) => const ChatAttachmentStore();

/// 对话执行仓储。
@riverpod
ChatActionRepository chatActionRepository(Ref ref) => ChatActionRepositoryImpl(
  datasource: ref.watch(chatActionDatasourceProvider),
);

/// 会话写数据源。
@riverpod
ChatSessionActionDatasource chatSessionActionDatasource(Ref ref) =>
    ChatSessionActionDatasource(
      preferences: ref.watch(preferencesStoreProvider),
    );

/// 会话写仓储。
@riverpod
ChatSessionActionRepository chatSessionActionRepository(Ref ref) =>
    ChatSessionActionRepositoryImpl(
      datasource: ref.watch(chatSessionActionDatasourceProvider),
    );

/// 提供给模型的本地工具清单。
///
/// 只读能力与执行能力分开注册，执行类工具调用前必须由用户确认。
@Riverpod(keepAlive: true)
List<ChatToolDefinition> chatTools(Ref ref) => <ChatToolDefinition>[
  ChatToolDefinition(
    name: 'get_device_info',
    description:
        'Read the current Android device environment, including device '
        'model, OS version, kernel version, security patch, baseband, '
        'build number, SOTA version, API level, CPU ABI, SELinux status '
        'and app version. Call this before answering questions about '
        'the device.',
    parameters: noArgsSchema,
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
    parameters: noArgsSchema,
    execute: (Map<String, dynamic> arguments) async {
      final bool rooted = await ref.read(rootStatusProvider.future);
      return jsonEncode(<String, bool>{'rooted': rooted});
    },
  ),
  ChatToolDefinition(
    name: 'get_adb_status',
    description:
        'Check whether the ADB debugging switches are enabled (USB / Wi-Fi). '
        'This only reports the system switches, not whether an adb shell '
        'channel is actually connected: Wi-Fi debugging can be on while no '
        'shell is live. To use or verify the shell, call adb_shell_exec; if it '
        'returns connected=false, call adb_pairing_request.',
    parameters: noArgsSchema,
    execute: (Map<String, dynamic> arguments) async {
      final status = await ref.read(adbStatusProvider.future);
      return jsonEncode(<String, bool>{'usb': status.usb, 'wifi': status.wifi});
    },
  ),
  // 命令工具按当前通道二选一：两条通道各自的工具集互不引用。
  ...switch (ref.watch(commandChannelControllerProvider)) {
    CommandChannel.adb => adbTools(ref),
    CommandChannel.stellar => stellarTools(ref),
  },
  ...browserTools(ref),
  ...webSearchTools(ref),
  ...coolapkTools(ref),
  ...escalationQueryTools(ref),
  ...escalationActionTools(ref),
  ...ghostKeyTools(ref),
  ...dirtyFragTools(ref),
  ...ghostLockTools(ref),
  ...ghostLockProfileTools(ref),
  ...kernelProfileTools(ref),
  ...otaTools(ref),
  ...runLogTools(ref),
  ...localFileTools(ref),
];

/// 对话控制器。
///
/// 负责会话级调度：发送、停止、重发、切换会话与落盘；单轮的多步推进由
/// [ChatStreamSession] 承担。每个会话的执行上下文独立保存在 [_jobs] 里，
/// 切换会话不会中断正在进行的流式请求。
@Riverpod(keepAlive: true)
class ChatController extends _$ChatController {
  /// 正在后台运行的会话，按会话 id 索引。
  final Map<String, ChatStreamSession> _jobs = <String, ChatStreamSession>{};

  int _sequence = 0;

  @override
  ChatState build() {
    ref.onDispose(() {
      for (final ChatStreamSession job in _jobs.values) {
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
    final ChatStreamSession? job = _jobs[initial.currentId];
    return ChatState(
      sessionId: initial.currentId,
      turns: job?.turns ?? initial.current?.turns ?? const <ChatTurn>[],
      streaming: job?.running ?? false,
    );
  }

  /// 发送一条用户消息，并自动跑完后续工具调用。
  Future<void> send(
    String input, {
    List<ChatAttachment> attachments = const <ChatAttachment>[],
  }) async {
    final String text = input.trim();
    final List<ChatAttachment> files = List<ChatAttachment>.unmodifiable(
      attachments,
    );
    if (text.isEmpty && files.isEmpty) return;
    if (_jobs[state.sessionId]?.running ?? false) return;

    final AiConfig? config = ref.read(aiConfigProvider).value?.current;
    if (config == null) {
      state = state.copyWith(issue: ChatIssue.noConfig);
      return;
    }

    final String sessionId = await _ensureSession();
    if (sessionId.isEmpty || _jobs.containsKey(sessionId)) return;

    // 标题只在会话还没有任何轮次时生成，避免覆盖用户手动改过的名字。
    final String? title = state.turns.isEmpty
        ? _deriveTitle(text, files)
        : null;

    final ChatStreamSession job = _startSession(
      sessionId: sessionId,
      initialTurns: <ChatTurn>[
        ...state.turns,
        ChatTurn(
          id: _nextId(),
          role: ChatRole.user,
          text: text,
          reasoning: '',
          toolCalls: const <ChatToolCall>[],
          streaming: false,
          error: '',
          notice: ChatNotice.none,
          attachments: files,
          createdAt: DateTime.now(),
          duration: Duration.zero,
          usage: ChatUsage.empty,
        ),
      ],
      title: title,
    );
    state = ChatState(sessionId: sessionId, turns: job.turns, streaming: true);

    await _runSession(job, config);
  }

  /// 由对话内的组件在用户完成操作后调用，放行被挂起的那一轮。
  ///
  /// 只完成 run loop 里的等待，模型已在内存中的上下文里继续生成；
  /// 不重发请求，因此不会出现「续跑后又被自己挂起」的循环。
  bool resumeAfterUserAction() {
    final ChatStreamSession? job = _jobs[state.sessionId];
    if (job == null || !job.running) return false;
    if (!job.resumeFromUser()) return false;
    state = state.copyWith(awaitingTurnId: '');
    return true;
  }

  /// 把内置浏览器回传的内容作为一条用户消息发出。
  ///
  /// [source] 是页面源码全文，不做截断；[filePath] 是用户选中的本地文件；
  /// 两者都可以为空，此时只回传 URL。界面上的折叠由用户气泡自己处理。
  Future<void> sendBrowserHandoff({
    required String url,
    required String source,
    required String filePath,
  }) async {
    final String link = url.trim();
    final String code = source.trim();
    final String file = filePath.trim();
    if (link.isEmpty && code.isEmpty && file.isEmpty) return;

    final StringBuffer buffer = StringBuffer();
    if (link.isNotEmpty) {
      buffer
        ..writeln('我用应用内浏览器查看了这个页面：')
        ..writeln(link);
    }
    if (code.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('页面源码：')
        ..writeln('```html')
        ..writeln(code)
        ..writeln('```');
    }
    if (file.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('已选好的本地文件：$file');
    }

    await send(buffer.toString());
  }

  /// 中止当前会话的流；其他会话的后台任务不受影响，已收到的内容保留。
  void stop() {
    final String id = state.sessionId;
    final ChatStreamSession? job = _jobs.remove(id);
    if (job == null) return;

    job.running = false;
    job.cancel();
    ref.read(chatJobsProvider.notifier).dropped(id);
    // 把中断的那一轮标记为已结束，并清掉挂起提示：run loop 已停，
    // 留着「等用户操作」会变成一个点了也没有反应的组件。
    job.turns = <ChatTurn>[
      for (final ChatTurn turn in job.turns)
        turn.streaming || turn.notice == ChatNotice.awaitingUser
            ? turn.copyWith(streaming: false, notice: ChatNotice.none)
            : turn,
    ];
    state = state.copyWith(
      turns: job.turns,
      streaming: false,
      awaitingTurnId: '',
    );
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

    final ChatStreamSession job = _startSession(
      sessionId: sessionId,
      initialTurns: turns.sublist(0, index),
    );
    state = state.copyWith(
      turns: job.turns,
      streaming: true,
      issue: ChatIssue.none,
    );

    await _runSession(job, config);
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

  /// 建一个会话上下文并挂上变化回调。
  ChatStreamSession _startSession({
    required String sessionId,
    required List<ChatTurn> initialTurns,
    String? title,
  }) {
    final ChatStreamSession session = ChatStreamSession(
      sessionId: sessionId,
      initialTurns: initialTurns,
      title: title,
    );
    session.onChanged = (List<ChatTurn> turns) => _publish(session);
    _jobs[sessionId] = session;
    ref.read(chatJobsProvider.notifier).started(sessionId);
    return session;
  }

  /// 把某个会话尚未收尾的后台内容立即落盘。
  ///
  /// 只在会话仍有后台任务（或显式给出快照）时写入，避免普通切换会话
  /// 也刷新「最近更新时间」把列表顺序打乱。
  Future<void> _flushSession(String id, {List<ChatTurn>? snapshot}) async {
    if (id.isEmpty) return;
    // 任务已收尾时 `_jobs` 里没有它，退回当前显示状态，
    // 否则切换会话会把刚结束（含错误提示）的这一轮漏掉。
    final List<ChatTurn> turns =
        snapshot ??
        _jobs[id]?.turns ??
        (id == state.sessionId ? state.turns : const <ChatTurn>[]);
    if (turns.isEmpty) return;

    String? title;
    for (final ChatTurn turn in turns) {
      if (turn.isUser) {
        title = _deriveTitle(turn.text, turn.attachments);
        break;
      }
    }
    await ref
        .read(chatSessionsProvider.notifier)
        .saveTurns(id, turns, title: title);
  }

  /// 跑完一个会话的整轮请求，并在收尾时落盘。
  Future<void> _runSession(ChatStreamSession job, AiConfig config) async {
    try {
      await job.run(
        repository: ref.read(chatActionRepositoryProvider),
        config: config,
        tools: ref.read(chatToolsProvider),
      );
    } catch (error) {
      // 请求层异常必须落到界面：否则续跑失败时用户只看到「什么都没发生」。
      if (job.turns.isNotEmpty) {
        final String lastId = job.turns.last.id;
        job.turns = <ChatTurn>[
          for (final ChatTurn turn in job.turns)
            turn.id == lastId
                ? turn.copyWith(error: '$error', streaming: false)
                : turn,
        ];
        _publish(job);
      }
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
            state.copyWith(
              turns: job.turns,
              streaming: false,
              awaitingTurnId: job.awaitTurnId,
            ),
          );
        }
        await ref
            .read(chatSessionsProvider.notifier)
            .saveTurns(job.sessionId, job.turns, title: job.title);

        final ChatJobs jobs = ref.read(chatJobsProvider.notifier);
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
    final ChatStreamSession? job = _jobs[next.currentId];
    final List<ChatTurn> turns =
        job?.turns ?? next.current?.turns ?? const <ChatTurn>[];
    // 内存里的任务以自己记下的轮次为准；磁盘恢复的历史没有 run loop 可放行，
    // 不认挂起标记，免得留下一个点了也没反应的组件。
    final String awaitingTurnId = job?.awaitTurnId ?? '';
    state = ChatState(
      sessionId: next.currentId,
      turns: turns,
      streaming: job?.running ?? false,
      awaitingTurnId: awaitingTurnId,
    );
  }

  /// 把后台任务的最新轮次推给 UI；只有当前会话需要刷新。
  void _publish(ChatStreamSession job) {
    // 任务被 stop / 删除接管后仍会走完收尾逻辑，此时不能再覆盖新内容。
    if (!identical(_jobs[job.sessionId], job)) return;
    if (job.sessionId != state.sessionId) return;
    state = state.copyWith(turns: job.turns, awaitingTurnId: job.awaitTurnId);
  }

  /// 由首条用户消息生成会话标题：取首行，最多 24 个字符。
  ///
  /// 纯附件消息取第一个附件的文件名，避免出现无标题会话。
  String? _deriveTitle(String text, List<ChatAttachment> attachments) {
    final String firstLine = text
        .split(RegExp(r'[\r\n]'))
        .firstWhere((String line) => line.trim().isNotEmpty, orElse: () => '')
        .trim();
    final String source = firstLine.isNotEmpty
        ? firstLine
        : (attachments.isEmpty ? '' : attachments.first.name.trim());
    if (source.isEmpty) return null;
    final List<int> runes = source.runes.toList(growable: false);
    if (runes.length <= 24) return source;
    return String.fromCharCodes(runes.take(24));
  }

  ChatState _stopStreaming(ChatState current) {
    return current.copyWith(
      turns: <ChatTurn>[
        for (final ChatTurn turn in current.turns)
          turn.streaming ? turn.copyWith(streaming: false) : turn,
      ],
    );
  }

  String _nextId() {
    _sequence += 1;
    // 带上时间戳，避免从磁盘恢复的历史会话与新建轮次撞 id。
    return 'turn-${DateTime.now().microsecondsSinceEpoch}-$_sequence';
  }
}

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

/// 会话列表控制器。
///
/// 只负责会话的增删改与当前项切换，不参与流式对话本身；
/// 对话内容由 `ChatController` 在每轮结束时通过 [saveTurns] 回写。
@Riverpod(keepAlive: true)
class ChatSessions extends _$ChatSessions {
  bool _disposed = false;

  ChatSessionActionRepository get _action =>
      ref.read(chatSessionActionRepositoryProvider);

  @override
  ChatSessionsState build() {
    ref.onDispose(() => _disposed = true);
    // 同步 build 无法 await，先返回空态，读盘完成后再刷新。
    Future<void>(_restore);
    return const ChatSessionsState();
  }

  Future<void> _restore() async {
    final List<ChatSession> sessions = await ref.read(
      storedChatSessionsProvider.future,
    );
    if (_disposed) return;

    final String storedId = await ref.read(storedChatSessionIdProvider.future);
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
      turns: const <ChatTurn>[],
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
    await _action.writeAll(sessions);
    await _action.writeCurrentId(session.id);
    return session.id;
  }

  /// 切换当前会话。
  Future<void> select(String id) async {
    if (id == state.currentId) return;
    if (!state.sessions.any((ChatSession session) => session.id == id)) return;
    state = state.copyWith(currentId: id);
    await _action.writeCurrentId(id);
  }

  /// 重命名会话，空标题视为未命名。
  Future<void> rename(String id, String title) async {
    final List<ChatSession> sessions = <ChatSession>[
      for (final ChatSession session in state.sessions)
        session.id == id ? session.copyWith(title: title.trim()) : session,
    ];
    state = state.copyWith(sessions: sessions);
    await _action.writeAll(sessions);
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
    await _action.writeAll(sessions);
    await _action.writeCurrentId(nextId);
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
    if (id.isEmpty || turns.isEmpty) return;
    final DateTime now = DateTime.now();
    final bool exists = state.sessions.any(
      (ChatSession session) => session.id == id,
    );
    // 会话不在列表里说明首次读盘还没落定（`_restore` 是异步的），
    // 此时直接 return 会把整轮内容连同错误提示一起丢掉，所以补建一条。
    final List<ChatSession> base = exists
        ? state.sessions
        : <ChatSession>[
            ChatSession(
              id: id,
              title: '',
              createdAt: now,
              updatedAt: now,
              turns: const <ChatTurn>[],
            ),
            ...state.sessions,
          ];
    final List<ChatSession> updated = <ChatSession>[
      for (final ChatSession session in base)
        if (session.id == id)
          session.copyWith(
            turns: turns,
            updatedAt: now,
            title: (session.title.trim().isEmpty && (title ?? '').isNotEmpty)
                ? (title ?? session.title)
                : session.title,
          )
        else
          session,
    ];
    final List<ChatSession> sorted = _sort(updated);
    state = state.copyWith(sessions: sorted);
    await _action.writeAll(sorted);
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
