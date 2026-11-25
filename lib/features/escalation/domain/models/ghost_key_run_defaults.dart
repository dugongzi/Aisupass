import 'package:freezed_annotation/freezed_annotation.dart';

part 'ghost_key_run_defaults.freezed.dart';

/// GhostKey 的运行偏好。
///
/// 与 `Cve98260Request` 的区别：Request 是**本次运行**的入参，本类是**跨运行持久**
/// 的偏好。字段语义相同，来源不同——本类落在 `KeyValueStore`，Request 由 Impl
/// 每次现装。
///
/// 移交管理器不再作为偏好：选中的 root 管理器是全局状态，每次运行都按它移交。
@freezed
abstract class GhostKeyRunDefaults with _$GhostKeyRunDefaults {
  const GhostKeyRunDefaults._();

  const factory GhostKeyRunDefaults({
    /// 是否接受 `calibrate-b` 的 `fallback` 置信度。
    required bool acceptFallbackPageOffset,
  }) = _GhostKeyRunDefaults;
}
