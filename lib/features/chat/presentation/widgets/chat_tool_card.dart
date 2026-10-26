import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/chat/domain/models/chat_turn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 单次工具调用的展示卡片。
///
/// 结果不单独成条消息，而是挂在发起调用的 assistant 轮次里，
/// 保证「调用 → 结果 → 继续输出」在视觉上连续。
class ChatToolCard extends HookWidget {
  const ChatToolCard({super.key, required this.call});

  final ChatToolCall call;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDark = context.isDark;
    final bool isDesktop = isDesktopPlatform;
    final double radius = isDesktop ? 12 : 12.r;
    final ValueNotifier<bool> expanded = useState(false);

    final Color color = switch (call.status) {
      ChatToolStatus.running => colors.primary,
      ChatToolStatus.succeeded => const Color(0xFF4CAF50),
      ChatToolStatus.failed => colors.error,
    };
    final String label = switch (call.status) {
      ChatToolStatus.running => context.l10n.chatToolRunning,
      ChatToolStatus.succeeded => context.l10n.chatToolSucceeded,
      ChatToolStatus.failed => context.l10n.chatToolFailed,
    };

    final String arguments = call.argumentsJson.trim();
    final bool hasArguments =
        arguments.isNotEmpty && arguments != '{}' && arguments != 'null';
    final String result = call.result.trim();
    final bool hasBody =
        hasArguments || result.isNotEmpty || (call.error ?? '').isNotEmpty;

    return Container(
      margin: EdgeInsets.only(bottom: isDesktop ? 10 : 10.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.14 : 0.07),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.32 : 0.26),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(12, 10, 8, 10),
            child: Row(
              children: <Widget>[
                _StatusIcon(status: call.status, color: color),
                SizedBox(width: isDesktop ? 8 : 8.w),
                Expanded(
                  child: Text(
                    '$label · ${call.name.isEmpty ? 'tool' : call.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isDesktop ? 12.5 : 12.5.sp,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
                if (call.duration != null) ...<Widget>[
                  _MetaChip(text: _formatDuration(call.duration!)),
                  SizedBox(width: isDesktop ? 4 : 4.w),
                ],
                if (hasBody)
                  IconButton(
                    onPressed: () => expanded.value = !expanded.value,
                    visualDensity: VisualDensity.compact,
                    iconSize: 18,
                    color: colors.onSurfaceVariant,
                    icon: Icon(
                      expanded.value
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                    ),
                  ),
              ],
            ),
          ),
          if (expanded.value && hasBody)
            Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (hasArguments)
                    _ToolSection(
                      title: context.l10n.chatToolArguments,
                      content: call.argumentsJson,
                      color: color,
                    ),
                  if (result.isNotEmpty)
                    _ToolSection(
                      title: context.l10n.chatToolResult,
                      content: result,
                      color: color,
                    ),
                  if ((call.error ?? '').isNotEmpty)
                    _ToolSection(
                      title: context.l10n.chatToolFailed,
                      content: call.error!,
                      color: colors.error,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

String _formatDuration(Duration duration) {
  final int ms = duration.inMilliseconds;
  if (ms < 1000) return '${ms}ms';
  final double seconds = ms / 1000;
  return '${seconds.toStringAsFixed(seconds >= 10 ? 0 : 1)}s';
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status, required this.color});

  final ChatToolStatus status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (status == ChatToolStatus.running) {
      return SizedBox(
        width: 14,
        height: 14,
        child: CircularProgressIndicator(strokeWidth: 2, color: color),
      );
    }
    return Icon(
      status == ChatToolStatus.succeeded
          ? Icons.check_circle_outline_rounded
          : Icons.error_outline_rounded,
      size: 15,
      color: color,
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDesktopPlatform;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 6 : 6.w,
        vertical: isDesktop ? 2 : 2.h,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isDesktop ? 10.5 : 10.5.sp,
          fontFamily: 'monospace',
          color: context.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _ToolSection extends HookWidget {
  const _ToolSection({
    required this.title,
    required this.content,
    required this.color,
  });

  final String title;
  final String content;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;
    final ValueNotifier<bool> expanded = useState(false);
    final double fontSize = isDesktop ? 11.5 : 11.5.sp;

    return Padding(
      padding: EdgeInsets.only(bottom: isDesktop ? 8 : 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isDesktop ? 11.5 : 11.5.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
              _MiniIconButton(
                icon: expanded.value
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded,
                onTap: () => expanded.value = !expanded.value,
              ),
              _MiniIconButton(
                icon: Icons.copy_rounded,
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: content));
                  if (!context.mounted) return;
                  ToastMessage.success(context.l10n.chatCopied);
                },
              ),
            ],
          ),
          if (expanded.value)
            Container(
              margin: EdgeInsets.only(top: isDesktop ? 4 : 4.h),
              padding: EdgeInsets.all(isDesktop ? 8 : 8.r),
              decoration: BoxDecoration(
                color: colors.onSurface.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(isDesktop ? 8 : 8.r),
              ),
              child: SelectableText(
                content,
                style: TextStyle(
                  fontSize: fontSize,
                  height: 1.45,
                  fontFamily: 'monospace',
                  color: colors.onSurface.withValues(alpha: 0.88),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MiniIconButton extends StatelessWidget {
  const _MiniIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      visualDensity: VisualDensity.compact,
      iconSize: 16,
      color: context.colorScheme.onSurfaceVariant,
      icon: Icon(icon),
    );
  }
}
