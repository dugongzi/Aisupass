import 'dart:convert';

import 'package:flutter/services.dart';

/// 提权资产目录的只读数据源。
///
/// M0 阶段不随包提供任何资产，因此读取失败必须优雅降级为空列表，
/// 由上层展示 `catalogCorrupted` 原因码，而不是让页面崩溃。
class EscalationCatalogDatasource {
  EscalationCatalogDatasource({AssetBundle? bundle})
    : _bundle = bundle ?? rootBundle;

  /// 载荷目录路径。
  static const String payloadCatalogPath =
      'assets/escalation/payloads/catalog.json';

  /// 内核配置目录路径。
  static const String kernelCatalogPath =
      'assets/escalation/kernels/catalog.json';

  final AssetBundle _bundle;

  /// 读取可用载荷 id 列表。
  Future<List<String>> loadPayloadIds() =>
      _loadIds(payloadCatalogPath, 'payloads');

  /// 读取可用内核配置名列表。
  Future<List<String>> loadKernelProfiles() =>
      _loadIds(kernelCatalogPath, 'kernels');

  Future<List<String>> _loadIds(String path, String key) async {
    try {
      final String raw = await _bundle.loadString(path);
      final Object? decoded = jsonDecode(raw);
      if (decoded is! Map) return const <String>[];
      final Object? items = decoded[key];
      if (items is! List) return const <String>[];
      return items
          .map((Object? item) => item?.toString() ?? '')
          .where((String id) => id.isNotEmpty)
          .toList(growable: false);
    } catch (_) {
      // 资产缺失与 JSON 非法都按「目录为空」处理，属 M0 的预期状态。
      return const <String>[];
    }
  }
}
