// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_action_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 后台任务状态，供会话列表的「接收中」动画与完成通知使用。

@ProviderFor(ChatJobs)
const chatJobsProvider = ChatJobsProvider._();

/// 后台任务状态，供会话列表的「接收中」动画与完成通知使用。
final class ChatJobsProvider
    extends $NotifierProvider<ChatJobs, ChatJobsState> {
  /// 后台任务状态，供会话列表的「接收中」动画与完成通知使用。
  const ChatJobsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatJobsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatJobsHash();

  @$internal
  @override
  ChatJobs create() => ChatJobs();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatJobsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatJobsState>(value),
    );
  }
}

String _$chatJobsHash() => r'a543d2f1b6cee620595364ee4e71bb8fb2d30924';

/// 后台任务状态，供会话列表的「接收中」动画与完成通知使用。

abstract class _$ChatJobs extends $Notifier<ChatJobsState> {
  ChatJobsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ChatJobsState, ChatJobsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatJobsState, ChatJobsState>,
              ChatJobsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 对话执行数据源。

@ProviderFor(chatActionDatasource)
const chatActionDatasourceProvider = ChatActionDatasourceProvider._();

/// 对话执行数据源。

final class ChatActionDatasourceProvider
    extends
        $FunctionalProvider<
          ChatActionDatasource,
          ChatActionDatasource,
          ChatActionDatasource
        >
    with $Provider<ChatActionDatasource> {
  /// 对话执行数据源。
  const ChatActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatActionDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatActionDatasourceHash();

  @$internal
  @override
  $ProviderElement<ChatActionDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChatActionDatasource create(Ref ref) {
    return chatActionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatActionDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatActionDatasource>(value),
    );
  }
}

String _$chatActionDatasourceHash() =>
    r'03f4af902927460f983fcff586b3b08496ede4fb';

/// 附件落盘服务：把选中的文件复制到应用私有目录。

@ProviderFor(chatAttachmentStore)
const chatAttachmentStoreProvider = ChatAttachmentStoreProvider._();

/// 附件落盘服务：把选中的文件复制到应用私有目录。

final class ChatAttachmentStoreProvider
    extends
        $FunctionalProvider<
          ChatAttachmentStore,
          ChatAttachmentStore,
          ChatAttachmentStore
        >
    with $Provider<ChatAttachmentStore> {
  /// 附件落盘服务：把选中的文件复制到应用私有目录。
  const ChatAttachmentStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatAttachmentStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatAttachmentStoreHash();

  @$internal
  @override
  $ProviderElement<ChatAttachmentStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChatAttachmentStore create(Ref ref) {
    return chatAttachmentStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatAttachmentStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatAttachmentStore>(value),
    );
  }
}

String _$chatAttachmentStoreHash() =>
    r'75add446375cb6d94d8317bc9176eb94a7f7d4dc';

/// 对话执行仓储。

@ProviderFor(chatActionRepository)
const chatActionRepositoryProvider = ChatActionRepositoryProvider._();

/// 对话执行仓储。

final class ChatActionRepositoryProvider
    extends
        $FunctionalProvider<
          ChatActionRepository,
          ChatActionRepository,
          ChatActionRepository
        >
    with $Provider<ChatActionRepository> {
  /// 对话执行仓储。
  const ChatActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChatActionRepository create(Ref ref) {
    return chatActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatActionRepository>(value),
    );
  }
}

String _$chatActionRepositoryHash() =>
    r'5923dab4050841af69ebfb8a2332c1a20b269ca9';

/// 会话写数据源。

@ProviderFor(chatSessionActionDatasource)
const chatSessionActionDatasourceProvider =
    ChatSessionActionDatasourceProvider._();

/// 会话写数据源。

final class ChatSessionActionDatasourceProvider
    extends
        $FunctionalProvider<
          ChatSessionActionDatasource,
          ChatSessionActionDatasource,
          ChatSessionActionDatasource
        >
    with $Provider<ChatSessionActionDatasource> {
  /// 会话写数据源。
  const ChatSessionActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSessionActionDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatSessionActionDatasourceHash();

  @$internal
  @override
  $ProviderElement<ChatSessionActionDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChatSessionActionDatasource create(Ref ref) {
    return chatSessionActionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatSessionActionDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatSessionActionDatasource>(value),
    );
  }
}

String _$chatSessionActionDatasourceHash() =>
    r'2af83a9ae36a1e5bcd0f93db002a1c06108faa47';

/// 会话写仓储。

@ProviderFor(chatSessionActionRepository)
const chatSessionActionRepositoryProvider =
    ChatSessionActionRepositoryProvider._();

/// 会话写仓储。

final class ChatSessionActionRepositoryProvider
    extends
        $FunctionalProvider<
          ChatSessionActionRepository,
          ChatSessionActionRepository,
          ChatSessionActionRepository
        >
    with $Provider<ChatSessionActionRepository> {
  /// 会话写仓储。
  const ChatSessionActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSessionActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatSessionActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatSessionActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChatSessionActionRepository create(Ref ref) {
    return chatSessionActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatSessionActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatSessionActionRepository>(value),
    );
  }
}

String _$chatSessionActionRepositoryHash() =>
    r'a7eceb1bb0c64760fb183e2e87c6945de938bf21';

/// 提供给模型的本地工具清单。
///
/// 只读能力与执行能力分开注册，执行类工具调用前必须由用户确认。

@ProviderFor(chatTools)
const chatToolsProvider = ChatToolsProvider._();

/// 提供给模型的本地工具清单。
///
/// 只读能力与执行能力分开注册，执行类工具调用前必须由用户确认。

final class ChatToolsProvider
    extends
        $FunctionalProvider<
          List<ChatToolDefinition>,
          List<ChatToolDefinition>,
          List<ChatToolDefinition>
        >
    with $Provider<List<ChatToolDefinition>> {
  /// 提供给模型的本地工具清单。
  ///
  /// 只读能力与执行能力分开注册，执行类工具调用前必须由用户确认。
  const ChatToolsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatToolsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatToolsHash();

  @$internal
  @override
  $ProviderElement<List<ChatToolDefinition>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<ChatToolDefinition> create(Ref ref) {
    return chatTools(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ChatToolDefinition> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ChatToolDefinition>>(value),
    );
  }
}

String _$chatToolsHash() => r'cda176138658cb206b1aacbde75c77310d72eb6c';

/// 对话控制器。
///
/// 负责会话级调度：发送、停止、重发、切换会话与落盘；单轮的多步推进由
/// [ChatStreamSession] 承担。每个会话的执行上下文独立保存在 [_jobs] 里，
/// 切换会话不会中断正在进行的流式请求。

@ProviderFor(ChatController)
const chatControllerProvider = ChatControllerProvider._();

/// 对话控制器。
///
/// 负责会话级调度：发送、停止、重发、切换会话与落盘；单轮的多步推进由
/// [ChatStreamSession] 承担。每个会话的执行上下文独立保存在 [_jobs] 里，
/// 切换会话不会中断正在进行的流式请求。
final class ChatControllerProvider
    extends $NotifierProvider<ChatController, ChatState> {
  /// 对话控制器。
  ///
  /// 负责会话级调度：发送、停止、重发、切换会话与落盘；单轮的多步推进由
  /// [ChatStreamSession] 承担。每个会话的执行上下文独立保存在 [_jobs] 里，
  /// 切换会话不会中断正在进行的流式请求。
  const ChatControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatControllerHash();

  @$internal
  @override
  ChatController create() => ChatController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatState>(value),
    );
  }
}

String _$chatControllerHash() => r'86be0904e91597af1ec6e56b4e572142de68d6bd';

/// 对话控制器。
///
/// 负责会话级调度：发送、停止、重发、切换会话与落盘；单轮的多步推进由
/// [ChatStreamSession] 承担。每个会话的执行上下文独立保存在 [_jobs] 里，
/// 切换会话不会中断正在进行的流式请求。

abstract class _$ChatController extends $Notifier<ChatState> {
  ChatState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ChatState, ChatState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatState, ChatState>,
              ChatState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 会话列表控制器。
///
/// 只负责会话的增删改与当前项切换，不参与流式对话本身；
/// 对话内容由 `ChatController` 在每轮结束时通过 [saveTurns] 回写。

@ProviderFor(ChatSessions)
const chatSessionsProvider = ChatSessionsProvider._();

/// 会话列表控制器。
///
/// 只负责会话的增删改与当前项切换，不参与流式对话本身；
/// 对话内容由 `ChatController` 在每轮结束时通过 [saveTurns] 回写。
final class ChatSessionsProvider
    extends $NotifierProvider<ChatSessions, ChatSessionsState> {
  /// 会话列表控制器。
  ///
  /// 只负责会话的增删改与当前项切换，不参与流式对话本身；
  /// 对话内容由 `ChatController` 在每轮结束时通过 [saveTurns] 回写。
  const ChatSessionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSessionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatSessionsHash();

  @$internal
  @override
  ChatSessions create() => ChatSessions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatSessionsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatSessionsState>(value),
    );
  }
}

String _$chatSessionsHash() => r'28c5a317d9f9bd6a513601516078b3b0e6c3c7f5';

/// 会话列表控制器。
///
/// 只负责会话的增删改与当前项切换，不参与流式对话本身；
/// 对话内容由 `ChatController` 在每轮结束时通过 [saveTurns] 回写。

abstract class _$ChatSessions extends $Notifier<ChatSessionsState> {
  ChatSessionsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ChatSessionsState, ChatSessionsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatSessionsState, ChatSessionsState>,
              ChatSessionsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
