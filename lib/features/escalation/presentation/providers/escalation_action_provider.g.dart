// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'escalation_action_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 提权动作数据源。
///
/// 轮询器挂在数据源内部，必须活到运行结束，因此用 `keepAlive`，
/// 由容器销毁时统一释放计时器，避免运行中途被回收导致收不到结束帧。

@ProviderFor(escalationActionDatasource)
const escalationActionDatasourceProvider =
    EscalationActionDatasourceProvider._();

/// 提权动作数据源。
///
/// 轮询器挂在数据源内部，必须活到运行结束，因此用 `keepAlive`，
/// 由容器销毁时统一释放计时器，避免运行中途被回收导致收不到结束帧。

final class EscalationActionDatasourceProvider
    extends
        $FunctionalProvider<
          EscalationActionDatasource,
          EscalationActionDatasource,
          EscalationActionDatasource
        >
    with $Provider<EscalationActionDatasource> {
  /// 提权动作数据源。
  ///
  /// 轮询器挂在数据源内部，必须活到运行结束，因此用 `keepAlive`，
  /// 由容器销毁时统一释放计时器，避免运行中途被回收导致收不到结束帧。
  const EscalationActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'escalationActionDatasourceProvider',
        isAutoDispose: false,
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
    r'995c98a5ade3fe6176b568e5514d7cb75d14d1eb';

/// 提权动作仓储。

@ProviderFor(escalationActionRepository)
const escalationActionRepositoryProvider =
    EscalationActionRepositoryProvider._();

/// 提权动作仓储。

final class EscalationActionRepositoryProvider
    extends
        $FunctionalProvider<
          EscalationActionRepository,
          EscalationActionRepository,
          EscalationActionRepository
        >
    with $Provider<EscalationActionRepository> {
  /// 提权动作仓储。
  const EscalationActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'escalationActionRepositoryProvider',
        isAutoDispose: false,
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
    r'935b59c3f2c9831df7f9e6069f80015abec22199';

/// 提权运行控制器：页面唯一的写入口。
///
/// 单 running 锁由 [start] 内部保证；结束时主动失效记录与遗留状态，
/// 让页面横幅与快捷面板红点立即反映最新结果。

@ProviderFor(EscalationRunController)
const escalationRunControllerProvider = EscalationRunControllerProvider._();

/// 提权运行控制器：页面唯一的写入口。
///
/// 单 running 锁由 [start] 内部保证；结束时主动失效记录与遗留状态，
/// 让页面横幅与快捷面板红点立即反映最新结果。
final class EscalationRunControllerProvider
    extends $NotifierProvider<EscalationRunController, EscalationRunState> {
  /// 提权运行控制器：页面唯一的写入口。
  ///
  /// 单 running 锁由 [start] 内部保证；结束时主动失效记录与遗留状态，
  /// 让页面横幅与快捷面板红点立即反映最新结果。
  const EscalationRunControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'escalationRunControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$escalationRunControllerHash();

  @$internal
  @override
  EscalationRunController create() => EscalationRunController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EscalationRunState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EscalationRunState>(value),
    );
  }
}

String _$escalationRunControllerHash() =>
    r'02c91416cc6d8f5023fe5edeb46c4688c8fba1b1';

/// 提权运行控制器：页面唯一的写入口。
///
/// 单 running 锁由 [start] 内部保证；结束时主动失效记录与遗留状态，
/// 让页面横幅与快捷面板红点立即反映最新结果。

abstract class _$EscalationRunController extends $Notifier<EscalationRunState> {
  EscalationRunState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<EscalationRunState, EscalationRunState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EscalationRunState, EscalationRunState>,
              EscalationRunState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
