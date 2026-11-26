// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_builtin_wallet_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiBuiltinWalletDto _$AiBuiltinWalletDtoFromJson(Map<String, dynamic> json) =>
    _AiBuiltinWalletDto(
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      frozenBalance: (json['frozen_balance'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$AiBuiltinWalletDtoToJson(_AiBuiltinWalletDto instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'frozen_balance': instance.frozenBalance,
    };
