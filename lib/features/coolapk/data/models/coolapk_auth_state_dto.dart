import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/features/coolapk/domain/models/coolapk_auth_state.dart';
import 'package:Aisupass/generated/coolapk_auth.g.dart' as pigeon;

part 'coolapk_auth_state_dto.freezed.dart';

/// 酷安登录态 DTO，承接安全存储与原生 Cookie 的原始取值。
///
/// 数据只来自安全存储与 Pigeon 原生通道，没有 JSON 形态，因此不声明
/// `fromJson`，缺省值由 `@Default` 兜底。
@freezed
abstract class CoolapkAuthStateDto with _$CoolapkAuthStateDto {
  const CoolapkAuthStateDto._();

  const factory CoolapkAuthStateDto({
    @Default('') String cookie,
    @Default('') String uid,
    @Default('') String username,
    @Default('') String captchaValidate,
    @Default(0) int captchaSavedAt,
    @Default(0) int savedAt,
  }) = _CoolapkAuthStateDto;

  /// 原生 `CoolapkCookie` -> 本 DTO：纯字段搬运。
  ///
  /// 原生只给 Cookie，uid 与昵称要靠后续服务端确认，这里留空。
  factory CoolapkAuthStateDto.fromNative(pigeon.CoolapkCookie raw) =>
      CoolapkAuthStateDto(cookie: raw.cookie);

  /// 实体 -> 本 DTO，落盘前用。
  factory CoolapkAuthStateDto.fromEntity(CoolapkAuthState state) =>
      CoolapkAuthStateDto(
        cookie: state.cookie,
        uid: state.uid,
        username: state.username,
        captchaValidate: state.captchaValidate,
        captchaSavedAt: state.captchaSavedAt,
        savedAt: state.savedAt,
      );

  /// 转成领域实体。
  CoolapkAuthState toEntity() => CoolapkAuthState(
    cookie: cookie,
    uid: uid,
    username: username,
    captchaValidate: captchaValidate,
    captchaSavedAt: captchaSavedAt,
    savedAt: savedAt,
  );
}
