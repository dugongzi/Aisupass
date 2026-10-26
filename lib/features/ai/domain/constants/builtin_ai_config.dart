import 'package:Aisupass/features/ai/domain/enums/ai_api_type.dart';
import 'package:Aisupass/features/ai/domain/models/ai_config.dart';

/// 内置服务：沐雪接口。
///
/// 内置配置不写入用户配置列表的存储，而是读取时由 `aiConfigProvider`
/// 拼在列表最前；写入时只落用户可改的字段，避免被当成普通配置整表覆盖。
const String builtinAiConfigId = 'builtin_muxue';
const String builtinAiConfigName = '沐雪接口';
const String builtinAiConfigBaseUrl = 'https://v2.muxueai.pro';

/// 获取 API Key 的站点。
const String builtinAiConfigPurchaseUrl = 'https://muxueai.pro';

/// 内置配置的默认最大输出 Token。
const int builtinAiConfigMaxToken = 4096;

/// 内置配置的默认采样温度。
const double builtinAiConfigTemperature = 1.0;

/// 组装内置配置。
///
/// 名称与地址由服务方决定；协议、模型、API Key 由用户在编辑页填写，
/// 各自单独持久化后在这里合并，不做硬编码。
AiConfig buildBuiltinAiConfig({
  required AiApiType apiType,
  String apiKey = '',
  String modelName = '',
}) => AiConfig(
  id: builtinAiConfigId,
  name: builtinAiConfigName,
  apiUrl: builtinAiConfigBaseUrl,
  apiKey: apiKey,
  modelName: modelName,
  maxToken: builtinAiConfigMaxToken,
  temperature: builtinAiConfigTemperature,
  apiType: apiType,
);

bool isBuiltinAiConfigId(String id) => id == builtinAiConfigId;

bool isBuiltinAiConfig(AiConfig config) => isBuiltinAiConfigId(config.id);
