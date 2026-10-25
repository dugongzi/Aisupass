import 'package:Aisupass/features/ai/domain/enums/ai_api_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_config.freezed.dart';

/// 单条 AI 服务配置。
///
/// 业务实体，序列化由 data 层的 `AiConfigDto` 负责。
@freezed
abstract class AiConfig with _$AiConfig {
  const AiConfig._();

  const factory AiConfig({
    required String id,
    required String name,
    required String apiUrl,
    required String apiKey,
    required String modelName,

    /// 最大输出 Token，`0` 表示沿用服务端默认值。
    required int maxToken,

    /// 采样温度，`-1` 表示沿用服务端默认值。
    required double temperature,
    required AiApiType apiType,
  }) = _AiConfig;

  bool get hasApiKey => apiKey.trim().isNotEmpty;

  bool get hasModel => modelName.trim().isNotEmpty;
}
