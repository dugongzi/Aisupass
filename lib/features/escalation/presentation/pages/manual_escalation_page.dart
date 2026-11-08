import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/providers/adb_shell_provider.dart';
import 'package:Aisupass/core/utils/escalation_reason.dart';
import 'package:Aisupass/core/utils/terminal_text_writer.dart';
import 'package:Aisupass/features/escalation/domain/enums/root_manager.dart';
import 'package:Aisupass/features/escalation/domain/models/handoff_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/escalation_menu_button.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/payload_catalog_dialog.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/payload_confirm_dialog.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/terminal_key_bar.dart';
import 'package:Aisupass/generated/adb_shell.g.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xterm3/xterm.dart';

/// 手动提权页：一条常驻 pty shell，提权与移交挂在底部左侧菜单。
///
/// 提权把载荷的命令行直接敲进这条 pty：输出实时上屏，`Ctrl+C` 中止，退出码看
/// `$?`。移交是一条命令等它跑完，因为要按退出码与输出分型。
class ManualEscalationPage extends HookConsumerWidget {
  const ManualEscalationPage({super.key});

  /// 终端按哪个平台的按键习惯解释输入；桌面端只用于调试布局，传 `unknown`。
  static TerminalTargetPlatform _platform() => Platform.isAndroid
      ? TerminalTargetPlatform.android
      : TerminalTargetPlatform.unknown;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ThemeData theme = Theme.of(context);

    // 重建 Widget 不能重建终端，否则屏幕历史会被清空。
    final Terminal terminal = useMemoized(
      () => Terminal(maxLines: 4000, platform: _platform()),
      const <Object?>[],
    );
    // 终端内部挂着监听器和定时器，页面销毁时必须显式释放。
    useEffect(() => terminal.dispose, <Object?>[terminal]);

    // 自己拿着滚动控制器：写屏之后要靠它补一次置底，见 [stickToBottom]。
    final ScrollController scroll = useMemoized(
      ScrollController.new,
      const <Object?>[],
    );
    useEffect(() => scroll.dispose, <Object?>[scroll]);

    // 选区记在控制器里。不自己传的话 `TerminalView` 会在内部另建一个，外部读
    // 不到选区，底栏的复制键就无从复制。
    final TerminalController controller = useMemoized(
      TerminalController.new,
      const <Object?>[],
    );
    useEffect(() => controller.dispose, <Object?>[controller]);

    // 写屏与招牌都在这层做，页面只管什么时候写什么。
    final TerminalTextWriter writer = useMemoized(
      () => TerminalTextWriter(terminal: terminal, scroll: scroll),
      <Object?>[terminal, scroll],
    );

    // 按键栏扣住的修饰键。软键盘输入也要按它改写，所以状态放在页面这层：
    // 按键栏只负责切换，改写发生在 onOutput 里。
    final ValueNotifier<Set<TerminalModifier>> armedModifiers = useMemoized(
      () => ValueNotifier<Set<TerminalModifier>>(const <TerminalModifier>{}),
      const <Object?>[],
    );
    useEffect(() => armedModifiers.dispose, <Object?>[armedModifiers]);

    final ShellTerminalState shellState = ref.watch(shellExecProvider);
    final ShellConnection? link = ref.watch(shellConnectionProvider).value;

    final bool connected = link?.connected ?? false;
    final int uid = link?.uid ?? -1;

    // 拼命令要读设备身份、解载荷清单，可能耗一小会儿；这段时间挂个转圈。
    final ValueNotifier<bool> busy = useState<bool>(false);

    // 记「哪个管理器被点过」而不是「点没点过」：换目标时不能自动开跑。
    final ValueNotifier<RootManager?> handoffTarget = useState<RootManager?>(
      null,
    );
    final RootManager? handoffManager = handoffTarget.value;
    final AsyncValue<HandoffOutcome>? handoff = handoffManager == null
        ? null
        : ref.watch(handoffRootProvider(manager: handoffManager));

    final bool running = busy.value || (handoff?.isLoading ?? false);

    // 招牌要按真实列数挑排版；画好之前到达的输出先攒着，顺序才不会颠倒。
    final ObjectRef<bool> bannerDrawn = useRef<bool>(false);
    final StringBuffer bannerBacklog = useMemoized(
      StringBuffer.new,
      const <Object?>[],
    );

    /// 画招牌，再补上为它暂存的输出。只跑一次。
    ///
    /// 调用点是首帧 post-frame 与 `onResize` 回调，谁先到算谁——在那之前
    /// `terminal.viewWidth` 还是默认的 80 列。
    void flushBanner() {
      if (bannerDrawn.value) return;
      bannerDrawn.value = true;
      writer.writeBanner(terminal.viewWidth);
      // 空一行：远端提示符紧跟其后，贴着招牌像同一行没写完。
      writer.writeLine('');
      if (bannerBacklog.isNotEmpty) {
        terminal.write(bannerBacklog.toString());
        bannerBacklog.clear();
      }
      writer.stickToBottom();
    }

    // 终端与会话接线只做一次。
    useEffect(() {
      final ShellExecController shell = ref.read(shellExecProvider.notifier);

      // 键盘输入与终端自发应答都走同一条 stdin，pty 只认字节流。
      // 底栏扣住的修饰键也要作用于软键盘，所以这里和按键栏共用同一套编码。
      terminal.onOutput = (String data) => unawaited(
        shell.writeBytes(encodeTerminalInput(data, armedModifiers.value)),
      );

      // xterm3 给 (列, 行, 像素宽, 像素高)，原生要 (行, 列)；像素尺寸远端用不上。
      terminal.onResize =
          (int width, int height, int pixelWidth, int pixelHeight) {
            unawaited(shell.resize(height, width));
            // 回调在 layout 内触发，写屏推迟到帧末。
            WidgetsBinding.instance.addPostFrameCallback((_) => flushBanner());
          };

      shell.attachSink((String text, bool isStderr) {
        // 载荷输出里可能带着 KASLR 偏移，喂给执行仓储的滑动缓存。
        ref.read(escalationActionRepositoryProvider).observeOutput(text);
        // 招牌还没画：先攒着，画完再补。
        if (!bannerDrawn.value) {
          bannerBacklog.write(text);
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

      return () {
        terminal.onOutput = null;
        terminal.onResize = null;
        shell.attachSink(null);
        // 页面走了就收掉会话，留一条没人读的 shell 只白占进程和管道。
        shell.close();
      };
    }, <Object?>[terminal]);

    /// 把拼出来的一行命令敲进 pty。
    ///
    /// pty 是交互式的，命令要跟一个回车才会执行；`\r` 就是回车键的字节，交给
    /// 远端行编辑处理，和手动敲进去没有区别。
    Future<void> writeCommand(String command) async {
      await ref
          .read(shellExecProvider.notifier)
          .writeBytes(utf8.encode('$command\r'));
    }

    /// 拼命令并敲进终端。跑不起来的原因（设备身份读不到、参数补不齐）由命令
    /// 自己 echo 出来；真正抛异常时在这里补一句。
    Future<void> runCommand(Future<String> Function() build) async {
      if (busy.value) return;
      busy.value = true;
      try {
        await writeCommand(await build());
      } catch (error) {
        writer.writeLine(
          '${l10n.escalationInvokeFailed}：$error',
          color: TerminalTextWriter.red,
        );
      } finally {
        busy.value = false;
      }
    }

    Future<void> startExploit() async {
      if (busy.value) return;
      // 光标停在远端提示符后面，先回车，否则这行接在 `$ ` 后面。
      writer.writeLine('');
      writer.writeLine(
        l10n.escalationExploitStarted,
        color: TerminalTextWriter.yellow,
      );
      ref.invalidate(shellConnectionProvider);
      // 每次都要重拼：设备状态可能变了，别吃上次的缓存。
      ref.invalidate(runPayloadProvider);
      await runCommand(() => ref.read(runPayloadProvider.future));
    }

    /// 用清单里挑出来的这一条提权，跳过自动匹配。
    Future<void> startPayload(Payload payload) async {
      if (busy.value) return;
      writer.writeLine('');
      writer.writeLine(
        l10n.escalationPayloadManualStarted(payload.displayName),
        color: TerminalTextWriter.yellow,
      );
      ref.invalidate(shellConnectionProvider);
      ref.invalidate(runPayloadChoiceProvider(payload: payload));
      await runCommand(
        () => ref.read(runPayloadChoiceProvider(payload: payload).future),
      );
    }

    /// 打开载荷清单，选中一条后先二次确认，确认了才真的跑。
    Future<void> openPayloadCatalog() async {
      final Payload? picked = await showPayloadCatalogDialog(context);
      if (picked == null) return;
      // 弹窗之间隔着一次 await，页面可能已经退出。
      if (!context.mounted) return;
      final bool confirmed = await showPayloadConfirmDialog(context, picked);
      if (!confirmed || !context.mounted) return;
      await startPayload(picked);
    }

    void startHandoff(RootManager manager) {
      writer.writeLine('');
      writer.writeLine(
        l10n.escalationHandoffRunning(manager.displayName),
        color: TerminalTextWriter.yellow,
      );
      if (handoffTarget.value == manager) {
        ref.invalidate(handoffRootProvider(manager: manager));
      } else {
        handoffTarget.value = manager;
      }
    }

    /// 把终端里选中的文本复制到剪贴板。
    ///
    /// 安卓上没有 `Ctrl+Shift+C`，xterm3 的复制只挂在桌面快捷键上，触摸端唯一
    /// 的入口就是底栏这个常驻键：先长按选中，再按它。
    void copySelection() {
      final BufferRange? range = controller.selectionFor(terminal.buffer);
      final String text = range == null
          ? ''
          : terminal.buffer.getText(range, true);
      if (text.isEmpty) {
        writer.writeLine(
          l10n.escalationCopyEmpty,
          color: TerminalTextWriter.yellow,
        );
        return;
      }
      unawaited(Clipboard.setData(ClipboardData(text: text)));
      writer.writeLine(l10n.escalationCopied, color: TerminalTextWriter.dim);
    }

    void onMenu(EscalationMenuAction action) {
      switch (action) {
        case EscalationMenuAction.exploit:
          unawaited(startExploit());
        case EscalationMenuAction.handoffKernelsu:
          startHandoff(RootManager.kernelsu);
        case EscalationMenuAction.handoffSukisu:
          startHandoff(RootManager.sukisu);
        case EscalationMenuAction.payloadCatalog:
          // 弹窗盖在终端上，键盘收起后用户先看完再关。
          unawaited(openPayloadCatalog());
        case EscalationMenuAction.clear:
          terminal.clear();
      }
    }

    // 招牌等首帧末尾再画：排版宽度要等 `TerminalView` layout 出列数。
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) => flushBanner());
      return null;
    }, const <Object?>[]);

    // 会话故障要留记号，pty 断掉后屏幕是静默停住的；用三个水位避免重刷。
    final ObjectRef<int> shownDropped = useRef<int>(0);
    final ObjectRef<String> shownFailure = useRef<String>('');
    final ObjectRef<bool> wasReady = useRef<bool>(false);
    useEffect(() {
      if (shellState.droppedBytes > shownDropped.value) {
        shownDropped.value = shellState.droppedBytes;
        writer.writeLine(
          l10n.escalationOutputTruncated(shellState.droppedBytes),
          color: TerminalTextWriter.yellow,
        );
      }

      final String failure = shellState.failure;
      if (failure.isNotEmpty && failure != shownFailure.value) {
        shownFailure.value = failure;
        writer.writeLine(
          kEscalationReasonCodes.contains(failure)
              ? l10n.escalationExecStartFailed(
                  escalationReasonLabel(failure, l10n),
                )
              : failure,
          color: TerminalTextWriter.red,
        );
      }

      // 有会话变没会话且没带故障：用户敲了 exit 或对端正常关闭，下一次按键会重连。
      if (wasReady.value && !shellState.ready && failure.isEmpty) {
        writer.writeLine(
          l10n.escalationTerminalClosed,
          color: TerminalTextWriter.dim,
        );
      }
      wasReady.value = shellState.ready;
      return null;
    }, <Object?>[shellState]);

    // 移交按 kind 分支：只有失败才多写一句，告诉用户接着该干什么。
    useEffect(() {
      final AsyncValue<HandoffOutcome>? state = handoff;
      if (state == null) return null;
      state.when(
        loading: () {},
        error: (Object error, StackTrace stackTrace) {
          writer.writeLine(
            '${l10n.escalationInvokeFailed}：$error',
            color: TerminalTextWriter.red,
          );
        },
        data: (HandoffOutcome outcome) {
          final RootManager manager = outcome.manager;
          if (!outcome.success) {
            writer.writeLine(switch (outcome.kind) {
              HandoffKind.managerMissing =>
                l10n.escalationHandoffManagerMissing(
                  manager.displayName,
                  manager.packageName,
                ),
              HandoffKind.noRoot => l10n.escalationHandoffNoRoot,
              HandoffKind.failed =>
                outcome.exitCode < 0
                    ? l10n.escalationHandoffFailedNoCode
                    : l10n.escalationHandoffFailed(outcome.exitCode),
              HandoffKind.success => '',
            }, color: TerminalTextWriter.red);
            // 终端会把 http(s) 识别成可点文本。
            if (outcome.kind == HandoffKind.managerMissing) {
              writer.writeLine(manager.homeUrl, color: TerminalTextWriter.dim);
            }
          }
          if (outcome.ksudPath.isNotEmpty) {
            writer.writeLine(
              'libksud.so: ${outcome.ksudPath}',
              color: TerminalTextWriter.dim,
            );
          }
          writer.writeStream(outcome.output);
          writer.writeLine(
            '[${escalationExitTag(outcome.exitCode)} · ${outcome.durationMs} ms'
            '${outcome.timedOut ? l10n.escalationTimedOutTag : ''}]',
            color: TerminalTextWriter.dim,
          );
        },
      );
      return null;
    }, <Object?>[handoff]);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.escalationTitle),
        actions: <Widget>[
          if (running)
            Padding(
              padding: EdgeInsets.only(right: 6.w),
              child: Center(
                child: SizedBox.square(
                  dimension: 16.r,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          // 连接状态放图标上，省一行地方。
          Tooltip(
            message: connected
                ? l10n.escalationShellConnected(uid)
                : l10n.escalationShellDisconnected,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Icon(
                connected ? Icons.link_rounded : Icons.link_off_rounded,
                size: 20.r,
                color: connected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
      // 终端自己画背景，外层再垫一层同色，避免布局过程中露出 Scaffold 底色。
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: TerminalThemes.defaultTheme.background,
              child: TerminalView(
                terminal,
                // 选区要能被底栏的复制键读到，所以控制器由页面持有。
                controller: controller,
                // 自己拿着滚动控制器：写屏之后要靠它补一次「跳到最新一行」。
                scrollController: scroll,
                padding: EdgeInsets.all(8.r),
                textStyle: TerminalStyle(fontSize: 12.sp, height: 1.15),
                theme: TerminalThemes.defaultTheme,
                // 软键盘退格不一定发按键事件，安卓上只能靠文本变化推断。推断出来的
                // 退格同样是交给 onOutput 的字节，远端行编辑会照常处理。
                deleteDetection: true,
                // 不在进页面时就弹键盘：需要打字时点一下终端即可
                // （TerminalView 在 tap-down 时请求焦点）。
                autofocus: false,
                onHyperlinkTap: (String uri) => unawaited(
                  launchUrl(
                    Uri.parse(uri),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
              ),
            ),
          ),
          // 底栏：左侧菜单固定，右侧复制键固定，中间功能键放得下就居中、
          // 放不下就横向滚动。
          TerminalKeyBar(
            armed: armedModifiers,
            onInput: (List<int> bytes) => unawaited(
              ref.read(shellExecProvider.notifier).writeBytes(bytes),
            ),
            leading: EscalationMenuButton(onSelected: onMenu),
            trailing: TerminalIconKey(
              semanticLabel: l10n.escalationCopy,
              onTap: copySelection,
              icon: Icon(
                Icons.content_copy_rounded,
                size: 18.r,
                color: TerminalKeyBar.keyForeground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
