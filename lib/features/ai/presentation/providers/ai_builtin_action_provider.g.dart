// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_builtin_action_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 内置面板的写入数据源。

@ProviderFor(aiBuiltinActionDatasource)
const aiBuiltinActionDatasourceProvider = AiBuiltinActionDatasourceProvider._();

/// 内置面板的写入数据源。

final class AiBuiltinActionDatasourceProvider
    extends
        $FunctionalProvider<
          AiBuiltinActionDatasource,
          AiBuiltinActionDatasource,
          AiBuiltinActionDatasource
        >
    with $Provider<AiBuiltinActionDatasource> {
  /// 内置面板的写入数据源。
  const AiBuiltinActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiBuiltinActionDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiBuiltinActionDatasourceHash();

  @$internal
  @override
  $ProviderElement<AiBuiltinActionDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiBuiltinActionDatasource create(Ref ref) {
    return aiBuiltinActionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiBuiltinActionDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiBuiltinActionDatasource>(value),
    );
  }
}

String _$aiBuiltinActionDatasourceHash() =>
    r'117c15fcdd09cb623b94c3505f778cb4039b8fd8';

/// 内置面板的写入仓储。

@ProviderFor(aiBuiltinActionRepository)
const aiBuiltinActionRepositoryProvider = AiBuiltinActionRepositoryProvider._();

/// 内置面板的写入仓储。

final class AiBuiltinActionRepositoryProvider
    extends
        $FunctionalProvider<
          AiBuiltinActionRepository,
          AiBuiltinActionRepository,
          AiBuiltinActionRepository
        >
    with $Provider<AiBuiltinActionRepository> {
  /// 内置面板的写入仓储。
  const AiBuiltinActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiBuiltinActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiBuiltinActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<AiBuiltinActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiBuiltinActionRepository create(Ref ref) {
    return aiBuiltinActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiBuiltinActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiBuiltinActionRepository>(value),
    );
  }
}

String _$aiBuiltinActionRepositoryHash() =>
    r'fad7612d3eb888a907190f4f15a76b9c6666ef0d';

/// 内置面板写操作入口的 Provider。
///
/// 用 `keepAlive` 保住 [Ref]，避免 `ref.read` 后立即销毁导致异步落盘失效。

@ProviderFor(aiBuiltinActions)
const aiBuiltinActionsProvider = AiBuiltinActionsProvider._();

/// 内置面板写操作入口的 Provider。
///
/// 用 `keepAlive` 保住 [Ref]，避免 `ref.read` 后立即销毁导致异步落盘失效。

final class AiBuiltinActionsProvider
    extends
        $FunctionalProvider<
          AiBuiltinActions,
          AiBuiltinActions,
          AiBuiltinActions
        >
    with $Provider<AiBuiltinActions> {
  /// 内置面板写操作入口的 Provider。
  ///
  /// 用 `keepAlive` 保住 [Ref]，避免 `ref.read` 后立即销毁导致异步落盘失效。
  const AiBuiltinActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiBuiltinActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiBuiltinActionsHash();

  @$internal
  @override
  $ProviderElement<AiBuiltinActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AiBuiltinActions create(Ref ref) {
    return aiBuiltinActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiBuiltinActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiBuiltinActions>(value),
    );
  }
}

String _$aiBuiltinActionsHash() => r'a8dba7c7ec0885187bba4cbba98f6c50d883924b';
