import 'dart:convert';

import 'package:Aisupass/core/constants/storage_keys.dart';
import 'package:Aisupass/core/storage/key_value_store.dart';
import 'package:Aisupass/features/escalation/data/models/imported_payload_dto.dart';

/// 自定义载荷的只读数据源：从本地存储取回已导入列表。
///
/// 一条载荷一个键（`前缀 + 设备路径`），所以这里只做「按键扫描 + 单条解析」，
/// 不涉及任何合并或过滤。
class PayloadImportQueryDatasource {
  const PayloadImportQueryDatasource({required this._storage});

  final KeyValueStore _storage;

  /// 读取已导入的自定义载荷。
  ///
  /// 没有任何条目时返回空列表；单条内容损坏时原样抛出解析异常，由 Provider 层
  /// 呈现错误态，不在这里吞掉。
  Future<List<ImportedPayloadDto>> loadImported() async {
    final Set<String> keys = await _storage.keys();
    final List<String> payloadKeys = keys
        .where(
          (String key) =>
              key.startsWith(StorageKeys.escalationImportedPayloadPrefix),
        )
        .toList(growable: false);

    final List<ImportedPayloadDto> items = <ImportedPayloadDto>[];
    for (final String key in payloadKeys) {
      final String raw = await _storage.read<String>(key);
      if (raw.isEmpty) continue;
      items.add(
        ImportedPayloadDto.fromJson(jsonDecode(raw) as Map<String, dynamic>),
      );
    }
    // 按键名排序，列表顺序不会随存储内部顺序抖动。
    items.sort(
      (ImportedPayloadDto a, ImportedPayloadDto b) =>
          a.displayName.compareTo(b.displayName),
    );
    return items;
  }
}
