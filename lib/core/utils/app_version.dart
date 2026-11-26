import 'package:package_info_plus/package_info_plus.dart';

/// 当前安装包的版本信息，进程内只读一次平台通道。
class AppVersion {
  AppVersion._();

  static PackageInfo? _cached;

  /// 读取版本信息；首次调用走平台通道，之后复用缓存。
  static Future<PackageInfo> load() async =>
      _cached ??= await PackageInfo.fromPlatform();

  /// 设置页与更新入口统一的展示格式：`1.0.0+1`。
  static String display(PackageInfo info) =>
      '${info.version}+${info.buildNumber}';
}
