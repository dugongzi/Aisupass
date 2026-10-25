import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 系统状态快照：ROOT 权限与 ADB 调试开关。
@immutable
class SystemStatus {
  const SystemStatus({
    required this.isRooted,
    required this.adbUsbEnabled,
    required this.adbWifiEnabled,
  });

  /// 是否具备 ROOT 权限。
  final bool isRooted;

  /// 有线（USB）调试是否开启。
  final bool adbUsbEnabled;

  /// 无线调试是否开启。
  final bool adbWifiEnabled;

  bool get isAdbEnabled => adbUsbEnabled || adbWifiEnabled;
}

/// 检测系统状态。
///
/// ROOT 与 ADB 都是 Android 概念，桌面端固定返回未激活。
final FutureProvider<SystemStatus> systemStatusProvider =
    FutureProvider<SystemStatus>((ref) async {
      if (!Platform.isAndroid) {
        return const SystemStatus(
          isRooted: false,
          adbUsbEnabled: false,
          adbWifiEnabled: false,
        );
      }

      return SystemStatus(
        isRooted: await _detectRoot(),
        adbUsbEnabled: await _readGlobalSwitch('adb_enabled'),
        adbWifiEnabled: await _readGlobalSwitch('adb_wifi_enabled'),
      );
    });

/// 检测 ROOT。
///
/// 依次检查 su 可执行文件、`which su` 与当前进程 uid，
/// 任一命中即视为已 ROOT。不执行 `su -c`，避免触发授权弹窗。
Future<bool> _detectRoot() async {
  const List<String> suPaths = <String>[
    '/system/bin/su',
    '/system/xbin/su',
    '/sbin/su',
    '/su/bin/su',
    '/vendor/bin/su',
    '/debug_ramdisk/su',
    '/data/adb/magisk',
  ];
  for (final String path in suPaths) {
    if (await File(path).exists()) return true;
  }

  for (final String bin in <String>['which', '/system/bin/which']) {
    try {
      final ProcessResult result = await Process.run(bin, <String>['su']);
      if (result.exitCode == 0 &&
          (result.stdout as String).trim().isNotEmpty) {
        return true;
      }
    } catch (_) {
      // 换下一个可执行路径继续尝试。
    }
  }

  // 应用被以 root 身份拉起时，uid 为 0。
  try {
    final ProcessResult result = await Process.run('id', <String>[]);
    if ((result.stdout as String).contains('uid=0')) return true;
  } catch (_) {
    // 读不到就按未 ROOT 处理。
  }

  return false;
}

/// 读取 `settings get global` 的开关值。
///
/// 读不到（部分 ROM 限制 app 域执行 settings）按关闭处理。
Future<bool> _readGlobalSwitch(String key) async {
  for (final String bin in <String>['settings', '/system/bin/settings']) {
    try {
      final ProcessResult result = await Process.run(bin, <String>[
        'get',
        'global',
        key,
      ]);
      if (result.exitCode != 0) continue;
      if ((result.stdout as String).trim() == '1') return true;
    } catch (_) {
      // 换下一个可执行路径继续尝试。
    }
  }
  return false;
}
