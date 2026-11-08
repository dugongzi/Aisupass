import 'package:flutter/widgets.dart';
import 'package:xterm3/xterm.dart';

/// 往终端里写文字的几条通路。
///
/// 终端没有主题可切换，颜色只能随文本流写死，所以 ANSI 码集中在这里；
/// 写屏之后要补一次置底，因此必须连 [ScrollController] 一起拿着。
class TerminalTextWriter {
  const TerminalTextWriter({required this.terminal, required this.scroll});

  /// 被写入的终端。
  final Terminal terminal;

  /// 终端视图的滚动控制器，置底靠它。
  final ScrollController scroll;

  /// 清掉所有属性。
  static const String reset = '\x1b[0m';

  /// 暗色，写次要信息（退出码、路径）。
  static const String dim = '\x1b[2m';

  /// 红色，写失败。
  static const String red = '\x1b[31m';

  /// 绿色，招牌配色之一。
  static const String green = '\x1b[32m';

  /// 黄色，写进行中的动作。
  static const String yellow = '\x1b[33m';

  /// 招牌用的字形，取自 figlet 的 `small` 字体。
  ///
  /// 每个字形右侧已补白到字体里的固定宽度（`A`、`U` 是 8 列，其余 6 列），
  /// 拼起来就是字距；五行里最后一行全空，画之前要裁掉。
  static const Map<String, List<String>> _bannerGlyphs = <String, List<String>>{
    'A': <String>[
      '    _   ',
      '   /_\\  ',
      '  / _ \\ ',
      ' /_/ \\_\\',
      '        ',
    ],
    'I': <String>['  ___ ', ' |_ _|', '  | | ', ' |___|', '      '],
    'S': <String>['  ___ ', ' / __|', ' \\__ \\', ' |___/', '      '],
    'U': <String>[
      '  _   _ ',
      ' | | | |',
      ' | |_| |',
      '  \\___/ ',
      '        ',
    ],
    'P': <String>['  ___ ', ' | _ \\', '  |  _/', ' |_|  ', '      '],
  };

  /// 招牌的几种排版，从宽到窄：取第一个放得下的。
  ///
  /// 字符画折一行就整幅散架，而手机竖屏只有约 49 列、放不下 54 列的整词，
  /// 所以宽度不能写死。
  static const List<List<String>> _bannerLayouts = <List<String>>[
    <String>['AISUPASS'],
    <String>['AISU', 'PASS'],
  ];

  /// 把视口钉在最后一行。xterm3 自带的跟随在首帧前、同帧连续大量写入时会
  /// 判断落空，新输出就停在视口下方。
  ///
  /// 调用点必须紧跟在 `terminal.write` 之后：那时还没布局，问的是「用户原
  /// 本是否就在底部」，往上翻历史时不会被拽回来。
  void stickToBottom() {
    if (!scroll.hasClients) return;
    final ScrollPosition position = scroll.position;
    if (position.pixels < position.maxScrollExtent - 1) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scroll.hasClients) return;
      final ScrollPosition after = scroll.position;
      if (after.pixels < after.maxScrollExtent) {
        after.jumpTo(after.maxScrollExtent);
      }
    });
  }

  /// 原样写屏，然后补一次置底。
  void write(String text) {
    terminal.write(text);
    stickToBottom();
  }

  /// 写一行，行尾补回车换行；给了 [color] 就整行染色。
  void writeLine(String text, {String? color}) {
    final String prefix = color ?? '';
    final String suffix = color == null ? '' : reset;
    terminal.write('$prefix$text$suffix\r\n');
    stickToBottom();
  }

  /// 把一次性 exec 的结果写进终端：raw 通道只有 `\n`，终端要 `\r\n` 才回行首。
  /// pty 的输出已经带 `\r\n`，不能走这里。
  void writeStream(String text, {String? color}) {
    if (text.isEmpty) return;
    String out = text.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    out = out.replaceAll('\n', '\r\n');
    if (!out.endsWith('\r\n')) out += '\r\n';
    final String prefix = color ?? '';
    final String suffix = color == null ? '' : reset;
    terminal.write('$prefix$out$suffix');
    stickToBottom();
  }

  /// 一段字母的列宽。
  int _segmentWidth(String segment) => segment.split('').fold(
    0,
    (int sum, String letter) => sum + _bannerGlyphs[letter]!.first.length,
  );

  /// 画一段字母，行尾按实际画到的列裁掉空格：写满末列会多折一行，把字拆散。
  void _writeBannerSegment(String segment) {
    final List<String> letters = segment.split('');
    final int height = _bannerGlyphs[letters.first]!.length;
    // 最后一行对 AISUPASS 是全空，裁掉，免得把提示符往下推。
    int lastRow = height - 1;
    while (lastRow > 0 &&
        letters.every(
          (String letter) => _bannerGlyphs[letter]![lastRow].trim().isEmpty,
        )) {
      lastRow--;
    }

    for (int row = 0; row <= lastRow; row++) {
      final int visible = letters
          .map((String letter) => _bannerGlyphs[letter]![row])
          .join()
          .trimRight()
          .length;
      final StringBuffer line = StringBuffer();
      int col = 0;
      for (int i = 0; i < letters.length && col < visible; i++) {
        final String cell = _bannerGlyphs[letters[i]]![row];
        final int take = visible - col < cell.length
            ? visible - col
            : cell.length;
        // 红绿相间：单色细线条在深底上容易糊成一片。转义不占列宽。
        final String color = i.isEven ? red : green;
        line.write('$color${cell.substring(0, take)}$reset');
        col += cell.length;
      }
      terminal.write('$line\r\n');
    }
  }

  /// 按终端当前列数挑一种放得下的排版：窄一列字符画就散架，而列数要取自
  /// `terminal.viewWidth`。少用一列，正经写满末列会被置成待折行。
  void writeBanner(int cols) {
    final int usable = cols - 1;
    for (final List<String> layout in _bannerLayouts) {
      final int width = layout
          .map(_segmentWidth)
          .reduce((int a, int b) => a > b ? a : b);
      if (width > usable) continue;
      for (final String segment in layout) {
        _writeBannerSegment(segment);
      }
      return;
    }
    // 两行版都放不下（超大字号窄分屏）：退回普通文字，别甩一堆错位的斜杠。
    terminal.write('$red[AISUPASS]$reset\r\n');
  }
}
