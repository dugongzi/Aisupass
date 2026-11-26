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

/// 渠道状态看板，选分组前用它判断哪个分组的渠道更健康。
const String builtinAiConfigMonitorUrl =
    'https://v2.muxueai.pro/monitor/public';

/// 额度说明与获取方式的文档地址。
const String builtinAiConfigCreditDocUrl =
    'https://www.yuque.com/ababa-haoqq/ykpku4/gpvqwygqvbfqsetd?singleDoc#';

/// 新建密钥的名称前缀，便于在面板上识别来源。
const String builtinAiConfigKeyNamePrefix = 'Aisupass';

/// 额度低于该值时界面标红提醒，单位与面板一致（美元）。
const double builtinAiConfigLowBalanceThreshold = 1.0;

/// 内置面板的登录页，内置浏览器从这里进入注册 / 登录流程。
const String builtinAiConfigLoginUrl = 'https://v2.muxueai.pro/login';

/// 内置面板接口前缀，与面板前端的 `/api/v1` 一致。
const String builtinAiConfigApiPath = '/api/v1';

/// 登录令牌的存储键，存于安全存储。
const String builtinAiConfigAuthTokenKey = 'ai_builtin_auth_token';

/// 已绑定分组 id 的存储键，存于普通配置。
const String builtinAiConfigGroupIdKey = 'ai_config_builtin_group_id';

/// 已绑定分组名的存储键，存于普通配置。
const String builtinAiConfigGroupNameKey = 'ai_config_builtin_group_name';

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
