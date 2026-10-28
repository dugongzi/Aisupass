import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_capability.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_capability_matrix.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_record_provider.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/escalation_confirm_dialog.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/escalation_header.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/escalation_matrix_view.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/escalation_outcome_card.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/escalation_residual_banner.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/escalation_texts.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/escalation_timeline.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
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
    final bool hasResidual = ref.watch(escalationResidualProvider).value ?? false;
    final EscalationRunState runState = ref.watch(
      escalationRunControllerProvider,
    );

    // M0 默认链：按破坏性优先级取首个可用链，全不可用时按钮禁用。
    final EscalationCapability? selected = matrix.firstAvailable;
    final double gap = isDesktop ? 12 : 12.h;

    /// 主按钮动作：运行中取消，其余情况先确认再启动。
    Future<void> onPrimaryPressed() async {
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

    final String actionLabel = runState.pairing
        ? l10n.escalationPairingWaiting
        : (runState.isRunning
              ? l10n.escalationCancel
              : (runState.isFinished
                    ? l10n.escalationRetry
                    : l10n.escalationStart));

    final IconData actionIcon = runState.pairing
        ? Icons.notifications_active_outlined
        : (runState.isRunning
              ? Icons.stop_circle_outlined
              : (runState.isFinished
                    ? Icons.refresh_rounded
                    : Icons.bolt_rounded));

    /// 配对进行中不给取消：取消只会断开页面订阅，原生线程仍要等满用户输码窗口。
    final bool cancellable = runState.isRunning && !runState.pairing;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isDesktop ? 760 : double.infinity),
        child: ListView(
          padding: isDesktop
              ? const EdgeInsets.fromLTRB(28, 6, 28, 28)
              : EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          children: <Widget>[
            EscalationHeader(
              fingerprint: matrix.fingerprint,
              hostAlive: hostAlive,
            ),
            if (hasResidual) ...<Widget>[
              SizedBox(height: gap),
              const EscalationResidualBanner(),
            ],
            SizedBox(height: gap),
            EscalationMatrixView(
              matrix: matrix,
              selectedChain: selected?.chain,
            ),
            SizedBox(height: gap),
            EscalationTimeline(
              steps: runState.steps,
              isRunning: runState.isRunning,
            ),
            if (runState.outcome != null) ...<Widget>[
              SizedBox(height: gap),
              EscalationOutcomeCard(
                outcome: runState.outcome,
                reasons: runState.reasons,
              ),
            ],
            SizedBox(height: gap),
            SizedBox(
              width: double.infinity,
              height: isDesktop ? 46 : 46.h,
              child: FilledButton.icon(
                onPressed: runState.pairing
                    ? null
                    : (runState.isRunning || selected != null
                          ? onPrimaryPressed
                          : null),
                icon: Icon(actionIcon, size: isDesktop ? 18 : 18.sp),
                label: Text(
                  actionLabel,
                  style: TextStyle(
                    fontSize: isDesktop ? 14 : 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: cancellable ? colors.error : colors.primary,
                  foregroundColor: cancellable
                      ? colors.onError
                      : colors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(isDesktop ? 10 : 12.r),
                  ),
                ),
              ),
            ),
            if (!hostAlive && isAndroidPlatform) ...<Widget>[
              SizedBox(height: isDesktop ? 10 : 10.h),
              SizedBox(
                width: double.infinity,
                height: isDesktop ? 44 : 44.h,
                child: OutlinedButton.icon(
                  onPressed: runState.isRunning
                      ? null
                      : () async {
                          // 没有通知权限，配对码输入框根本弹不出来。
                          // 被拒也继续发起：原生会立刻以配对失败收尾，时间线上有记录，
                          // 好过点了按钮毫无反应。
                          await Permission.notification.request();
                          if (!context.mounted) return;
                          await ref
                              .read(escalationRunControllerProvider.notifier)
                              .startPairing();
                        },
                  icon: Icon(
                    Icons.wifi_tethering_rounded,
                    size: isDesktop ? 18 : 18.sp,
                  ),
                  label: Text(
                    l10n.escalationPairingStart,
                    style: TextStyle(
                      fontSize: isDesktop ? 13.5 : 13.5.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.primary,
                    side: BorderSide(
                      color: colors.primary.withValues(alpha: 0.45),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isDesktop ? 10 : 12.r),
                    ),
                  ),
                ),
              ),
              SizedBox(height: isDesktop ? 8 : 8.h),
              // 必须写在按钮旁边：用户一旦为了输码切回本 App，系统的配对弹窗就作废了。
              Text(
                l10n.escalationPairingNotice,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isDesktop ? 11.5 : 11.5.sp,
                  height: 1.4,
                  color: colors.onSurfaceVariant.withValues(alpha: 0.8),
                ),
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
    );
  }

  /// 无可用链时的提示：总述 + 首条链的首个原因，避免只给一句「不可用」。
  String _unavailableHint(AppLocalizations l10n) {
    final List<EscalationCapability> ordered = matrix.orderedCapabilities;
    if (ordered.isEmpty) return l10n.escalationNoAvailableChain;
    return '${l10n.escalationNoAvailableChain} · '
        '${escalationReasonText(l10n, ordered.first.primaryReason)}';
  }
}
