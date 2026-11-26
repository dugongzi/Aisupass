/// 把 HTML 片段转成纯文本：去标签、反转义实体、压缩空白。
///
/// 酷安等社区接口的正文是 HTML，且引号常被转义两层（`&amp;quot;`），
/// 因此实体解码默认跑两遍；正文末尾的「查看更多」链接会单独剔除。
///
/// 带 `href` 的 `<a>` 标签会展开成 `文字 地址`，避免清洗后把下载链接丢掉；
/// 站内相对路径（以 `/` 开头）不保留，它们对用户没有意义。
String plainTextFromHtml(String raw, {String moreLabel = '查看更多'}) {
  String text = raw;
  if (moreLabel.isNotEmpty) {
    final String label = RegExp.escape(moreLabel);
    text = text.replaceAll(RegExp('<a[^>]*>\\s*$label\\s*</a>'), '');
  }
  text = text.replaceAllMapped(_anchorPattern, _expandAnchor);
  text = text.replaceAll(RegExp(r'<[^>]+>'), '');
  for (int i = 0; i < 2; i++) {
    text = decodeHtmlEntities(text);
  }
  return text.replaceAll(RegExp(r'\s+'), ' ').trim();
}

/// `<a href="...">文字</a>`，文字里可能还嵌行内标签。
final RegExp _anchorPattern = RegExp(
  r'<a\b[^>]*\bhref="([^"]+)"[^>]*>(.*?)</a>',
  caseSensitive: false,
  dotAll: true,
);

/// 把锚点展开成 `文字 地址`；文字为空或与地址相同时只留地址。
String _expandAnchor(Match match) {
  final String href = decodeHtmlEntities(match.group(1) ?? '').trim();
  final String label = (match.group(2) ?? '')
      .replaceAll(RegExp(r'<[^>]+>'), '')
      .trim();
  if (href.isEmpty || href.startsWith('/')) return label;
  if (label.isEmpty || label == href) return href;
  return '$label $href';
}

/// `@JsonKey(fromJson:)` 适配：任意值按字符串处理后转纯文本。
String plainTextFromJson(Object? raw, {String moreLabel = '查看更多'}) =>
    plainTextFromHtml((raw ?? '').toString(), moreLabel: moreLabel);

/// HTML 实体反转义一轮，覆盖常见命名实体与数字实体。
String decodeHtmlEntities(String text) => text
    .replaceAllMapped(
      RegExp(r'&#(\d+);'),
      (Match m) => _fromCodePoint(int.tryParse(m.group(1) ?? ''), m),
    )
    .replaceAllMapped(
      RegExp(r'&#[xX]([0-9a-fA-F]+);'),
      (Match m) => _fromCodePoint(int.tryParse(m.group(1) ?? '', radix: 16), m),
    )
    .replaceAll('&lt;', '<')
    .replaceAll('&gt;', '>')
    .replaceAll('&quot;', '"')
    .replaceAll('&apos;', "'")
    .replaceAll('&nbsp;', ' ')
    .replaceAll('&amp;', '&');

/// 码点 → 字符；缺失或越界时保留原文。
String _fromCodePoint(int? code, Match match) {
  if (code == null || code < 0 || code > 0x10FFFF) return match.group(0)!;
  return String.fromCharCodes(<int>[code]);
}
