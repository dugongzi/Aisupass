import 'dart:io';

import 'package:Aisupass/generated/system_status.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 原生接口实例，与平台通道一一对应。
final Provider<SystemStatusNative> systemStatusNativeProvider =
    Provider<SystemStatusNative>((ref) => SystemStatusNative());

/// 是否具备 ROOT 权限。
///
/// 与 ADB 拆成两个 provider，卡片上的刷新按钮才能只重查自己那一项。
/// 桌面端没有 ROOT 概念，固定返回 false。
final FutureProvider<bool> rootStatusProvider = FutureProvider<bool>((ref) async {
  if (!Platform.isAndroid) return false;

  final SystemStatusNative native = ref.watch(systemStatusNativeProvider);
  try {
    return await native.isRoot();
  } catch (_) {
    // 原生未注册或调用失败时按未 ROOT 处理。
    return false;
  }
});

/// ADB 调试开关状态。
///
/// 有线与无线分别由原生判定，桌面端固定返回均未开启。
final FutureProvider<AdbStatus> adbStatusProvider =
    FutureProvider<AdbStatus>((ref) async {
      final AdbStatus disabled = AdbStatus(usb: false, wifi: false);
      if (!Platform.isAndroid) return disabled;

      final SystemStatusNative native = ref.watch(systemStatusNativeProvider);
      try {
        return await native.isAdbEnabled();
      } catch (_) {
        return disabled;
      }
    });
