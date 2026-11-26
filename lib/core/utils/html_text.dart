/// 把 HTML 片段转成纯文本：去标签、反转义实体、压缩空白。
///
/// 酷安等社区接口的正文是 HTML，且引号常被转义两层（`&amp;quot;`），
/// 因此实体解码默认跑两遍；正文末尾的「查看更多」链接会单独剔除。
String plainTextFromHtml(String raw, {String moreLabel = '查看更多'}) {
  String text = raw;
  if (moreLabel.isNotEmpty) {
    final String label = RegExp.escape(moreLabel);
    text = text.replaceAll(RegExp('<a[^>]*>\\s*$label\\s*</a>'), '');
  }
  text = text.replaceAll(RegExp(r'<[^>]+>'), '');
  for (int i = 0; i < 2; i++) {
    text = decodeHtmlEntities(text);
  }
  return text.replaceAll(RegExp(r'\s+'), ' ').trim();
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
