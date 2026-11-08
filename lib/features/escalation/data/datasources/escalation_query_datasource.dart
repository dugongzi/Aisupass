import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle;

import 'package:Aisupass/core/constants/storage_keys.dart';
import 'package:Aisupass/core/storage/key_value_store.dart';
import 'package:Aisupass/features/escalation/data/models/payload_dto.dart';
import 'package:Aisupass/generated/device_identity.g.dart' as pigeon;
import 'package:Aisupass/generated/root_manager.g.dart';

/// 提权链路只读数据源：载荷清单、设备身份与已安装的管理器。
///
/// 只做读取与原始结构解析，不含任何匹配判断。
class EscalationQueryDatasource {
  const EscalationQueryDatasource({
    required this._bundle,
    required this._native,
    required this._managers,
    required this._storage,
  });

  /// 载荷清单在包内的路径。
  static const String catalogPath = 'assets/escalation/payloads/catalog.json';

  final AssetBundle _bundle;
  final pigeon.DeviceIdentityNative _native;
  final RootManagerNative _managers;
  final KeyValueStore _storage;

  /// 读取用户选定的 root 管理器包名。
  ///
  /// 未设置时返回 `''`，由仓储层决定回落成哪个管理器。
  Future<String> readSelectedRootManagerPackage() =>
      _storage.read<String>(StorageKeys.escalationSelectedRootManager);

  /// 扫描设备上带 `libksud.so` 的应用。
  Future<List<RootManagerInfo>> scanRootManagers() => _managers.scan();

  /// 读取并解析载荷清单。解析失败直接抛出，不吞异常。
  Future<List<PayloadDto>> loadPayloadCatalog() async {
    final String raw = await _bundle.loadString(catalogPath);
    final Map<String, dynamic> root = jsonDecode(raw) as Map<String, dynamic>;
    final List<dynamic> entries = root['entries'] as List<dynamic>;
    return entries
        .map(
          (dynamic entry) => PayloadDto.fromJson(entry as Map<String, dynamic>),
        )
        .toList();
  }

  /// 采集设备身份。
  Future<pigeon.DeviceIdentity> readDeviceIdentity() => _native.read();
}
