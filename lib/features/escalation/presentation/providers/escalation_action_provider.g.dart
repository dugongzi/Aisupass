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

/// 自动匹配并拼出执行载荷的那一行命令。
///
/// 「选哪份」归查询仓储，「拼命令」归执行仓储，两者的装配只在这里发生。

@ProviderFor(runPayload)
const runPayloadProvider = RunPayloadProvider._();

/// 自动匹配并拼出执行载荷的那一行命令。
///
/// 「选哪份」归查询仓储，「拼命令」归执行仓储，两者的装配只在这里发生。

final class RunPayloadProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// 自动匹配并拼出执行载荷的那一行命令。
  ///
  /// 「选哪份」归查询仓储，「拼命令」归执行仓储，两者的装配只在这里发生。
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
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return runPayload(ref);
  }
}

String _$runPayloadHash() => r'a30cc1e659d1860e8f111ae4dd2d1bd4c9bc4193';

/// 用指定载荷拼出执行命令，跳过自动匹配。
///
/// 与 [runPayload] 共用执行仓储，区别只在「哪一条」是调用方给的，还是查出来的。
/// 用户在载荷清单里手动指定时走这里。

@ProviderFor(runPayloadChoice)
const runPayloadChoiceProvider = RunPayloadChoiceFamily._();

/// 用指定载荷拼出执行命令，跳过自动匹配。
///
/// 与 [runPayload] 共用执行仓储，区别只在「哪一条」是调用方给的，还是查出来的。
/// 用户在载荷清单里手动指定时走这里。

final class RunPayloadChoiceProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// 用指定载荷拼出执行命令，跳过自动匹配。
  ///
  /// 与 [runPayload] 共用执行仓储，区别只在「哪一条」是调用方给的，还是查出来的。
  /// 用户在载荷清单里手动指定时走这里。
  const RunPayloadChoiceProvider._({
    required RunPayloadChoiceFamily super.from,
    required Payload super.argument,
  }) : super(
         retry: null,
         name: r'runPayloadChoiceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$runPayloadChoiceHash();

  @override
  String toString() {
    return r'runPayloadChoiceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument = this.argument as Payload;
    return runPayloadChoice(ref, payload: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RunPayloadChoiceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$runPayloadChoiceHash() => r'8ccf60befdebf6f7959aaf38a6725b3b0541f4d8';

/// 用指定载荷拼出执行命令，跳过自动匹配。
///
/// 与 [runPayload] 共用执行仓储，区别只在「哪一条」是调用方给的，还是查出来的。
/// 用户在载荷清单里手动指定时走这里。

final class RunPayloadChoiceFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String>, Payload> {
  const RunPayloadChoiceFamily._()
    : super(
        retry: null,
        name: r'runPayloadChoiceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 用指定载荷拼出执行命令，跳过自动匹配。
  ///
  /// 与 [runPayload] 共用执行仓储，区别只在「哪一条」是调用方给的，还是查出来的。
  /// 用户在载荷清单里手动指定时走这里。

  RunPayloadChoiceProvider call({required Payload payload}) =>
      RunPayloadChoiceProvider._(argument: payload, from: this);

  @override
  String toString() => r'runPayloadChoiceProvider';
}

/// 把临时 root 移交给用户选定的 [manager]。
///
/// 管理器未安装时返回 [HandoffKind.managerMissing]，不抛异常。

@ProviderFor(handoffRoot)
const handoffRootProvider = HandoffRootFamily._();

/// 把临时 root 移交给用户选定的 [manager]。
///
/// 管理器未安装时返回 [HandoffKind.managerMissing]，不抛异常。

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
  /// 管理器未安装时返回 [HandoffKind.managerMissing]，不抛异常。
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
/// 管理器未安装时返回 [HandoffKind.managerMissing]，不抛异常。

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
  /// 管理器未安装时返回 [HandoffKind.managerMissing]，不抛异常。

  HandoffRootProvider call({required RootManager manager}) =>
      HandoffRootProvider._(argument: manager, from: this);

  @override
  String toString() => r'handoffRootProvider';
}

/// 记住用户选定的 root 管理器。
///
/// 落盘后失效 [selectedRootManagerProvider]。

@ProviderFor(selectRootManager)
const selectRootManagerProvider = SelectRootManagerFamily._();

/// 记住用户选定的 root 管理器。
///
/// 落盘后失效 [selectedRootManagerProvider]。

final class SelectRootManagerProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// 记住用户选定的 root 管理器。
  ///
  /// 落盘后失效 [selectedRootManagerProvider]。
  const SelectRootManagerProvider._({
    required SelectRootManagerFamily super.from,
    required RootManager super.argument,
  }) : super(
         retry: null,
         name: r'selectRootManagerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$selectRootManagerHash();

  @override
  String toString() {
    return r'selectRootManagerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as RootManager;
    return selectRootManager(ref, manager: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SelectRootManagerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$selectRootManagerHash() => r'5d7f6ef19e8e6a41a9db5d64f7a8164bc9e05f06';

/// 记住用户选定的 root 管理器。
///
/// 落盘后失效 [selectedRootManagerProvider]。

final class SelectRootManagerFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, RootManager> {
  const SelectRootManagerFamily._()
    : super(
        retry: null,
        name: r'selectRootManagerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 记住用户选定的 root 管理器。
  ///
  /// 落盘后失效 [selectedRootManagerProvider]。

  SelectRootManagerProvider call({required RootManager manager}) =>
      SelectRootManagerProvider._(argument: manager, from: this);

  @override
  String toString() => r'selectRootManagerProvider';
}
