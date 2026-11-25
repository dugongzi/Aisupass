// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payload_import_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 自定义载荷只读数据源。

@ProviderFor(payloadImportQueryDatasource)
const payloadImportQueryDatasourceProvider =
    PayloadImportQueryDatasourceProvider._();

/// 自定义载荷只读数据源。

final class PayloadImportQueryDatasourceProvider
    extends
        $FunctionalProvider<
          PayloadImportQueryDatasource,
          PayloadImportQueryDatasource,
          PayloadImportQueryDatasource
        >
    with $Provider<PayloadImportQueryDatasource> {
  /// 自定义载荷只读数据源。
  const PayloadImportQueryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'payloadImportQueryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$payloadImportQueryDatasourceHash();

  @$internal
  @override
  $ProviderElement<PayloadImportQueryDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PayloadImportQueryDatasource create(Ref ref) {
    return payloadImportQueryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PayloadImportQueryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PayloadImportQueryDatasource>(value),
    );
  }
}

String _$payloadImportQueryDatasourceHash() =>
    r'3b9ce2298aaa91e3fdb32f2dad2c68afd8e8cfad';

/// 自定义载荷查询仓储。

@ProviderFor(payloadImportQueryRepository)
const payloadImportQueryRepositoryProvider =
    PayloadImportQueryRepositoryProvider._();

/// 自定义载荷查询仓储。

final class PayloadImportQueryRepositoryProvider
    extends
        $FunctionalProvider<
          PayloadImportQueryRepository,
          PayloadImportQueryRepository,
          PayloadImportQueryRepository
        >
    with $Provider<PayloadImportQueryRepository> {
  /// 自定义载荷查询仓储。
  const PayloadImportQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'payloadImportQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$payloadImportQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<PayloadImportQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PayloadImportQueryRepository create(Ref ref) {
    return payloadImportQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PayloadImportQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PayloadImportQueryRepository>(value),
    );
  }
}

String _$payloadImportQueryRepositoryHash() =>
    r'985320ca0e650724921583bc9431e99489f8fe93';

/// 已导入的自定义载荷列表。

@ProviderFor(importedPayloads)
const importedPayloadsProvider = ImportedPayloadsProvider._();

/// 已导入的自定义载荷列表。

final class ImportedPayloadsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ImportedPayload>>,
          List<ImportedPayload>,
          FutureOr<List<ImportedPayload>>
        >
    with
        $FutureModifier<List<ImportedPayload>>,
        $FutureProvider<List<ImportedPayload>> {
  /// 已导入的自定义载荷列表。
  const ImportedPayloadsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'importedPayloadsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$importedPayloadsHash();

  @$internal
  @override
  $FutureProviderElement<List<ImportedPayload>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ImportedPayload>> create(Ref ref) {
    return importedPayloads(ref);
  }
}

String _$importedPayloadsHash() => r'8ef835337cbae63268d1fb5453b5821ffaa7f41e';
