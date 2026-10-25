import 'package:pigeon/pigeon.dart';

/// 系统状态原生接口。
///
/// 由 Pigeon 生成 Dart 与 Kotlin 两侧代码，方法签名只有这一份定义，
/// 改名字或改参数时两侧同时失效，不会出现「字符串方法名写错、运行时才炸」。
@HostApi()
abstract class SystemStatusNative {
  /// 是否具备 ROOT 权限。
  ///
  /// 通过 `su -c id` 判定：授权成功且退出码为 0 才算已 ROOT。
  /// 放在后台线程执行，首次会弹出 ROOT 授权框，超时按未 ROOT 处理。
  @async
  bool isRoot();

  /// ADB 调试开关状态。
  ///
  /// 读 `Settings.Global` 判断开关，再用 `sys.usb.state` 区分有线是否真正生效，
  /// 需要执行 `getprop`，所以放到后台线程。
  @async
  AdbStatus isAdbEnabled();
}

/// ADB 调试开关。
class AdbStatus {
  AdbStatus({required this.usb, required this.wifi});

  /// 有线（USB）调试。
  bool usb;

  /// 无线调试。
  bool wifi;
}
