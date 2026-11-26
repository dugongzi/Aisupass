import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_builtin_model.freezed.dart';

/// 内置面板中的一个可选模型。
///
/// 价格字段随模型广场一并解析保留，用于后续展示或排序；
/// 当前选择流程只呈现模型名与品牌图标。
@freezed
abstract class AiBuiltinModel with _$AiBuiltinModel {
  const AiBuiltinModel._();

  const factory AiBuiltinModel({
    required String name,
    required String platform,
    required double inputPrice,
    required double outputPrice,
  }) = _AiBuiltinModel;
}
