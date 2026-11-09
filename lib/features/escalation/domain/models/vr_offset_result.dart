import 'package:freezed_annotation/freezed_annotation.dart';

part 'vr_offset_result.freezed.dart';

/// 一次离线 vr 偏移提取的结果。
///
/// 取值来自 Rust 侧返回的 JSON，解析在 [VrOffsetResultDto] 完成。
@freezed
abstract class VrOffsetResult with _$VrOffsetResult {
  const VrOffsetResult._();

  const factory VrOffsetResult({
    /// 是否提取成功。
    required bool ok,

    /// `struct tracepoint` 里 `funcs` 的成员偏移；失败时为 `0`。
    ///
    /// 成功时取值区间为 `1..256`，可直接喂给 `--vr-off`。
    required int member,

    /// 内核 release 串；未取到为空串。
    required String release,

    /// 失败原因；成功时为空串。
    required String error,
  }) = _VrOffsetResult;

  /// 偏移是否可用于 `--vr-off`。
  bool get usable => ok && member > 0 && member <= 256;
}
