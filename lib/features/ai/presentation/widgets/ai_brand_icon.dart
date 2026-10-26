import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 已收录的品牌图标（simple-icons，CC0-1.0），颜色取各家官方品牌色。
enum AiBrand {
  openai('openai', Color(0xFF412991)),
  anthropic('anthropic', Color(0xFF191919)),
  claude('claude', Color(0xFFD97757)),
  deepseek('deepseek', Color(0xFF5786FE)),
  moonshot('moonshotai', Color(0xFF000000)),
  gemini('googlegemini', Color(0xFF8E75B2)),
  mistral('mistralai', Color(0xFFFA520F)),
  ollama('ollama', Color(0xFF000000)),
  qwen('qwen', Color(0xFF6950EF)),
  perplexity('perplexity', Color(0xFF1FB8CD)),
  glm('glm', Color(0xFF3B82F6)),
  groq('groq', Color(0xFFF55036)),
  xai('xai', Color(0xFF000000)),
  meta('meta', Color(0xFF0668E1)),
  minimax('minimax', Color(0xFF5B5CE2)),
  cohere('cohere', Color(0xFF39594D)),
  baichuan('baichuan', Color(0xFF3D7EFF)),
  yi('01ai', Color(0xFF111111)),
  internlm('internlm', Color(0xFF1677FF)),
  doubao('doubao', Color(0xFF3370FF)),
  llama('llama', Color(0xFF0668E1)),
  grok('grok', Color(0xFF000000)),
  stepfun('stepfun', Color(0xFF5B5CE2)),
  tencent('tencent', Color(0xFF0052D9)),
  amazon('amazon', Color(0xFFFF9900)),
  microsoft('microsoft', Color(0xFF5E5E5E)),
  ai21('ai21', Color(0xFF6C47FF));

  const AiBrand(this.assetName, this.brandColor);

  final String assetName;

  /// 官方品牌色。
  final Color brandColor;

  String get assetPath => 'assets/images/ai_icons/$assetName.svg';

  /// 在给定亮度下实际可用的着色。
  ///
  /// 多数品牌色（如 DeepSeek 蓝、Claude 橙）是中间明度，两种主题下都清晰；
  /// 但 Moonshot / Ollama 的纯黑、Anthropic 的近黑在深色背景上会隐形，
  /// 因此过暗的品牌色在深色模式下按原色相提亮，无色相的则转浅灰。
  Color resolveColor({required bool isDark}) {
    if (!isDark) return brandColor;

    final HSLColor hsl = HSLColor.fromColor(brandColor);
    if (hsl.lightness >= 0.55) return brandColor;

    // 近乎无彩色的品牌（纯黑/近黑）没有可提亮的色相，改用中性浅色。
    if (hsl.saturation < 0.08) return const Color(0xFFE6E6E6);

    return hsl
        .withLightness(hsl.lightness < 0.35 ? 0.72 : 0.80)
        .withSaturation(hsl.saturation.clamp(0.55, 1.0))
        .toColor();
  }

  /// 依据接口地址/模型名/配置名推断服务商，识别不出返回 null。
  static AiBrand? resolve({String? apiUrl, String? modelName, String? name}) {
    final String haystack = <String>[
      apiUrl ?? '',
      modelName ?? '',
      name ?? '',
    ].join(' ').toLowerCase();

    if (haystack.trim().isEmpty) return null;

    // 关键词顺序敏感：产品品牌优先于公司品牌。
    const List<(AiBrand, List<String>)> matchers = <(AiBrand, List<String>)>[
      (AiBrand.claude, <String>['claude']),
      (AiBrand.anthropic, <String>['anthropic']),
      (AiBrand.deepseek, <String>['deepseek']),
      (AiBrand.moonshot, <String>['moonshot', 'kimi', '月之暗面']),
      (
        AiBrand.gemini,
        <String>['gemini', 'generativelanguage', 'googleapis'],
      ),
      (AiBrand.mistral, <String>['mistral']),
      (AiBrand.ollama, <String>['ollama']),
      (AiBrand.qwen, <String>['qwen', 'dashscope', '通义']),
      (AiBrand.perplexity, <String>['perplexity']),
      (AiBrand.glm, <String>['glm', 'chatglm', 'zhipu', '智谱', '清言']),
      (AiBrand.groq, <String>['groq']),
      (AiBrand.xai, <String>['x.ai', 'grok', 'xai']),
      (AiBrand.meta, <String>['llama', 'meta']),
      (AiBrand.minimax, <String>['minimax', 'abab']),
      (AiBrand.cohere, <String>['cohere', 'command-r']),
      (AiBrand.baichuan, <String>['baichuan', '百川']),
      (AiBrand.yi, <String>['01.ai', '01ai', 'yi-']),
      (AiBrand.internlm, <String>['internlm', '书生']),
      (AiBrand.doubao, <String>['doubao', '豆包', 'volcengine']),
      (AiBrand.stepfun, <String>['stepfun', 'step-']),
      (AiBrand.tencent, <String>['hunyuan', '混元', 'tencent']),
      (AiBrand.amazon, <String>['amazon', 'nova', 'bedrock']),
      (AiBrand.microsoft, <String>['azure', 'copilot', 'phi-']),
      (AiBrand.ai21, <String>['ai21', 'jamba']),
      (
        AiBrand.openai,
        <String>['openai', 'gpt-', 'gpt4', 'gpt5', 'o1-', 'o3-', 'o4-'],
      ),
    ];

    for (final (AiBrand brand, List<String> keywords) in matchers) {
      if (keywords.any(haystack.contains)) return brand;
    }
    return null;
  }
}

/// 依据接口地址/模型名/配置名推断服务商，识别不出返回 null。
AiBrand? resolveAiBrand({String? apiUrl, String? modelName, String? name}) =>
    AiBrand.resolve(apiUrl: apiUrl, modelName: modelName, name: name);

/// 品牌图标，按各家官方品牌色着色；无匹配品牌时回退为通用图标。
class AiBrandIcon extends HookWidget {
  const AiBrandIcon({
    super.key,
    this.brand,
    this.size = 22,
    this.fallbackIcon = Icons.smart_toy_outlined,
  });

  final AiBrand? brand;
  final double size;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final AiBrand? brand = this.brand;

    if (brand == null) return _fallback(scheme);

    return SvgPicture.asset(
      brand.assetPath,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        brand.resolveColor(isDark: isDark),
        BlendMode.srcIn,
      ),
      placeholderBuilder: (BuildContext _) => _fallback(scheme),
    );
  }

  Widget _fallback(ColorScheme scheme) =>
      Icon(fallbackIcon, size: size * 0.86, color: scheme.primary);
}
