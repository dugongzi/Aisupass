// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_model_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 模型目录的只读数据源。

@ProviderFor(aiModelQueryDatasource)
const aiModelQueryDatasourceProvider = AiModelQueryDatasourceProvider._();

/// 模型目录的只读数据源。

final class AiModelQueryDatasourceProvider
    extends
        $FunctionalProvider<
          AiModelQueryDatasource,
          AiModelQueryDatasource,
          AiModelQueryDatasource
        >
    with $Provider<AiModelQueryDatasource> {
  /// 模型目录的只读数据源。
  const AiModelQueryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiModelQueryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiModelQueryDatasourceHash();

  @$internal
  @override
  $ProviderElement<AiModelQueryDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiModelQueryDatasource create(Ref ref) {
    return aiModelQueryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiModelQueryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiModelQueryDatasource>(value),
    );
  }
}

String _$aiModelQueryDatasourceHash() =>
    r'ea9b1c4f3f030ff38d8febeb5f11f62b4b675264';

/// 模型目录的查询仓储。

@ProviderFor(aiModelQueryRepository)
const aiModelQueryRepositoryProvider = AiModelQueryRepositoryProvider._();

/// 模型目录的查询仓储。

final class AiModelQueryRepositoryProvider
    extends
        $FunctionalProvider<
          AiModelQueryRepository,
          AiModelQueryRepository,
          AiModelQueryRepository
        >
    with $Provider<AiModelQueryRepository> {
  /// 模型目录的查询仓储。
  const AiModelQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiModelQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiModelQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<AiModelQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiModelQueryRepository create(Ref ref) {
    return aiModelQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiModelQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiModelQueryRepository>(value),
    );
  }
}

String _$aiModelQueryRepositoryHash() =>
    r'cee2c73b8152d1acf4ba587b2178e1ab0bd6b5f2';
