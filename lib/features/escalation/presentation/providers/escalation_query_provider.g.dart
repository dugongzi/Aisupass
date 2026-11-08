// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'escalation_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 提权链路只读数据源。

@ProviderFor(escalationQueryDatasource)
const escalationQueryDatasourceProvider = EscalationQueryDatasourceProvider._();

/// 提权链路只读数据源。

final class EscalationQueryDatasourceProvider
    extends
        $FunctionalProvider<
          EscalationQueryDatasource,
          EscalationQueryDatasource,
          EscalationQueryDatasource
        >
    with $Provider<EscalationQueryDatasource> {
  /// 提权链路只读数据源。
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
    r'666227f16308ac174e645eaf942f40e9816ef190';

/// 提权链路只读仓储。

@ProviderFor(escalationQueryRepository)
const escalationQueryRepositoryProvider = EscalationQueryRepositoryProvider._();

/// 提权链路只读仓储。

final class EscalationQueryRepositoryProvider
    extends
        $FunctionalProvider<
          EscalationQueryRepository,
          EscalationQueryRepository,
          EscalationQueryRepository
        >
    with $Provider<EscalationQueryRepository> {
  /// 提权链路只读仓储。
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
    r'f39df6252fadb64e951d0101c048532165c80d20';

/// 全部载荷条目。

@ProviderFor(payloads)
const payloadsProvider = PayloadsProvider._();

/// 全部载荷条目。

final class PayloadsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Payload>>,
          List<Payload>,
          FutureOr<List<Payload>>
        >
    with $FutureModifier<List<Payload>>, $FutureProvider<List<Payload>> {
  /// 全部载荷条目。
  const PayloadsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'payloadsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$payloadsHash();

  @$internal
  @override
  $FutureProviderElement<List<Payload>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Payload>> create(Ref ref) {
    return payloads(ref);
  }
}

String _$payloadsHash() => r'65474f533991bbb0e484ad042782b2667fbdffb1';

/// 当前设备身份。

@ProviderFor(currentDeviceIdentity)
const currentDeviceIdentityProvider = CurrentDeviceIdentityProvider._();

/// 当前设备身份。

final class CurrentDeviceIdentityProvider
    extends
        $FunctionalProvider<
          AsyncValue<DeviceIdentity>,
          DeviceIdentity,
          FutureOr<DeviceIdentity>
        >
    with $FutureModifier<DeviceIdentity>, $FutureProvider<DeviceIdentity> {
  /// 当前设备身份。
  const CurrentDeviceIdentityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentDeviceIdentityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentDeviceIdentityHash();

  @$internal
  @override
  $FutureProviderElement<DeviceIdentity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DeviceIdentity> create(Ref ref) {
    return currentDeviceIdentity(ref);
  }
}

String _$currentDeviceIdentityHash() =>
    r'466dcecb5e1b11e47df2c078781a127de9573c7b';

/// 用户上次选定的 root 管理器。
///
/// 只读；写入走执行侧同名动作。

@ProviderFor(selectedRootManager)
const selectedRootManagerProvider = SelectedRootManagerProvider._();

/// 用户上次选定的 root 管理器。
///
/// 只读；写入走执行侧同名动作。

final class SelectedRootManagerProvider
    extends
        $FunctionalProvider<
          AsyncValue<RootManager>,
          RootManager,
          FutureOr<RootManager>
        >
    with $FutureModifier<RootManager>, $FutureProvider<RootManager> {
  /// 用户上次选定的 root 管理器。
  ///
  /// 只读；写入走执行侧同名动作。
  const SelectedRootManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedRootManagerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedRootManagerHash();

  @$internal
  @override
  $FutureProviderElement<RootManager> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RootManager> create(Ref ref) {
    return selectedRootManager(ref);
  }
}

String _$selectedRootManagerHash() =>
    r'fe4bea92a06f32efce7ea27b7b65f43b94ca3558';
