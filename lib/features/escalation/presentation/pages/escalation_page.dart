import 'dart:async';

import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_chain.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_outcome.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_stage.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_capability.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_capability_matrix.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_step_record.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_record_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/escalation_confirm_dialog.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/escalation_connection_panel.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/escalation_header.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/escalation_matrix_view.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/escalation_outcome_card.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/escalation_residual_banner.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/escalation_texts.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/escalation_timeline.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// `hooks_riverpod` 只转出 HookConsumerWidget，`useEffect` 本身在 flutter_hooks 里，
// 不单独 import 会报 `The method 'useEffect' isn't defined`。
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

/// 提权页：只读探测 → 选择链路 → 执行 → 查看时间线与结论。
///
/// 首屏只调用 `probeAll`，不产生任何系统改动；真正的写操作只发生在
/// 用户点击「开始提权」之后，且由 `EscalationRunController` 单点串行。
class EscalationPage extends HookConsumerWidget {
  const EscalationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final bool isDesktop = isDesktopPlatform;
    final AsyncValue<EscalationCapabilityMatrix> matrixAsync = ref.watch(
      escalationCapabilityMatrixProvider,
    );

    final Widget content = matrixAsync.when(
      loading: () => const Loading(),
      error: (Object error, StackTrace stackTrace) => RefError(
        onRetry: () => ref.invalidate(escalationCapabilityMatrixProvider),
      ),
      data: (EscalationCapabilityMatrix matrix) =>
          _EscalationBody(matrix: matrix),
    );

    if (!isDesktop) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.escalationTitle)),
        body: content,
      );
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 28, 8),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    l10n.escalationTitle,
                    style: context.textTheme.titleLarge?.copyWith(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: content),
        ],
      ),
    );
  }
}

/// 页面主体：矩阵加载完成后才渲染，避免探测期间出现空壳按钮。
///
/// 页面固定三段，顺序即操作顺序：
/// 1. 连接：宿主状态 + **唯一**动作（配对 / 重试点火 / 断开）；
/// 2. 选链：能力矩阵，点哪条就只跑哪条，不再由「优先级最高」替用户决定；
/// 3. 执行：时间线 + 结论卡，底部按钮只负责「开始 / 取消」当前选中的链。
class _EscalationBody extends HookConsumerWidget {
  const _EscalationBody({required this.matrix});

  /// 本次只读探测得到的完整能力矩阵。
  final EscalationCapabilityMatrix matrix;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;

    final bool hostAlive =
        ref.watch(escalationHostStatusProvider).value?.alive ?? false;
    final bool hasResidual =
        ref.watch(escalationResidualProvider).value ?? false;
    final EscalationRunState runState = ref.watch(
      escalationRunControllerProvider,
    );

    // 宿主状态不是推送式的：原生侧只有 `linkToDeath`，没有回传给 Dart 的通道，
    // 而 `escalationHostStatusProvider` 只在点火结束时被 invalidate 一次。
    // 结果就是「已就绪」一旦出现就会一直保持——用户断开无线调试、特权进程被杀
    // 之后，`!hostAlive` 这个配对按钮的显示条件不再成立，按钮永远不会回来。
    // 这里在就绪期间定时重查，让状态跟着真实存活翻转；未就绪时不轮询，
    // 由配对/点火流程自身的 invalidate 负责把状态推上去。
    useEffect(() {
      if (!hostAlive) return null;
      final Timer timer = Timer.periodic(const Duration(seconds: 3), (_) {
        // 上一次查询还没回来就跳过：Binder 若卡在 transact 里，
        // 每 3 秒叠一个新请求会把 Pigeon 的后台线程堆满。
        if (ref.read(escalationHostStatusProvider).isLoading) return;
        ref.invalidate(escalationHostStatusProvider);
      });
      return timer.cancel;
    }, <Object?>[hostAlive]);

    // 选链：用户点过就按用户点的算；没点过、或点过的那条已经不可用，
    // 才退回优先级最高的可用链作为初始值。这里只是「初始值」，
    // 不再像以前那样直接决定主按钮跑哪条链。
    final ValueNotifier<EscalationChain?> picked = useState<EscalationChain?>(
      null,
    );
    final EscalationChain? pickedChain = picked.value;
    final EscalationChain? selectedChain =
        pickedChain != null &&
            (matrix.capabilityOf(pickedChain.name)?.available ?? false)
        ? pickedChain
        : matrix.firstAvailable?.chain;
    final EscalationCapability? selected = selectedChain == null
        ? null
        : matrix.capabilityOf(selectedChain.name);

    /// 配对码是否已被系统接受。
    ///
    /// `PROBE` 阶段一旦带上成功证据，就说明码已经换完了，剩下的只是发现并连接
    /// 调试端口（最坏十几秒）。不区分这两段的话，用户提交码之后页面仍显示
    /// 「等待输入配对码」，看起来就像卡死了。
    final bool codeAccepted =
        runState.pairing &&
        runState.steps.any(
          (EscalationStepRecord step) =>
              step.stage == EscalationStage.probe && step.ok,
        );
    final String pairingStatusLabel = codeAccepted
        ? l10n.escalationPairingConnecting
        : l10n.escalationPairingWaiting;

    /// 配对会话正在进行（码还没换完，或正在建链）。
    final bool pairingRunning = runState.isRunning && runState.pairing;
    /// 配对已完成、正在拉起常驻特权进程。
    final bool igniting =
        runState.pairing && runState.ignitePhase == EscalationIgnitePhase.running;
    /// 配对成功但特权进程没起来；入口留在连接段单独重试。
    final bool igniteFailed =
        runState.pairing && runState.ignitePhase == EscalationIgnitePhase.failed;

    /// 连接段动作是否可点：配对/点火进行中、或提权链正在跑时一律禁掉，
    /// 避免两条写操作同时下发。
    final bool connectionIdle = !runState.isRunning && !igniting;

    /// 断开入口的进行态：只用于防重入与按钮文案，不参与任何判定。
    final ValueNotifier<bool> disconnecting = useState(false);

    /// 配对入口：配对码在通知栏输入；配对（建链）成功后由控制器异步点火。
    Future<void> onPairingPressed() async {
      // 没有通知权限，配对码输入框根本弹不出来。
      // 被拒也继续发起：原生会立刻以配对失败收尾，时间线上有记录，
      // 好过点了按钮毫无反应。
      await Permission.notification.request();
      if (!context.mounted) return;
      await ref.read(escalationRunControllerProvider.notifier).startPairing();
    }

    /// 断开宿主持久进程：特权进程退出后 `hostAlive` 立刻翻回 false，
    /// 配对入口随之重新出现。
    Future<void> onDisconnectPressed() async {
      if (disconnecting.value) return;
      disconnecting.value = true;
      try {
        await ref
            .read(escalationRunControllerProvider.notifier)
            .disconnectHost();
      } finally {
        if (context.mounted) disconnecting.value = false;
      }
    }

    /// 执行段动作：运行中取消，其余情况先确认再启动**选中**的那条链。
    Future<void> onExecutePressed() async {
      if (runState.isRunning) {
        await ref.read(escalationRunControllerProvider.notifier).cancel();
        return;
      }

      final EscalationCapability? capability = selected;
      if (capability == null) return;

      if (capability.chain.dangerLevel >= 1) {
        final bool confirmed = await showEscalationConfirmDialog(
          context,
          chain: capability.chain,
          dangerLevel: capability.chain.dangerLevel,
        );
        if (!confirmed) return;
      }

      await ref
          .read(escalationRunControllerProvider.notifier)
          .start(capability.chain);
    }

    // ---- 连接段：状态 + 唯一动作 ----
    late final String connectionStatus;
    late final String connectionActionLabel;
    late final IconData connectionActionIcon;
    late final VoidCallback? connectionAction;
    late final String? connectionHint;

    if (pairingRunning) {
      connectionStatus = pairingStatusLabel;
      connectionActionLabel = pairingStatusLabel;
      connectionActionIcon = Icons.notifications_active_outlined;
      connectionAction = null;
      connectionHint = l10n.escalationPairingNotice;
    } else if (igniting) {
      connectionStatus = l10n.escalationIgniteRunning;
      connectionActionLabel = l10n.escalationIgniteRunning;
      connectionActionIcon = Icons.hourglass_top_rounded;
      connectionAction = null;
      connectionHint = null;
    } else if (igniteFailed) {
      connectionStatus = l10n.escalationIgniteFailed;
      connectionActionLabel = l10n.escalationIgniteRetry;
      connectionActionIcon = Icons.refresh_rounded;
      // 只重跑点火，不重跑配对：系统那边其实已经配过了。
      connectionAction = () =>
          ref.read(escalationRunControllerProvider.notifier).retryIgnite();
      connectionHint = null;
    } else if (hostAlive) {
      connectionStatus = l10n.escalationHostReady;
      connectionActionLabel = disconnecting.value
          ? l10n.escalationHostDisconnecting
          : l10n.escalationHostDisconnect;
      connectionActionIcon = Icons.link_off_rounded;
      connectionAction = connectionIdle && !disconnecting.value
          ? onDisconnectPressed
          : null;
      connectionHint = l10n.escalationHostDisconnectHint;
    } else {
      connectionStatus = l10n.escalationHostNotStarted;
      connectionActionLabel = l10n.escalationPairingStart;
      connectionActionIcon = Icons.wifi_tethering_rounded;
      connectionAction = connectionIdle ? onPairingPressed : null;
      connectionHint = l10n.escalationPairingNotice;
    }

    // ---- 执行段：底部固定按钮，只负责开始/取消当前选中的链 ----
    late final String executeLabel;
    late final IconData executeIcon;
    late final VoidCallback? executeAction;
    if (runState.isRunning) {
      if (runState.pairing) {
        // 配对进行中不给取消：取消只断开页面订阅，原生线程仍要等满输码窗口。
        executeLabel = pairingStatusLabel;
        executeIcon = Icons.notifications_active_outlined;
        executeAction = null;
      } else {
        executeLabel = l10n.escalationCancel;
        executeIcon = Icons.stop_circle_outlined;
        executeAction = onExecutePressed;
      }
    } else if (igniting) {
      executeLabel = l10n.escalationIgniteRunning;
      executeIcon = Icons.hourglass_top_rounded;
      executeAction = null;
    } else if (runState.isFinished && !runState.pairing) {
      executeLabel = l10n.escalationRetry;
      executeIcon = Icons.refresh_rounded;
      executeAction = selected != null ? onExecutePressed : null;
    } else {
      executeLabel = l10n.escalationStart;
      executeIcon = Icons.bolt_rounded;
      executeAction = selected != null ? onExecutePressed : null;
    }

    /// 配对运行中不给取消：取消只会断开页面订阅，原生线程仍要等满用户输码窗口。
    final bool cancellable = runState.isRunning && !runState.pairing;

    /// 失败原始原因，写进结论卡。
    ///
    /// 阶段失败走步骤里的 `error` 证据；点火失败不产生阶段记录，原因在
    /// `igniteDetail` 里，两者合并成同一个字段展示。
    final String? failureDetail =
        _failureDetail(runState) ?? runState.igniteDetail;

    /// 底部常驻状态行：把「现在在做什么 / 卡在哪」直接写在按钮上方，
    /// 不需要用户去翻时间线或看 logcat。
    final String statusLine = switch (runState.phase) {
      EscalationRunPhase.idle =>
        selected == null
            ? l10n.escalationNoAvailableChain
            : '${escalationChainName(l10n, selected.chain)} · '
                  '${hostAlive ? l10n.escalationHostReady : l10n.escalationHostNotStarted}',
      EscalationRunPhase.running =>
        runState.pairing
            ? pairingStatusLabel
            : '${l10n.escalationRunning}${runState.chain == null ? '' : ' · ${escalationChainName(l10n, runState.chain!)}'}',
      EscalationRunPhase.finished => _resultLine(l10n, runState),
    };

    final double gap = isDesktop ? 12 : 12.h;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isDesktop ? 760 : double.infinity,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: isDesktop
                    ? const EdgeInsets.fromLTRB(28, 6, 28, 16)
                    : EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
                children: <Widget>[
                  EscalationHeader(
                    fingerprint: matrix.fingerprint,
                    hostAlive: hostAlive,
                  ),
                  if (hasResidual) ...<Widget>[
                    SizedBox(height: gap),
                    const EscalationResidualBanner(),
                  ],
                  // 连接段只存在于 Android：其他平台既没有无线调试，也没有宿主。
                  if (isAndroidPlatform) ...<Widget>[
                    SizedBox(height: gap),
                    EscalationConnectionPanel(
                      connected: hostAlive,
                      statusText: connectionStatus,
                      actionLabel: connectionActionLabel,
                      actionIcon: connectionActionIcon,
                      onAction: connectionAction,
                      detail: igniteFailed ? runState.igniteDetail : null,
                      hint: connectionHint,
                    ),
                  ],
                  SizedBox(height: gap),
                  EscalationMatrixView(
                    matrix: matrix,
                    selectedChain: selectedChain,
                    // 运行中禁掉选链：改选中项不会改变已在跑的那条链，
                    // 只会让页面显示的和实际在跑的对不上。
                    onSelect: runState.isRunning
                        ? null
                        : (EscalationChain chain) => picked.value = chain,
                  ),
                  SizedBox(height: gap),
                  EscalationTimeline(steps: runState.steps),
                  if (runState.outcome != null) ...<Widget>[
                    SizedBox(height: gap),
                    EscalationOutcomeCard(
                      outcome: runState.outcome!,
                      reasons: runState.reasons,
                      pairing: runState.pairing,
                      detail: failureDetail,
                    ),
                  ],
                  if (selected == null) ...<Widget>[
                    SizedBox(height: isDesktop ? 8 : 8.h),
                    Text(
                      _unavailableHint(l10n),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isDesktop ? 11.5 : 11.5.sp,
                        height: 1.4,
                        color: colors.onSurfaceVariant.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // 操作区固定在底部：能力矩阵会把整页撑出屏幕，
            // 放在 ListView 末尾就等于「没有按钮」。
            Material(
              color: colors.surface,
              elevation: 8,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: isDesktop
                      ? const EdgeInsets.fromLTRB(28, 10, 28, 16)
                      : EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      if (statusLine.isNotEmpty) ...<Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              // 可选中：这行常带原始异常，用户要能直接拷走，
                              // 而不是对着屏幕手抄一遍。
                              child: SelectableText(
                                statusLine,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isDesktop ? 12 : 12.sp,
                                  height: 1.3,
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ),
                            // 有失败原因时给一个一键复制；没有就不用占位置。
                            if (failureDetail != null)
                              IconButton(
                                onPressed: () => _copy(context, statusLine),
                                icon: Icon(
                                  Icons.copy_rounded,
                                  size: isDesktop ? 16 : 16.sp,
                                ),
                                color: colors.onSurfaceVariant,
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                tooltip: l10n.escalationCopy,
                              ),
                          ],
                        ),
                        SizedBox(height: isDesktop ? 8 : 8.h),
                      ],
                      SizedBox(
                        height: isDesktop ? 46 : 46.h,
                        child: FilledButton.icon(
                          onPressed: executeAction,
                          icon: Icon(executeIcon, size: isDesktop ? 18 : 18.sp),
                          label: Text(
                            executeLabel,
                            style: TextStyle(
                              fontSize: isDesktop ? 14 : 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: cancellable
                                ? colors.error
                                : colors.primary,
                            foregroundColor: cancellable
                                ? colors.onError
                                : colors.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                isDesktop ? 10 : 12.r,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 把状态行写进剪贴板。
  ///
  /// 状态行常带原生回传的原始异常，用户要的是能直接拷走、贴出来，
  /// 而不是对着手机屏幕一个字一个字抄。
  void _copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.maybeOf(context)
        ?.showSnackBar(SnackBar(content: Text(context.l10n.escalationCopied)));
  }

  /// 结束态的一行结论：配对会话用「配对成功 / 配对失败」，不再混用「提权」。
  String _resultLine(AppLocalizations l10n, EscalationRunState runState) {
    final EscalationOutcome? outcome = runState.outcome;
    if (outcome == null) return '';

    final String reasonSuffix = runState.reasons.isEmpty
        ? ''
        : ' · ${escalationReasonText(l10n, runState.reasons.first)}';

    if (runState.pairing) {
      if (outcome != EscalationOutcome.success) {
        return '${l10n.escalationPairingFailed}$reasonSuffix';
      }
      // 配对成功之后点火是独立一步，必须说清它进行到哪了；
      // 否则「配对成功」和页头「宿主未启动」摆在一起会让人以为系统在骗人。
      return switch (runState.ignitePhase) {
        EscalationIgnitePhase.running => l10n.escalationIgniteStarting,
        EscalationIgnitePhase.ready => l10n.escalationPairingSucceeded,
        // 点火失败没有阶段记录，原因来自 `igniteDetail`；直接写在这一行，
        // 用户不用滑到结论卡，也不用翻 logcat。
        EscalationIgnitePhase.failed =>
          runState.igniteDetail == null
              ? l10n.escalationIgniteFailed
              : '${l10n.escalationIgniteFailed} · ${runState.igniteDetail}',
        EscalationIgnitePhase.idle => l10n.escalationPairingSucceeded,
      };
    }
    return '${escalationOutcomeText(l10n, outcome)}$reasonSuffix';
  }

  /// 最后一个失败阶段回填的 `error` 证据；没有就返回 null。
  String? _failureDetail(EscalationRunState runState) {
    String? detail;
    for (final step in runState.steps) {
      if (step.ok) continue;
      final String value = step.evidence['error']?.trim() ?? '';
      if (value.isNotEmpty) detail = value;
    }
    return detail;
  }

  /// 无可用链时的提示：总述 + 首条链的首个原因，避免只给一句「不可用」。
  String _unavailableHint(AppLocalizations l10n) {
    final List<EscalationCapability> ordered = matrix.orderedCapabilities;
    if (ordered.isEmpty) return l10n.escalationNoAvailableChain;
    return '${l10n.escalationNoAvailableChain} · '
        '${escalationReasonText(l10n, ordered.first.primaryReason)}';
  }
}
