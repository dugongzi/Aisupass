// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_bundle_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// App 内置资源包的读取入口。
///
/// 提权链路的载荷清单来自 `assets/escalation/payloads/catalog.json`，
/// 走这里取，方便测试时整体替换。

@ProviderFor(assetBundle)
const assetBundleProvider = AssetBundleProvider._();

/// App 内置资源包的读取入口。
///
/// 提权链路的载荷清单来自 `assets/escalation/payloads/catalog.json`，
/// 走这里取，方便测试时整体替换。

final class AssetBundleProvider
    extends $FunctionalProvider<AssetBundle, AssetBundle, AssetBundle>
    with $Provider<AssetBundle> {
  /// App 内置资源包的读取入口。
  ///
  /// 提权链路的载荷清单来自 `assets/escalation/payloads/catalog.json`，
  /// 走这里取，方便测试时整体替换。
  const AssetBundleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assetBundleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assetBundleHash();

  @$internal
  @override
  $ProviderElement<AssetBundle> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AssetBundle create(Ref ref) {
    return assetBundle(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AssetBundle value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AssetBundle>(value),
    );
  }
}

String _$assetBundleHash() => r'c8b3f8b421eb270854b13c74f343816c76c0617e';
