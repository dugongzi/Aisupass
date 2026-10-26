import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 对话输入栏：多行输入 + 发送/停止。
///
/// 桌面端支持 Enter 发送、Shift + Enter 换行。
class ChatInputBar extends HookWidget {
  const ChatInputBar({
    super.key,
    required this.streaming,
    required this.onSend,
    required this.onStop,
  });

  final bool streaming;
  final ValueChanged<String> onSend;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDark = context.isDark;
    final bool isDesktop = isDesktopPlatform;
    final TextEditingController controller = useTextEditingController();
    final TextEditingValue value = useValueListenable(controller);
    final bool canSend = value.text.trim().isNotEmpty;

    void submit() {
      if (streaming || !canSend) return;
      final String text = controller.text.trim();
      controller.clear();
      onSend(text);
    }

    final double radius = isDesktop ? 22 : 22.r;

    Widget field = TextField(
      controller: controller,
      minLines: 1,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      style: TextStyle(
        fontSize: isDesktop ? 14 : 14.sp,
        height: 1.45,
        color: colors.onSurface,
      ),
      decoration: InputDecoration(
        hintText: context.l10n.chatInputHint,
        hintStyle: TextStyle(
          fontSize: isDesktop ? 13.5 : 13.5.sp,
          color: colors.onSurfaceVariant.withValues(alpha: 0.8),
        ),
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 16 : 16.w,
          vertical: isDesktop ? 12 : 12.h,
        ),
      ),
    );

    if (isDesktop) {
      field = Shortcuts(
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.enter): _SendIntent(),
          SingleActivator(LogicalKeyboardKey.numpadEnter): _SendIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            _SendIntent: CallbackAction<_SendIntent>(
              onInvoke: (_) {
                submit();
                return null;
              },
            ),
          },
          child: field,
        ),
      );
    }

    final Widget row = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Container(
            constraints: BoxConstraints(minHeight: isDesktop ? 44 : 44.h),
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest.withValues(
                alpha: isDark ? 0.35 : 0.5,
              ),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: colors.outline.withValues(
                  alpha: isDark ? 0.26 : 0.14,
                ),
              ),
            ),
            child: field,
          ),
        ),
        SizedBox(width: isDesktop ? 10 : 10.w),
        _SendButton(
          streaming: streaming,
          enabled: canSend,
          onSend: submit,
          onStop: onStop,
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 24 : 16.w,
        isDesktop ? 10 : 10.h,
        isDesktop ? 24 : 16.w,
        isDesktop ? 14 : 10.h,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(
            color: colors.outline.withValues(alpha: isDark ? 0.22 : 0.12),
          ),
        ),
      ),
      child: isDesktop
          ? Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: row,
              ),
            )
          : row,
    );
  }
}

class _SendIntent extends Intent {
  const _SendIntent();
}

class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.streaming,
    required this.enabled,
    required this.onSend,
    required this.onStop,
  });

  final bool streaming;
  final bool enabled;
  final VoidCallback onSend;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;
    final bool active = streaming || enabled;

    return Tooltip(
      message: streaming ? context.l10n.chatStop : context.l10n.chatSend,
      child: SizedBox(
        width: isDesktop ? 44 : 44.w,
        height: isDesktop ? 44 : 44.h,
        child: Material(
          color: active
              ? colors.primary
              : colors.onSurface.withValues(alpha: 0.08),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: streaming ? onStop : (enabled ? onSend : null),
            child: Icon(
              streaming ? Icons.stop_rounded : Icons.arrow_upward_rounded,
              size: isDesktop ? 20 : 20.sp,
              color: active
                  ? colors.onPrimary
                  : colors.onSurfaceVariant.withValues(alpha: 0.55),
            ),
          ),
        ),
      ),
    );
  }
}
