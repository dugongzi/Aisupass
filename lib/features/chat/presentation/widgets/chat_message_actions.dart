import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/chat/domain/models/chat_turn.dart';
import 'package:Aisupass/features/chat/presentation/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

/// 回答末尾的信息行与操作按钮。
///
/// 左侧是 token 消耗、总耗时与回答时间，右侧是复制、分享与重新生成。
/// 只在回答结束后显示，流式过程中不占位。
class ChatMessageActions extends HookConsumerWidget {
  const ChatMessageActions({super.key, required this.turn});

  final ChatTurn turn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDesktop = isDesktopPlatform;
    final ColorScheme colors = context.colorScheme;
    final Color muted = colors.onSurfaceVariant.withValues(alpha: 0.62);
    final String text = turn.text.trim();

    final List<String> info = <String>[
      if (turn.usage != null && !turn.usage!.isEmpty)
        context.l10n.chatUsageTokens(turn.usage!.totalTokens),
      if (turn.duration != null)
        context.l10n.chatElapsed(_formatSeconds(turn.duration!)),
      if (turn.createdAt != null) _formatClock(turn.createdAt!),
    ];

    Future<void> handleCopy() async {
      await Clipboard.setData(ClipboardData(text: text));
      if (!context.mounted) return;
      ToastMessage.success(context.l10n.chatCopied);
    }

    Future<void> handleShare() async {
      try {
        await SharePlus.instance.share(ShareParams(text: text));
      } catch (_) {
        if (!context.mounted) return;
        ToastMessage.error(context.l10n.chatShareFailed);
      }
    }

    return Padding(
      padding: EdgeInsets.only(top: isDesktop ? 6 : 6.h),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              info.join(' · '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isDesktop ? 10.5 : 10.5.sp,
                height: 1.2,
                color: muted,
              ),
            ),
          ),
          SizedBox(width: isDesktop ? 8 : 8.w),
          _ActionButton(
            icon: Icons.copy_rounded,
            label: context.l10n.chatActionCopy,
            color: muted,
            onTap: text.isEmpty ? null : handleCopy,
          ),
          _ActionButton(
            icon: Icons.ios_share_rounded,
            label: context.l10n.chatActionShare,
            color: muted,
            onTap: text.isEmpty ? null : handleShare,
          ),
          _ActionButton(
            icon: Icons.refresh_rounded,
            label: context.l10n.chatActionRegenerate,
            color: muted,
            onTap: () => ref
                .read(chatControllerProvider.notifier)
                .regenerate(turn.id),
          ),
        ],
      ),
    );
  }
}

/// 单个操作按钮：桌面端图标 + 文案，移动端只留图标并用 Tooltip 说明。
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDesktopPlatform;
    final double iconSize = isDesktop ? 14 : 14.sp;
    final Color tint = onTap == null ? color.withValues(alpha: 0.4) : color;

    final Widget content = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 6 : 6.w,
        vertical: isDesktop ? 3 : 3.h,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: iconSize, color: tint),
          if (isDesktop) ...<Widget>[
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 11, height: 1.2, color: tint),
            ),
          ],
        ],
      ),
    );

    return Tooltip(
      message: label,
      waitDuration: const Duration(milliseconds: 400),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isDesktop ? 6 : 6.r),
        child: content,
      ),
    );
  }
}

/// 秒数保留一位小数，避免出现「耗时 3s」这类过度取整。
String _formatSeconds(Duration duration) {
  return (duration.inMilliseconds / 1000).toStringAsFixed(1);
}

/// 回答时间只保留时分。
String _formatClock(DateTime time) {
  final String hour = time.hour.toString().padLeft(2, '0');
  final String minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
