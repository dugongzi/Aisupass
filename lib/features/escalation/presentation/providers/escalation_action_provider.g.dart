// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'escalation_action_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 提权链路执行数据源。

@ProviderFor(escalationActionDatasource)
const escalationActionDatasourceProvider =
    EscalationActionDatasourceProvider._();

/// 提权链路执行数据源。

final class EscalationActionDatasourceProvider
    extends
        $FunctionalProvider<
          EscalationActionDatasource,
          EscalationActionDatasource,
          EscalationActionDatasource
        >
    with $Provider<EscalationActionDatasource> {
  /// 提权链路执行数据源。
  const EscalationActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'escalationActionDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$escalationActionDatasourceHash();

  @$internal
  @override
  $ProviderElement<EscalationActionDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EscalationActionDatasource create(Ref ref) {
    return escalationActionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EscalationActionDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EscalationActionDatasource>(value),
    );
  }
}

String _$escalationActionDatasourceHash() =>
    r'033cb08c2ea1d7d43ed2f87cf285a4f223d499e4';

/// 提权链路执行仓储。

@ProviderFor(escalationActionRepository)
const escalationActionRepositoryProvider =
    EscalationActionRepositoryProvider._();

/// 提权链路执行仓储。

final class EscalationActionRepositoryProvider
    extends
        $FunctionalProvider<
          EscalationActionRepository,
          EscalationActionRepository,
          EscalationActionRepository
        >
    with $Provider<EscalationActionRepository> {
  /// 提权链路执行仓储。
  const EscalationActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'escalationActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$escalationActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<EscalationActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EscalationActionRepository create(Ref ref) {
    return escalationActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EscalationActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EscalationActionRepository>(value),
    );
  }
}

String _$escalationActionRepositoryHash() =>
    r'874eb12d3417e136b6da44f7903cdf1a1a2dafe8';

/// 自动匹配并执行一次载荷提权。
///
/// 「选哪份」归查询仓储，「跑」归执行仓储，两者的装配只在这里发生。
/// 成功后刷新查询侧，避免 UI 还拿着旧的匹配结果。

@ProviderFor(runPayload)
const runPayloadProvider = RunPayloadProvider._();

/// 自动匹配并执行一次载荷提权。
///
/// 「选哪份」归查询仓储，「跑」归执行仓储，两者的装配只在这里发生。
/// 成功后刷新查询侧，避免 UI 还拿着旧的匹配结果。

final class RunPayloadProvider
    extends
        $FunctionalProvider<
          AsyncValue<EscalationRunResult>,
          EscalationRunResult,
          FutureOr<EscalationRunResult>
        >
    with
        $FutureModifier<EscalationRunResult>,
        $FutureProvider<EscalationRunResult> {
  /// 自动匹配并执行一次载荷提权。
  ///
  /// 「选哪份」归查询仓储，「跑」归执行仓储，两者的装配只在这里发生。
  /// 成功后刷新查询侧，避免 UI 还拿着旧的匹配结果。
  const RunPayloadProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'runPayloadProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$runPayloadHash();

  @$internal
  @override
  $FutureProviderElement<EscalationRunResult> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<EscalationRunResult> create(Ref ref) {
    return runPayload(ref);
  }
}

String _$runPayloadHash() => r'c9539072bc7e90f512f033291eb3162b27cd6944';

/// 把临时 root 移交给用户选定的 [manager]。
///
/// 与 [runPayload] 分开是刻意的：提权拿到的一次性 root 与「谁接管」是两件
/// 事，上游也把移交做成了独立入口。移交必然失败于「管理器没装」，这种情况下
/// 返回的是 [HandoffKind.managerMissing] 而非异常，UI 直接渲染即可。

@ProviderFor(handoffRoot)
const handoffRootProvider = HandoffRootFamily._();

/// 把临时 root 移交给用户选定的 [manager]。
///
/// 与 [runPayload] 分开是刻意的：提权拿到的一次性 root 与「谁接管」是两件
/// 事，上游也把移交做成了独立入口。移交必然失败于「管理器没装」，这种情况下
/// 返回的是 [HandoffKind.managerMissing] 而非异常，UI 直接渲染即可。

final class HandoffRootProvider
    extends
        $FunctionalProvider<
          AsyncValue<HandoffOutcome>,
          HandoffOutcome,
          FutureOr<HandoffOutcome>
        >
    with $FutureModifier<HandoffOutcome>, $FutureProvider<HandoffOutcome> {
  /// 把临时 root 移交给用户选定的 [manager]。
  ///
  /// 与 [runPayload] 分开是刻意的：提权拿到的一次性 root 与「谁接管」是两件
  /// 事，上游也把移交做成了独立入口。移交必然失败于「管理器没装」，这种情况下
  /// 返回的是 [HandoffKind.managerMissing] 而非异常，UI 直接渲染即可。
  const HandoffRootProvider._({
    required HandoffRootFamily super.from,
    required RootManager super.argument,
  }) : super(
         retry: null,
         name: r'handoffRootProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$handoffRootHash();

  @override
  String toString() {
    return r'handoffRootProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<HandoffOutcome> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HandoffOutcome> create(Ref ref) {
    final argument = this.argument as RootManager;
    return handoffRoot(ref, manager: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HandoffRootProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$handoffRootHash() => r'9ccac61d7f99b1fecd78537b4d1d7ef08220d1ef';

/// 把临时 root 移交给用户选定的 [manager]。
///
/// 与 [runPayload] 分开是刻意的：提权拿到的一次性 root 与「谁接管」是两件
/// 事，上游也把移交做成了独立入口。移交必然失败于「管理器没装」，这种情况下
/// 返回的是 [HandoffKind.managerMissing] 而非异常，UI 直接渲染即可。

final class HandoffRootFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<HandoffOutcome>, RootManager> {
  const HandoffRootFamily._()
    : super(
        retry: null,
        name: r'handoffRootProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 把临时 root 移交给用户选定的 [manager]。
  ///
  /// 与 [runPayload] 分开是刻意的：提权拿到的一次性 root 与「谁接管」是两件
  /// 事，上游也把移交做成了独立入口。移交必然失败于「管理器没装」，这种情况下
  /// 返回的是 [HandoffKind.managerMissing] 而非异常，UI 直接渲染即可。

  HandoffRootProvider call({required RootManager manager}) =>
      HandoffRootProvider._(argument: manager, from: this);

  @override
  String toString() => r'handoffRootProvider';
}
