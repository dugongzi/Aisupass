import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle;

import 'package:Aisupass/core/constants/storage_keys.dart';
import 'package:Aisupass/core/storage/key_value_store.dart';
import 'package:Aisupass/features/escalation/data/models/device_identity_dto.dart';
import 'package:Aisupass/features/escalation/data/models/payload_dto.dart';
import 'package:Aisupass/features/escalation/data/models/root_manager_dto.dart';
import 'package:Aisupass/generated/device_identity.g.dart' as pigeon;
import 'package:Aisupass/generated/root_manager.g.dart' as root_pigeon;

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
  final root_pigeon.RootManagerNative _managers;
  final KeyValueStore _storage;

  /// 读取用户选定的 root 管理器包名。
  ///
  /// 未设置时返回 `''`，由仓储层决定回落成哪个管理器。
  Future<String> readSelectedRootManagerPackage() =>
      _storage.read<String>(StorageKeys.escalationSelectedRootManager);

  /// 扫描设备上自带 ksud 的应用（固定名或携带指纹的随机名）。原生对象在本层收敛为 DTO。
  Future<List<RootManagerDto>> scanRootManagers() async =>
      (await _managers.scan())
          .map(RootManagerDto.fromNative)
          .toList(growable: false);

  /// 取指定管理器自带 ksud 的绝对路径；未安装或找不到时返回空串。
  Future<String> resolveKsudPath(String packageName) =>
      _managers.resolveKsudPath(packageName);

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

  /// 采集设备身份。原生对象在本层收敛为 DTO。
  Future<DeviceIdentityDto> readDeviceIdentity() async =>
      DeviceIdentityDto.fromNative(await _native.read());
}
