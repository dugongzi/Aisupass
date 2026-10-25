/// AI 服务接口协议。
///
/// 只保留实际会用到的两种：OpenAI 兼容协议（多数服务商都兼容）
/// 与 Anthropic Messages 协议。
enum AiApiType {
  openai,
  anthropic;

  /// 协议展示名。属于产品专有名词，不做翻译。
  String get label => switch (this) {
    AiApiType.openai => 'OpenAI Chat Completions',
    AiApiType.anthropic => 'Anthropic Messages',
  };

  /// 选择器里的短名，避免窄屏分段按钮放不下完整名称。
  String get shortLabel => switch (this) {
    AiApiType.openai => 'OpenAI',
    AiApiType.anthropic => 'Anthropic',
  };

  /// 从持久化的枚举名还原，未知值回退到 OpenAI 兼容协议。
  static AiApiType fromName(String? name) {
    for (final AiApiType type in AiApiType.values) {
      if (type.name == name) return type;
    }
    return AiApiType.openai;
  }
}
