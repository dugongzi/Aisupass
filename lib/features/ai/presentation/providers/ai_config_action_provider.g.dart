// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_config_action_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// AI 配置的写入数据源。

@ProviderFor(aiConfigActionDatasource)
const aiConfigActionDatasourceProvider = AiConfigActionDatasourceProvider._();

/// AI 配置的写入数据源。

final class AiConfigActionDatasourceProvider
    extends
        $FunctionalProvider<
          AiConfigActionDatasource,
          AiConfigActionDatasource,
          AiConfigActionDatasource
        >
    with $Provider<AiConfigActionDatasource> {
  /// AI 配置的写入数据源。
  const AiConfigActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiConfigActionDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiConfigActionDatasourceHash();

  @$internal
  @override
  $ProviderElement<AiConfigActionDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiConfigActionDatasource create(Ref ref) {
    return aiConfigActionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiConfigActionDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiConfigActionDatasource>(value),
    );
  }
}

String _$aiConfigActionDatasourceHash() =>
    r'82259e0bffd6fa83610170ea2f25bfcf29f358b6';

/// AI 配置的写入仓储。

@ProviderFor(aiConfigActionRepository)
const aiConfigActionRepositoryProvider = AiConfigActionRepositoryProvider._();

/// AI 配置的写入仓储。

final class AiConfigActionRepositoryProvider
    extends
        $FunctionalProvider<
          AiConfigActionRepository,
          AiConfigActionRepository,
          AiConfigActionRepository
        >
    with $Provider<AiConfigActionRepository> {
  /// AI 配置的写入仓储。
  const AiConfigActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiConfigActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiConfigActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<AiConfigActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiConfigActionRepository create(Ref ref) {
    return aiConfigActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiConfigActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiConfigActionRepository>(value),
    );
  }
}

String _$aiConfigActionRepositoryHash() =>
    r'e9af4ad8949bb3528bd24f45f2177ffc5ba86044';

/// 配置写操作入口的 Provider。
///
/// 用 `keepAlive` 保住 [Ref]，避免 `ref.read` 后立即销毁导致异步落盘时失效。

@ProviderFor(aiConfigActions)
const aiConfigActionsProvider = AiConfigActionsProvider._();

/// 配置写操作入口的 Provider。
///
/// 用 `keepAlive` 保住 [Ref]，避免 `ref.read` 后立即销毁导致异步落盘时失效。

final class AiConfigActionsProvider
    extends
        $FunctionalProvider<AiConfigActions, AiConfigActions, AiConfigActions>
    with $Provider<AiConfigActions> {
  /// 配置写操作入口的 Provider。
  ///
  /// 用 `keepAlive` 保住 [Ref]，避免 `ref.read` 后立即销毁导致异步落盘时失效。
  const AiConfigActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiConfigActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiConfigActionsHash();

  @$internal
  @override
  $ProviderElement<AiConfigActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AiConfigActions create(Ref ref) {
    return aiConfigActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiConfigActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiConfigActions>(value),
    );
  }
}

String _$aiConfigActionsHash() => r'e9d6febfc2e04385788aa5a12a7e7750cb447cf5';
