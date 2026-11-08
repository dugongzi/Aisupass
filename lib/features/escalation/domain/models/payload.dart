import 'package:freezed_annotation/freezed_annotation.dart';

part 'payload.freezed.dart';

/// 一份机型专属提权载荷的元数据。
///
/// [kernelVersion] 用空串表达「内核版本未知」，不用可空类型；
/// 需要布尔语义时走 [kernelUnknown] 派生 getter。
@freezed
abstract class Payload with _$Payload {
  const Payload._();

  const factory Payload({
    /// 条目标识，catalog 内唯一。
    required String id,

    /// 载荷文件名，如 `libksu_vivo_iqoo13_6657_a.so`。
    required String library,

    /// 厂商，如 `vivo` / `google`。
    required String vendor,

    /// 展示名，如 `iQOO 13（6.6.57）`。
    required String displayName,

    /// 可匹配的机型关键词；无机型登记时为 `<String>[]`。
    required List<String> models,

    /// 内核版本是否未知。未知条目**禁止**进入自动匹配。
    required bool kernelUnknown,

    /// 内核版本，如 `6.6.57`；未知时为空串。
    required String kernelVersion,

    /// 该内核版本下可用的内核 `g<commit>` 前缀集合。
    ///
    /// 空集表示「该条目无 commit 约束」，此时最多只能命中
    /// [MatchTier.sameKernel]，不能进 [MatchTier.exact]。
    required List<String> kernelCommits,

    /// 构建号，仅展示用。
    required String buildId,

    /// 载荷体积（字节），仅用于打包自检。
    required int size,

    /// 载荷摘要，仅用于打包自检。
    required String sha256,

    required String command,

    required bool standalone,

    /// 来源描述，仅展示用。
    required String source,
  }) = _Payload;

  /// 是否为「不限内核版本」的载荷。不限内核时可在任意内核版本下使用。
  bool get kernelAgnostic => !kernelUnknown && kernelVersion.isEmpty;

  /// 内核大版本 + 小版本，如 `6.6.89` → `6.6`。无法解析时返回空串。
  String get kernelSeries {
    final List<String> parts = kernelVersion.split('.');
    return parts.length >= 2 ? '${parts[0]}.${parts[1]}' : '';
  }
}
