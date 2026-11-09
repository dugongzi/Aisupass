import 'package:freezed_annotation/freezed_annotation.dart';

part 'vr_derive_progress.freezed.dart';

/// 提取进度的即时快照。
///
/// [phase] 为 0 表示下载字节，为 1 表示解包；两者单位不同，不跨阶段比较。
@freezed
abstract class VrDeriveProgress with _$VrDeriveProgress {
  const VrDeriveProgress._();

  const factory VrDeriveProgress({
    /// 阶段：0 下载，1 解包。
    required int phase,

    /// 本阶段已完成量。
    required int done,

    /// 本阶段总量；未知时为 `0`。
    required int total,
  }) = _VrDeriveProgress;

  /// 是否处于下载阶段。
  bool get downloading => phase == 0;

  /// 完成比例 0..1；总量未知时为 `0`。
  double get fraction => total <= 0 ? 0 : (done / total).clamp(0, 1).toDouble();
}
