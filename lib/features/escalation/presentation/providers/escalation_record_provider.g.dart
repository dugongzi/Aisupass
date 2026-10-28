// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'escalation_record_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 运行记录数据源。

@ProviderFor(escalationRecordDatasource)
const escalationRecordDatasourceProvider =
    EscalationRecordDatasourceProvider._();

/// 运行记录数据源。

final class EscalationRecordDatasourceProvider
    extends
        $FunctionalProvider<
          EscalationRecordDatasource,
          EscalationRecordDatasource,
          EscalationRecordDatasource
        >
    with $Provider<EscalationRecordDatasource> {
  /// 运行记录数据源。
  const EscalationRecordDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'escalationRecordDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$escalationRecordDatasourceHash();

  @$internal
  @override
  $ProviderElement<EscalationRecordDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EscalationRecordDatasource create(Ref ref) {
    return escalationRecordDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EscalationRecordDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EscalationRecordDatasource>(value),
    );
  }
}

String _$escalationRecordDatasourceHash() =>
    r'07572cb6d9a95add389a2a585223d938b88a9edc';

/// 运行记录仓储。

@ProviderFor(escalationRecordRepository)
const escalationRecordRepositoryProvider =
    EscalationRecordRepositoryProvider._();

/// 运行记录仓储。

final class EscalationRecordRepositoryProvider
    extends
        $FunctionalProvider<
          EscalationRecordRepository,
          EscalationRecordRepository,
          EscalationRecordRepository
        >
    with $Provider<EscalationRecordRepository> {
  /// 运行记录仓储。
  const EscalationRecordRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'escalationRecordRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$escalationRecordRepositoryHash();

  @$internal
  @override
  $ProviderElement<EscalationRecordRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EscalationRecordRepository create(Ref ref) {
    return escalationRecordRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EscalationRecordRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EscalationRecordRepository>(value),
    );
  }
}

String _$escalationRecordRepositoryHash() =>
    r'cfc17990e0292bc2db2fb68246e824a351c1a091';

/// 历史运行记录，按开始时间倒序。
///
/// 只读；每次运行结束后由 `EscalationRunController` 主动失效。

@ProviderFor(escalationRecords)
const escalationRecordsProvider = EscalationRecordsProvider._();

/// 历史运行记录，按开始时间倒序。
///
/// 只读；每次运行结束后由 `EscalationRunController` 主动失效。

final class EscalationRecordsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<EscalationRunRecord>>,
          List<EscalationRunRecord>,
          FutureOr<List<EscalationRunRecord>>
        >
    with
        $FutureModifier<List<EscalationRunRecord>>,
        $FutureProvider<List<EscalationRunRecord>> {
  /// 历史运行记录，按开始时间倒序。
  ///
  /// 只读；每次运行结束后由 `EscalationRunController` 主动失效。
  const EscalationRecordsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'escalationRecordsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$escalationRecordsHash();

  @$internal
  @override
  $FutureProviderElement<List<EscalationRunRecord>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<EscalationRunRecord>> create(Ref ref) {
    return escalationRecords(ref);
  }
}

String _$escalationRecordsHash() => r'61c1c076343b8f9344122b20bb86bc3932e9f076';

/// 是否存在遗留状态，供页面横幅与快捷面板红点共用。

@ProviderFor(escalationResidual)
const escalationResidualProvider = EscalationResidualProvider._();

/// 是否存在遗留状态，供页面横幅与快捷面板红点共用。

final class EscalationResidualProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// 是否存在遗留状态，供页面横幅与快捷面板红点共用。
  const EscalationResidualProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'escalationResidualProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$escalationResidualHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return escalationResidual(ref);
  }
}

String _$escalationResidualHash() =>
    r'a08fd0086fd85d3370754ab3b1af8eeac87b8303';
