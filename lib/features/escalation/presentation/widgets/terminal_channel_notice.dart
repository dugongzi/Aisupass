import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/models/command_channel.dart';
import 'package:Aisupass/core/providers/command_channel_provider.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 终端页顶部的通道提示：终端需要无线 ADB 通道。
///
/// 命令通道切到别的通道后，这条常驻 pty 会话不会建立；不提示的话用户面对的是
/// 一块永远不出提示符的黑屏，看起来像卡死。
class TerminalChannelNotice extends ConsumerWidget {
  const TerminalChannelNotice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CommandChannel channel = ref.watch(commandChannelControllerProvider);
    if (channel == CommandChannel.adb) return const SizedBox.shrink();

    final AppLocalizations l10n = context.l10n;
    final ColorScheme colors = context.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 8.w, 10.h),
      color: colors.surfaceContainerHigh,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.info_outline_rounded,
            size: 16.sp,
            color: colors.onSurfaceVariant,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              l10n.escalationTerminalAdbOnly,
              style: TextStyle(
                fontSize: 11.5.sp,
                height: 1.35,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          TextButton(
            onPressed: () => ref
                .read(commandChannelControllerProvider.notifier)
                .setChannel(CommandChannel.adb),
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
            ),
            child: Text(
              l10n.commandChannelSwitchToAdb,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
