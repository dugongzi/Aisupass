import 'package:Aisupass/features/escalation/domain/models/ghost_key_run_defaults.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ghost_key_run_defaults_dto.freezed.dart';
part 'ghost_key_run_defaults_dto.g.dart';

/// [GhostKeyRunDefaults] 的传输形态。
///
/// 默认值与设置页首次打开时的取值一致：`calib_b` 回 fallback 时默认记降级并继续。
@freezed
abstract class GhostKeyRunDefaultsDto with _$GhostKeyRunDefaultsDto {
  const GhostKeyRunDefaultsDto._();

  const factory GhostKeyRunDefaultsDto({
    @Default(true) bool acceptFallbackPageOffset,
  }) = _GhostKeyRunDefaultsDto;

  factory GhostKeyRunDefaultsDto.fromJson(Map<String, dynamic> json) =>
      _$GhostKeyRunDefaultsDtoFromJson(json);

  GhostKeyRunDefaults toEntity() => GhostKeyRunDefaults(
    acceptFallbackPageOffset: acceptFallbackPageOffset,
  );
}
