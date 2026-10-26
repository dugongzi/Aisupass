import 'dart:convert';
import 'dart:typed_data';

import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

/// 助手消息的 Markdown 渲染。
///
/// 代码块、表格、图片使用自定义 builder，其余元素走统一的文本样式，
/// 保持与瀑布流对话一致的留白和层级。
class ChatMarkdown extends StatelessWidget {
  const ChatMarkdown({super.key, required this.data, this.streaming = false});

  final String data;
  final bool streaming;

  @override
  Widget build(BuildContext context) {
    final bool showCursor = streaming && data.trim().isNotEmpty;
    return MarkdownBody(
      data: showCursor ? '$data▌' : data,
      selectable: true,
      styleSheet: _buildStyleSheet(context),
      builders: <String, MarkdownElementBuilder>{
        'code': _CodeBlockBuilder(),
        'table': _TableBuilder(),
        'img': _ImageBuilder(),
      },
      onTapLink: (String text, String? href, String title) {
        final Uri? uri = href == null ? null : Uri.tryParse(href);
        if (uri == null) return;
        launchUrl(uri, mode: LaunchMode.externalApplication);
      },
    );
  }
}

MarkdownStyleSheet _buildStyleSheet(BuildContext context) {
  final ThemeData theme = context.theme;
  final ColorScheme colors = context.colorScheme;
  final bool isDark = context.isDark;
  final bool isDesktop = isDesktopPlatform;

  final double body = isDesktop ? 14.5 : 14.5.sp;
  final double codeSize = isDesktop ? 12.5 : 12.5.sp;
  final double gap = isDesktop ? 8 : 8.h;
  final double radius = isDesktop ? 8 : 8.r;

  return MarkdownStyleSheet.fromTheme(theme).copyWith(
    p: TextStyle(
      fontSize: body,
      height: 1.66,
      color: colors.onSurface.withValues(alpha: 0.92),
    ),
    pPadding: EdgeInsets.only(bottom: gap),
    a: TextStyle(
      color: colors.primary,
      decoration: TextDecoration.underline,
      decorationColor: colors.primary.withValues(alpha: 0.5),
    ),
    strong: TextStyle(fontWeight: FontWeight.w700, color: colors.onSurface),
    em: const TextStyle(fontStyle: FontStyle.italic),
    del: const TextStyle(decoration: TextDecoration.lineThrough),
    h1: TextStyle(
      fontSize: body + 6,
      fontWeight: FontWeight.w700,
      height: 1.4,
      color: colors.onSurface,
    ),
    h2: TextStyle(
      fontSize: body + 3,
      fontWeight: FontWeight.w700,
      height: 1.4,
      color: colors.onSurface,
    ),
    h3: TextStyle(
      fontSize: body + 1,
      fontWeight: FontWeight.w600,
      height: 1.4,
      color: colors.onSurface,
    ),
    h4: TextStyle(
      fontSize: body,
      fontWeight: FontWeight.w600,
      height: 1.4,
      color: colors.onSurface,
    ),
    h5: TextStyle(
      fontSize: body,
      fontWeight: FontWeight.w600,
      height: 1.4,
      color: colors.onSurface,
    ),
    h6: TextStyle(
      fontSize: body - 1,
      fontWeight: FontWeight.w600,
      height: 1.4,
      color: colors.onSurfaceVariant,
    ),
    code: TextStyle(
      fontSize: codeSize,
      fontFamily: 'monospace',
      color: isDark ? colors.primary : const Color(0xFFD84315),
      backgroundColor: isDark
          ? Colors.white.withValues(alpha: 0.06)
          : Colors.black.withValues(alpha: 0.05),
    ),
    codeblockDecoration: const BoxDecoration(),
    blockquote: TextStyle(
      fontSize: body,
      height: 1.6,
      color: colors.onSurfaceVariant,
    ),
    blockquoteDecoration: BoxDecoration(
      color: isDark
          ? Colors.white.withValues(alpha: 0.04)
          : Colors.black.withValues(alpha: 0.035),
      borderRadius: BorderRadius.circular(radius),
    ),
    blockquotePadding: EdgeInsets.symmetric(horizontal: 12, vertical: gap),
    listBullet: TextStyle(color: colors.primary, fontSize: body),
    listIndent: isDesktop ? 20 : 18,
    tableBorder: TableBorder.all(
      color: colors.outlineVariant.withValues(alpha: isDark ? 0.5 : 0.7),
    ),
    tableHead: TextStyle(
      fontSize: body - 1,
      fontWeight: FontWeight.w700,
      color: colors.onSurface,
    ),
    tableBody: TextStyle(
      fontSize: body - 1,
      height: 1.45,
      color: colors.onSurface.withValues(alpha: 0.9),
    ),
    tableCellsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    blockSpacing: gap,
    horizontalRuleDecoration: BoxDecoration(
      border: Border(
        top: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.7)),
      ),
    ),
  );
}

/// 围栏代码块：语言标签 + 复制按钮 + 横向滚动，避免长行撑破布局。
class _CodeBlockBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final String code = element.textContent.trimRight();
    final String language =
        (element.attributes['class'] ?? '').replaceFirst('language-', '');
    if (language.isEmpty && !code.contains('\n')) {
      // 行内 code 交给默认样式。
      return null;
    }
    return _CodeBlock(code: code, language: language);
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code, required this.language});

  final String code;
  final String language;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDark = context.isDark;
    final bool isDesktop = isDesktopPlatform;
    final double radius = isDesktop ? 12 : 12.r;

    return Container(
      margin: EdgeInsets.only(
        top: isDesktop ? 4 : 4.h,
        bottom: isDesktop ? 8 : 8.h,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withValues(alpha: 0.3)
            : Colors.black.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: isDark ? 0.3 : 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(12, 4, 4, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    language.isEmpty ? 'code' : language,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isDesktop ? 11 : 11.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
                _CopyButton(text: code),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: isDesktop ? 380 : 320),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.fromLTRB(12, 2, 12, 12),
              child: SingleChildScrollView(
                child: SelectableText(
                  code,
                  style: TextStyle(
                    fontSize: isDesktop ? 12.5 : 12.5.sp,
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
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: text));
        if (!context.mounted) return;
        ToastMessage.success(context.l10n.chatCopied);
      },
      visualDensity: VisualDensity.compact,
      iconSize: 16,
      color: context.colorScheme.onSurfaceVariant,
      icon: const Icon(Icons.copy_rounded),
      tooltip: context.l10n.chatCopied,
    );
  }
}

/// 表格：外层横向滚动，列宽自适应内容。
class _TableBuilder extends MarkdownElementBuilder {
  @override
  bool isBlockElement() => true;

  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final List<md.Element> rows = <md.Element>[];
    for (final md.Node section in element.children ?? const <md.Node>[]) {
      if (section is! md.Element) continue;
      if (section.tag == 'tr') {
        rows.add(section);
        continue;
      }
      for (final md.Node row in section.children ?? const <md.Node>[]) {
        if (row is md.Element && row.tag == 'tr') rows.add(row);
      }
    }
    if (rows.isEmpty) return null;

    int columns = 0;
    for (final md.Element row in rows) {
      final int length = row.children?.length ?? 0;
      if (length > columns) columns = length;
    }
    if (columns == 0) return null;

    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;
    final double fontSize = isDesktop ? 13 : 12.5.sp;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isDesktop ? 4 : 4.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          defaultColumnWidth: const IntrinsicColumnWidth(),
          border: TableBorder.all(
            color: colors.outlineVariant.withValues(alpha: 0.6),
          ),
          children: <TableRow>[
            for (int i = 0; i < rows.length; i += 1)
              TableRow(
                children: <Widget>[
                  for (int j = 0; j < columns; j += 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: Text(
                        _cellText(rows[i], j),
                        style: TextStyle(
                          fontSize: fontSize,
                          height: 1.45,
                          fontWeight: i == 0
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _cellText(md.Element row, int index) {
    final List<md.Node> cells = row.children ?? const <md.Node>[];
    if (index >= cells.length) return '';
    return cells[index].textContent.trim();
  }
}

/// 图片：支持网络地址与 base64 data URI，其余直接忽略。
class _ImageBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final String src = (element.attributes['src'] ?? '').trim();
    if (src.isEmpty) return null;
    final String alt = element.attributes['alt'] ?? '';
    final double maxSize = isDesktopPlatform ? 320 : 300.w;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isDesktopPlatform ? 10 : 10.r),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxSize, maxHeight: maxSize),
          child: _buildImage(src, alt),
        ),
      ),
    );
  }

  Widget _buildImage(String src, String alt) {
    if (src.startsWith('data:image/')) {
      final int comma = src.indexOf(',');
      if (comma < 0) return const SizedBox.shrink();
      try {
        final Uint8List bytes = base64Decode(src.substring(comma + 1));
        return Image.memory(
          bytes,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => _placeholder(alt),
        );
      } on FormatException {
        return const SizedBox.shrink();
      }
    }
    return Image.network(
      src,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => _placeholder(alt),
    );
  }

  Widget _placeholder(String alt) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        alt.isEmpty ? 'image' : alt,
        style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      ),
    );
  }
}
