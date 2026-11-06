import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle;

import 'package:Aisupass/features/escalation/data/models/payload_dto.dart';
import 'package:Aisupass/generated/device_identity.g.dart' as pigeon;

/// 提权链路只读数据源：载荷清单与设备身份。
///
/// 只做读取与原始结构解析，不含任何匹配判断。
class EscalationQueryDatasource {
  const EscalationQueryDatasource({
    required this._bundle,
    required this._native,
  });

  /// 载荷清单在包内的路径。
  static const String catalogPath = 'assets/escalation/payloads/catalog.json';

  final AssetBundle _bundle;
  final pigeon.DeviceIdentityNative _native;

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
