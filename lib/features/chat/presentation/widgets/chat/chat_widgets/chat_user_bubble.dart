import 'dart:io';

import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/chat/domain/models/chat_attachment.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 折叠状态展示的代码行数。
const int _collapsedLines = 14;

/// 展开后代码区最大高度，超出在块内滚动，避免一条消息占满整屏。
const double _expandedMaxHeight = 460;

/// 折叠状态代码区最大高度。
const double _collapsedMaxHeight = 320;

/// 用户消息气泡，右对齐，右下角收一个小圆角。
///
/// 内容里带围栏代码块时按块拆分：普通文本照旧，代码块默认只露前
/// [_collapsedLines] 行，由「展开全文 / 收起」控制。浏览器回传的整页源码
/// 因此可以完整进入上下文，又不会把对话撑成几万行。
class ChatUserBubble extends HookWidget {
  const ChatUserBubble({
    super.key,
    required this.text,
    this.attachments = const <ChatAttachment>[],
  });

  final String text;
  final List<ChatAttachment> attachments;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDark = context.isDark;
    final bool isDesktop = isDesktopPlatform;
    final double radius = isDesktop ? 16 : 16.r;
    final List<_Segment> segments = useMemoized(
      () => _parseSegments(text),
      <Object?>[text],
    );
    final bool hasCode = segments.any((_Segment s) => s.isCode);
    // 带代码块时放宽气泡，否则窄栏里的源码可读性极差。
    final double maxWidth = hasCode
        ? (isDesktop ? 760 : MediaQuery.sizeOf(context).width * 0.92)
        : (isDesktop ? 560 : MediaQuery.sizeOf(context).width * 0.78);

    final TextStyle bodyStyle = TextStyle(
      fontSize: isDesktop ? 13.5 : 13.5.sp,
      height: 1.5,
      color: colors.onSurface,
    );

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (attachments.isNotEmpty)
                _AttachmentGrid(attachments: attachments),
              if (attachments.isNotEmpty && text.trim().isNotEmpty)
                SizedBox(height: isDesktop ? 8 : 8.h),
              if (text.trim().isNotEmpty)
                if (hasCode)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      for (final _Segment segment in segments)
                        if (segment.isCode)
                          _CodeSegment(segment: segment)
                        else if (segment.text.trim().isNotEmpty)
                          SelectableText(segment.text.trim(), style: bodyStyle),
                    ],
                  )
                else
                  SelectableText(text, style: bodyStyle),
            ],
          ),
        ),
      ),
    );
  }
}

/// 用户消息里的附件：图片显示缩略图，文本显示文件名标签。
class _AttachmentGrid extends HookWidget {
  const _AttachmentGrid({required this.attachments});

  final List<ChatAttachment> attachments;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDesktopPlatform;

    return Wrap(
      spacing: isDesktop ? 6 : 6.w,
      runSpacing: isDesktop ? 6 : 6.h,
      children: <Widget>[
        for (final ChatAttachment attachment in attachments)
          if (attachment.isImage)
            _ImageThumb(attachment: attachment)
          else
            _FileChip(attachment: attachment),
      ],
    );
  }
}

/// 图片缩略图；文件已被清理时退化为占位图标。
class _ImageThumb extends HookWidget {
  const _ImageThumb({required this.attachment});

  final ChatAttachment attachment;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDesktopPlatform;
    final ColorScheme colors = context.colorScheme;
    final double size = isDesktop ? 132 : 112.w;

    return ClipRRect(
      borderRadius: BorderRadius.circular(isDesktop ? 10 : 10.r),
      child: Image.file(
        File(attachment.path),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (BuildContext context, Object error, StackTrace? _) =>
            Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              color: colors.surface.withValues(alpha: 0.5),
              child: Icon(
                Icons.broken_image_outlined,
                size: isDesktop ? 22 : 22.sp,
                color: colors.onSurfaceVariant,
              ),
            ),
      ),
    );
  }
}

/// 文本附件标签：只展示文件名，内容发送时由请求层读取。
class _FileChip extends HookWidget {
  const _FileChip({required this.attachment});

  final ChatAttachment attachment;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDesktopPlatform;
    final ColorScheme colors = context.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 9 : 9.w,
        vertical: isDesktop ? 6 : 6.h,
      ),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: context.isDark ? 0.45 : 0.7),
        borderRadius: BorderRadius.circular(isDesktop ? 10 : 10.r),
        border: Border.all(color: colors.primary.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            attachment.isBinary
                ? Icons.inventory_2_outlined
                : Icons.description_outlined,
            size: isDesktop ? 14 : 14.sp,
            color: colors.onSurfaceVariant,
          ),
          SizedBox(width: isDesktop ? 5 : 5.w),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 200 : 160.w),
            child: Text(
              attachment.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isDesktop ? 11.5 : 11.5.sp,
                color: colors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 一个气泡片段：普通文本，或带语言标记的围栏代码块。
class _Segment {
  const _Segment({required this.text, this.language});

  final String text;

  /// 非空表示这是代码块；空串表示围栏未标注语言。
  final String? language;

  bool get isCode => language != null;
}

/// 按 ``` 围栏切分；未闭合的围栏还原成普通文本，不丢内容。
List<_Segment> _parseSegments(String raw) {
  final List<_Segment> out = <_Segment>[];
  final StringBuffer plain = StringBuffer();
  final StringBuffer code = StringBuffer();
  String? language;
  bool opened = false;

  void flushPlain() {
    if (plain.isEmpty) return;
    out.add(_Segment(text: plain.toString()));
    plain.clear();
  }

  for (final String line in raw.split('\n')) {
    final String trimmed = line.trimLeft();
    if (!opened) {
      if (trimmed.startsWith('```')) {
        flushPlain();
        opened = true;
        language = trimmed.substring(3).trim();
        code.clear();
        continue;
      }
      if (plain.isNotEmpty) plain.write('\n');
      plain.write(line);
      continue;
    }
    if (trimmed.startsWith('```')) {
      out.add(_Segment(text: code.toString(), language: language));
      opened = false;
      language = null;
      continue;
    }
    if (code.isNotEmpty) code.write('\n');
    code.write(line);
  }

  if (opened) {
    if (plain.isNotEmpty) plain.write('\n');
    plain
      ..write('```')
      ..write(language ?? '');
    if (code.isNotEmpty) {
      plain
        ..write('\n')
        ..write(code.toString());
    }
  }
  flushPlain();
  return out;
}

/// 代码块：语言与行数标签 + 展开/收起 + 双向滚动。
class _CodeSegment extends HookWidget {
  const _CodeSegment({required this.segment});

  final _Segment segment;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme colors = context.colorScheme;
    final bool isDark = context.isDark;
    final bool isDesktop = isDesktopPlatform;
    final ValueNotifier<bool> expanded = useState<bool>(false);
    final List<String> lines = useMemoized(
      () => segment.text.split('\n'),
      <Object?>[segment.text],
    );
    final bool foldable = lines.length > _collapsedLines;
    final String shown = foldable && !expanded.value
        ? '${lines.take(_collapsedLines).join('\n')}\n…'
        : segment.text;
    final String language = segment.language ?? '';
    final String label = language.isEmpty
        ? l10n.chatCodeLabel
        : '$language · ${l10n.chatCodeLines(lines.length)}';

    return Container(
      margin: EdgeInsets.only(
        top: isDesktop ? 6 : 6.h,
        bottom: isDesktop ? 2 : 2.h,
      ),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: isDark ? 0.5 : 0.7),
        borderRadius: BorderRadius.circular(isDesktop ? 10 : 10.r),
        border: Border.all(
          color: colors.primary.withValues(alpha: isDark ? 0.24 : 0.16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10, 4, 4, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isDesktop ? 11 : 11.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
                if (foldable)
                  TextButton(
                    onPressed: () => expanded.value = !expanded.value,
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      minimumSize: Size.zero,
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      expanded.value
                          ? l10n.chatToolCollapse
                          : l10n.chatCodeExpand,
                      style: TextStyle(fontSize: isDesktop ? 11 : 11.sp),
                    ),
                  ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: _maxHeight(isDesktop, expanded.value && foldable),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.fromLTRB(10, 2, 10, 10),
              child: SingleChildScrollView(
                child: SelectableText(
                  shown,
                  style: TextStyle(
                    fontSize: isDesktop ? 11.5 : 11.5.sp,
                    height: 1.5,
                    fontFamily: 'monospace',
                    color: colors.onSurface.withValues(alpha: 0.92),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _maxHeight(bool isDesktop, bool expanded) {
    if (!isDesktop) {
      return expanded ? _expandedMaxHeight.h : _collapsedMaxHeight.h;
    }
    return expanded ? _expandedMaxHeight : _collapsedMaxHeight;
  }
}
