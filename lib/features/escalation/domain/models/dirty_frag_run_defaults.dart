import 'package:freezed_annotation/freezed_annotation.dart';

part 'dirty_frag_run_defaults.freezed.dart';

/// 运行默认值：设置页四个开关的当前值。
///
/// 与 `DirtyFragRequest` 的区别：Request 是**本次运行**的入参，
/// 本类是**跨运行持久**的偏好。两者字段语义相同，来源不同。
@freezed
abstract class DirtyFragRunDefaults with _$DirtyFragRunDefaults {
  const DirtyFragRunDefaults._();

  const factory DirtyFragRunDefaults({
    /// 是否启用 VR 反制。仅 vivo `vr.ko` 机型需要开。
    required bool vrDisarm,

    /// 是否由内核 BTF 自动解析偏移。
    required bool vrAuto,

    /// 手动偏移；[vrAuto] 为 true 时忽略。取值 1..256，`0` 表示从未设过。
    required int vrOffset,

    /// 成功后是否让管理器 soft-reboot。
    required bool softReboot,
  }) = _DirtyFragRunDefaults;

  /// 手动偏移是否已设过且合法。
  bool get hasManualOffset => vrOffset >= 1 && vrOffset <= 256;

  /// 本次运行需要传手动偏移吗（开了反制且没开自动解析）。
  bool get needsManualOffset => vrDisarm && !vrAuto;
}
