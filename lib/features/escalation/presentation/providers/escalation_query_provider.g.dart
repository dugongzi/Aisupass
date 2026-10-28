// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'escalation_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 原生提权客户端。
///
/// 全工程只从这里取实例，保证宿主通道只有一份；Client 内部仅持有通道，
/// 重建开销可以忽略，因此不需要 `keepAlive`。

@ProviderFor(escalationNative)
const escalationNativeProvider = EscalationNativeProvider._();

/// 原生提权客户端。
///
/// 全工程只从这里取实例，保证宿主通道只有一份；Client 内部仅持有通道，
/// 重建开销可以忽略，因此不需要 `keepAlive`。

final class EscalationNativeProvider
    extends
        $FunctionalProvider<
          pigeon.EscalationNative,
          pigeon.EscalationNative,
          pigeon.EscalationNative
        >
    with $Provider<pigeon.EscalationNative> {
  /// 原生提权客户端。
  ///
  /// 全工程只从这里取实例，保证宿主通道只有一份；Client 内部仅持有通道，
  /// 重建开销可以忽略，因此不需要 `keepAlive`。
  const EscalationNativeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'escalationNativeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$escalationNativeHash();

  @$internal
  @override
  $ProviderElement<pigeon.EscalationNative> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  pigeon.EscalationNative create(Ref ref) {
    return escalationNative(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(pigeon.EscalationNative value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<pigeon.EscalationNative>(value),
    );
  }
}

String _$escalationNativeHash() => r'e55a7307ff7fff4664e87e2c4692a3c620dd2ed0';

/// 提权只读数据源。

@ProviderFor(escalationQueryDatasource)
const escalationQueryDatasourceProvider = EscalationQueryDatasourceProvider._();

/// 提权只读数据源。

final class EscalationQueryDatasourceProvider
    extends
        $FunctionalProvider<
          EscalationQueryDatasource,
          EscalationQueryDatasource,
          EscalationQueryDatasource
        >
    with $Provider<EscalationQueryDatasource> {
  /// 提权只读数据源。
  const EscalationQueryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'escalationQueryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$escalationQueryDatasourceHash();

  @$internal
  @override
  $ProviderElement<EscalationQueryDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EscalationQueryDatasource create(Ref ref) {
    return escalationQueryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EscalationQueryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EscalationQueryDatasource>(value),
    );
  }
}

String _$escalationQueryDatasourceHash() =>
    r'06c00e0cad1b270e226d677f5fc2c6e689c60a46';

/// 提权只读仓储。

@ProviderFor(escalationQueryRepository)
const escalationQueryRepositoryProvider = EscalationQueryRepositoryProvider._();

/// 提权只读仓储。

final class EscalationQueryRepositoryProvider
    extends
        $FunctionalProvider<
          EscalationQueryRepository,
          EscalationQueryRepository,
          EscalationQueryRepository
        >
    with $Provider<EscalationQueryRepository> {
  /// 提权只读仓储。
  const EscalationQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'escalationQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$escalationQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<EscalationQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EscalationQueryRepository create(Ref ref) {
    return escalationQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EscalationQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EscalationQueryRepository>(value),
    );
  }
}

String _$escalationQueryRepositoryHash() =>
    r'd9bdd67da751a68a80af91e3c975780fe8102123';

/// 能力矩阵：进页面自动触发，**零副作用**。
///
/// 只调用原生 `probeAll`，不产生任何系统改动；页面每次进入重新探测，
/// 保证展示的是当前设备状态而不是上次缓存的结论。

@ProviderFor(escalationCapabilityMatrix)
const escalationCapabilityMatrixProvider =
    EscalationCapabilityMatrixProvider._();

/// 能力矩阵：进页面自动触发，**零副作用**。
///
/// 只调用原生 `probeAll`，不产生任何系统改动；页面每次进入重新探测，
/// 保证展示的是当前设备状态而不是上次缓存的结论。

final class EscalationCapabilityMatrixProvider
    extends
        $FunctionalProvider<
          AsyncValue<EscalationCapabilityMatrix>,
          EscalationCapabilityMatrix,
          FutureOr<EscalationCapabilityMatrix>
        >
    with
        $FutureModifier<EscalationCapabilityMatrix>,
        $FutureProvider<EscalationCapabilityMatrix> {
  /// 能力矩阵：进页面自动触发，**零副作用**。
  ///
  /// 只调用原生 `probeAll`，不产生任何系统改动；页面每次进入重新探测，
  /// 保证展示的是当前设备状态而不是上次缓存的结论。
  const EscalationCapabilityMatrixProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'escalationCapabilityMatrixProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$escalationCapabilityMatrixHash();

  @$internal
  @override
  $FutureProviderElement<EscalationCapabilityMatrix> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<EscalationCapabilityMatrix> create(Ref ref) {
    return escalationCapabilityMatrix(ref);
  }
}

String _$escalationCapabilityMatrixHash() =>
    r'bccf24ab429ecaa59c61568e1bceaae6d563de32';

/// 宿主连接状态：只读查询，**零副作用**。
///
/// M0 原生实现固定返回 `alive = false`，页面据此展示连接提示；
/// 通道未就绪或查询失败时同样降级为「未连接」，不向上抛异常。

@ProviderFor(escalationHostStatus)
const escalationHostStatusProvider = EscalationHostStatusProvider._();

/// 宿主连接状态：只读查询，**零副作用**。
///
/// M0 原生实现固定返回 `alive = false`，页面据此展示连接提示；
/// 通道未就绪或查询失败时同样降级为「未连接」，不向上抛异常。

final class EscalationHostStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<pigeon.HostStatus>,
          pigeon.HostStatus,
          FutureOr<pigeon.HostStatus>
        >
    with
        $FutureModifier<pigeon.HostStatus>,
        $FutureProvider<pigeon.HostStatus> {
  /// 宿主连接状态：只读查询，**零副作用**。
  ///
  /// M0 原生实现固定返回 `alive = false`，页面据此展示连接提示；
  /// 通道未就绪或查询失败时同样降级为「未连接」，不向上抛异常。
  const EscalationHostStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'escalationHostStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$escalationHostStatusHash();

  @$internal
  @override
  $FutureProviderElement<pigeon.HostStatus> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<pigeon.HostStatus> create(Ref ref) {
    return escalationHostStatus(ref);
  }
}

String _$escalationHostStatusHash() =>
    r'ba7930eb96113231d0b274027c64785fb129e539';
