import 'dart:async';

import 'package:Aisupass/common/widgets/adb_pairing_code_input.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/models/command_channel.dart';
import 'package:Aisupass/core/models/stellar_launch_state.dart';
import 'package:Aisupass/core/models/stellar_service_status.dart';
import 'package:Aisupass/core/providers/adb_shell_provider.dart';
import 'package:Aisupass/core/providers/command_channel_provider.dart';
import 'package:Aisupass/core/providers/stellar_service_provider.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 终端页顶部的连接处理。
///
/// 两条通道的「连接」含义不同，因此提示与动作也分开：
/// - 无线 ADB：终端跑在它的 pty 上，判据是**实际连接**而不是「命令通道」这个设置；
/// - Stellar：终端跑在本地特权服务的 pty 上，判据是**服务是否就绪**，
///   而且这条路没有配对概念，不能摆配对码输入框。
class TerminalLinkNotice extends HookConsumerWidget {
  const TerminalLinkNotice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CommandChannel channel = ref.watch(commandChannelControllerProvider);
    return channel == CommandChannel.stellar
        ? const _StellarLinkNotice()
        : const _AdbLinkNotice();
  }
}

/// 无线 ADB 通道的连接处理。
///
/// 姿态是「先自己动手，失败才说话」：
/// 1. 进页面若没连上，先静默重连一次（已配对过的设备不需要用户参与）；
/// 2. 仍未连上才出现一行字与一个重试按钮；
/// 3. 重试时才走需要用户参与的配对流程（通知栏输码 / 小窗输码）。
class _AdbLinkNotice extends HookConsumerWidget {
  const _AdbLinkNotice();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ShellLink? link = ref.watch(shellLinkProvider);
    if (link?.connected ?? false) return const SizedBox.shrink();

    // true = 静默重连已经试过且没成功，该把重试入口露出来了。
    final ValueNotifier<bool> needAction = useState<bool>(false);
    // true = 这次重试需要用户填配对码（小窗输入模式）。
    final ValueNotifier<bool> wantCode = useState<bool>(false);
    // true = 这一轮重试还在跑，避免连点叠出两次。
    final ValueNotifier<bool> retrying = useState<bool>(false);
    final ShellPairingState pairing = ref.watch(shellPairingProvider);

    // 进页面先悄悄试一次，不弹任何东西。
    useEffect(() {
      unawaited(() async {
        final bool linked = await ref.read(adbSilentReconnectProvider)();
        if (!linked && context.mounted) needAction.value = true;
      }());
      return null;
    }, const <Object?>[]);

    /// 重试：先静默重连，不行才走需要用户参与的配对。
    Future<void> retry() async {
      if (retrying.value) return;
      retrying.value = true;
      try {
        final AdbAutoConnectResult result = await ref.read(
          adbAutoConnectProvider,
        )();
        wantCode.value = result == AdbAutoConnectResult.needsCode;
      } finally {
        retrying.value = false;
      }
    }

    // 静默尝试中：只给一条细进度，不占地方也不解释。
    if (!needAction.value) {
      return const SizedBox(
        height: 2,
        child: LinearProgressIndicator(minHeight: 2),
      );
    }

    final AppLocalizations l10n = context.l10n;
    final ColorScheme colors = context.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 8.w, 8.h),
      color: colors.surfaceContainerHigh,
      child: wantCode.value
          ? const AdbPairingCodeInput()
          : Row(
              children: <Widget>[
                Icon(
                  Icons.link_off_rounded,
                  size: 16.sp,
                  color: colors.onSurfaceVariant,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    l10n.escalationTerminalNeedsAdb,
                    style: TextStyle(
                      fontSize: 12.sp,
                      height: 1.3,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
                TextButton(
                  // 配对进行中或重连还没回来，先不叠第二次。
                  onPressed: (pairing.active || retrying.value)
                      ? null
                      : () => unawaited(retry()),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                  ),
                  child: Text(
                    l10n.shellPairingRetry,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

/// Stellar 通道的连接处理。
///
/// 与 ADB 分支的两点不同：
/// 1. 判据是服务是否就绪，不是 socket 是否连着；
/// 2. 不进页面自动拉起服务——拉起要消耗一次 ADB 执行，用户可能并不想启动，
///    因此把按钮交给用户点。
class _StellarLinkNotice extends HookConsumerWidget {
  const _StellarLinkNotice();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<StellarServiceStatus> status = ref.watch(
      stellarServiceStatusProvider,
    );
    final StellarLaunchState launch = ref.watch(stellarLaunchProvider);

    // 服务就绪且没有动作在跑：终端由别处负责建会话，这里不需要提示。
    final bool available = status.value?.available ?? false;
    if (available && !launch.busy) return const SizedBox.shrink();

    // 首次探活还没回来：与 ADB 分支一样只给一条细进度，不先摆一句「未启动」。
    if (!status.hasValue && status.isLoading && !launch.busy) {
      return const SizedBox(
        height: 2,
        child: LinearProgressIndicator(minHeight: 2),
      );
    }

    final AppLocalizations l10n = context.l10n;
    final ColorScheme colors = context.colorScheme;

    final String hint = launch.busy
        ? l10n.stellarLaunching
        : _launchHint(l10n, launch.reason) ?? l10n.terminalNeedsStellar;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 8.w, 8.h),
      color: colors.surfaceContainerHigh,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.verified_user_outlined,
            size: 16.sp,
            color: launch.reason.isEmpty || available
                ? colors.onSurfaceVariant
                : colors.error,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              hint,
              style: TextStyle(
                fontSize: 12.sp,
                height: 1.3,
                color: launch.reason.isEmpty || available
                    ? colors.onSurfaceVariant
                    : colors.error,
              ),
            ),
          ),
          TextButton(
            onPressed: launch.busy || status.isLoading
                ? null
                : () => unawaited(_start(ref)),
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
            ),
            child: Text(
              l10n.stellarStartService,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  /// 拉起服务；成功后再补建一次终端会话。
  ///
  /// 进页面那次 `open()` 因为服务没起而失败，会话已被判定不可用；
  /// 拉起成功后若不补建，用户会看到提示消失但终端仍然空着。
  Future<void> _start(WidgetRef ref) async {
    final StellarServiceStatus result = await ref
        .read(stellarLaunchProvider.notifier)
        .start();
    if (!result.available) return;
    unawaited(ref.read(shellExecProvider.notifier).open());
  }

  /// 拉起失败原因码 → 一句可读说明；未失败时返回 null。
  ///
  /// 与首页卡片同一套原因码，措辞也保持一致，避免同一故障两处两种说法。
  String? _launchHint(AppLocalizations l10n, String reason) {
    switch (reason) {
      case StellarLaunchState.reasonNoRunner:
        return l10n.stellarLaunchNoRunner;
      case StellarLaunchState.reasonAwaitingCode:
        return l10n.stellarLaunchAwaitingCode;
      case StellarLaunchState.reasonLauncherMissing:
        return l10n.stellarLaunchLauncherMissing;
      case StellarLaunchState.reasonNotAnswering:
        return l10n.stellarLaunchNotAnswering;
      case StellarLaunchState.reasonStopFailed:
        return l10n.stellarStopFailed;
      case StellarLaunchState.reasonPortTaken:
        return l10n.stellarLaunchPortTaken;
      case StellarLaunchState.reasonProtocolMismatch:
        return l10n.stellarLaunchProtocolMismatch;
      default:
        return null;
    }
  }
}
