import 'package:Aisupass/core/utils/json_value.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_account.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coolapk_account_dto.freezed.dart';
part 'coolapk_account_dto.g.dart';

/// 酷安账号资料 DTO，对应 `/v6/user/profile` 的 `data` 对象。
@freezed
abstract class CoolapkAccountDto with _$CoolapkAccountDto {
  const CoolapkAccountDto._();

  const factory CoolapkAccountDto({
    @JsonKey(name: 'uid', fromJson: stringFromJson) @Default('') String uid,
    @Default('') String username,
    @Default('') String userAvatar,
  }) = _CoolapkAccountDto;

  factory CoolapkAccountDto.fromJson(Map<String, dynamic> json) =>
      _$CoolapkAccountDtoFromJson(json);

  CoolapkAccount toEntity() =>
      CoolapkAccount(uid: uid, username: username, userAvatar: userAvatar);
}
