// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'escalation_catalog_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 资产目录数据源。

@ProviderFor(escalationCatalogDatasource)
const escalationCatalogDatasourceProvider =
    EscalationCatalogDatasourceProvider._();

/// 资产目录数据源。

final class EscalationCatalogDatasourceProvider
    extends
        $FunctionalProvider<
          EscalationCatalogDatasource,
          EscalationCatalogDatasource,
          EscalationCatalogDatasource
        >
    with $Provider<EscalationCatalogDatasource> {
  /// 资产目录数据源。
  const EscalationCatalogDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'escalationCatalogDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$escalationCatalogDatasourceHash();

  @$internal
  @override
  $ProviderElement<EscalationCatalogDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EscalationCatalogDatasource create(Ref ref) {
    return escalationCatalogDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EscalationCatalogDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EscalationCatalogDatasource>(value),
    );
  }
}

String _$escalationCatalogDatasourceHash() =>
    r'a5c1cdf5fe09cf1ac55aa5d5bc1fa65e58401303';

/// 资产目录仓储。

@ProviderFor(escalationCatalogRepository)
const escalationCatalogRepositoryProvider =
    EscalationCatalogRepositoryProvider._();

/// 资产目录仓储。

final class EscalationCatalogRepositoryProvider
    extends
        $FunctionalProvider<
          EscalationCatalogRepository,
          EscalationCatalogRepository,
          EscalationCatalogRepository
        >
    with $Provider<EscalationCatalogRepository> {
  /// 资产目录仓储。
  const EscalationCatalogRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'escalationCatalogRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$escalationCatalogRepositoryHash();

  @$internal
  @override
  $ProviderElement<EscalationCatalogRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EscalationCatalogRepository create(Ref ref) {
    return escalationCatalogRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EscalationCatalogRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EscalationCatalogRepository>(value),
    );
  }
}

String _$escalationCatalogRepositoryHash() =>
    r'5abb9d68edde7e42e969dd4ca59d167fa1947877';

/// 读取资产目录，资产缺失时返回空目录而非报错。

@ProviderFor(escalationCatalog)
const escalationCatalogProvider = EscalationCatalogProvider._();

/// 读取资产目录，资产缺失时返回空目录而非报错。

final class EscalationCatalogProvider
    extends
        $FunctionalProvider<
          AsyncValue<EscalationCatalog>,
          EscalationCatalog,
          FutureOr<EscalationCatalog>
        >
    with
        $FutureModifier<EscalationCatalog>,
        $FutureProvider<EscalationCatalog> {
  /// 读取资产目录，资产缺失时返回空目录而非报错。
  const EscalationCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'escalationCatalogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$escalationCatalogHash();

  @$internal
  @override
  $FutureProviderElement<EscalationCatalog> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<EscalationCatalog> create(Ref ref) {
    return escalationCatalog(ref);
  }
}

String _$escalationCatalogHash() => r'c0e2c1dff7540a4ffb1ddd2c557584f05688ab7d';
