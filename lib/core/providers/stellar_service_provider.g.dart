// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stellar_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stellar 特权服务的当前状态。
///
/// 服务端尚未接入，这里如实返回「服务未运行」；接入后改为查询原生状态，
/// 本 Provider 的签名与调用方都不需要变。

@ProviderFor(stellarServiceStatus)
const stellarServiceStatusProvider = StellarServiceStatusProvider._();

/// Stellar 特权服务的当前状态。
///
/// 服务端尚未接入，这里如实返回「服务未运行」；接入后改为查询原生状态，
/// 本 Provider 的签名与调用方都不需要变。

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
  /// 服务端尚未接入，这里如实返回「服务未运行」；接入后改为查询原生状态，
  /// 本 Provider 的签名与调用方都不需要变。
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
    r'e3ee70e6c8f954195a12825382ddc4a5a8573b19';
