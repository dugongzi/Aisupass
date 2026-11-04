import 'package:pigeon/pigeon.dart';

/// 当前设备的身份快照，一次取值全部字段。
///
/// 字段全部非空：取不到时回落成空串，语义由上层还原，
/// 不让 `null` 穿过通道。
class DeviceIdentity {
  DeviceIdentity({
    required this.identityText,
    required this.kernelRelease,
    required this.kernelVersion,
    required this.kernelCommit,
    required this.manufacturer,
    required this.model,
    required this.pageSize,
  });

  /// 机型召回用的身份文本：厂商、品牌、型号、设备代号、产品名等去重后
  /// 小写空格拼接。vivo/iQOO 的 `Build.MODEL` 是型号代码（`V2463A`），
  /// 市场名落在别的字段里，所以这里宁可多拼几个来源。
  String identityText;

  /// 内核完整版本串，取自 `Os.uname().release`，形如
  /// `6.6.89-android15-8-g1f71897ac249-ab13551234`。
  String kernelRelease;

  /// 内核版本号，取 [kernelRelease] 第一个 `-` 之前的部分，如 `6.6.89`。
  String kernelVersion;

  /// 内核提交号，形如 `1f71897ac249`；取不到为空串。
  String kernelCommit;

  /// 厂商，`Build.MANUFACTURER` 的小写形式。
  String manufacturer;

  /// 型号，`Build.MODEL` 原值。
  String model;

  /// 内存页大小，取自 `Os.sysconf(OsConstants._SC_PAGESIZE)`。
  int pageSize;
}

/// 设备身份采集原生接口。
///
/// 契约原则：
/// 1. 一次调用取全量身份，避免多次跨通道往返；
/// 2. 不抛异常，失败以空串 / 0 表达；
/// 3. 不缓存任何路径，`nativeLibraryDir` 每次现读。
@HostApi()
abstract class DeviceIdentityNative {
  /// 读取当前设备身份。
  @async
  DeviceIdentity read();

  /// 读取本 App 的原生库解压目录（`nativeLibraryDir`）。
  ///
  /// 打进 `jniLibs` 的 so 由 PackageManager 解压到这里，权限
  /// `-rwxr-xr-x system system`，shell（uid=2000）能直接 `LD_PRELOAD`。
  ///
  /// 路径含安装随机后缀，每次安装/更新都会变，**调用方不得缓存**。
  /// 返回空串表示目录不可用（`android:extractNativeLibs=false` 时 so
  /// 留在 APK 内不解压）。
  @async
  String nativeLibraryDir();
}
