import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_builtin_wallet.freezed.dart';

/// 内置面板账户的钱包信息。
///
/// 当前只承载可用余额；余额单位与面板一致（美元），
/// 展示格式由界面负责，实体本身不做格式化。
@freezed
abstract class AiBuiltinWallet with _$AiBuiltinWallet {
  const AiBuiltinWallet._();

  const factory AiBuiltinWallet({required double balance}) = _AiBuiltinWallet;

  /// 余额是否低于给定阈值。
  bool isBelow(double threshold) => balance < threshold;
}
