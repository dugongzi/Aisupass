// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_builtin_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 内置面板的只读数据源。

@ProviderFor(aiBuiltinQueryDatasource)
const aiBuiltinQueryDatasourceProvider = AiBuiltinQueryDatasourceProvider._();

/// 内置面板的只读数据源。

final class AiBuiltinQueryDatasourceProvider
    extends
        $FunctionalProvider<
          AiBuiltinQueryDatasource,
          AiBuiltinQueryDatasource,
          AiBuiltinQueryDatasource
        >
    with $Provider<AiBuiltinQueryDatasource> {
  /// 内置面板的只读数据源。
  const AiBuiltinQueryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiBuiltinQueryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiBuiltinQueryDatasourceHash();

  @$internal
  @override
  $ProviderElement<AiBuiltinQueryDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiBuiltinQueryDatasource create(Ref ref) {
    return aiBuiltinQueryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiBuiltinQueryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiBuiltinQueryDatasource>(value),
    );
  }
}

String _$aiBuiltinQueryDatasourceHash() =>
    r'e767b918d83502f2c9dae2adc32d39b12ef9835f';

/// 内置面板的只读仓储。

@ProviderFor(aiBuiltinQueryRepository)
const aiBuiltinQueryRepositoryProvider = AiBuiltinQueryRepositoryProvider._();

/// 内置面板的只读仓储。

final class AiBuiltinQueryRepositoryProvider
    extends
        $FunctionalProvider<
          AiBuiltinQueryRepository,
          AiBuiltinQueryRepository,
          AiBuiltinQueryRepository
        >
    with $Provider<AiBuiltinQueryRepository> {
  /// 内置面板的只读仓储。
  const AiBuiltinQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiBuiltinQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiBuiltinQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<AiBuiltinQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiBuiltinQueryRepository create(Ref ref) {
    return aiBuiltinQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiBuiltinQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiBuiltinQueryRepository>(value),
    );
  }
}

String _$aiBuiltinQueryRepositoryHash() =>
    r'f12219f0d993e557548a6816bbd6dd38dceef240';

/// 当前账号可见的分组（含模型清单），已按倍率升序排列。
///
/// [token] 为空时只取公开分组；登录页拿到令牌后按令牌取值。

@ProviderFor(builtinGroups)
const builtinGroupsProvider = BuiltinGroupsFamily._();

/// 当前账号可见的分组（含模型清单），已按倍率升序排列。
///
/// [token] 为空时只取公开分组；登录页拿到令牌后按令牌取值。

final class BuiltinGroupsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AiBuiltinGroup>>,
          List<AiBuiltinGroup>,
          FutureOr<List<AiBuiltinGroup>>
        >
    with
        $FutureModifier<List<AiBuiltinGroup>>,
        $FutureProvider<List<AiBuiltinGroup>> {
  /// 当前账号可见的分组（含模型清单），已按倍率升序排列。
  ///
  /// [token] 为空时只取公开分组；登录页拿到令牌后按令牌取值。
  const BuiltinGroupsProvider._({
    required BuiltinGroupsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'builtinGroupsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$builtinGroupsHash();

  @override
  String toString() {
    return r'builtinGroupsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<AiBuiltinGroup>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AiBuiltinGroup>> create(Ref ref) {
    final argument = this.argument as String;
    return builtinGroups(ref, token: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BuiltinGroupsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$builtinGroupsHash() => r'60af9f8a0cbf8ae46316c1cc15cf7e1ce6d10cf1';

/// 当前账号可见的分组（含模型清单），已按倍率升序排列。
///
/// [token] 为空时只取公开分组；登录页拿到令牌后按令牌取值。

final class BuiltinGroupsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<AiBuiltinGroup>>, String> {
  const BuiltinGroupsFamily._()
    : super(
        retry: null,
        name: r'builtinGroupsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 当前账号可见的分组（含模型清单），已按倍率升序排列。
  ///
  /// [token] 为空时只取公开分组；登录页拿到令牌后按令牌取值。

  BuiltinGroupsProvider call({String token = ''}) =>
      BuiltinGroupsProvider._(argument: token, from: this);

  @override
  String toString() => r'builtinGroupsProvider';
}

/// 内置配置已绑定的分组名，未绑定时为空串。

@ProviderFor(builtinGroupName)
const builtinGroupNameProvider = BuiltinGroupNameProvider._();

/// 内置配置已绑定的分组名，未绑定时为空串。

final class BuiltinGroupNameProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// 内置配置已绑定的分组名，未绑定时为空串。
  const BuiltinGroupNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'builtinGroupNameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$builtinGroupNameHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return builtinGroupName(ref);
  }
}

String _$builtinGroupNameHash() => r'2fc0588da3c5115839c71860758140914fdd2724';

/// 内置面板账户的额度信息。
///
/// 登录令牌从安全存储读取；未登录或令牌失效时抛 `ApiException`，
/// 由界面展示失败态并提供重新登录入口。

@ProviderFor(builtinWallet)
const builtinWalletProvider = BuiltinWalletProvider._();

/// 内置面板账户的额度信息。
///
/// 登录令牌从安全存储读取；未登录或令牌失效时抛 `ApiException`，
/// 由界面展示失败态并提供重新登录入口。

final class BuiltinWalletProvider
    extends
        $FunctionalProvider<
          AsyncValue<AiBuiltinWallet>,
          AiBuiltinWallet,
          FutureOr<AiBuiltinWallet>
        >
    with $FutureModifier<AiBuiltinWallet>, $FutureProvider<AiBuiltinWallet> {
  /// 内置面板账户的额度信息。
  ///
  /// 登录令牌从安全存储读取；未登录或令牌失效时抛 `ApiException`，
  /// 由界面展示失败态并提供重新登录入口。
  const BuiltinWalletProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'builtinWalletProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$builtinWalletHash();

  @$internal
  @override
  $FutureProviderElement<AiBuiltinWallet> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AiBuiltinWallet> create(Ref ref) {
    return builtinWallet(ref);
  }
}

String _$builtinWalletHash() => r'6372a85066fcd4f5088e4d0207af6f1c591a1684';
