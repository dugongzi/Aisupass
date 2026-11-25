import 'dart:convert';

import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/features/escalation/domain/enums/terminal_modifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xterm3/xterm.dart';

/// 按键栏上的一个功能键。
@immutable
class TerminalKey {
  const TerminalKey({required this.label, required this.bytes, this.ctrlBytes});

  /// 键帽上显示的文字。
  final String label;

  /// 不扣任何修饰键时发给 pty 的序列。
  final String bytes;

  /// 扣住 Ctrl 时改发的序列；为空表示该键不吃 Ctrl。
  final String? ctrlBytes;

  /// 按当前扣住的修饰键，算出真正要写给 pty 的序列。
  String payload(Set<TerminalModifier> armed) {
    final String? ctrl = ctrlBytes;
    if (ctrl != null && armed.contains(TerminalModifier.ctrl)) return ctrl;
    return bytes;
  }
}

/// 不扣修饰键时直接发送的功能键。
///
/// 方向键带 xterm 的 `CSI 1;5x` 变体，扣住 Ctrl 时才能和原生终端一样发组合键。
/// 只留提权脚本真正用得上的键：HOME / END / PGUP / PGDN 在这里没有场景
/// （输出是逐块追加的日志，滚动靠触摸）。
const List<TerminalKey> _functionKeys = <TerminalKey>[
  TerminalKey(label: 'TAB', bytes: '\t'),
  TerminalKey(label: '←', bytes: '\x1b[D', ctrlBytes: '\x1b[1;5D'),
  TerminalKey(label: '↑', bytes: '\x1b[A', ctrlBytes: '\x1b[1;5A'),
  TerminalKey(label: '↓', bytes: '\x1b[B', ctrlBytes: '\x1b[1;5B'),
  TerminalKey(label: '→', bytes: '\x1b[C', ctrlBytes: '\x1b[1;5C'),
];

/// 按扣住的修饰键改写一次软键盘输入。
///
/// 只加工「单个字符」：方向键、粘贴进来的整段文本、终端对远端查询的自动应答
/// 都是多字节或转义序列，改写会把序列弄坏，原样放行。
List<int> encodeTerminalInput(String data, Set<TerminalModifier> armed) {
  // 终端内部的转义序列与整段粘贴不走修饰键，直接放行。
  if (armed.isEmpty || data.length != 1) return utf8.encode(data);

  final int code = data.codeUnitAt(0);
  // 只有 ASCII 字母与 `@[\]^_` 有对应的控制字符，其余字符 Ctrl 无意义。
  final bool ctrlApplicable =
      (code >= 0x40 && code <= 0x5f) || (code >= 0x61 && code <= 0x7a);
  final bool ctrl = armed.contains(TerminalModifier.ctrl) && ctrlApplicable;

  return ctrl ? <int>[code & 0x1f] : utf8.encode(data);
}

/// 终端按键栏：贴在终端下方的一排功能键。
///
/// 视觉沿用 xterm3 的默认暗色主题：底色与终端画布同色，键帽比底色亮一档，
/// 字用终端前景色，整条栏看起来是终端的一部分而不是界面上的另一块控件。
///
/// 键多时横向滚动，放得下时整体居中；最左侧的 [leading]（菜单）固定不动，
/// 不跟着滚走。
class TerminalKeyBar extends StatelessWidget {
  const TerminalKeyBar({
    super.key,
    required this.armed,
    required this.onInput,
    this.leading,
    this.trailing,
    this.theme = TerminalThemes.defaultTheme,
  });

  /// 键帽高度（设计稿值）。
  static const double keyHeight = 40;

  /// 键帽最小宽度（设计稿值）。低于 44 的可点区域在小屏上很难按准。
  static const double keyMinWidth = 44;

  /// 键帽底色：比终端画布亮一档，键与背景之间才有层次。
  static const Color keyColor = Color(0xFF2A2A2C);

  /// 键帽描边。深色底上的分隔线，只起分层作用。
  static const Color keyBorder = Color(0xFF3E3E42);

  /// 键帽上的文字色，取自终端前景色（#CCCCCC），在 [keyColor] 上对比度约 9:1。
  static const Color keyForeground = Color(0xFFCCCCCC);

  /// 键帽内容色：扣住修饰键时的强调色。
  static const Color keyAccent = Color(0xFF23D18B);

  /// 栏顶分隔线与栏目内竖线。
  static const Color hairline = Color(0x1FFFFFFF);

  /// 当前扣住的修饰键。页面持有它，因为软键盘输入也要按它改写。
  final ValueNotifier<Set<TerminalModifier>> armed;

  /// 一键发一段字节。
  final ValueChanged<List<int>> onInput;

  /// 最左侧常驻的按钮（菜单），不参与横向滚动。
  final Widget? leading;

  /// 最右侧常驻的按钮（复制），不参与横向滚动。
  final Widget? trailing;

  /// 配色，默认与终端画布同一套。
  final TerminalTheme theme;

  @override
  Widget build(BuildContext context) {
    final Widget? leading = this.leading;
    final Widget? trailing = this.trailing;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.background,
        border: const Border(top: BorderSide(color: hairline)),
      ),
      // 手势条区的底色也要算进栏里，否则底部会露出一条别的颜色。
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          child: ValueListenableBuilder<Set<TerminalModifier>>(
            valueListenable: armed,
            builder:
                (
                  BuildContext context,
                  Set<TerminalModifier> modifiers,
                  Widget? child,
                ) {
                  return Row(
                    children: <Widget>[
                      if (leading != null) ...<Widget>[
                        leading,
                        SizedBox(width: 8.w),
                        SizedBox(
                          height: 22.h,
                          child: const VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: hairline,
                          ),
                        ),
                        SizedBox(width: 8.w),
                      ],
                      Expanded(child: _buildKeys(context, modifiers)),
                      if (trailing != null) ...<Widget>[
                        SizedBox(width: 8.w),
                        SizedBox(
                          height: 22.h,
                          child: const VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: hairline,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        trailing,
                      ],
                    ],
                  );
                },
          ),
        ),
      ),
    );
  }

  /// 键帽行：宽度够就居中，不够就横向滚动，任何屏宽下都不溢出。
  Widget _buildKeys(BuildContext context, Set<TerminalModifier> modifiers) {
    final List<Widget> keys = <Widget>[
      _buildKey(label: 'ESC', bytes: '\x1b', modifiers: modifiers),
      _buildModifier(TerminalModifier.ctrl, 'CTRL', modifiers),
      for (final TerminalKey key in _functionKeys)
        _buildKey(label: key.label, key: key, modifiers: modifiers),
    ];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (int i = 0; i < keys.length; i++) ...<Widget>[
                  if (i > 0) SizedBox(width: 6.w),
                  keys[i],
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// 一次性的功能键。[key] 为空时只发 [bytes]（ESC 用）。
  Widget _buildKey({
    required String label,
    required Set<TerminalModifier> modifiers,
    String? bytes,
    TerminalKey? key,
  }) {
    return _KeyButton(
      label: label,
      active: false,
      onTap: () => _emit(key?.payload(modifiers) ?? bytes!, modifiers),
      textColor: keyForeground,
    );
  }

  /// 修饰键：点击只切换扣住状态，不发字节。
  Widget _buildModifier(
    TerminalModifier modifier,
    String label,
    Set<TerminalModifier> modifiers,
  ) {
    final bool active = modifiers.contains(modifier);
    return _KeyButton(
      label: label,
      active: active,
      onTap: () {
        final Set<TerminalModifier> next = <TerminalModifier>{...modifiers};
        if (active) {
          next.remove(modifier);
        } else {
          next.add(modifier);
        }
        armed.value = next;
      },
      textColor: active ? const Color(0xFF101010) : keyForeground,
    );
  }

  void _emit(String data, Set<TerminalModifier> modifiers) {
    onInput(utf8.encode(data));
    // 修饰键是一次性的：按过任意功能键就弹起，免得用户以为还扣着。
    if (modifiers.isNotEmpty) armed.value = const <TerminalModifier>{};
  }
}

/// 底栏上的图标键：外观与键帽一致，点击行为由 [onTap] 决定。
///
/// 菜单按钮挂在底栏最左侧，用同一套键帽外壳，整条栏看起来才是原生的终端
/// 按键区，而不是界面控件硬塞进来的一块。
class TerminalIconKey extends StatelessWidget {
  const TerminalIconKey({
    super.key,
    required this.semanticLabel,
    required this.icon,
    required this.onTap,
  });

  /// 读屏念出的名字；图标本身对读屏没有意义。
  final String semanticLabel;

  /// 键帽里的图标。
  final Widget icon;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: _KeyShell(onTap: onTap, child: icon),
    );
  }
}

/// 键帽。
class _KeyButton extends StatelessWidget {
  const _KeyButton({
    required this.label,
    required this.active,
    required this.onTap,
    required this.textColor,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: active ? true : null,
      label: label,
      excludeSemantics: true,
      child: _KeyShell(
        active: active,
        onTap: onTap,
        child: Text(
          label,
          maxLines: 1,
          softWrap: false,
          style: TextStyle(
            fontFamily: AppFonts.code,
            fontSize: 11.sp,
            height: 1,
            letterSpacing: 0.2,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

/// 键帽外壳：底色、描边、圆角、水波纹。文字键与图标键共用，尺寸才统一。
class _KeyShell extends StatelessWidget {
  const _KeyShell({
    required this.child,
    required this.onTap,
    this.active = false,
  });

  final Widget child;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(8.r);

    return SizedBox(
      height: TerminalKeyBar.keyHeight.h,
      child: Material(
        color: active ? TerminalKeyBar.keyAccent : TerminalKeyBar.keyColor,
        borderRadius: radius,
        // 不用 InkWell 的焦点：点按键时焦点要留在终端上，软键盘不能收起来。
        child: InkWell(
          borderRadius: radius,
          canRequestFocus: false,
          onTap: onTap,
          child: Container(
            constraints: BoxConstraints(minWidth: TerminalKeyBar.keyMinWidth.w),
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(
                color: active
                    ? TerminalKeyBar.keyAccent
                    : TerminalKeyBar.keyBorder,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
