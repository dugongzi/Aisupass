import 'package:pigeon/pigeon.dart';

/// 设备上已安装的一个 KernelSU 系 root 管理器。
///
/// 字段全部非空：名字与图标取不到时回落成安装包名与空字节数组，
/// 不让 `null` 穿过通道。
class RootManagerInfo {
  RootManagerInfo({
    required this.packageName,
    required this.displayName,
    required this.icon,
  });

  /// 管理器包名，同时是 `late-load --package-name` 的参数。
  String packageName;

  /// 应用图标上显示的名字，取自 `PackageManager.getApplicationLabel`。
  String displayName;

  /// 图标转成的 PNG 字节；取不到时为空数组。
  Uint8List icon;
}

/// root 管理器扫描原生接口。
///
/// 契约原则：
/// 1. 只回答「哪些应用带了 `libksud.so`」，选择与排序交给上层；
/// 2. 不抛异常，扫描失败以空列表表达；
/// 3. 不缓存安装路径，`nativeLibraryDir` 每次现读。
@HostApi()
abstract class RootManagerNative {
  /// 扫描设备上装了 `libksud.so` 的应用。
  @async
  List<RootManagerInfo> scan();
}
