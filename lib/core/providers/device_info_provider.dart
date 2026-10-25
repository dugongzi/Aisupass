import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 设备信息字段。
///
/// 这里只存字段标识，标题文案由 UI 层映射多语言，
/// 避免 provider 里依赖 `BuildContext`。
enum DeviceInfoField {
  selinuxStatus,
  deviceModel,
  osVersion,
  kernelVersion,
  securityPatch,
  baseband,
  buildNumber,
  sotaVersion,
  apiLevel,
  cpuAbi,
  appVersion,
}

/// 一条设备信息。
@immutable
class DeviceInfoItem {
  const DeviceInfoItem(this.field, this.value);

  final DeviceInfoField field;
  final String value;
}

/// 设备环境快照，按展示顺序排列。
///
/// 平台不支持的字段不会出现在列表里，UI 直接遍历即可。
@immutable
class DeviceSnapshot {
  const DeviceSnapshot(this.items);

  final List<DeviceInfoItem> items;
}

/// 采集设备环境信息。
///
/// 提权方案依赖这些数据（SELinux、系统版本、内核、基带、版本号），
/// 因此在首页展示并支持逐项复制给 AI。
final FutureProvider<DeviceSnapshot> deviceSnapshotProvider =
    FutureProvider<DeviceSnapshot>((ref) async {
      final List<DeviceInfoItem> items = <DeviceInfoItem>[];

      if (Platform.isAndroid) {
        final AndroidDeviceInfo android = await DeviceInfoPlugin().androidInfo;

        // SELinux 决定利用路径，放第一位。
        await _add(items, DeviceInfoField.selinuxStatus, _readSelinuxStatus);

        await _add(
          items,
          DeviceInfoField.deviceModel,
          () async => '${android.manufacturer} ${android.model}'.trim(),
        );
        await _add(
          items,
          DeviceInfoField.osVersion,
          () async => 'Android ${android.version.release}',
        );
        await _add(items, DeviceInfoField.kernelVersion, _readKernelVersion);
        await _add(
          items,
          DeviceInfoField.securityPatch,
          () async => _nullIfEmpty(android.version.securityPatch) ??
              _readSystemProperty('ro.build.version.security_patch'),
        );
        await _add(
          items,
          DeviceInfoField.baseband,
          () => _readSystemProperty('gsm.version.baseband'),
        );
        await _add(
          items,
          DeviceInfoField.buildNumber,
          // ColorOS 的 `ro.build.display.id` 只有 `PHB110_x.x.x.xxx(CN01)`，
          // 设置页展示的完整版本号在 `ro.build.version.ota` 里，优先读它。
          () async =>
              _readSystemProperty('ro.build.version.ota') ??
              _nullIfEmpty(android.display) ??
              _readSystemProperty('ro.build.display.id'),
        );
        await _add(items, DeviceInfoField.sotaVersion, _readSotaVersion);
        await _add(
          items,
          DeviceInfoField.apiLevel,
          () async => '${android.version.sdkInt}',
        );
        if (android.supportedAbis.isNotEmpty) {
          items.add(
            DeviceInfoItem(DeviceInfoField.cpuAbi, android.supportedAbis.first),
          );
        }
      } else {
        // 桌面端只展示系统版本，Android 专属字段直接跳过。
        items.add(
          DeviceInfoItem(
            DeviceInfoField.osVersion,
            Platform.operatingSystemVersion,
          ),
        );
      }

      final PackageInfo package = await PackageInfo.fromPlatform();
      items.add(
        DeviceInfoItem(
          DeviceInfoField.appVersion,
          '${package.version}+${package.buildNumber}',
        ),
      );

      return DeviceSnapshot(items);
    });

/// 读取成功才加入列表，读不到的字段直接跳过，不显示占位值。
Future<void> _add(
  List<DeviceInfoItem> items,
  DeviceInfoField field,
  Future<String?> Function() reader,
) async {
  final String? value = await reader();
  if (value != null && value.isNotEmpty) {
    items.add(DeviceInfoItem(field, value));
  }
}

String? _nullIfEmpty(String? value) =>
    (value == null || value.isEmpty) ? null : value;

/// 读取内核版本，部分定制系统限制访问时返回 null。
Future<String?> _readKernelVersion() async {
  try {
    final String content = await File('/proc/version').readAsString();
    return RegExp(r'Linux version (\S+)').firstMatch(content)?.group(1);
  } catch (_) {
    return null;
  }
}

/// 读取 SELinux 状态：1 为 Enforcing，0 为 Permissive。
///
/// 读不到时返回 null，不猜测为 Disabled，避免展示错误信息。
Future<String?> _readSelinuxStatus() async {
  try {
    final String value = (await File(
      '/sys/fs/selinux/enforce',
    ).readAsString()).trim();
    return switch (value) {
      '1' => 'Enforcing',
      '0' => 'Permissive',
      _ => null,
    };
  } catch (_) {
    return null;
  }
}

/// 读取 SOTA 版本。
///
/// 该字段由 ROM 厂商提供，不同厂商属性名不同：
/// OPPO/一加用 `persist.sys.oplus.sota_ver_curr`，华为/荣耀用 `ro.*.sota`。
/// 按候选顺序取第一个非空值，全部为空时该行不展示。
Future<String?> _readSotaVersion() async {
  const List<String> keys = <String>[
    'persist.sys.oplus.sota_ver_curr',
    'ro.build.version.sota',
    'ro.vendor.build.version.sota',
    'ro.odm.build.version.sota',
    'ro.build.sota',
  ];
  for (final String key in keys) {
    final String? value = await _readSystemProperty(key);
    if (value != null) return value;
  }
  return null;
}

/// 通过 getprop 读取系统属性。
///
/// 部分属性受 SELinux 限制读不到，读不到返回 null。
Future<String?> _readSystemProperty(String key) async {
  for (final String bin in <String>['getprop', '/system/bin/getprop']) {
    try {
      final ProcessResult result = await Process.run(bin, <String>[key]);
      if (result.exitCode != 0) continue;
      final String value = (result.stdout as String).trim();
      if (value.isNotEmpty) return value;
    } catch (_) {
      // 换下一个可执行路径继续尝试。
    }
  }
  return null;
}
