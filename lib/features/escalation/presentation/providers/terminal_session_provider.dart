import 'dart:async';
import 'dart:io';

import 'package:Aisupass/core/providers/adb_shell_provider.dart';
import 'package:Aisupass/core/utils/terminal_text_writer.dart';
import 'package:Aisupass/features/escalation/domain/enums/terminal_modifier.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/terminal_key_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xterm3/xterm.dart';

part 'terminal_session_provider.g.dart';

/// 终端按哪个平台的按键习惯解释输入；桌面端只用于调试布局，传 `unknown`。
TerminalTargetPlatform _platform() => Platform.isAndroid
    ? TerminalTargetPlatform.android
    : TerminalTargetPlatform.unknown;

/// 全局唯一的终端会话。
///
/// 手动提权页与终端页共用同一份终端缓冲与同一条 pty：切页不丢历史，停在提权页
/// 时发起的提权命令，其输出也继续累积进来，进终端页能看到完整过程。
///
/// 刻意 `keepAlive`：切页会把实例连同屏幕历史一起丢掉。
@Riverpod(keepAlive: true)
TerminalSession terminalSession(Ref ref) {
  final TerminalSession session = TerminalSession(ref);
  ref.onDispose(session.dispose);
  // 连接恢复后补建一次 pty：进页面那次 open() 可能因为还没连上而失败。
  ref.listen<ShellLink?>(shellLinkProvider, (
    ShellLink? previous,
    ShellLink? next,
  ) {
    if (next?.connected == true && previous?.connected != true) {
      session.onLinkRestored();
    }
  });
  return session;
}

/// 共享终端：终端实例、修饰键、写屏通路、招牌与会话生命周期都在这里。
///
/// 会话用引用计数管理：页面进 [acquire]、走 [release]，减到 0 才收掉 pty，
/// 因此在手动提权页与终端页之间来回切不会重建会话。
class TerminalSession {
  TerminalSession(this._ref)
    : terminal = Terminal(maxLines: 4000, platform: _platform());

  /// 招牌还没画出来时，输出先攒着，画完再按顺序回放。
  static const int _backlogCap = 1 << 20;

  final Ref _ref;

  /// 被写入、被显示的终端。
  final Terminal terminal;

  /// 终端视图的滚动控制器，写屏之后靠它补一次置底。
  final ScrollController scroll = ScrollController();

  /// 选区记在控制器里；复制键靠它读到选区。
  final TerminalController controller = TerminalController();

  /// 写屏与招牌都走它，颜色与置底逻辑集中在这里。
  late final TerminalTextWriter writer = TerminalTextWriter(
    terminal: terminal,
    scroll: scroll,
  );

  /// 按键栏扣住的修饰键。软键盘输入也要按它改写，所以与会话同生命周期。
  final ValueNotifier<Set<TerminalModifier>> armed =
      ValueNotifier<Set<TerminalModifier>>(const <TerminalModifier>{});

  /// 招牌只画一次（清屏之后也不重画）。
  bool _bannerDrawn = false;

  /// 招牌画出来之前的输出。
  final StringBuffer _backlog = StringBuffer();

  /// 正在使用这条会话的页面数。
  int _acquires = 0;

  /// 页面进来时调用，第一处调用负责接线并建会话。
  void acquire() {
    if (_acquires++ > 0) return;

    final ShellExecController shell = _ref.read(shellExecProvider.notifier);

    // 键盘输入与终端自发应答都走同一条 stdin，pty 只认字节流。
    terminal.onOutput = (String data) =>
        unawaited(shell.writeBytes(encodeTerminalInput(data, armed.value)));

    // xterm3 给 (列, 行, 像素宽, 像素高)，原生要 (行, 列)；像素尺寸远端用不上。
    terminal.onResize =
        (int width, int height, int pixelWidth, int pixelHeight) {
          unawaited(shell.resize(height, width));
          // 回调在 layout 内触发，写屏推迟到帧末。
          WidgetsBinding.instance.addPostFrameCallback((_) => flushBanner());
        };

    shell.attachSink((String text, bool isStderr) {
      // 载荷输出里可能带着 KASLR 偏移，喂给执行侧的滑动缓存。
      unawaited(
        _ref.read(escalationActionsProvider).observePayloadOutput(text),
      );
      // 招牌还没画：先攒着，画完再补。攒太多了就先画招牌，别把输出一直扣住。
      if (!_bannerDrawn) {
        _backlog.write(text);
        if (_backlog.length > _backlogCap) flushBanner();
        return;
      }
      // pty 输出自带 `\r\n` 与控制序列，原样写屏。
      terminal.write(text);
      writer.stickToBottom();
    });

    // 先挂通路再建会话：提示符可能立刻就到。
    unawaited(() async {
      await shell.open();
      // 视图没 layout 完时那次 onResize 会被丢掉，这里补一次。
      await shell.resize(terminal.viewHeight, terminal.viewWidth);
    }());
  }

  /// 页面离开时调用，最后一处离开才收掉会话。
  void release() {
    if (_acquires == 0) return;
    if (--_acquires > 0) return;

    terminal.onOutput = null;
    terminal.onResize = null;
    final ShellExecController shell = _ref.read(shellExecProvider.notifier);
    shell.attachSink(null);
    // 页面都走了就收掉会话，留一条没人读的 shell 只白占进程和管道。
    shell.close();
  }

  /// 连接恢复后补建会话；没人用着这条会话时不动手。
  void onLinkRestored() {
    if (_acquires == 0) return;
    unawaited(_ref.read(shellExecProvider.notifier).open());
  }

  /// 画招牌，再补上为它暂存的输出。整个终端缓冲只跑一次。
  void flushBanner() {
    if (_bannerDrawn) return;
    _bannerDrawn = true;
    writer.writeBanner(terminal.viewWidth);
    // 空一行：远端提示符紧跟其后，贴着招牌像同一行没写完。
    writer.writeLine('');
    if (_backlog.isNotEmpty) {
      terminal.write(_backlog.toString());
      _backlog.clear();
    }
    writer.stickToBottom();
  }

  /// 容器销毁时释放终端内部挂着的监听器与定时器。
  void dispose() {
    terminal.onOutput = null;
    terminal.onResize = null;
    armed.dispose();
    controller.dispose();
    scroll.dispose();
    terminal.dispose();
  }
}
