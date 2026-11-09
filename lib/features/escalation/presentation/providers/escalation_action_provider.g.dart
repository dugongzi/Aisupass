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

/// DirtyFrag 运行数据源。

@ProviderFor(dirtyFragActionDatasource)
const dirtyFragActionDatasourceProvider = DirtyFragActionDatasourceProvider._();

/// DirtyFrag 运行数据源。

final class DirtyFragActionDatasourceProvider
    extends
        $FunctionalProvider<
          DirtyFragActionDatasource,
          DirtyFragActionDatasource,
          DirtyFragActionDatasource
        >
    with $Provider<DirtyFragActionDatasource> {
  /// DirtyFrag 运行数据源。
  const DirtyFragActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dirtyFragActionDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dirtyFragActionDatasourceHash();

  @$internal
  @override
  $ProviderElement<DirtyFragActionDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DirtyFragActionDatasource create(Ref ref) {
    return dirtyFragActionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DirtyFragActionDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DirtyFragActionDatasource>(value),
    );
  }
}

String _$dirtyFragActionDatasourceHash() =>
    r'6ac04d1f0b45f5b96f300b8e3802bd20d8ab79ea';

/// DirtyFrag 运行仓储。

@ProviderFor(dirtyFragActionRepository)
const dirtyFragActionRepositoryProvider = DirtyFragActionRepositoryProvider._();

/// DirtyFrag 运行仓储。

final class DirtyFragActionRepositoryProvider
    extends
        $FunctionalProvider<
          DirtyFragActionRepository,
          DirtyFragActionRepository,
          DirtyFragActionRepository
        >
    with $Provider<DirtyFragActionRepository> {
  /// DirtyFrag 运行仓储。
  const DirtyFragActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dirtyFragActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dirtyFragActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<DirtyFragActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DirtyFragActionRepository create(Ref ref) {
    return dirtyFragActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DirtyFragActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DirtyFragActionRepository>(value),
    );
  }
}

String _$dirtyFragActionRepositoryHash() =>
    r'ef5f252646f4858bb0b09d81cc228bdc53588636';

/// 本次开机是否已经注入过。

@ProviderFor(dirtyFragArmed)
const dirtyFragArmedProvider = DirtyFragArmedProvider._();

/// 本次开机是否已经注入过。

final class DirtyFragArmedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// 本次开机是否已经注入过。
  const DirtyFragArmedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dirtyFragArmedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dirtyFragArmedHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return dirtyFragArmed(ref);
  }
}

String _$dirtyFragArmedHash() => r'74006fbd33ad6ec1e4648fe31ac9be398ce7c5fb';

/// 运行默认值（设置页四个开关的当前值）。

@ProviderFor(dirtyFragRunDefaults)
const dirtyFragRunDefaultsProvider = DirtyFragRunDefaultsProvider._();

/// 运行默认值（设置页四个开关的当前值）。

final class DirtyFragRunDefaultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<DirtyFragRunDefaults>,
          DirtyFragRunDefaults,
          FutureOr<DirtyFragRunDefaults>
        >
    with
        $FutureModifier<DirtyFragRunDefaults>,
        $FutureProvider<DirtyFragRunDefaults> {
  /// 运行默认值（设置页四个开关的当前值）。
  const DirtyFragRunDefaultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dirtyFragRunDefaultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dirtyFragRunDefaultsHash();

  @$internal
  @override
  $FutureProviderElement<DirtyFragRunDefaults> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DirtyFragRunDefaults> create(Ref ref) {
    return dirtyFragRunDefaults(ref);
  }
}

String _$dirtyFragRunDefaultsHash() =>
    r'c147e91ade7a9f1c0aa3b9e122cdc55b8cc695e0';

/// 写运行默认值。设置页改开关时调用。

@ProviderFor(saveDirtyFragRunDefaults)
const saveDirtyFragRunDefaultsProvider = SaveDirtyFragRunDefaultsFamily._();

/// 写运行默认值。设置页改开关时调用。

final class SaveDirtyFragRunDefaultsProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// 写运行默认值。设置页改开关时调用。
  const SaveDirtyFragRunDefaultsProvider._({
    required SaveDirtyFragRunDefaultsFamily super.from,
    required DirtyFragRunDefaults super.argument,
  }) : super(
         retry: null,
         name: r'saveDirtyFragRunDefaultsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$saveDirtyFragRunDefaultsHash();

  @override
  String toString() {
    return r'saveDirtyFragRunDefaultsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as DirtyFragRunDefaults;
    return saveDirtyFragRunDefaults(ref, defaults: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SaveDirtyFragRunDefaultsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$saveDirtyFragRunDefaultsHash() =>
    r'02004449b98f9973ee87d0ffefba58e5da45455b';

/// 写运行默认值。设置页改开关时调用。

final class SaveDirtyFragRunDefaultsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, DirtyFragRunDefaults> {
  const SaveDirtyFragRunDefaultsFamily._()
    : super(
        retry: null,
        name: r'saveDirtyFragRunDefaultsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 写运行默认值。设置页改开关时调用。

  SaveDirtyFragRunDefaultsProvider call({
    required DirtyFragRunDefaults defaults,
  }) => SaveDirtyFragRunDefaultsProvider._(argument: defaults, from: this);

  @override
  String toString() => r'saveDirtyFragRunDefaultsProvider';
}

/// 跑一次 DirtyFrag，按块吐出证据。

@ProviderFor(runDirtyFrag)
const runDirtyFragProvider = RunDirtyFragFamily._();

/// 跑一次 DirtyFrag，按块吐出证据。

final class RunDirtyFragProvider
    extends
        $FunctionalProvider<
          AsyncValue<DirtyFragOutcome>,
          DirtyFragOutcome,
          Stream<DirtyFragOutcome>
        >
    with $FutureModifier<DirtyFragOutcome>, $StreamProvider<DirtyFragOutcome> {
  /// 跑一次 DirtyFrag，按块吐出证据。
  const RunDirtyFragProvider._({
    required RunDirtyFragFamily super.from,
    required ({RootManager manager, int? vrOffsetOverride}) super.argument,
  }) : super(
         retry: null,
         name: r'runDirtyFragProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$runDirtyFragHash();

  @override
  String toString() {
    return r'runDirtyFragProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<DirtyFragOutcome> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<DirtyFragOutcome> create(Ref ref) {
    final argument =
        this.argument as ({RootManager manager, int? vrOffsetOverride});
    return runDirtyFrag(
      ref,
      manager: argument.manager,
      vrOffsetOverride: argument.vrOffsetOverride,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RunDirtyFragProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$runDirtyFragHash() => r'4df47a1a78a0ab5fe45690f8c346b89c6e5a6fdb';

/// 跑一次 DirtyFrag，按块吐出证据。

final class RunDirtyFragFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<DirtyFragOutcome>,
          ({RootManager manager, int? vrOffsetOverride})
        > {
  const RunDirtyFragFamily._()
    : super(
        retry: null,
        name: r'runDirtyFragProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 跑一次 DirtyFrag，按块吐出证据。

  RunDirtyFragProvider call({
    required RootManager manager,
    int? vrOffsetOverride,
  }) => RunDirtyFragProvider._(
    argument: (manager: manager, vrOffsetOverride: vrOffsetOverride),
    from: this,
  );

  @override
  String toString() => r'runDirtyFragProvider';
}

/// 专家模式开关当前状态。

@ProviderFor(dirtyFragExpertMode)
const dirtyFragExpertModeProvider = DirtyFragExpertModeProvider._();

/// 专家模式开关当前状态。

final class DirtyFragExpertModeProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// 专家模式开关当前状态。
  const DirtyFragExpertModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dirtyFragExpertModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dirtyFragExpertModeHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return dirtyFragExpertMode(ref);
  }
}

String _$dirtyFragExpertModeHash() =>
    r'1609c1b937d215039251d22dcdd9933982d6aec5';

/// 开机自启开关当前状态。真相是组件启用态。

@ProviderFor(dirtyFragBootAutostart)
const dirtyFragBootAutostartProvider = DirtyFragBootAutostartProvider._();

/// 开机自启开关当前状态。真相是组件启用态。

final class DirtyFragBootAutostartProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// 开机自启开关当前状态。真相是组件启用态。
  const DirtyFragBootAutostartProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dirtyFragBootAutostartProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dirtyFragBootAutostartHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return dirtyFragBootAutostart(ref);
  }
}

String _$dirtyFragBootAutostartHash() =>
    r'50200e7bc0cf5292f007f4d2541f423eb393f6e7';

/// 切换专家模式。

@ProviderFor(setDirtyFragExpertMode)
const setDirtyFragExpertModeProvider = SetDirtyFragExpertModeFamily._();

/// 切换专家模式。

final class SetDirtyFragExpertModeProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// 切换专家模式。
  const SetDirtyFragExpertModeProvider._({
    required SetDirtyFragExpertModeFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'setDirtyFragExpertModeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$setDirtyFragExpertModeHash();

  @override
  String toString() {
    return r'setDirtyFragExpertModeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as bool;
    return setDirtyFragExpertMode(ref, enabled: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SetDirtyFragExpertModeProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$setDirtyFragExpertModeHash() =>
    r'a64348a4122f62ef74b3009abe9c93fe7df00fbe';

/// 切换专家模式。

final class SetDirtyFragExpertModeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, bool> {
  const SetDirtyFragExpertModeFamily._()
    : super(
        retry: null,
        name: r'setDirtyFragExpertModeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 切换专家模式。

  SetDirtyFragExpertModeProvider call({required bool enabled}) =>
      SetDirtyFragExpertModeProvider._(argument: enabled, from: this);

  @override
  String toString() => r'setDirtyFragExpertModeProvider';
}

/// 切换开机自启。

@ProviderFor(setDirtyFragBootAutostart)
const setDirtyFragBootAutostartProvider = SetDirtyFragBootAutostartFamily._();

/// 切换开机自启。

final class SetDirtyFragBootAutostartProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// 切换开机自启。
  const SetDirtyFragBootAutostartProvider._({
    required SetDirtyFragBootAutostartFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'setDirtyFragBootAutostartProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$setDirtyFragBootAutostartHash();

  @override
  String toString() {
    return r'setDirtyFragBootAutostartProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as bool;
    return setDirtyFragBootAutostart(ref, enabled: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SetDirtyFragBootAutostartProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$setDirtyFragBootAutostartHash() =>
    r'900e56823aefa4b6e0c4b072715930f5b125ce3e';

/// 切换开机自启。

final class SetDirtyFragBootAutostartFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, bool> {
  const SetDirtyFragBootAutostartFamily._()
    : super(
        retry: null,
        name: r'setDirtyFragBootAutostartProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 切换开机自启。

  SetDirtyFragBootAutostartProvider call({required bool enabled}) =>
      SetDirtyFragBootAutostartProvider._(argument: enabled, from: this);

  @override
  String toString() => r'setDirtyFragBootAutostartProvider';
}

/// 从镜像或 OTA 直链算一次 vr 偏移。

@ProviderFor(deriveVrOffset)
const deriveVrOffsetProvider = DeriveVrOffsetFamily._();

/// 从镜像或 OTA 直链算一次 vr 偏移。

final class DeriveVrOffsetProvider
    extends
        $FunctionalProvider<
          AsyncValue<VrOffsetResult>,
          VrOffsetResult,
          FutureOr<VrOffsetResult>
        >
    with $FutureModifier<VrOffsetResult>, $FutureProvider<VrOffsetResult> {
  /// 从镜像或 OTA 直链算一次 vr 偏移。
  const DeriveVrOffsetProvider._({
    required DeriveVrOffsetFamily super.from,
    required ({String input, bool insecure}) super.argument,
  }) : super(
         retry: null,
         name: r'deriveVrOffsetProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$deriveVrOffsetHash();

  @override
  String toString() {
    return r'deriveVrOffsetProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<VrOffsetResult> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VrOffsetResult> create(Ref ref) {
    final argument = this.argument as ({String input, bool insecure});
    return deriveVrOffset(
      ref,
      input: argument.input,
      insecure: argument.insecure,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DeriveVrOffsetProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$deriveVrOffsetHash() => r'fa51b920a1a22e1da6e8b196218d9ea37f4d5bad';

/// 从镜像或 OTA 直链算一次 vr 偏移。

final class DeriveVrOffsetFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<VrOffsetResult>,
          ({String input, bool insecure})
        > {
  const DeriveVrOffsetFamily._()
    : super(
        retry: null,
        name: r'deriveVrOffsetProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 从镜像或 OTA 直链算一次 vr 偏移。

  DeriveVrOffsetProvider call({required String input, bool insecure = false}) =>
      DeriveVrOffsetProvider._(
        argument: (input: input, insecure: insecure),
        from: this,
      );

  @override
  String toString() => r'deriveVrOffsetProvider';
}

/// 提取进度。只在被监听期间轮询，弹窗关掉就停。

@ProviderFor(vrDeriveProgress)
const vrDeriveProgressProvider = VrDeriveProgressProvider._();

/// 提取进度。只在被监听期间轮询，弹窗关掉就停。

final class VrDeriveProgressProvider
    extends
        $FunctionalProvider<
          AsyncValue<VrDeriveProgress>,
          VrDeriveProgress,
          Stream<VrDeriveProgress>
        >
    with $FutureModifier<VrDeriveProgress>, $StreamProvider<VrDeriveProgress> {
  /// 提取进度。只在被监听期间轮询，弹窗关掉就停。
  const VrDeriveProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vrDeriveProgressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vrDeriveProgressHash();

  @$internal
  @override
  $StreamProviderElement<VrDeriveProgress> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<VrDeriveProgress> create(Ref ref) {
    return vrDeriveProgress(ref);
  }
}

String _$vrDeriveProgressHash() => r'6328101a05e6d604b5067d9539040d603605a839';
