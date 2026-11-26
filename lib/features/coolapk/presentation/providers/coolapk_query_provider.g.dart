// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coolapk_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 酷安查询数据源。

@ProviderFor(coolapkQueryDatasource)
const coolapkQueryDatasourceProvider = CoolapkQueryDatasourceProvider._();

/// 酷安查询数据源。

final class CoolapkQueryDatasourceProvider
    extends
        $FunctionalProvider<
          CoolapkQueryDatasource,
          CoolapkQueryDatasource,
          CoolapkQueryDatasource
        >
    with $Provider<CoolapkQueryDatasource> {
  /// 酷安查询数据源。
  const CoolapkQueryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coolapkQueryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coolapkQueryDatasourceHash();

  @$internal
  @override
  $ProviderElement<CoolapkQueryDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CoolapkQueryDatasource create(Ref ref) {
    return coolapkQueryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoolapkQueryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoolapkQueryDatasource>(value),
    );
  }
}

String _$coolapkQueryDatasourceHash() =>
    r'8faaf2e68323acdad71c361ae2e148a2e67a8546';

/// 酷安查询仓储。

@ProviderFor(coolapkQueryRepository)
const coolapkQueryRepositoryProvider = CoolapkQueryRepositoryProvider._();

/// 酷安查询仓储。

final class CoolapkQueryRepositoryProvider
    extends
        $FunctionalProvider<
          CoolapkQueryRepository,
          CoolapkQueryRepository,
          CoolapkQueryRepository
        >
    with $Provider<CoolapkQueryRepository> {
  /// 酷安查询仓储。
  const CoolapkQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coolapkQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coolapkQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<CoolapkQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CoolapkQueryRepository create(Ref ref) {
    return coolapkQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoolapkQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoolapkQueryRepository>(value),
    );
  }
}

String _$coolapkQueryRepositoryHash() =>
    r'f4145a878d6a85f68d918ee6d7ca0e31890de684';

/// 一次酷安搜索。
///
/// 关键词、维度与页码都是入参，结果不缓存：社区内容实时变动。

@ProviderFor(coolapkSearch)
const coolapkSearchProvider = CoolapkSearchFamily._();

/// 一次酷安搜索。
///
/// 关键词、维度与页码都是入参，结果不缓存：社区内容实时变动。

final class CoolapkSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<CoolapkSearchBatch>,
          CoolapkSearchBatch,
          FutureOr<CoolapkSearchBatch>
        >
    with
        $FutureModifier<CoolapkSearchBatch>,
        $FutureProvider<CoolapkSearchBatch> {
  /// 一次酷安搜索。
  ///
  /// 关键词、维度与页码都是入参，结果不缓存：社区内容实时变动。
  const CoolapkSearchProvider._({
    required CoolapkSearchFamily super.from,
    required ({String query, CoolapkSearchType type, int page}) super.argument,
  }) : super(
         retry: null,
         name: r'coolapkSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$coolapkSearchHash();

  @override
  String toString() {
    return r'coolapkSearchProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<CoolapkSearchBatch> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CoolapkSearchBatch> create(Ref ref) {
    final argument =
        this.argument as ({String query, CoolapkSearchType type, int page});
    return coolapkSearch(
      ref,
      query: argument.query,
      type: argument.type,
      page: argument.page,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CoolapkSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$coolapkSearchHash() => r'6e2e5fd4ba27d56eef869dfe54b3649b900b482c';

/// 一次酷安搜索。
///
/// 关键词、维度与页码都是入参，结果不缓存：社区内容实时变动。

final class CoolapkSearchFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<CoolapkSearchBatch>,
          ({String query, CoolapkSearchType type, int page})
        > {
  const CoolapkSearchFamily._()
    : super(
        retry: null,
        name: r'coolapkSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 一次酷安搜索。
  ///
  /// 关键词、维度与页码都是入参，结果不缓存：社区内容实时变动。

  CoolapkSearchProvider call({
    required String query,
    CoolapkSearchType type = CoolapkSearchType.feed,
    int page = 1,
  }) => CoolapkSearchProvider._(
    argument: (query: query, type: type, page: page),
    from: this,
  );

  @override
  String toString() => r'coolapkSearchProvider';
}
