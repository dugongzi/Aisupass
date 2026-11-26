// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coolapk_auth_action_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 酷安登录态的写入数据源。

@ProviderFor(coolapkAuthActionDatasource)
const coolapkAuthActionDatasourceProvider =
    CoolapkAuthActionDatasourceProvider._();

/// 酷安登录态的写入数据源。

final class CoolapkAuthActionDatasourceProvider
    extends
        $FunctionalProvider<
          CoolapkAuthActionDatasource,
          CoolapkAuthActionDatasource,
          CoolapkAuthActionDatasource
        >
    with $Provider<CoolapkAuthActionDatasource> {
  /// 酷安登录态的写入数据源。
  const CoolapkAuthActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coolapkAuthActionDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coolapkAuthActionDatasourceHash();

  @$internal
  @override
  $ProviderElement<CoolapkAuthActionDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CoolapkAuthActionDatasource create(Ref ref) {
    return coolapkAuthActionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoolapkAuthActionDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoolapkAuthActionDatasource>(value),
    );
  }
}

String _$coolapkAuthActionDatasourceHash() =>
    r'f91f065fa5900ff7dd976b7f062cba7348036b94';

/// 酷安登录态写入仓储。

@ProviderFor(coolapkAuthActionRepository)
const coolapkAuthActionRepositoryProvider =
    CoolapkAuthActionRepositoryProvider._();

/// 酷安登录态写入仓储。

final class CoolapkAuthActionRepositoryProvider
    extends
        $FunctionalProvider<
          CoolapkAuthActionRepository,
          CoolapkAuthActionRepository,
          CoolapkAuthActionRepository
        >
    with $Provider<CoolapkAuthActionRepository> {
  /// 酷安登录态写入仓储。
  const CoolapkAuthActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coolapkAuthActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coolapkAuthActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<CoolapkAuthActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CoolapkAuthActionRepository create(Ref ref) {
    return coolapkAuthActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoolapkAuthActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoolapkAuthActionRepository>(value),
    );
  }
}

String _$coolapkAuthActionRepositoryHash() =>
    r'4a95f750217a542e030df64731f7739dc84c15d2';

/// 登录态写操作入口的 Provider。
///
/// 用 `keepAlive` 保住 [Ref]，避免 `ref.read` 后立即销毁导致异步落盘时失效。

@ProviderFor(coolapkAuthActions)
const coolapkAuthActionsProvider = CoolapkAuthActionsProvider._();

/// 登录态写操作入口的 Provider。
///
/// 用 `keepAlive` 保住 [Ref]，避免 `ref.read` 后立即销毁导致异步落盘时失效。

final class CoolapkAuthActionsProvider
    extends
        $FunctionalProvider<
          CoolapkAuthActions,
          CoolapkAuthActions,
          CoolapkAuthActions
        >
    with $Provider<CoolapkAuthActions> {
  /// 登录态写操作入口的 Provider。
  ///
  /// 用 `keepAlive` 保住 [Ref]，避免 `ref.read` 后立即销毁导致异步落盘时失效。
  const CoolapkAuthActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coolapkAuthActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coolapkAuthActionsHash();

  @$internal
  @override
  $ProviderElement<CoolapkAuthActions> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CoolapkAuthActions create(Ref ref) {
    return coolapkAuthActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoolapkAuthActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoolapkAuthActions>(value),
    );
  }
}

String _$coolapkAuthActionsHash() =>
    r'7c6112553b7bbb5970ef5baab8831bfef0bd8b3d';
