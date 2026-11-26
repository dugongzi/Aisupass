import 'package:Aisupass/features/ai/domain/enums/ai_api_type.dart';
import 'package:Aisupass/features/ai/domain/models/ai_builtin_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_builtin_group.freezed.dart';

/// 内置面板中的一个可绑定分组。
///
/// 模型清单随分组一起下发，选中分组后无需再请求一次。
@freezed
abstract class AiBuiltinGroup with _$AiBuiltinGroup {
  const AiBuiltinGroup._();

  const factory AiBuiltinGroup({
    required int id,
    required String name,
    required String description,
    required String platform,
    required double rateMultiplier,
    required bool isExclusive,
    required List<AiBuiltinModel> models,
  }) = _AiBuiltinGroup;

  /// 该分组应使用的请求协议。
  ///
  /// 平台名只区分 Anthropic 与其它：`anthropic` 走 Messages，
  /// 其余（含 `openai`、`gemini`、`grok` 等）按 OpenAI 兼容协议处理，
  /// 未知平台同样落到 OpenAI 兼容分支，与 [AiApiType.fromName] 的兜底一致。
  AiApiType get apiType =>
      platform.trim().toLowerCase() == 'anthropic'
      ? AiApiType.anthropic
      : AiApiType.openai;

  /// 平台展示名。
  ///
  /// 均为厂商/产品专有名词，不做翻译，与 [AiApiType.label] 的处理一致；
  /// 未收录的平台直接回显原始标识，避免把标识吞成空串。
  String get platformLabel => switch (platform.trim().toLowerCase()) {
    'openai' => 'OpenAI',
    'anthropic' => 'Anthropic',
    'gemini' => 'Google Gemini',
    'grok' => 'xAI Grok',
    'composite' => 'Composite',
    'typesafe' => 'TypeSafe',
    _ => platform.trim(),
  };
}
