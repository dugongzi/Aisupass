/// 判断一条 AI 请求错误是否「换个配置就能解决」。
///
/// 对话失败时只拿得到一段错误文案（状态码可能夹在其中，也可能只有服务端
/// 的中英文提示），因此这里按状态码与关键字两类线索判断：额度不足、密钥
/// 无效、权限不足、分组或模型不可用、限流，都属于去 AI 配置页能处理的；
/// 纯网络错误（超时、DNS 失败）不在此列。
///
/// 纯字符串判断，不依赖任何层，故放在 `core/utils`。
bool isAiConfigRelatedError(String message) {
  final String text = message.trim().toLowerCase();
  if (text.isEmpty) return false;

  for (final int code in _configErrorStatusCodes) {
    if (text.contains('$code')) return true;
  }
  return _configErrorKeywords.any(text.contains);
}

/// 需要引导用户去配置页的 HTTP 状态码。
const List<int> _configErrorStatusCodes = <int>[
  401, // 未授权：密钥无效或过期
  402, // 需付费：余额不足
  403, // 无权限：密钥被禁用或分组受限
  429, // 限流：渠道或额度受限
  500, // 上游异常：换分组可能绕开
  502,
  503,
  504,
];

/// 需要引导用户去配置页的错误关键字，覆盖中英文常见措辞。
const List<String> _configErrorKeywords = <String>[
  '余额不足',
  '额度不足',
  '余额',
  '额度',
  '欠费',
  '充值',
  'insufficient',
  'quota',
  'balance',
  'credit',
  'billing',
  'unauthorized',
  'invalid api key',
  'invalid_api_key',
  'api key',
  '密钥',
  '未授权',
  '认证失败',
  'no available channel',
  '无可用渠道',
  '分组',
  'group',
  'model not found',
  '模型不存在',
  // 模型侧内容安全拒绝：换分组无效，但用户确实要去配置页换模型。
  'refusal',
  'content_filter',
  '拒绝',
  '内容安全',
];
