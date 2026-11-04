// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_identity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 设备身份采集的原生接口实例，与 Pigeon 通道一一对应。

@ProviderFor(deviceIdentityNative)
const deviceIdentityNativeProvider = DeviceIdentityNativeProvider._();

/// 设备身份采集的原生接口实例，与 Pigeon 通道一一对应。

final class DeviceIdentityNativeProvider
    extends
        $FunctionalProvider<
          DeviceIdentityNative,
          DeviceIdentityNative,
          DeviceIdentityNative
        >
    with $Provider<DeviceIdentityNative> {
  /// 设备身份采集的原生接口实例，与 Pigeon 通道一一对应。
  const DeviceIdentityNativeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceIdentityNativeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceIdentityNativeHash();

  @$internal
  @override
  $ProviderElement<DeviceIdentityNative> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeviceIdentityNative create(Ref ref) {
    return deviceIdentityNative(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceIdentityNative value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceIdentityNative>(value),
    );
  }
}

String _$deviceIdentityNativeHash() =>
    r'28cdce9b677b162b9a5b2a2c2fc80489e86f74da';
