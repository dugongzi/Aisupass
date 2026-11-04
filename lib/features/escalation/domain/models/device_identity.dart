import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_identity.freezed.dart';

/// 参与载荷匹配的设备身份快照。
///
/// 所有字段非空：[identityText] 用于机型关键词召回，[kernelVersion] 用空串
/// 表达「读不出来」，比可空类型更容易在匹配时被显式排除。
@freezed
abstract class DeviceIdentity with _$DeviceIdentity {
  const DeviceIdentity._();

  const factory DeviceIdentity({
    /// 机型关键词拼接串，已小写、去重，如 `vivo iqoo 13 v2463a`。
    required String identityText,

    /// 完整内核串，如 `6.6.57-android14-11-g1a2b3c4d5e6f`。
    required String kernelRelease,

    /// 内核版本号，取 [kernelRelease] 第一个 `-` 之前的部分。
    required String kernelVersion,

    /// 内核 commit 短哈希；取不到时为空串。
    required String kernelCommit,

    /// 厂商，如 `vivo` / `Xiaomi`。
    required String manufacturer,

    /// 出厂型号代码，如 `V2463A`。
    required String model,

    /// 系统页大小（字节）。
    required int pageSize,
  }) = _DeviceIdentity;

  /// 内核版本是否未知。
  bool get kernelUnknown => kernelVersion.isEmpty;

  /// 内核大版本 + 小版本，如 `6.6.57` → `6.6`。无法解析时返回空串。
  String get kernelSeries {
    final List<String> parts = kernelVersion.split('.');
    return parts.length >= 2 ? '${parts[0]}.${parts[1]}' : '';
  }
}
