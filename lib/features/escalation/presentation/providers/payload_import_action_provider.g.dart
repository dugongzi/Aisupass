// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payload_import_action_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 自定义载荷写数据源。

@ProviderFor(payloadImportActionDatasource)
const payloadImportActionDatasourceProvider =
    PayloadImportActionDatasourceProvider._();

/// 自定义载荷写数据源。

final class PayloadImportActionDatasourceProvider
    extends
        $FunctionalProvider<
          PayloadImportActionDatasource,
          PayloadImportActionDatasource,
          PayloadImportActionDatasource
        >
    with $Provider<PayloadImportActionDatasource> {
  /// 自定义载荷写数据源。
  const PayloadImportActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'payloadImportActionDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$payloadImportActionDatasourceHash();

  @$internal
  @override
  $ProviderElement<PayloadImportActionDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PayloadImportActionDatasource create(Ref ref) {
    return payloadImportActionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PayloadImportActionDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PayloadImportActionDatasource>(
        value,
      ),
    );
  }
}

String _$payloadImportActionDatasourceHash() =>
    r'6a768fdae03e0228132b0fcfde7717704e704ef8';

/// 自定义载荷动作仓储。

@ProviderFor(payloadImportActionRepository)
const payloadImportActionRepositoryProvider =
    PayloadImportActionRepositoryProvider._();

/// 自定义载荷动作仓储。

final class PayloadImportActionRepositoryProvider
    extends
        $FunctionalProvider<
          PayloadImportActionRepository,
          PayloadImportActionRepository,
          PayloadImportActionRepository
        >
    with $Provider<PayloadImportActionRepository> {
  /// 自定义载荷动作仓储。
  const PayloadImportActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'payloadImportActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$payloadImportActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<PayloadImportActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PayloadImportActionRepository create(Ref ref) {
    return payloadImportActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PayloadImportActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PayloadImportActionRepository>(
        value,
      ),
    );
  }
}

String _$payloadImportActionRepositoryHash() =>
    r'fc2a37790a12d11c44a5423fc0d63469f5fba2ce';

/// 自定义载荷的写操作。
///
/// 同 [rootManagerActions]：无参类持有 [Ref]，参数走方法入参。

@ProviderFor(payloadImportActions)
const payloadImportActionsProvider = PayloadImportActionsProvider._();

/// 自定义载荷的写操作。
///
/// 同 [rootManagerActions]：无参类持有 [Ref]，参数走方法入参。

final class PayloadImportActionsProvider
    extends
        $FunctionalProvider<
          PayloadImportActions,
          PayloadImportActions,
          PayloadImportActions
        >
    with $Provider<PayloadImportActions> {
  /// 自定义载荷的写操作。
  ///
  /// 同 [rootManagerActions]：无参类持有 [Ref]，参数走方法入参。
  const PayloadImportActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'payloadImportActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$payloadImportActionsHash();

  @$internal
  @override
  $ProviderElement<PayloadImportActions> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PayloadImportActions create(Ref ref) {
    return payloadImportActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PayloadImportActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PayloadImportActions>(value),
    );
  }
}

String _$payloadImportActionsHash() =>
    r'3e4300edd80aa8ffd56f9273a7b5b8a901f68d27';
