// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_config_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// AI 配置的只读数据源。

@ProviderFor(aiConfigQueryDatasource)
const aiConfigQueryDatasourceProvider = AiConfigQueryDatasourceProvider._();

/// AI 配置的只读数据源。

final class AiConfigQueryDatasourceProvider
    extends
        $FunctionalProvider<
          AiConfigQueryDatasource,
          AiConfigQueryDatasource,
          AiConfigQueryDatasource
        >
    with $Provider<AiConfigQueryDatasource> {
  /// AI 配置的只读数据源。
  const AiConfigQueryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiConfigQueryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiConfigQueryDatasourceHash();

  @$internal
  @override
  $ProviderElement<AiConfigQueryDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiConfigQueryDatasource create(Ref ref) {
    return aiConfigQueryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiConfigQueryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiConfigQueryDatasource>(value),
    );
  }
}

String _$aiConfigQueryDatasourceHash() =>
    r'ac7b2e1f3cad610932df42aa90489e3aeb7e4f31';

/// AI 配置的查询仓储。

@ProviderFor(aiConfigQueryRepository)
const aiConfigQueryRepositoryProvider = AiConfigQueryRepositoryProvider._();

/// AI 配置的查询仓储。

final class AiConfigQueryRepositoryProvider
    extends
        $FunctionalProvider<
          AiConfigQueryRepository,
          AiConfigQueryRepository,
          AiConfigQueryRepository
        >
    with $Provider<AiConfigQueryRepository> {
  /// AI 配置的查询仓储。
  const AiConfigQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiConfigQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiConfigQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<AiConfigQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiConfigQueryRepository create(Ref ref) {
    return aiConfigQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiConfigQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiConfigQueryRepository>(value),
    );
  }
}

String _$aiConfigQueryRepositoryHash() =>
    r'5dd42b05dc832632471c7bac2831ca6d950b102a';

/// 读取全部 AI 配置及当前启用项。
///
/// 只读，写操作统一走 `aiConfigActionsProvider`，写完后由写侧失效本 Provider。

@ProviderFor(aiConfig)
const aiConfigProvider = AiConfigProvider._();

/// 读取全部 AI 配置及当前启用项。
///
/// 只读，写操作统一走 `aiConfigActionsProvider`，写完后由写侧失效本 Provider。

final class AiConfigProvider
    extends
        $FunctionalProvider<
          AsyncValue<AiConfigState>,
          AiConfigState,
          FutureOr<AiConfigState>
        >
    with $FutureModifier<AiConfigState>, $FutureProvider<AiConfigState> {
  /// 读取全部 AI 配置及当前启用项。
  ///
  /// 只读，写操作统一走 `aiConfigActionsProvider`，写完后由写侧失效本 Provider。
  const AiConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiConfigProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiConfigHash();

  @$internal
  @override
  $FutureProviderElement<AiConfigState> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AiConfigState> create(Ref ref) {
    return aiConfig(ref);
  }
}

String _$aiConfigHash() => r'919a393e3591ee631c14f2326577ff59906648c4';
