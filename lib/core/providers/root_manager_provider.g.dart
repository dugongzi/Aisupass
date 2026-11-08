// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'root_manager_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// root 管理器扫描的原生接口实例，与 Pigeon 通道一一对应。

@ProviderFor(rootManagerNative)
const rootManagerNativeProvider = RootManagerNativeProvider._();

/// root 管理器扫描的原生接口实例，与 Pigeon 通道一一对应。

final class RootManagerNativeProvider
    extends
        $FunctionalProvider<
          RootManagerNative,
          RootManagerNative,
          RootManagerNative
        >
    with $Provider<RootManagerNative> {
  /// root 管理器扫描的原生接口实例，与 Pigeon 通道一一对应。
  const RootManagerNativeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rootManagerNativeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rootManagerNativeHash();

  @$internal
  @override
  $ProviderElement<RootManagerNative> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RootManagerNative create(Ref ref) {
    return rootManagerNative(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RootManagerNative value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RootManagerNative>(value),
    );
  }
}

String _$rootManagerNativeHash() => r'a9c7074534024406a88b4b36ad00cc480e14e7f2';
