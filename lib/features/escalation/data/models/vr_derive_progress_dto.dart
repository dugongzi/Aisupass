import 'package:Aisupass/features/escalation/domain/models/vr_derive_progress.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'vr_derive_progress_dto.freezed.dart';
part 'vr_derive_progress_dto.g.dart';

/// 进度快照的 DTO。
///
/// 原生只回 `"<phase> <done> <total>"` 这种三元组串，解析在 [fromNative]。
@freezed
abstract class VrDeriveProgressDto with _$VrDeriveProgressDto {
  const VrDeriveProgressDto._();

  const factory VrDeriveProgressDto({
    @Default(0) int phase,
    @Default(0) int done,
    @Default(0) int total,
  }) = _VrDeriveProgressDto;

  factory VrDeriveProgressDto.fromJson(Map<String, dynamic> json) =>
      _$VrDeriveProgressDtoFromJson(json);

  /// 解析原生返回的三元组串。
  ///
  /// 字段缺失、非数字、负数一律当 `0`：进度丢一帧不影响功能，
  /// 不值得为它抛异常打断提取。
  factory VrDeriveProgressDto.fromNative(String raw) {
    final List<String> parts = raw.trim().split(' ');
    int at(int index) {
      if (index >= parts.length) return 0;
      final int? value = int.tryParse(parts[index]);
      return value == null || value < 0 ? 0 : value;
    }

    return VrDeriveProgressDto(
      phase: at(0),
      done: at(1),
      total: at(2),
    );
  }

  /// 转成领域实体。
  VrDeriveProgress toEntity() => VrDeriveProgress(
    phase: phase,
    done: done,
    total: total,
  );
}
