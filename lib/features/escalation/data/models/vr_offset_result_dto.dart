import 'package:Aisupass/features/escalation/domain/models/vr_offset_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'vr_offset_result_dto.freezed.dart';
part 'vr_offset_result_dto.g.dart';

/// 提取结果的 DTO，字段与 Rust 返回的 JSON 同名。
@freezed
abstract class VrOffsetResultDto with _$VrOffsetResultDto {
  const VrOffsetResultDto._();

  const factory VrOffsetResultDto({
    @Default(false) bool ok,
    @Default(0) int member,
    @Default('') String release,
    @Default('') String error,
  }) = _VrOffsetResultDto;

  factory VrOffsetResultDto.fromJson(Map<String, dynamic> json) =>
      _$VrOffsetResultDtoFromJson(json);

  /// 转成领域实体。
  VrOffsetResult toEntity() => VrOffsetResult(
    ok: ok,
    member: member,
    release: release,
    error: error,
  );
}
