import 'package:Aisupass/common/widgets/adb_pairing_code_input.dart';
import 'package:Aisupass/common/widgets/app_status_card.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/models/stellar_launch_state.dart';
import 'package:Aisupass/core/models/stellar_service_status.dart';
import 'package:Aisupass/core/providers/adb_shell_provider.dart';
import 'package:Aisupass/core/providers/stellar_service_provider.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/generated/adb_shell.g.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppStellarServiceCard extends ConsumerWidget {
  const AppStellarServiceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!isAndroidPlatform) return const SizedBox.shrink();

    final AppLocalizations l10n = context.l10n;
    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;

    final AsyncValue<StellarServiceStatus> status = ref.watch(
      stellarServiceStatusProvider,
    );
    final StellarLaunchState launch = ref.watch(stellarLaunchProvider);
    final StellarServiceStatus? value = status.value;
    final bool available = value?.available ?? false;

    // 执行通道没连上时的配对交互，与 ADB 卡片遵守同一个「配对码输入位置」设置。
    final ShellPairingState pairing = ref.watch(shellPairingProvider);
    // 只有**静默重连也失败**之后才摆输入框：已配对过的设备断开后点启动，
    // 应该悄悄连上就把服务拉起来，不该先要一次码。
    final bool showCodeInput =
        launch.reason == StellarLaunchState.reasonAwaitingCode &&
        !available &&
        !launch.busy &&
        !pairing.active;

    late final String subtitle;
    if (pairing.active) {
      subtitle = _pairingLabel(l10n, pairing.stage);
    } else if (launch.busy) {
      subtitle = launch.stopping ? l10n.stellarStopping : l10n.stellarLaunching;
    } else if (!status.hasValue) {
      subtitle = status.hasError
          ? l10n.stellarStatusNotReady
          : l10n.statusDetecting;
    } else {
      subtitle = available
          ? l10n.stellarStatusReady(value!.uid)
          : l10n.stellarStatusNotReady;
    }

    // 失败原因优先展示上一次动作的结果，其次才是通用的未就绪说明。
    final String? hint = showCodeInput
        ? (pairing.failed
              ? _pairingFailure(l10n, pairing.reason)
              : l10n.stellarLaunchAwaitingCode)
        : _launchHint(l10n, launch.reason) ??
              (available ? null : l10n.stellarNotReadyHint);

    return AppStatusCard(
      title: l10n.stellarCardTitle,
      subtitle: subtitle,
      icon: Icons.verified_user_outlined,
      isActivated: available,
      isLoading: !status.hasValue && !launch.busy,
      isRefreshing: status.isLoading || launch.busy,
      onRefresh: () => ref.invalidate(stellarServiceStatusProvider),
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (hint != null)
            Text(
              hint,
              style: TextStyle(
                fontSize: isDesktop ? 11 : 11.sp,
                height: 1.35,
                color: launch.reason.isEmpty || available
                    ? colors.onSurfaceVariant.withValues(alpha: 0.8)
                    : colors.error,
              ),
            ),
          SizedBox(height: isDesktop ? 8 : 8.h),
          if (showCodeInput)
            // 配对成功后接着拉起服务，不用用户再回来点一次。
            AdbPairingCodeInput(
              onSubmitted: () =>
                  ref.read(stellarLaunchProvider.notifier).start(),
            )
          else
            SizedBox(
              height: isDesktop ? 36 : 36.h,
              child: OutlinedButton.icon(
                // 有动作进行时禁用，避免连点叠出多个请求。
                onPressed: launch.busy
                    ? null
                    : () => available
                          ? ref.read(stellarLaunchProvider.notifier).stop()
                          : ref.read(stellarLaunchProvider.notifier).start(),
                icon: Icon(
                  available ? Icons.close_rounded : Icons.play_arrow_rounded,
                  size: isDesktop ? 15 : 15.sp,
                ),
                label: Text(
                  available
                      ? l10n.stellarStopService
                      : l10n.stellarStartService,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isDesktop ? 12.5 : 12.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: available ? colors.error : colors.primary,
                  side: BorderSide(
                    color: (available ? colors.error : colors.primary)
                        .withValues(alpha: 0.45),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(isDesktop ? 10 : 12.r),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 拉起失败原因码 → 一句可读说明；未失败时返回 null。
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
      default:
        return null;
    }
  }

  /// 配对会话阶段 → 状态行文案，和 ADB 卡片的措辞保持一致。
  String _pairingLabel(AppLocalizations l10n, PairingStage? stage) {
    switch (stage) {
      case PairingStage.pairing:
        return l10n.shellPairingPairing;
      case PairingStage.connecting:
        return l10n.shellPairingConnecting;
      case PairingStage.done:
      case PairingStage.waitingCode:
      case null:
        return l10n.shellPairingWaitingCode;
    }
  }

  /// 配对失败原因码 → 一句可读说明，与 ADB 卡片同口径。
  String _pairingFailure(AppLocalizations l10n, String? reason) {
    switch (reason) {
      case 'hostAuthFailed':
        return l10n.shellReasonHostAuthFailed;
      case 'hostDisconnected':
        return l10n.shellReasonHostDisconnected;
      case 'pairingEndpointNotFound':
        return l10n.shellReasonEndpointNotFound;
      case 'pairingTimeout':
        return l10n.shellReasonPairingTimeout;
      case 'deviceRebooted':
        return l10n.shellReasonDeviceRebooted;
      case 'cancelled':
        return l10n.shellReasonCancelled;
      case 'hostPairingFailed':
      default:
        return l10n.shellReasonHostPairingFailed;
    }
  }
}
