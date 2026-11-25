import 'dart:async';

import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/providers/adb_shell_provider.dart';
import 'package:Aisupass/core/utils/escalation_reason.dart';
import 'package:Aisupass/core/utils/escalation_result_lines.dart';
import 'package:Aisupass/core/utils/terminal_text_writer.dart';
import 'package:Aisupass/features/escalation/domain/enums/ghost_key_kind.dart';
import 'package:Aisupass/features/escalation/domain/models/dirty_frag_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/dirty_frag_run_defaults.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_preflight.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_run_defaults.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_preflight.dart';
import 'package:Aisupass/features/escalation/domain/models/handoff_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:Aisupass/features/escalation/presentation/controllers/manual_escalation_controller.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/terminal_session_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/dirty_frag_confirm_dialog.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ghost_key_confirm_dialog.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ghost_key_progress_panel.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/ghost_lock_confirm_dialog.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/payload_catalog_dialog.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/payload_confirm_dialog.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/terminal_key_bar.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/terminal_link_notice.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xterm3/xterm.dart';

/// 终端页：一条常驻 pty shell 的交互界面，同时是提权流程的执行处。
///
/// 终端实例与 pty 会话由 [terminalSessionProvider] 持有，与手动提权页共用，
/// 所以从提权页发起的动作进来就能看到完整输出。提权流程也放在这一页执行：
/// 命令输出与结果都写在这里的屏幕上，不再依赖另一个页面的状态。
class TerminalPage extends HookConsumerWidget {
  const TerminalPage({super.key, this.initialAction});

  /// 进页面后立刻执行的动作，来自路由 `?action=`：
  /// `payload` / `dirtyFrag` / `ghostKey` / `ghostLock` / `handoff`。
  final String? initialAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ThemeData theme = Theme.of(context);

    final TerminalSession session = ref.watch(terminalSessionProvider);
    final Terminal terminal = session.terminal;
    final TerminalTextWriter writer = session.writer;

    // 会话按引用计数：这一页在的时候保证 pty 是通的，走了只交还自己那份。
    useEffect(() {
      session.acquire();
      // 招牌等首帧末尾再画：排版宽度要等 `TerminalView` layout 出列数。
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => session.flushBanner(),
      );
      return session.release;
    }, <Object?>[session]);

    // 拼命令要读设备身份、解载荷清单，可能耗一小会儿；这段时间挂个转圈。
    final ValueNotifier<bool> busy = useState<bool>(false);

    // 流程编排统一交给 Controller：页面只提供写屏、忙碌位与弹窗回调。
    final ManualEscalationController flow = useMemoized(
      () => ManualEscalationController(
        ref: ref,
        l10n: l10n,
        writeLine: (String text, EscalationTone tone) =>
            writer.writeLine(text, color: escalationToneColor(tone)),
        isBusy: () => busy.value,
        setBusy: (bool value) => busy.value = value,
      ),
      <Object?>[session, l10n],
    );

    final ShellTerminalState shellState = ref.watch(shellExecProvider);
    final ShellLink? link = ref.watch(shellLinkProvider);

    final bool connected = link?.connected ?? false;
    final int uid = link?.uid ?? -1;

    // 记「哪个管理器被点过」而不是「点没点过」：换目标时不能自动开跑。
    final ValueNotifier<RootManager?> handoffTarget = useState<RootManager?>(
      null,
    );
    final RootManager? handoffManager = handoffTarget.value;
    final AsyncValue<HandoffOutcome>? handoff = handoffManager == null
        ? null
        : ref.watch(handoffRootProvider(manager: handoffManager));

    // 记这一轮的偏移覆盖而不是「点没点过」：null 表示还没开跑。
    // 其余参数（VR 反制 / 自动解析 / 软重启）来自设置页，不进这个状态。
    final ValueNotifier<int?> dirtyFragOffset = useState<int?>(null);
    final ObjectRef<bool> dirtyFragStarted = useRef<bool>(false);
    final RootManager? dirtyFragManager = ref
        .watch(selectedRootManagerProvider)
        .value;
    final AsyncValue<DirtyFragOutcome>? dirtyFrag =
        !dirtyFragStarted.value || dirtyFragManager == null
        ? null
        : ref.watch(
            runDirtyFragProvider(
              manager: dirtyFragManager,
              vrOffsetOverride: dirtyFragOffset.value,
            ),
          );

    final RootManager? ghostKeyManager = ref
        .watch(selectedRootManagerProvider)
        .value;
    // 用 useState 而非 useRef：开跑前要先等运行日志落盘，这段 await 之后
    // 必须靠这次状态变化触发重建，才能订阅到 runGhostKeyProvider。
    final ValueNotifier<bool> ghostKeyStarted = useState<bool>(false);
    final AsyncValue<GhostKeyOutcome>? ghostKey = !ghostKeyStarted.value
        ? null
        : ref.watch(runGhostKeyProvider(manager: ghostKeyManager));

    final RootManager? ghostLockManager = ref
        .watch(selectedRootManagerProvider)
        .value;
    final ValueNotifier<bool> ghostLockStarted = useState<bool>(false);
    final ValueNotifier<bool> ghostLockSafeMode = useState<bool>(false);
    final AsyncValue<GhostLockOutcome>? ghostLock = !ghostLockStarted.value
        ? null
        : ref.watch(
            runGhostLockProvider(
              manager: ghostLockManager,
              safeMode: ghostLockSafeMode.value,
            ),
          );

    final bool running =
        busy.value ||
        (handoff?.isLoading ?? false) ||
        (dirtyFrag?.isLoading ?? false) ||
        (ghostKey?.isLoading ?? false) ||
        (ghostLock?.isLoading ?? false);

    Future<void> startExploit() => flow.startExploit();

    /// 载荷提权：先选一条（自动匹配或清单里指定），确认后执行。
    ///
    /// 自动匹配不需要二次确认：它本来就是按设备身份挑最合适的一条，弹窗里
    /// 已经点过一次。手工指定的载荷会在设备上真实执行，落键前再问一次。
    Future<void> startPayloadRoot() async {
      final PayloadPick? pick = await showPayloadPickDialog(context);
      if (pick == null || !context.mounted) return;
      switch (pick) {
        case PayloadPickAuto():
          await startExploit();
        case PayloadPickItem(payload: final Payload payload):
          final bool confirmed = await showPayloadConfirmDialog(
            context,
            payload,
          );
          if (!confirmed) return;
          await flow.startPayload(payload);
      }
    }

    /// 停止本侧读取；设备侧进程继续跑。
    Future<void> stopGhostKey() =>
        flow.stopGhostKey(onError: (Object error) => ToastMessage.error(error));

    /// 停止本侧读取；设备侧进程继续跑。
    Future<void> stopGhostLock() => flow.stopGhostLock(
      onError: (Object error) => ToastMessage.error(error),
    );

    /// 把临时 root 移交给当前选定的管理器。
    Future<void> startHandoff() => flow.startHandoff(
      currentTarget: handoffTarget.value,
      onSwitch: (RootManager manager) => handoffTarget.value = manager,
      onRetry: (RootManager manager) =>
          ref.invalidate(handoffRootProvider(manager: manager)),
    );

    /// 跑一次 DirtyFrag。
    Future<void> startDirtyFrag() => flow.startDirtyFrag(
      confirm:
          ({
            required RootManager manager,
            required String kernelVersion,
            required bool kernelSupported,
            required DirtyFragRunDefaults defaults,
          }) async {
            if (!context.mounted) return null;
            return showDirtyFragConfirmDialog(
              context,
              manager: manager,
              kernelVersion: kernelVersion,
              kernelSupported: kernelSupported,
              defaults: defaults,
            );
          },
      onStart: (RootManager manager, int? override) {
        dirtyFragOffset.value = override;
        dirtyFragStarted.value = true;
        ref.invalidate(
          runDirtyFragProvider(manager: manager, vrOffsetOverride: override),
        );
      },
    );

    /// 跑一次 GhostKey。
    Future<void> startGhostKey() => flow.startGhostKey(
      confirm:
          ({
            required RootManager? manager,
            required GhostKeyPreflight preflight,
            required GhostKeyRunDefaults defaults,
          }) async {
            if (!context.mounted) return null;
            return showGhostKeyConfirmDialog(
              context,
              manager: manager,
              preflight: preflight,
              defaults: defaults,
            );
          },
      onStart: (RootManager? manager) {
        ghostKeyStarted.value = true;
        ref.invalidate(runGhostKeyProvider(manager: manager));
      },
    );

    /// 跑一次 GhostLock。
    Future<void> startGhostLock() => flow.startGhostLock(
      confirm:
          ({
            required RootManager? manager,
            required GhostLockPreflight preflight,
          }) async {
            if (!context.mounted) return null;
            return showGhostLockConfirmDialog(
              context,
              manager: manager,
              preflight: preflight,
            );
          },
      onStart: (RootManager? manager, bool safeMode) {
        ghostLockSafeMode.value = safeMode;
        ghostLockStarted.value = true;
        ref.invalidate(
          runGhostLockProvider(manager: manager, safeMode: safeMode),
        );
      },
    );

    /// 进页面时带过来的动作，只执行一次。
    ///
    /// 推迟到首帧之后：确认弹窗要等 `TerminalView` 先画出来，用户才看得到
    /// 弹窗背后的终端。
    final ObjectRef<bool> actionFired = useRef<bool>(false);
    useEffect(() {
      if (actionFired.value) return null;
      final String? action = initialAction;
      if (action == null || action.isEmpty) return null;
      actionFired.value = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        switch (action) {
          case 'payload':
            unawaited(startPayloadRoot());
          case 'dirtyFrag':
            unawaited(startDirtyFrag());
          case 'ghostKey':
            unawaited(startGhostKey());
          case 'ghostLock':
            unawaited(startGhostLock());
          case 'handoff':
            unawaited(startHandoff());
        }
      });
      return null;
    }, const <Object?>[]);

    /// 把终端里选中的文本复制到剪贴板。
    ///
    /// 安卓上没有 `Ctrl+Shift+C`，xterm3 的复制只挂在桌面快捷键上，触摸端唯一
    /// 的入口就是底栏这个常驻键：先长按选中，再按它。
    void copySelection() {
      final BufferRange? range = session.controller.selectionFor(
        terminal.buffer,
      );
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

    void clearTerminal() => terminal.clear();

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
      // 会话恢复后清掉水位：下次真断了要能重新记一行。
      if (shellState.ready) shownFailure.value = '';
      // 通道未连接不写进终端：顶部提示条负责说明并给出重连入口，写进屏幕只会
      // 在连上之后留下一句错的旧话，看着像还断着。
      if (failure.isNotEmpty &&
          failure != kEscalationChannelNotReady &&
          failure != shownFailure.value) {
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
          writeEscalationResult(
            writer,
            handoffResultLines(outcome, l10n),
            stream: outcome.output,
          );
        },
      );
      return null;
    }, <Object?>[handoff]);

    // DirtyFrag 每块都写屏：中间块只追加输出，终局块再补结论行。
    useEffect(() {
      final AsyncValue<DirtyFragOutcome>? state = dirtyFrag;
      if (state == null) return null;
      state.when(
        loading: () {},
        error: (Object error, StackTrace stackTrace) {
          writer.writeLine(
            '${l10n.escalationInvokeFailed}：$error',
            color: TerminalTextWriter.red,
          );
        },
        data: (DirtyFragOutcome outcome) {
          if (!outcome.isFinal) {
            writer.writeStream(outcome.output);
            return;
          }
          final RootManager? manager = dirtyFragManager;
          writeEscalationResult(
            writer,
            dirtyFragResultLines(outcome, manager, l10n),
            stream: outcome.output,
          );
          // 跑完就复位，否则重进页面会复用上一轮的 Provider 缓存。
          dirtyFragStarted.value = false;
          dirtyFragOffset.value = null;
          ref.invalidate(dirtyFragArmedProvider);

          // D8：成功后自动补跑移交。
          //
          // 必须补跑的理由：bootstrap.c 的 ksud 调用不带 --allow-shell，
          // 内核能力只进了管理器，本进程（shell uid 2000）仍然没有 root。
          // 既有移交脚本带 --allow-shell，是 shell 侧拿到 root 的唯一路径。
          // 复用既有流程：给 handoffTarget 赋上管理器，既有的 handoff
          // useEffect 会接手写屏，这里不重复输出。
          if (outcome.success && manager != null) {
            if (handoffTarget.value == manager) {
              ref.invalidate(handoffRootProvider(manager: manager));
            } else {
              handoffTarget.value = manager;
            }
          }
        },
      );
      return null;
    }, <Object?>[dirtyFrag]);

    // GhostKey 每块都写屏：中间块只追加输出，终局块再补结论行。
    useEffect(() {
      final AsyncValue<GhostKeyOutcome>? state = ghostKey;
      if (state == null) return null;
      state.when(
        loading: () {},
        error: (Object error, StackTrace stackTrace) {
          writer.writeLine(
            '${l10n.escalationInvokeFailed}：$error',
            color: TerminalTextWriter.red,
          );
        },
        data: (GhostKeyOutcome outcome) {
          if (!outcome.isFinal) {
            writer.writeStream(outcome.output);
            return;
          }
          writeEscalationResult(
            writer,
            ghostKeyResultLines(outcome, ghostKeyManager, l10n),
            stream: outcome.output,
          );
          // 08：落盘 + 诊断。顺序严格为「写屏 -> 落盘 -> finish」，不可换。
          unawaited(flow.persistGhostKeyChunk(outcome));
          // 跑完就复位，否则重进页面会复用上一轮的 Provider 缓存。
          ghostKeyStarted.value = false;
        },
      );
      return null;
    }, <Object?>[ghostKey]);

    // GhostLock 每块都写屏：中间块只追加输出，终局块再补结论行。
    useEffect(() {
      final AsyncValue<GhostLockOutcome>? state = ghostLock;
      if (state == null) return null;
      state.when(
        loading: () {},
        error: (Object error, StackTrace stackTrace) {
          writer.writeLine(
            '${l10n.escalationInvokeFailed}：$error',
            color: TerminalTextWriter.red,
          );
        },
        data: (GhostLockOutcome outcome) {
          if (!outcome.isFinal) {
            writer.writeStream(outcome.output);
            return;
          }
          writeEscalationResult(
            writer,
            ghostLockResultLines(outcome, ghostLockManager, l10n),
            stream: outcome.output,
          );
          // 写屏 -> 落盘 -> finish，顺序不可换。
          unawaited(flow.persistGhostLockChunk(outcome));
          // 跑完就复位，否则重进页面会复用上一轮的 Provider 缓存。
          ghostLockStarted.value = false;
          ref.invalidate(ghostLockPreflightProvider);

          // D8：成功后自动补跑移交。
          //
          // 上游 root 脚本只做 `late-load --kmi`，不带 --allow-shell，
          // 内核能力只进了管理器，本进程（uid 2000）仍没有 root。
          // 既有移交脚本带 --allow-shell，是 shell 侧拿到 root 的唯一路径。
          if (outcome.success && ghostLockManager != null) {
            if (handoffTarget.value == ghostLockManager) {
              ref.invalidate(handoffRootProvider(manager: ghostLockManager));
            } else {
              handoffTarget.value = ghostLockManager;
            }
          }
        },
      );
      return null;
    }, <Object?>[ghostLock]);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.escalationTerminalTitle),
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
          // 运行中给一个停止入口：只停止本侧读取，设备侧进程继续跑。
          if (ghostKeyStarted.value && ghostKey?.value?.isFinal != true)
            IconButton(
              tooltip: l10n.escalationGhostLockStop,
              onPressed: () => unawaited(stopGhostKey()),
              icon: Icon(
                Icons.stop_circle_outlined,
                size: 20.r,
                color: theme.colorScheme.error,
              ),
            ),
          if (ghostLockStarted.value && ghostLock?.value?.isFinal != true)
            IconButton(
              tooltip: l10n.escalationGhostLockStop,
              onPressed: () => unawaited(stopGhostLock()),
              icon: Icon(
                Icons.stop_circle_outlined,
                size: 20.r,
                color: theme.colorScheme.error,
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
          // 终端只跑在无线 ADB 上；没连上时在这里说明，并提供连接入口。
          const TerminalLinkNotice(),
          Expanded(
            child: Container(
              color: TerminalThemes.defaultTheme.background,
              child: TerminalView(
                terminal,
                // 选区要能被底栏的复制键读到，所以控制器由会话持有。
                controller: session.controller,
                // 自己拿着滚动控制器：写屏之后要靠它补一次「跳到最新一行」。
                scrollController: session.scroll,
                padding: EdgeInsets.all(8.r),
                textStyle: TerminalStyle(fontSize: 12.sp, height: 1.15),
                theme: TerminalThemes.defaultTheme,
                // 软键盘退格不一定发按键事件，安卓上只能靠文本变化推断。推断出来的
                // 退格同样是交给 onOutput 的字节，远端行编辑会照常处理。
                deleteDetection: true,
                // 不在进页面时就弹键盘：需要打字时点一下终端即可
                // （TerminalView 在 tap-down 时请求焦点）。
                autofocus: false,
              ),
            ),
          ),
          // 未受理时五个阶段都没跑，进度面板没有信息可给。
          if (ghostKey?.value != null &&
              ghostKey!.value!.kind != GhostKeyKind.notStarted)
            GhostKeyProgressPanel(outcome: ghostKey.value!),
          // 底栏：左侧清屏固定，右侧复制键固定，中间功能键放得下就居中、
          // 放不下就横向滚动。
          TerminalKeyBar(
            armed: session.armed,
            onInput: (List<int> bytes) => unawaited(
              ref.read(shellExecProvider.notifier).writeBytes(bytes),
            ),
            leading: TerminalIconKey(
              semanticLabel: l10n.escalationMenuClear,
              onTap: clearTerminal,
              icon: Icon(
                Icons.cleaning_services_rounded,
                size: 18.r,
                color: TerminalKeyBar.keyForeground,
              ),
            ),
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
