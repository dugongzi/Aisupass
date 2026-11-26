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
/// 没有候选时抛 [PayloadLaunchException]，文案由展示层写屏。

@ProviderFor(runPayload)
const runPayloadProvider = RunPayloadProvider._();

/// 自动匹配并拼出执行载荷的那一行命令。
///
/// 「选哪份」归查询仓储，「拼命令」归执行仓储，两者的装配只在这里发生。
/// 没有候选时抛 [PayloadLaunchException]，文案由展示层写屏。

final class RunPayloadProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// 自动匹配并拼出执行载荷的那一行命令。
  ///
  /// 「选哪份」归查询仓储，「拼命令」归执行仓储，两者的装配只在这里发生。
  /// 没有候选时抛 [PayloadLaunchException]，文案由展示层写屏。
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

String _$runPayloadHash() => r'4519e87d93ebed4e62158b9c47c9eed0ccac5646';

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

/// 提权链路的写操作。
///
/// 无参 `keepAlive` 类持有 [Ref]，参数走方法入参。

@ProviderFor(escalationActions)
const escalationActionsProvider = EscalationActionsProvider._();

/// 提权链路的写操作。
///
/// 无参 `keepAlive` 类持有 [Ref]，参数走方法入参。

final class EscalationActionsProvider
    extends
        $FunctionalProvider<
          EscalationActions,
          EscalationActions,
          EscalationActions
        >
    with $Provider<EscalationActions> {
  /// 提权链路的写操作。
  ///
  /// 无参 `keepAlive` 类持有 [Ref]，参数走方法入参。
  const EscalationActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'escalationActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$escalationActionsHash();

  @$internal
  @override
  $ProviderElement<EscalationActions> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EscalationActions create(Ref ref) {
    return escalationActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EscalationActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EscalationActions>(value),
    );
  }
}

String _$escalationActionsHash() => r'161c8871c554ad28674166549b1a8bf8a745bed7';

/// 把临时 root 移交给用户选定的 [manager]，成功后把该管理器拉到前台。
///
/// 先由原生按该管理器解析 ksud 路径（支持改了名的管理器），再拼脚本；
/// 管理器未安装时返回 [HandoffKind.managerMissing]，不抛异常。

@ProviderFor(handoffRoot)
const handoffRootProvider = HandoffRootFamily._();

/// 把临时 root 移交给用户选定的 [manager]，成功后把该管理器拉到前台。
///
/// 先由原生按该管理器解析 ksud 路径（支持改了名的管理器），再拼脚本；
/// 管理器未安装时返回 [HandoffKind.managerMissing]，不抛异常。

final class HandoffRootProvider
    extends
        $FunctionalProvider<
          AsyncValue<HandoffOutcome>,
          HandoffOutcome,
          FutureOr<HandoffOutcome>
        >
    with $FutureModifier<HandoffOutcome>, $FutureProvider<HandoffOutcome> {
  /// 把临时 root 移交给用户选定的 [manager]，成功后把该管理器拉到前台。
  ///
  /// 先由原生按该管理器解析 ksud 路径（支持改了名的管理器），再拼脚本；
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

String _$handoffRootHash() => r'25c3a053ff558a504a0e6b8cc43241f37a2dbb53';

/// 把临时 root 移交给用户选定的 [manager]，成功后把该管理器拉到前台。
///
/// 先由原生按该管理器解析 ksud 路径（支持改了名的管理器），再拼脚本；
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

  /// 把临时 root 移交给用户选定的 [manager]，成功后把该管理器拉到前台。
  ///
  /// 先由原生按该管理器解析 ksud 路径（支持改了名的管理器），再拼脚本；
  /// 管理器未安装时返回 [HandoffKind.managerMissing]，不抛异常。

  HandoffRootProvider call({required RootManager manager}) =>
      HandoffRootProvider._(argument: manager, from: this);

  @override
  String toString() => r'handoffRootProvider';
}

/// root 管理器的写操作。
///
/// 形态同 `aiConfigActions`：无参 `keepAlive` 类持有 [Ref]，参数走方法入参。
/// 带参族函数会按参数缓存，同样的参数第二次调用不再执行方法体。

@ProviderFor(rootManagerActions)
const rootManagerActionsProvider = RootManagerActionsProvider._();

/// root 管理器的写操作。
///
/// 形态同 `aiConfigActions`：无参 `keepAlive` 类持有 [Ref]，参数走方法入参。
/// 带参族函数会按参数缓存，同样的参数第二次调用不再执行方法体。

final class RootManagerActionsProvider
    extends
        $FunctionalProvider<
          RootManagerActions,
          RootManagerActions,
          RootManagerActions
        >
    with $Provider<RootManagerActions> {
  /// root 管理器的写操作。
  ///
  /// 形态同 `aiConfigActions`：无参 `keepAlive` 类持有 [Ref]，参数走方法入参。
  /// 带参族函数会按参数缓存，同样的参数第二次调用不再执行方法体。
  const RootManagerActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rootManagerActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rootManagerActionsHash();

  @$internal
  @override
  $ProviderElement<RootManagerActions> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RootManagerActions create(Ref ref) {
    return rootManagerActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RootManagerActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RootManagerActions>(value),
    );
  }
}

String _$rootManagerActionsHash() =>
    r'f84a7be6ff0900100ae2492dfa6cd513dfe3a32f';

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
    r'57dd66c3706ea44c44d395809d19311c8b6690e8';

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

/// DirtyFrag 设置页的写操作。
///
/// 同 [rootManagerActions]：无参类，参数走方法入参。

@ProviderFor(dirtyFragActions)
const dirtyFragActionsProvider = DirtyFragActionsProvider._();

/// DirtyFrag 设置页的写操作。
///
/// 同 [rootManagerActions]：无参类，参数走方法入参。

final class DirtyFragActionsProvider
    extends
        $FunctionalProvider<
          DirtyFragActions,
          DirtyFragActions,
          DirtyFragActions
        >
    with $Provider<DirtyFragActions> {
  /// DirtyFrag 设置页的写操作。
  ///
  /// 同 [rootManagerActions]：无参类，参数走方法入参。
  const DirtyFragActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dirtyFragActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dirtyFragActionsHash();

  @$internal
  @override
  $ProviderElement<DirtyFragActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DirtyFragActions create(Ref ref) {
    return dirtyFragActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DirtyFragActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DirtyFragActions>(value),
    );
  }
}

String _$dirtyFragActionsHash() => r'da9f3570dec10c45a19961219ce0d3c8745ed94d';

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

String _$runDirtyFragHash() => r'e9cf4654c97b12af4362e04da6fe1110b3840b15';

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

String _$vrDeriveProgressHash() => r'd5664c5663df2891f859e97c89981ec58be9a7a6';

/// 提取进度的单次快照，供一次性查询使用。

@ProviderFor(vrDeriveProgressSnapshot)
const vrDeriveProgressSnapshotProvider = VrDeriveProgressSnapshotProvider._();

/// 提取进度的单次快照，供一次性查询使用。

final class VrDeriveProgressSnapshotProvider
    extends
        $FunctionalProvider<
          AsyncValue<VrDeriveProgress>,
          VrDeriveProgress,
          FutureOr<VrDeriveProgress>
        >
    with $FutureModifier<VrDeriveProgress>, $FutureProvider<VrDeriveProgress> {
  /// 提取进度的单次快照，供一次性查询使用。
  const VrDeriveProgressSnapshotProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vrDeriveProgressSnapshotProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vrDeriveProgressSnapshotHash();

  @$internal
  @override
  $FutureProviderElement<VrDeriveProgress> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VrDeriveProgress> create(Ref ref) {
    return vrDeriveProgressSnapshot(ref);
  }
}

String _$vrDeriveProgressSnapshotHash() =>
    r'a0cc11760b9da540f0f5dcfc5b76a0ffa8da52b2';

/// GhostKey 运行数据源。

@ProviderFor(ghostKeyActionDatasource)
const ghostKeyActionDatasourceProvider = GhostKeyActionDatasourceProvider._();

/// GhostKey 运行数据源。

final class GhostKeyActionDatasourceProvider
    extends
        $FunctionalProvider<
          GhostKeyActionDatasource,
          GhostKeyActionDatasource,
          GhostKeyActionDatasource
        >
    with $Provider<GhostKeyActionDatasource> {
  /// GhostKey 运行数据源。
  const GhostKeyActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ghostKeyActionDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ghostKeyActionDatasourceHash();

  @$internal
  @override
  $ProviderElement<GhostKeyActionDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GhostKeyActionDatasource create(Ref ref) {
    return ghostKeyActionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GhostKeyActionDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GhostKeyActionDatasource>(value),
    );
  }
}

String _$ghostKeyActionDatasourceHash() =>
    r'b25682224a0c1a2bc769fd9a0540a7c944abeca4';

/// GhostKey 运行仓储。

@ProviderFor(ghostKeyActionRepository)
const ghostKeyActionRepositoryProvider = GhostKeyActionRepositoryProvider._();

/// GhostKey 运行仓储。

final class GhostKeyActionRepositoryProvider
    extends
        $FunctionalProvider<
          GhostKeyActionRepository,
          GhostKeyActionRepository,
          GhostKeyActionRepository
        >
    with $Provider<GhostKeyActionRepository> {
  /// GhostKey 运行仓储。
  const GhostKeyActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ghostKeyActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ghostKeyActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<GhostKeyActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GhostKeyActionRepository create(Ref ref) {
    return ghostKeyActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GhostKeyActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GhostKeyActionRepository>(value),
    );
  }
}

String _$ghostKeyActionRepositoryHash() =>
    r'b66eb0eb80d0c8df54920e10acd3a9206fb7a41f';

/// GhostKey 起跑前的六项就绪检查。

@ProviderFor(ghostKeyPreflight)
const ghostKeyPreflightProvider = GhostKeyPreflightProvider._();

/// GhostKey 起跑前的六项就绪检查。

final class GhostKeyPreflightProvider
    extends
        $FunctionalProvider<
          AsyncValue<GhostKeyPreflight>,
          GhostKeyPreflight,
          FutureOr<GhostKeyPreflight>
        >
    with
        $FutureModifier<GhostKeyPreflight>,
        $FutureProvider<GhostKeyPreflight> {
  /// GhostKey 起跑前的六项就绪检查。
  const GhostKeyPreflightProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ghostKeyPreflightProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ghostKeyPreflightHash();

  @$internal
  @override
  $FutureProviderElement<GhostKeyPreflight> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GhostKeyPreflight> create(Ref ref) {
    return ghostKeyPreflight(ref);
  }
}

String _$ghostKeyPreflightHash() => r'53ef1c0818cc66863c046c99d6bdb47ec170df4f';

/// 运行偏好（设置页两个开关的当前值）。

@ProviderFor(ghostKeyRunDefaults)
const ghostKeyRunDefaultsProvider = GhostKeyRunDefaultsProvider._();

/// 运行偏好（设置页两个开关的当前值）。

final class GhostKeyRunDefaultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<GhostKeyRunDefaults>,
          GhostKeyRunDefaults,
          FutureOr<GhostKeyRunDefaults>
        >
    with
        $FutureModifier<GhostKeyRunDefaults>,
        $FutureProvider<GhostKeyRunDefaults> {
  /// 运行偏好（设置页两个开关的当前值）。
  const GhostKeyRunDefaultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ghostKeyRunDefaultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ghostKeyRunDefaultsHash();

  @$internal
  @override
  $FutureProviderElement<GhostKeyRunDefaults> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GhostKeyRunDefaults> create(Ref ref) {
    return ghostKeyRunDefaults(ref);
  }
}

String _$ghostKeyRunDefaultsHash() =>
    r'95e2a28a80597ec5f480f85fa34efcd31f43d786';

/// GhostKey 设置页的写操作。
///
/// 同 [rootManagerActions]：无参类，参数走方法入参。

@ProviderFor(ghostKeyActions)
const ghostKeyActionsProvider = GhostKeyActionsProvider._();

/// GhostKey 设置页的写操作。
///
/// 同 [rootManagerActions]：无参类，参数走方法入参。

final class GhostKeyActionsProvider
    extends
        $FunctionalProvider<GhostKeyActions, GhostKeyActions, GhostKeyActions>
    with $Provider<GhostKeyActions> {
  /// GhostKey 设置页的写操作。
  ///
  /// 同 [rootManagerActions]：无参类，参数走方法入参。
  const GhostKeyActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ghostKeyActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ghostKeyActionsHash();

  @$internal
  @override
  $ProviderElement<GhostKeyActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GhostKeyActions create(Ref ref) {
    return ghostKeyActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GhostKeyActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GhostKeyActions>(value),
    );
  }
}

String _$ghostKeyActionsHash() => r'd131b7ce2923ae6a94d0f6f954495decd9872f6e';

/// 跑一次 GhostKey，按块吐出证据。

@ProviderFor(runGhostKey)
const runGhostKeyProvider = RunGhostKeyFamily._();

/// 跑一次 GhostKey，按块吐出证据。

final class RunGhostKeyProvider
    extends
        $FunctionalProvider<
          AsyncValue<GhostKeyOutcome>,
          GhostKeyOutcome,
          Stream<GhostKeyOutcome>
        >
    with $FutureModifier<GhostKeyOutcome>, $StreamProvider<GhostKeyOutcome> {
  /// 跑一次 GhostKey，按块吐出证据。
  const RunGhostKeyProvider._({
    required RunGhostKeyFamily super.from,
    required RootManager? super.argument,
  }) : super(
         retry: null,
         name: r'runGhostKeyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$runGhostKeyHash();

  @override
  String toString() {
    return r'runGhostKeyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<GhostKeyOutcome> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<GhostKeyOutcome> create(Ref ref) {
    final argument = this.argument as RootManager?;
    return runGhostKey(ref, manager: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RunGhostKeyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$runGhostKeyHash() => r'b3d23e3ebdd337e7a46f512cb6f2baefbe43356c';

/// 跑一次 GhostKey，按块吐出证据。

final class RunGhostKeyFamily extends $Family
    with $FunctionalFamilyOverride<Stream<GhostKeyOutcome>, RootManager?> {
  const RunGhostKeyFamily._()
    : super(
        retry: null,
        name: r'runGhostKeyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 跑一次 GhostKey，按块吐出证据。

  RunGhostKeyProvider call({RootManager? manager}) =>
      RunGhostKeyProvider._(argument: manager, from: this);

  @override
  String toString() => r'runGhostKeyProvider';
}

/// GhostLock 运行数据源。

@ProviderFor(ghostLockActionDatasource)
const ghostLockActionDatasourceProvider = GhostLockActionDatasourceProvider._();

/// GhostLock 运行数据源。

final class GhostLockActionDatasourceProvider
    extends
        $FunctionalProvider<
          GhostLockActionDatasource,
          GhostLockActionDatasource,
          GhostLockActionDatasource
        >
    with $Provider<GhostLockActionDatasource> {
  /// GhostLock 运行数据源。
  const GhostLockActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ghostLockActionDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ghostLockActionDatasourceHash();

  @$internal
  @override
  $ProviderElement<GhostLockActionDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GhostLockActionDatasource create(Ref ref) {
    return ghostLockActionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GhostLockActionDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GhostLockActionDatasource>(value),
    );
  }
}

String _$ghostLockActionDatasourceHash() =>
    r'89f1c841797af1508853105fb3ad211260028d1c';

/// GhostLock 运行仓储。

@ProviderFor(ghostLockActionRepository)
const ghostLockActionRepositoryProvider = GhostLockActionRepositoryProvider._();

/// GhostLock 运行仓储。

final class GhostLockActionRepositoryProvider
    extends
        $FunctionalProvider<
          GhostLockActionRepository,
          GhostLockActionRepository,
          GhostLockActionRepository
        >
    with $Provider<GhostLockActionRepository> {
  /// GhostLock 运行仓储。
  const GhostLockActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ghostLockActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ghostLockActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<GhostLockActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GhostLockActionRepository create(Ref ref) {
    return ghostLockActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GhostLockActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GhostLockActionRepository>(value),
    );
  }
}

String _$ghostLockActionRepositoryHash() =>
    r'eda6e5758a12c79213a24c595a4862eedc656e41';

/// 运行前自检。

@ProviderFor(ghostLockPreflight)
const ghostLockPreflightProvider = GhostLockPreflightProvider._();

/// 运行前自检。

final class GhostLockPreflightProvider
    extends
        $FunctionalProvider<
          AsyncValue<GhostLockPreflight>,
          GhostLockPreflight,
          FutureOr<GhostLockPreflight>
        >
    with
        $FutureModifier<GhostLockPreflight>,
        $FutureProvider<GhostLockPreflight> {
  /// 运行前自检。
  const GhostLockPreflightProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ghostLockPreflightProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ghostLockPreflightHash();

  @$internal
  @override
  $FutureProviderElement<GhostLockPreflight> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GhostLockPreflight> create(Ref ref) {
    return ghostLockPreflight(ref);
  }
}

String _$ghostLockPreflightHash() =>
    r'61686b25188450100085d617b07ddc665ec2f739';

/// GhostLock 运行期的写操作。
///
/// 无参 `keepAlive` 类持有 [Ref]，参数走方法入参。

@ProviderFor(ghostLockActions)
const ghostLockActionsProvider = GhostLockActionsProvider._();

/// GhostLock 运行期的写操作。
///
/// 无参 `keepAlive` 类持有 [Ref]，参数走方法入参。

final class GhostLockActionsProvider
    extends
        $FunctionalProvider<
          GhostLockActions,
          GhostLockActions,
          GhostLockActions
        >
    with $Provider<GhostLockActions> {
  /// GhostLock 运行期的写操作。
  ///
  /// 无参 `keepAlive` 类持有 [Ref]，参数走方法入参。
  const GhostLockActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ghostLockActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ghostLockActionsHash();

  @$internal
  @override
  $ProviderElement<GhostLockActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GhostLockActions create(Ref ref) {
    return ghostLockActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GhostLockActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GhostLockActions>(value),
    );
  }
}

String _$ghostLockActionsHash() => r'7868b64f53e0b67c5d5aca14beef712537a45ac3';

/// 跑一次 GhostLock，按块吐出证据。

@ProviderFor(runGhostLock)
const runGhostLockProvider = RunGhostLockFamily._();

/// 跑一次 GhostLock，按块吐出证据。

final class RunGhostLockProvider
    extends
        $FunctionalProvider<
          AsyncValue<GhostLockOutcome>,
          GhostLockOutcome,
          Stream<GhostLockOutcome>
        >
    with $FutureModifier<GhostLockOutcome>, $StreamProvider<GhostLockOutcome> {
  /// 跑一次 GhostLock，按块吐出证据。
  const RunGhostLockProvider._({
    required RunGhostLockFamily super.from,
    required ({RootManager? manager, bool safeMode}) super.argument,
  }) : super(
         retry: null,
         name: r'runGhostLockProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$runGhostLockHash();

  @override
  String toString() {
    return r'runGhostLockProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<GhostLockOutcome> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<GhostLockOutcome> create(Ref ref) {
    final argument = this.argument as ({RootManager? manager, bool safeMode});
    return runGhostLock(
      ref,
      manager: argument.manager,
      safeMode: argument.safeMode,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RunGhostLockProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$runGhostLockHash() => r'dc2b9bddefa405ac61c718ba1fb740747ab316f9';

/// 跑一次 GhostLock，按块吐出证据。

final class RunGhostLockFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<GhostLockOutcome>,
          ({RootManager? manager, bool safeMode})
        > {
  const RunGhostLockFamily._()
    : super(
        retry: null,
        name: r'runGhostLockProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 跑一次 GhostLock，按块吐出证据。

  RunGhostLockProvider call({RootManager? manager, bool safeMode = false}) =>
      RunGhostLockProvider._(
        argument: (manager: manager, safeMode: safeMode),
        from: this,
      );

  @override
  String toString() => r'runGhostLockProvider';
}

/// GhostLock profile 导入数据源。

@ProviderFor(ghostLockProfileActionDatasource)
const ghostLockProfileActionDatasourceProvider =
    GhostLockProfileActionDatasourceProvider._();

/// GhostLock profile 导入数据源。

final class GhostLockProfileActionDatasourceProvider
    extends
        $FunctionalProvider<
          GhostLockProfileActionDatasource,
          GhostLockProfileActionDatasource,
          GhostLockProfileActionDatasource
        >
    with $Provider<GhostLockProfileActionDatasource> {
  /// GhostLock profile 导入数据源。
  const GhostLockProfileActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ghostLockProfileActionDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ghostLockProfileActionDatasourceHash();

  @$internal
  @override
  $ProviderElement<GhostLockProfileActionDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GhostLockProfileActionDatasource create(Ref ref) {
    return ghostLockProfileActionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GhostLockProfileActionDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GhostLockProfileActionDatasource>(
        value,
      ),
    );
  }
}

String _$ghostLockProfileActionDatasourceHash() =>
    r'a46973bc5774b9ca12f644e955941b657a203ac0';

/// GhostLock profile 导入仓储。

@ProviderFor(ghostLockProfileActionRepository)
const ghostLockProfileActionRepositoryProvider =
    GhostLockProfileActionRepositoryProvider._();

/// GhostLock profile 导入仓储。

final class GhostLockProfileActionRepositoryProvider
    extends
        $FunctionalProvider<
          GhostLockProfileActionRepository,
          GhostLockProfileActionRepository,
          GhostLockProfileActionRepository
        >
    with $Provider<GhostLockProfileActionRepository> {
  /// GhostLock profile 导入仓储。
  const GhostLockProfileActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ghostLockProfileActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ghostLockProfileActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<GhostLockProfileActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GhostLockProfileActionRepository create(Ref ref) {
    return ghostLockProfileActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GhostLockProfileActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GhostLockProfileActionRepository>(
        value,
      ),
    );
  }
}

String _$ghostLockProfileActionRepositoryHash() =>
    r'ce52af89914b546c990d5ec112032f851947789a';

/// 用户导入的 profile 列表。

@ProviderFor(ghostLockImportedProfiles)
const ghostLockImportedProfilesProvider = GhostLockImportedProfilesProvider._();

/// 用户导入的 profile 列表。

final class GhostLockImportedProfilesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GhostLockUserProfile>>,
          List<GhostLockUserProfile>,
          FutureOr<List<GhostLockUserProfile>>
        >
    with
        $FutureModifier<List<GhostLockUserProfile>>,
        $FutureProvider<List<GhostLockUserProfile>> {
  /// 用户导入的 profile 列表。
  const GhostLockImportedProfilesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ghostLockImportedProfilesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ghostLockImportedProfilesHash();

  @$internal
  @override
  $FutureProviderElement<List<GhostLockUserProfile>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GhostLockUserProfile>> create(Ref ref) {
    return ghostLockImportedProfiles(ref);
  }
}

String _$ghostLockImportedProfilesHash() =>
    r'770ed9d1239d2d25272b6925b94418cf9fdd5742';

/// 内置 GhostLock 内核表的全部 release，按与设备内核的相近度排序。
///
/// 设备 release 尚未就绪（自检未跑完）时退回原生顺序，不阻塞列表。

@ProviderFor(ghostLockBuiltinReleases)
const ghostLockBuiltinReleasesProvider = GhostLockBuiltinReleasesProvider._();

/// 内置 GhostLock 内核表的全部 release，按与设备内核的相近度排序。
///
/// 设备 release 尚未就绪（自检未跑完）时退回原生顺序，不阻塞列表。

final class GhostLockBuiltinReleasesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// 内置 GhostLock 内核表的全部 release，按与设备内核的相近度排序。
  ///
  /// 设备 release 尚未就绪（自检未跑完）时退回原生顺序，不阻塞列表。
  const GhostLockBuiltinReleasesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ghostLockBuiltinReleasesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ghostLockBuiltinReleasesHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return ghostLockBuiltinReleases(ref);
  }
}

String _$ghostLockBuiltinReleasesHash() =>
    r'a977c4dc1372308b77a177ce9ee86d56cff79772';

/// 某 release 的生效 GhostLock 配置。

@ProviderFor(ghostLockProfileConfig)
const ghostLockProfileConfigProvider = GhostLockProfileConfigFamily._();

/// 某 release 的生效 GhostLock 配置。

final class GhostLockProfileConfigProvider
    extends
        $FunctionalProvider<
          AsyncValue<GhostLockProfileConfig>,
          GhostLockProfileConfig,
          FutureOr<GhostLockProfileConfig>
        >
    with
        $FutureModifier<GhostLockProfileConfig>,
        $FutureProvider<GhostLockProfileConfig> {
  /// 某 release 的生效 GhostLock 配置。
  const GhostLockProfileConfigProvider._({
    required GhostLockProfileConfigFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'ghostLockProfileConfigProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ghostLockProfileConfigHash();

  @override
  String toString() {
    return r'ghostLockProfileConfigProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<GhostLockProfileConfig> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GhostLockProfileConfig> create(Ref ref) {
    final argument = this.argument as String;
    return ghostLockProfileConfig(ref, release: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GhostLockProfileConfigProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ghostLockProfileConfigHash() =>
    r'6cf93438b0d2069a8b1b79d3a08a75ab6764b6d7';

/// 某 release 的生效 GhostLock 配置。

final class GhostLockProfileConfigFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<GhostLockProfileConfig>, String> {
  const GhostLockProfileConfigFamily._()
    : super(
        retry: null,
        name: r'ghostLockProfileConfigProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 某 release 的生效 GhostLock 配置。

  GhostLockProfileConfigProvider call({required String release}) =>
      GhostLockProfileConfigProvider._(argument: release, from: this);

  @override
  String toString() => r'ghostLockProfileConfigProvider';
}

/// 上一次提取留在缓存里的镜像路径。

@ProviderFor(ghostLockExtractedImages)
const ghostLockExtractedImagesProvider = GhostLockExtractedImagesProvider._();

/// 上一次提取留在缓存里的镜像路径。

final class GhostLockExtractedImagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// 上一次提取留在缓存里的镜像路径。
  const GhostLockExtractedImagesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ghostLockExtractedImagesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ghostLockExtractedImagesHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return ghostLockExtractedImages(ref);
  }
}

String _$ghostLockExtractedImagesHash() =>
    r'ffa031c2cc13938d8d7b0b4c30ace5ec49fb8891';

/// kernel 表解析进度快照，供一次性查询使用。

@ProviderFor(ghostLockProbeProgressSnapshot)
const ghostLockProbeProgressSnapshotProvider =
    GhostLockProbeProgressSnapshotProvider._();

/// kernel 表解析进度快照，供一次性查询使用。

final class GhostLockProbeProgressSnapshotProvider
    extends
        $FunctionalProvider<
          AsyncValue<GhostLockProbeProgress>,
          GhostLockProbeProgress,
          FutureOr<GhostLockProbeProgress>
        >
    with
        $FutureModifier<GhostLockProbeProgress>,
        $FutureProvider<GhostLockProbeProgress> {
  /// kernel 表解析进度快照，供一次性查询使用。
  const GhostLockProbeProgressSnapshotProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ghostLockProbeProgressSnapshotProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ghostLockProbeProgressSnapshotHash();

  @$internal
  @override
  $FutureProviderElement<GhostLockProbeProgress> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GhostLockProbeProgress> create(Ref ref) {
    return ghostLockProbeProgressSnapshot(ref);
  }
}

String _$ghostLockProbeProgressSnapshotHash() =>
    r'1999ae028ecc71e69d83da362d7866c2bcb54c1f';

/// 单份用户 profile 的原始 HOCON 文本；不存在返回空串。

@ProviderFor(ghostLockImportedProfileContent)
const ghostLockImportedProfileContentProvider =
    GhostLockImportedProfileContentFamily._();

/// 单份用户 profile 的原始 HOCON 文本；不存在返回空串。

final class GhostLockImportedProfileContentProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// 单份用户 profile 的原始 HOCON 文本；不存在返回空串。
  const GhostLockImportedProfileContentProvider._({
    required GhostLockImportedProfileContentFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'ghostLockImportedProfileContentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ghostLockImportedProfileContentHash();

  @override
  String toString() {
    return r'ghostLockImportedProfileContentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument = this.argument as String;
    return ghostLockImportedProfileContent(ref, name: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GhostLockImportedProfileContentProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ghostLockImportedProfileContentHash() =>
    r'd6cef0630202b23c23f711f70cba2b9cda6ebb41';

/// 单份用户 profile 的原始 HOCON 文本；不存在返回空串。

final class GhostLockImportedProfileContentFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String>, String> {
  const GhostLockImportedProfileContentFamily._()
    : super(
        retry: null,
        name: r'ghostLockImportedProfileContentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 单份用户 profile 的原始 HOCON 文本；不存在返回空串。

  GhostLockImportedProfileContentProvider call({required String name}) =>
      GhostLockImportedProfileContentProvider._(argument: name, from: this);

  @override
  String toString() => r'ghostLockImportedProfileContentProvider';
}

/// GhostLock 解析进度。只在被监听期间轮询，面板收起就停。

@ProviderFor(ghostLockProbeProgress)
const ghostLockProbeProgressProvider = GhostLockProbeProgressProvider._();

/// GhostLock 解析进度。只在被监听期间轮询，面板收起就停。

final class GhostLockProbeProgressProvider
    extends
        $FunctionalProvider<
          AsyncValue<GhostLockProbeProgress>,
          GhostLockProbeProgress,
          Stream<GhostLockProbeProgress>
        >
    with
        $FutureModifier<GhostLockProbeProgress>,
        $StreamProvider<GhostLockProbeProgress> {
  /// GhostLock 解析进度。只在被监听期间轮询，面板收起就停。
  const GhostLockProbeProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ghostLockProbeProgressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ghostLockProbeProgressHash();

  @$internal
  @override
  $StreamProviderElement<GhostLockProbeProgress> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<GhostLockProbeProgress> create(Ref ref) {
    return ghostLockProbeProgress(ref);
  }
}

String _$ghostLockProbeProgressHash() =>
    r'ce040afc80f91953087ed26cf09f4c293b8f3417';

/// GhostLock profile 编辑数据源。

@ProviderFor(ghostLockProfileEditActionDatasource)
const ghostLockProfileEditActionDatasourceProvider =
    GhostLockProfileEditActionDatasourceProvider._();

/// GhostLock profile 编辑数据源。

final class GhostLockProfileEditActionDatasourceProvider
    extends
        $FunctionalProvider<
          GhostLockProfileEditActionDatasource,
          GhostLockProfileEditActionDatasource,
          GhostLockProfileEditActionDatasource
        >
    with $Provider<GhostLockProfileEditActionDatasource> {
  /// GhostLock profile 编辑数据源。
  const GhostLockProfileEditActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ghostLockProfileEditActionDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$ghostLockProfileEditActionDatasourceHash();

  @$internal
  @override
  $ProviderElement<GhostLockProfileEditActionDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GhostLockProfileEditActionDatasource create(Ref ref) {
    return ghostLockProfileEditActionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GhostLockProfileEditActionDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<GhostLockProfileEditActionDatasource>(value),
    );
  }
}

String _$ghostLockProfileEditActionDatasourceHash() =>
    r'58843b4337c980a74cc4c8a450b658b262686605';

/// GhostLock profile 编辑仓储。

@ProviderFor(ghostLockProfileEditActionRepository)
const ghostLockProfileEditActionRepositoryProvider =
    GhostLockProfileEditActionRepositoryProvider._();

/// GhostLock profile 编辑仓储。

final class GhostLockProfileEditActionRepositoryProvider
    extends
        $FunctionalProvider<
          GhostLockProfileEditActionRepository,
          GhostLockProfileEditActionRepository,
          GhostLockProfileEditActionRepository
        >
    with $Provider<GhostLockProfileEditActionRepository> {
  /// GhostLock profile 编辑仓储。
  const GhostLockProfileEditActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ghostLockProfileEditActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$ghostLockProfileEditActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<GhostLockProfileEditActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GhostLockProfileEditActionRepository create(Ref ref) {
    return ghostLockProfileEditActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GhostLockProfileEditActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<GhostLockProfileEditActionRepository>(value),
    );
  }
}

String _$ghostLockProfileEditActionRepositoryHash() =>
    r'e52c967f2b27c072e4a13041ac256ab04459521a';

/// GhostLock profile 导入与编辑的写操作。
///
/// 同 [ghostKeyActions]：无参类，参数走方法入参。

@ProviderFor(ghostLockProfileActions)
const ghostLockProfileActionsProvider = GhostLockProfileActionsProvider._();

/// GhostLock profile 导入与编辑的写操作。
///
/// 同 [ghostKeyActions]：无参类，参数走方法入参。

final class GhostLockProfileActionsProvider
    extends
        $FunctionalProvider<
          GhostLockProfileActions,
          GhostLockProfileActions,
          GhostLockProfileActions
        >
    with $Provider<GhostLockProfileActions> {
  /// GhostLock profile 导入与编辑的写操作。
  ///
  /// 同 [ghostKeyActions]：无参类，参数走方法入参。
  const GhostLockProfileActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ghostLockProfileActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ghostLockProfileActionsHash();

  @$internal
  @override
  $ProviderElement<GhostLockProfileActions> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GhostLockProfileActions create(Ref ref) {
    return ghostLockProfileActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GhostLockProfileActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GhostLockProfileActions>(value),
    );
  }
}

String _$ghostLockProfileActionsHash() =>
    r'e7a0278569bf2af14cbad4aead04ec26a6e53b2f';
