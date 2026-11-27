import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 挂在单条消息下方的轻提示，用于错误与非致命提醒。
///
/// 布局分三层：左侧竖向色条标出提示类型，中间是正文，底部是操作区。
/// 正文独占整行，操作按钮不再挤在文字右侧，长文案不会被压成窄条。
/// [detail] 非空时底部给出「查看原始响应」，展开后原样展示服务端返回。
class ChatInlineNotice extends StatefulWidget {
  const ChatInlineNotice({
    super.key,
    required this.text,
    this.isError = false,
    this.actionLabel,
    this.onAction,
    this.detail = '',
  });

  final String text;
  final bool isError;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String detail;

  @override
  State<ChatInlineNotice> createState() => _ChatInlineNoticeState();
}

class _ChatInlineNoticeState extends State<ChatInlineNotice> {
  bool _rawOpen = false;

  Future<void> _copyRaw() async {
    await Clipboard.setData(ClipboardData(text: widget.detail));
    if (!mounted) return;
    ToastMessage.success(context.l10n.aiTestCopied);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;
    final Color color = widget.isError ? colors.error : colors.onSurfaceVariant;
    final bool hasDetail = widget.detail.trim().isNotEmpty;
    final bool hasAction =
        widget.actionLabel != null && widget.onAction != null;
    final double radius = isDesktop ? 12 : 12.r;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: isDesktop ? 8 : 8.h),
      // 左侧竖向色条用 Stack 叠出来：比整圈描边轻，也不和正文抢注意力。
      // 不用 IntrinsicHeight，避免和内部滚动区域打架。
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: ColoredBox(
                color: color.withValues(alpha: widget.isError ? 0.055 : 0.04),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: SizedBox(
                width: isDesktop ? 3 : 3.w,
                child: ColoredBox(color: color.withValues(alpha: 0.7)),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                isDesktop ? 11 : 11.w,
                isDesktop ? 10 : 10.h,
                isDesktop ? 12 : 12.w,
                isDesktop ? 11 : 11.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: isDesktop ? 1.5 : 1.5.h),
                        child: Icon(
                          widget.isError
                              ? Icons.error_outline_rounded
                              : Icons.info_outline_rounded,
                          size: isDesktop ? 15 : 15.sp,
                          color: color,
                        ),
                      ),
                      SizedBox(width: isDesktop ? 8 : 8.w),
                      Expanded(
                        child: Text(
                          widget.text,
                          style: TextStyle(
                            fontSize: isDesktop ? 13 : 13.sp,
                            height: 1.45,
                            fontWeight: FontWeight.w500,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (hasDetail || hasAction)
                    Padding(
                      padding: EdgeInsets.only(
                        top: isDesktop ? 9 : 9.h,
                        left: isDesktop ? 23 : 23.w,
                      ),
                      child: Row(
                        children: <Widget>[
                          if (hasDetail)
                            _RawToggle(
                              open: _rawOpen,
                              onTap: () => setState(() => _rawOpen = !_rawOpen),
                            ),
                          const Spacer(),
                          if (hasAction)
                            _NoticeAction(
                              label: widget.actionLabel!,
                              onTap: widget.onAction!,
                              color: color,
                            ),
                        ],
                      ),
                    ),
                  if (hasDetail)
                    AnimatedSize(
                      duration: const Duration(milliseconds: 160),
                      curve: Curves.easeOut,
                      alignment: Alignment.topLeft,
                      child: _rawOpen
                          ? Padding(
                              padding: EdgeInsets.only(
                                top: isDesktop ? 8 : 8.h,
                                left: isDesktop ? 23 : 23.w,
                              ),
                              child: _RawPanel(
                                text: widget.detail,
                                color: color,
                                onCopy: _copyRaw,
                              ),
                            )
                          : const SizedBox(width: double.infinity),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 底部主操作按钮：浅色填充的小胶囊，便于一眼识别可点又不过分抢眼。
class _NoticeAction extends StatelessWidget {
  const _NoticeAction({
    required this.label,
    required this.onTap,
    required this.color,
  });

  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDesktopPlatform;
    final double radius = isDesktop ? 8 : 8.r;

    return Material(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 10 : 10.w,
            vertical: isDesktop ? 6 : 6.h,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: isDesktop ? 12.5 : 12.5.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

/// 「查看 / 收起原始响应」的胶囊按钮：中性色，与正文区分开。
class _RawToggle extends StatelessWidget {
  const _RawToggle({required this.open, required this.onTap});

  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;
    final double radius = isDesktop ? 16 : 16.r;

    return Material(
      color: colors.surfaceContainerHighest.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            isDesktop ? 8 : 8.w,
            isDesktop ? 5 : 5.h,
            isDesktop ? 5 : 5.w,
            isDesktop ? 5 : 5.h,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.terminal_rounded,
                size: isDesktop ? 12.5 : 12.5.sp,
                color: colors.onSurfaceVariant,
              ),
              SizedBox(width: isDesktop ? 5 : 5.w),
              Text(
                open
                    ? context.l10n.chatErrorHideRaw
                    : context.l10n.chatErrorShowRaw,
                style: TextStyle(
                  fontSize: isDesktop ? 11.5 : 11.5.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurfaceVariant,
                ),
              ),
              SizedBox(width: isDesktop ? 1 : 1.w),
              Icon(
                open
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                size: isDesktop ? 16 : 16.sp,
                color: colors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 服务端原始响应面板：带标题行与复制按钮，内容限高后可滚动。
class _RawPanel extends StatelessWidget {
  const _RawPanel({
    required this.text,
    required this.color,
    required this.onCopy,
  });

  final String text;
  final Color color;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;
    final double radius = isDesktop ? 8 : 8.r;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(
              isDesktop ? 10 : 10.w,
              isDesktop ? 2 : 2.h,
              isDesktop ? 4 : 4.w,
              0,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'RAW',
                    style: TextStyle(
                      fontSize: isDesktop ? 10 : 10.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      color: color.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onCopy,
                  tooltip: context.l10n.aiTestCopy,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  iconSize: isDesktop ? 15 : 15.sp,
                  color: color.withValues(alpha: 0.65),
                  icon: const Icon(Icons.copy_rounded),
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: isDesktop ? 260 : 220),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                isDesktop ? 10 : 10.w,
                0,
                isDesktop ? 10 : 10.w,
                isDesktop ? 10 : 10.h,
              ),
              child: SelectableText(
                text,
                style: TextStyle(
                  fontSize: isDesktop ? 11 : 11.sp,
                  height: 1.5,
                  fontFamily: 'monospace',
                  color: colors.onSurface.withValues(alpha: 0.75),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 会话级问题提示条，例如未完成 AI 配置。
class ChatIssueBanner extends StatelessWidget {
  const ChatIssueBanner({
    super.key,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDark = context.isDark;
    final bool isDesktop = isDesktopPlatform;
    final double radius = isDesktop ? 10 : 10.r;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 24 : 16.w,
        isDesktop ? 6 : 6.h,
        isDesktop ? 24 : 16.w,
        isDesktop ? 4 : 4.h,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 12 : 12.w,
              vertical: isDesktop ? 6 : 4.h,
            ),
            decoration: BoxDecoration(
              color: colors.error.withValues(alpha: isDark ? 0.14 : 0.08),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: colors.error.withValues(alpha: isDark ? 0.3 : 0.22),
              ),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.error_outline_rounded,
                  size: isDesktop ? 15 : 15.sp,
                  color: colors.error,
                ),
                SizedBox(width: isDesktop ? 8 : 8.w),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: isDesktop ? 12.5 : 12.5.sp,
                      height: 1.4,
                      color: colors.error,
                    ),
                  ),
                ),
                if (actionLabel != null && onAction != null)
                  TextButton(
                    onPressed: onAction,
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 8 : 8.w,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: colors.error,
                      textStyle: TextStyle(
                        fontSize: isDesktop ? 12 : 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: Text(actionLabel!),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
