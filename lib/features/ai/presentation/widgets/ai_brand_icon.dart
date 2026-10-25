import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 已知的模型服务品牌，用于给配置卡片配一个可辨识的图标与配色。
enum AiBrand { openai, anthropic, deepseek, moonshot, gemini, qwen, generic }

/// 品牌视觉：渐变底色 + 图标。
class AiBrandStyle {
  const AiBrandStyle({required this.colors, required this.icon});

  final List<Color> colors;
  final IconData icon;
}

/// 根据地址、模型名与配置名推断品牌。
AiBrand resolveAiBrand({String? apiUrl, String? modelName, String? name}) {
  final String source =
      '${apiUrl ?? ''} ${modelName ?? ''} ${name ?? ''}'.toLowerCase();
  if (source.contains('anthropic') || source.contains('claude')) {
    return AiBrand.anthropic;
  }
  if (source.contains('deepseek')) return AiBrand.deepseek;
  if (source.contains('moonshot') || source.contains('kimi')) {
    return AiBrand.moonshot;
  }
  if (source.contains('gemini') || source.contains('generativelanguage')) {
    return AiBrand.gemini;
  }
  if (source.contains('qwen') ||
      source.contains('dashscope') ||
      source.contains('tongyi')) {
    return AiBrand.qwen;
  }
  if (source.contains('openai') ||
      source.contains('gpt') ||
      source.contains('o1-') ||
      source.contains('o3-') ||
      source.contains('o4-')) {
    return AiBrand.openai;
  }
  return AiBrand.generic;
}

AiBrandStyle aiBrandStyle(AiBrand brand, ColorScheme scheme) =>
    switch (brand) {
      AiBrand.openai => const AiBrandStyle(
        colors: <Color>[Color(0xFF19C39C), Color(0xFF0E8C6D)],
        icon: Icons.auto_awesome_rounded,
      ),
      AiBrand.anthropic => const AiBrandStyle(
        colors: <Color>[Color(0xFFE08A66), Color(0xFFB85C3E)],
        icon: Icons.psychology_alt_rounded,
      ),
      AiBrand.deepseek => const AiBrandStyle(
        colors: <Color>[Color(0xFF5B7BFF), Color(0xFF2F4BE0)],
        icon: Icons.waves_rounded,
      ),
      AiBrand.moonshot => const AiBrandStyle(
        colors: <Color>[Color(0xFF7C6BFF), Color(0xFF4A3ACB)],
        icon: Icons.nightlight_round,
      ),
      AiBrand.gemini => const AiBrandStyle(
        colors: <Color>[Color(0xFF4285F4), Color(0xFF9B72CB)],
        icon: Icons.diamond_rounded,
      ),
      AiBrand.qwen => const AiBrandStyle(
        colors: <Color>[Color(0xFF7A5CFF), Color(0xFF4C2FD6)],
        icon: Icons.hexagon_outlined,
      ),
      AiBrand.generic => AiBrandStyle(
        colors: <Color>[scheme.primary, scheme.tertiary],
        icon: Icons.smart_toy_rounded,
      ),
    };

/// 品牌图标块：渐变底 + 白色图标，尺寸由 [size] 决定。
class AiBrandIcon extends HookWidget {
  const AiBrandIcon({super.key, required this.brand, this.size = 20});

  final AiBrand brand;
  final double size;

  @override
  Widget build(BuildContext context) {
    final AiBrandStyle style = aiBrandStyle(brand, Theme.of(context).colorScheme);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: style.colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.32),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: style.colors.first.withValues(alpha: 0.32),
            blurRadius: size * 0.36,
            offset: Offset(0, size * 0.10),
          ),
        ],
      ),
      child: Icon(style.icon, size: size * 0.54, color: Colors.white),
    );
  }
}
