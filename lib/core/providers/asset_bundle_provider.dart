import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'asset_bundle_provider.g.dart';

/// App 内置资源包的读取入口。
///
/// 提权链路的载荷清单来自 `assets/escalation/payloads/catalog.json`，
/// 走这里取，方便测试时整体替换。
@riverpod
AssetBundle assetBundle(Ref ref) => rootBundle;
