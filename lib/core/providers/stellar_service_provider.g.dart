// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stellar_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stellar 特权服务的当前状态。
///
/// 判定依据是回环端口能否完成一次 PING/PONG——只回答「在不在、以谁的身份在」，
/// 不代表已经具备执行能力。

@ProviderFor(stellarServiceStatus)
const stellarServiceStatusProvider = StellarServiceStatusProvider._();

/// Stellar 特权服务的当前状态。
///
/// 判定依据是回环端口能否完成一次 PING/PONG——只回答「在不在、以谁的身份在」，
/// 不代表已经具备执行能力。
final class StellarServiceStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<StellarServiceStatus>,
          StellarServiceStatus,
          FutureOr<StellarServiceStatus>
        >
    with
        $FutureModifier<StellarServiceStatus>,
        $FutureProvider<StellarServiceStatus> {
  /// Stellar 特权服务的当前状态。
  ///
  /// 判定依据是回环端口能否完成一次 PING/PONG——只回答「在不在、以谁的身份在」，
  /// 不代表已经具备执行能力。
  const StellarServiceStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stellarServiceStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stellarServiceStatusHash();

  @$internal
  @override
  $FutureProviderElement<StellarServiceStatus> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<StellarServiceStatus> create(Ref ref) {
    return stellarServiceStatus(ref);
  }
}

String _$stellarServiceStatusHash() =>
    r'2f7c9e14a6d83b05e1c7a9d4f2b63e805c4d1a79';

/// 把服务拉起来。
///
/// 拉起动作与「当前有没有可用的执行通道」无关：没有通道时命令根本跑不起来，
/// 这里只按结果分型，不做通道层面的判断。

@ProviderFor(StellarLaunch)
const stellarLaunchProvider = StellarLaunchProvider._();

/// 把服务拉起来。
///
/// 拉起动作与「当前有没有可用的执行通道」无关：没有通道时命令根本跑不起来，
/// 这里只按结果分型，不做通道层面的判断。
final class StellarLaunchProvider
    extends $NotifierProvider<StellarLaunch, StellarLaunchState> {
  /// 把服务拉起来。
  ///
  /// 拉起动作与「当前有没有可用的执行通道」无关：没有通道时命令根本跑不起来，
  /// 这里只按结果分型，不做通道层面的判断。
  const StellarLaunchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stellarLaunchProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stellarLaunchHash();

  @$internal
  @override
  StellarLaunch create() => StellarLaunch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StellarLaunchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StellarLaunchState>(value),
    );
  }
}

String _$stellarLaunchHash() =>
    r'8b3d5a71c0e94f26d8b1a4c7e93f5028a6d7c41b';

/// 把服务拉起来。
///
/// 拉起动作与「当前有没有可用的执行通道」无关：没有通道时命令根本跑不起来，
/// 这里只按结果分型，不做通道层面的判断。

abstract class _$StellarLaunch extends $Notifier<StellarLaunchState> {
  StellarLaunchState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<StellarLaunchState, StellarLaunchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StellarLaunchState, StellarLaunchState>,
              StellarLaunchState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
