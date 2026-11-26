// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coolapk_auth_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 酷安登录 Cookie 的原生接口实例，与 Pigeon 通道一一对应。

@ProviderFor(coolapkAuthNative)
const coolapkAuthNativeProvider = CoolapkAuthNativeProvider._();

/// 酷安登录 Cookie 的原生接口实例，与 Pigeon 通道一一对应。

final class CoolapkAuthNativeProvider
    extends
        $FunctionalProvider<
          CoolapkAuthNative,
          CoolapkAuthNative,
          CoolapkAuthNative
        >
    with $Provider<CoolapkAuthNative> {
  /// 酷安登录 Cookie 的原生接口实例，与 Pigeon 通道一一对应。
  const CoolapkAuthNativeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coolapkAuthNativeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coolapkAuthNativeHash();

  @$internal
  @override
  $ProviderElement<CoolapkAuthNative> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CoolapkAuthNative create(Ref ref) {
    return coolapkAuthNative(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoolapkAuthNative value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoolapkAuthNative>(value),
    );
  }
}

String _$coolapkAuthNativeHash() => r'025cdbf5b7ec15d30761661a77ac900a099b0051';

/// 酷安登录态的只读数据源。

@ProviderFor(coolapkAuthQueryDatasource)
const coolapkAuthQueryDatasourceProvider =
    CoolapkAuthQueryDatasourceProvider._();

/// 酷安登录态的只读数据源。

final class CoolapkAuthQueryDatasourceProvider
    extends
        $FunctionalProvider<
          CoolapkAuthQueryDatasource,
          CoolapkAuthQueryDatasource,
          CoolapkAuthQueryDatasource
        >
    with $Provider<CoolapkAuthQueryDatasource> {
  /// 酷安登录态的只读数据源。
  const CoolapkAuthQueryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coolapkAuthQueryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coolapkAuthQueryDatasourceHash();

  @$internal
  @override
  $ProviderElement<CoolapkAuthQueryDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CoolapkAuthQueryDatasource create(Ref ref) {
    return coolapkAuthQueryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoolapkAuthQueryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoolapkAuthQueryDatasource>(value),
    );
  }
}

String _$coolapkAuthQueryDatasourceHash() =>
    r'0f2759de8033de6b68b17f1d1c95ca1ab834eb51';

/// 酷安登录态查询仓储。

@ProviderFor(coolapkAuthQueryRepository)
const coolapkAuthQueryRepositoryProvider =
    CoolapkAuthQueryRepositoryProvider._();

/// 酷安登录态查询仓储。

final class CoolapkAuthQueryRepositoryProvider
    extends
        $FunctionalProvider<
          CoolapkAuthQueryRepository,
          CoolapkAuthQueryRepository,
          CoolapkAuthQueryRepository
        >
    with $Provider<CoolapkAuthQueryRepository> {
  /// 酷安登录态查询仓储。
  const CoolapkAuthQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coolapkAuthQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coolapkAuthQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<CoolapkAuthQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CoolapkAuthQueryRepository create(Ref ref) {
    return coolapkAuthQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoolapkAuthQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoolapkAuthQueryRepository>(value),
    );
  }
}

String _$coolapkAuthQueryRepositoryHash() =>
    r'08414ecd9b5e2038378b06312f1780dfa44e541d';

/// 当前登录态。
///
/// keepAlive：聊天过程中会被工具、数据源反复读取，不能因为一时没人监听
/// 就退回未登录。

@ProviderFor(coolapkAuth)
const coolapkAuthProvider = CoolapkAuthProvider._();

/// 当前登录态。
///
/// keepAlive：聊天过程中会被工具、数据源反复读取，不能因为一时没人监听
/// 就退回未登录。

final class CoolapkAuthProvider
    extends
        $FunctionalProvider<
          AsyncValue<CoolapkAuthState>,
          CoolapkAuthState,
          FutureOr<CoolapkAuthState>
        >
    with $FutureModifier<CoolapkAuthState>, $FutureProvider<CoolapkAuthState> {
  /// 当前登录态。
  ///
  /// keepAlive：聊天过程中会被工具、数据源反复读取，不能因为一时没人监听
  /// 就退回未登录。
  const CoolapkAuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coolapkAuthProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coolapkAuthHash();

  @$internal
  @override
  $FutureProviderElement<CoolapkAuthState> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CoolapkAuthState> create(Ref ref) {
    return coolapkAuth(ref);
  }
}

String _$coolapkAuthHash() => r'c24280b4ed1faed7d40cfe5bf8f3983bb715425f';

/// 当前登录 Cookie；未登录或仍在加载时为空串。
///
/// 数据源拼请求头时直接用它，免得到处展开 AsyncValue。

@ProviderFor(coolapkAuthCookie)
const coolapkAuthCookieProvider = CoolapkAuthCookieProvider._();

/// 当前登录 Cookie；未登录或仍在加载时为空串。
///
/// 数据源拼请求头时直接用它，免得到处展开 AsyncValue。

final class CoolapkAuthCookieProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// 当前登录 Cookie；未登录或仍在加载时为空串。
  ///
  /// 数据源拼请求头时直接用它，免得到处展开 AsyncValue。
  const CoolapkAuthCookieProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coolapkAuthCookieProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coolapkAuthCookieHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return coolapkAuthCookie(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$coolapkAuthCookieHash() => r'5f57a51233e21b5077d0c0724613d81ced0a33ad';

/// 已拿到的易盾验证码票据；没有则为空串。
///
/// 数据源把它作为 `validate` Cookie 发出去，绕开详情接口的风控。

@ProviderFor(coolapkCaptchaValidate)
const coolapkCaptchaValidateProvider = CoolapkCaptchaValidateProvider._();

/// 已拿到的易盾验证码票据；没有则为空串。
///
/// 数据源把它作为 `validate` Cookie 发出去，绕开详情接口的风控。

final class CoolapkCaptchaValidateProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// 已拿到的易盾验证码票据；没有则为空串。
  ///
  /// 数据源把它作为 `validate` Cookie 发出去，绕开详情接口的风控。
  const CoolapkCaptchaValidateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coolapkCaptchaValidateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coolapkCaptchaValidateHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return coolapkCaptchaValidate(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$coolapkCaptchaValidateHash() =>
    r'7ea78aebae125d5ae1a9b007432eb1f457453478';

/// 票据保存时间（毫秒时间戳）；没有票据时为 0。
///
/// 验证卡片用它比较「保存时间是否晚于卡片出现时刻」，
/// 不能在 loading 期间用票据是否为空来判断，那样会把旧票据误认成刚验证过。

@ProviderFor(coolapkCaptchaSavedAt)
const coolapkCaptchaSavedAtProvider = CoolapkCaptchaSavedAtProvider._();

/// 票据保存时间（毫秒时间戳）；没有票据时为 0。
///
/// 验证卡片用它比较「保存时间是否晚于卡片出现时刻」，
/// 不能在 loading 期间用票据是否为空来判断，那样会把旧票据误认成刚验证过。

final class CoolapkCaptchaSavedAtProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// 票据保存时间（毫秒时间戳）；没有票据时为 0。
  ///
  /// 验证卡片用它比较「保存时间是否晚于卡片出现时刻」，
  /// 不能在 loading 期间用票据是否为空来判断，那样会把旧票据误认成刚验证过。
  const CoolapkCaptchaSavedAtProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coolapkCaptchaSavedAtProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coolapkCaptchaSavedAtHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return coolapkCaptchaSavedAt(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$coolapkCaptchaSavedAtHash() =>
    r'0d0a2e7fec70f0cc255714dc656b730d0a5cddbf';
