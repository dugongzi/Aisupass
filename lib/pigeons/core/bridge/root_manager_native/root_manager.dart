import 'package:pigeon/pigeon.dart';

/// 设备上已安装的一个 root 管理器（KernelSU 系及其各分支）。
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
/// 1. 只回答「哪些应用自带可用的 ksud」：应用 `lib/arm64` 下固定名 `libksud.so`
///    优先；没有固定名时扫随机名，判据是 arm64 可执行 ELF 头 + 二进制里的 ksud
///    子命令文本（`post-fs-data` / `boot-completed` / `late-load`）。不按包名、
///    不按库文件名猜；
/// 2. 不抛异常，扫描失败以空列表表达；
/// 3. 只读管理器自己的原生库目录，不读 APK、不写盘。
@HostApi()
abstract class RootManagerNative {
  /// 扫描设备上自带 ksud 的应用。
  @async
  List<RootManagerInfo> scan();

  /// 取指定管理器自带 ksud 的绝对路径。
  ///
  /// 判据与 [scan] 一致；包名非法、未安装或自带库里没有可用的 ksud 时返回空串。
  /// 移交脚本用它免掉按文件名 `find`。
  @async
  String resolveKsudPath(String packageName);

  /// 把指定管理器拉到前台。
  ///
  /// 用 `getLaunchIntentForPackage` 解析启动入口，不写死 Activity 类名：各分支的
  /// 入口类名并不统一，而官方 KernelSU 的 `ksud late-load` 尾部是靠
  /// `am start -n <包名>/me.weishu.kernelsu.ui.MainActivity` 这个写死的组件名
  /// 拉起自己的——换成分支后组件名对不上，就拉不起来了。
  /// 包名非法、未安装或没有启动入口时返回 false。
  @async
  bool launchManager(String packageName);
}
