import 'package:Aisupass/features/ai/domain/models/ai_builtin_wallet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_builtin_wallet_dto.freezed.dart';
part 'ai_builtin_wallet_dto.g.dart';

/// 账户信息的传输对象。
///
/// 只取额度相关字段，其余账户资料不参与本流程。
@freezed
abstract class AiBuiltinWalletDto with _$AiBuiltinWalletDto {
  const AiBuiltinWalletDto._();

  const factory AiBuiltinWalletDto({
    @Default(0) double balance,
    @JsonKey(name: 'frozen_balance') @Default(0) double frozenBalance,
  }) = _AiBuiltinWalletDto;

  factory AiBuiltinWalletDto.fromJson(Map<String, dynamic> json) =>
      _$AiBuiltinWalletDtoFromJson(json);

  /// 转成领域实体。
  AiBuiltinWallet toEntity() => AiBuiltinWallet(balance: balance);
}
