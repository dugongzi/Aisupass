import 'dart:async';

import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_brand_icon.dart';
import 'package:Aisupass/features/chat/domain/models/chat_turn.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat_markdown.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat_message_actions.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat_notice.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat_reasoning_card.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat_tool_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 单条对话消息。
///
/// assistant 走无气泡瀑布流，正文、思考过程与工具结果在同一轮内依次展开；
/// user 走右侧气泡，保持输入内容的边界感。
class ChatMessageView extends HookWidget {
  const ChatMessageView({
    super.key,
    required this.turn,
    this.brand,
    this.modelName = '',
    this.showModelName = true,
    this.animate = false,
  });

  final ChatTurn turn;
  final AiBrand? brand;
  final String modelName;

  /// 模型名只在会话首条 assistant 消息上显示，避免每条都重复。
  final bool showModelName;

  /// 是否为新插入的消息，插入时做一次淡入上移动画。
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDesktopPlatform;
    final Widget content = turn.isUser
        ? _UserBubble(text: turn.text)
        : _AssistantMessage(
            turn: turn,
            brand: brand,
            modelName: showModelName ? modelName : '',
          );

    return Padding(
      padding: EdgeInsets.only(bottom: isDesktop ? 16 : 16.h),
      child: _EnterTransition(enabled: animate, child: content),
    );
  }
}

/// 入场动画：260ms 淡入 + 轻微上移。
class _EnterTransition extends HookWidget {
  const _EnterTransition({required this.enabled, required this.child});

  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final AnimationController controller = useAnimationController(
      duration: const Duration(milliseconds: 260),
      initialValue: enabled ? 0 : 1,
    );

    useEffect(() {
      if (enabled && controller.value < 1) {
        controller.forward();
      }
      return null;
    }, const <Object?>[]);

    if (!enabled) return child;

    final Animation<double> curved = controller.drive(
      CurveTween(curve: Curves.easeOutCubic),
    );

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}

/// 助手消息：头像与模型名单独一行，正文整块排在其下方。
///
/// 头像不参与正文排版，避免每轮正文都整体右移一个头像的宽度。
class _AssistantMessage extends HookWidget {
  const _AssistantMessage({
    required this.turn,
    required this.brand,
    required this.modelName,
  });

  final ChatTurn turn;
  final AiBrand? brand;
  final String modelName;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDesktopPlatform;
    final String text = turn.text.trim();
    final bool hasText = text.isNotEmpty;
    // 正文尚未出现时才算「正在思考」，正文一开始流式就结束思考态。
    final bool thinking = turn.streaming && !hasText;
    final String shownText = _useThrottledText(turn.text, streaming: turn.streaming);
    final bool showHeader = modelName.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (showHeader)
          Padding(
            padding: EdgeInsets.only(bottom: isDesktop ? 8 : 8.h),
            child: Row(
              children: <Widget>[
                _AssistantAvatar(brand: brand),
                SizedBox(width: isDesktop ? 8 : 8.w),
                Flexible(
                  child: Text(
                    modelName.trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isDesktop ? 12 : 12.sp,
                      fontWeight: FontWeight.w600,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (turn.reasoning.trim().isNotEmpty)
          ChatReasoningCard(
            reasoning: turn.reasoning,
            active: thinking && turn.toolCalls.isEmpty,
          ),
        if (turn.toolCalls.isNotEmpty) ChatToolGroup(calls: turn.toolCalls),
        if (hasText) ChatMarkdown(data: shownText, streaming: turn.streaming),
        if (thinking && turn.toolCalls.isEmpty) const _TypingDots(),
        if ((turn.error ?? '').trim().isNotEmpty)
          ChatInlineNotice(text: turn.error!, isError: true),
        if (turn.notice != null)
          ChatInlineNotice(text: _noticeText(context, turn.notice!)),
        // 回答结束后再显示信息行与操作按钮，流式过程中不占位。
        if (!turn.streaming && (hasText || (turn.error ?? '').trim().isNotEmpty))
          ChatMessageActions(turn: turn),
      ],
    );
  }
}

/// 助手头像：品牌图标，识别不出品牌时回退为通用图标。
class _AssistantAvatar extends StatelessWidget {
  const _AssistantAvatar({this.brand});

  final AiBrand? brand;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDesktopPlatform;
    final double size = isDesktop ? 26 : 26.r;
    final double radius = isDesktop ? 9 : 9.r;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withValues(
          alpha: context.isDark ? 0.18 : 0.1,
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: AiBrandIcon(brand: brand, size: size * 0.58),
    );
  }
}

/// 用户消息气泡，右对齐，右下角收一个小圆角。
class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDark = context.isDark;
    final bool isDesktop = isDesktopPlatform;
    final double radius = isDesktop ? 16 : 16.r;
    final double maxWidth = isDesktop
        ? 560
        : MediaQuery.sizeOf(context).width * 0.78;

    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 14 : 14.w,
            vertical: isDesktop ? 10 : 10.h,
          ),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: isDark ? 0.24 : 0.1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius),
              bottomLeft: Radius.circular(radius),
              bottomRight: Radius.circular(radius * 0.35),
            ),
            border: Border.all(
              color: colors.primary.withValues(alpha: isDark ? 0.26 : 0.14),
            ),
          ),
          child: SelectableText(
            text,
            style: TextStyle(
              fontSize: isDesktop ? 13.5 : 13.5.sp,
              height: 1.5,
              color: colors.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

/// 等待首个 token 时的三点动效。
class _TypingDots extends HookWidget {
  const _TypingDots();

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDesktopPlatform;
    final AnimationController controller = useAnimationController(
      duration: const Duration(milliseconds: 900),
    );

    useEffect(() {
      controller.repeat();
      return null;
    }, const <Object?>[]);

    final Color color = context.colorScheme.onSurfaceVariant;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isDesktop ? 6 : 6.h),
      child: AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget? child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List<Widget>.generate(3, (int index) {
              final double t = (controller.value + index * 0.18) % 1;
              final double opacity =
                  0.25 + 0.6 * (t < 0.5 ? t * 2 : (1 - t) * 2);
              return Container(
                width: isDesktop ? 5 : 5.w,
                height: isDesktop ? 5 : 5.w,
                margin: EdgeInsets.only(right: index == 2 ? 0 : 5),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: opacity),
                  shape: BoxShape.circle,
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

String _noticeText(BuildContext context, ChatNotice notice) {
  return switch (notice) {
    ChatNotice.toolCallLimit => context.l10n.chatNoticeToolLimit,
    ChatNotice.emptyReply => context.l10n.chatNoticeEmptyReply,
  };
}

/// 流式正文节流：每 24ms 才把最新文本推到 Markdown 渲染，
/// 避免每个 token 都触发一次整篇解析。流式结束后直接返回最终文本。
String _useThrottledText(String source, {required bool streaming}) {
  final ObjectRef<String> latest = useRef<String>(source);
  latest.value = source;
  final ValueNotifier<String> shown = useState<String>(source);
  final ObjectRef<Timer?> timer = useRef<Timer?>(null);

  useEffect(() {
    if (!streaming || shown.value == source) return null;
    timer.value ??= Timer(const Duration(milliseconds: 24), () {
      timer.value = null;
      shown.value = latest.value;
    });
    return null;
  }, <Object?>[source, streaming]);

  useEffect(() => () => timer.value?.cancel(), const <Object?>[]);

  return streaming ? shown.value : source;
}
