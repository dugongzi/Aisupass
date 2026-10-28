import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_fingerprint.freezed.dart';

/// 提权探测所需的设备指纹。
///
/// 只覆盖判定会用到的最小字段集，避免把无关信息带进领域层。
@freezed
abstract class DeviceFingerprint with _$DeviceFingerprint {
  const DeviceFingerprint._();

  const factory DeviceFingerprint({
    required int androidSdk,
    required String abi,
    required String kernelVersion,
    required bool selinuxEnforcing,
    required String manufacturer,
    required String model,
    required bool isEmulator,
  }) = _DeviceFingerprint;

  /// 是否达到本工程要求的最低系统版本（Android 11 / API 30）。
  bool get meetsMinSdk => androidSdk >= 30;
}
