import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/models/command_channel.dart';
import 'package:Aisupass/core/providers/command_channel_provider.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 终端当前跑在哪条命令通道上。
///
/// 存在的理由：两条通道都就绪时，终端页顶部都是空白（未连接提示只在异常态出现），
/// 用户无法判断屏幕上的 shell 是 adb 的还是本机特权服务的。两者的权限相同
/// （都是 uid 2000）但生存条件不同——ADB 通道依赖无线调试保持连接，Stellar
/// 通道脱离 adbd 后不受无线调试开关影响，排查问题时这个区别很关键。
///
/// 只做展示，不承载切换动作：切换入口在设置页，通道是有持久化的全局选择，
/// 不该在终端里被顺手改掉。
class TerminalChannelChip extends HookConsumerWidget {
  const TerminalChannelChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CommandChannel channel = ref.watch(commandChannelControllerProvider);
    final AppLocalizations l10n = context.l10n;
    final ColorScheme colors = context.colorScheme;

    final bool stellar = channel == CommandChannel.stellar;
    final Color tone = stellar ? colors.tertiary : colors.primary;

    return Tooltip(
      message: stellar ? l10n.terminalChannelStellarHint : l10n.terminalChannelAdbHint,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: tone.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: tone.withValues(alpha: 0.35)),
        ),
        child: Text(
          stellar ? l10n.commandChannelStellar : l10n.commandChannelAdb,
          style: TextStyle(
            fontSize: 11.sp,
            height: 1.2,
            fontWeight: FontWeight.w600,
            color: tone,
          ),
        ),
      ),
    );
  }
}
