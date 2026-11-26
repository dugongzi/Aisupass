import 'dart:async';

import 'package:Aisupass/common/widgets/adb_pairing_code_input.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/models/adb_wifi_state.dart';
import 'package:Aisupass/core/providers/adb_shell_provider.dart';
import 'package:Aisupass/core/providers/system_status_provider.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/generated/adb_shell.g.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

/// 首页 ADB 卡片底部的 shell 连接区：当前连接状态 + **唯一**动作。
///
/// 无线调试配对、uid=2000 的 adb shell 都属于「ADB 连接」本身，因此整块长在
/// ADB 状态卡片里，只回答一个问题：这条 shell 连接现在通了没有，下一步只该点
/// 哪里。
class AppAdbShellPanel extends HookConsumerWidget {
  const AppAdbShellPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 只有 Android 有无线调试与 adb shell，其他平台整块不渲染。
    if (!isAndroidPlatform) return const SizedBox.shrink();

    final AppLocalizations l10n = context.l10n;
    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;

    final ShellLink? link = ref.watch(shellLinkProvider);
    final ShellPairingState pairing = ref.watch(shellPairingProvider);
    final bool connected = link?.connected ?? false;
    // 卡片输入模式：通知栏弹不出输入框的机型由卡片直接收码。
    final bool cardInput = ref.watch(shellPairingModeProvider).isCard;

    // 三态判定：只有 off 才拦截；unknown 表示「ROM 读不到或尚未查到」，
    // 不得据此断言用户没开无线调试。
    final AdbWifiState wifiState = AdbWifiState.fromName(
      ref.watch(adbStatusProvider).value?.wifiState,
    );
    final bool wifiOff = wifiState == AdbWifiState.off;
    final bool everConnected = link?.everConnected ?? false;

    // true = 用户刚经本卡片去开过无线调试，正在等开关翻转。
    final ValueNotifier<bool> awaitingWifi = useState<bool>(false);

    // true = 开关已开，正在替用户静默重连（S4）。
    final ValueNotifier<bool> reconnecting = useState<bool>(false);

    // 输入框只在「还没连上、也没在配对、开关非同 off、也没有自动重连在跑」时出现，
    // 其余状态仍是状态文案。
    final bool showCodeInput =
        cardInput &&
        !connected &&
        !pairing.active &&
        !wifiOff &&
        !reconnecting.value;

    // 连接状态不是推送式的：用户关掉无线调试或设备重启时原生不会主动通知，
    // 所以已连接期间定时重查，让配对入口能自己回来；未连接时不轮询，
    // 由配对收尾时的 invalidate 把状态推上去。
    useEffect(() {
      if (!connected) return null;
      final Timer timer = Timer.periodic(const Duration(seconds: 3), (_) {
        // 上一次查询还没回来就跳过，别把 Pigeon 后台线程堆满。
        if (ref.read(shellConnectionProvider).isLoading) return;
        ref.invalidate(shellConnectionProvider);
      });
      return timer.cancel;
    }, <Object?>[connected]);

    // 开关关闭期间，用户点了「去开启无线调试」后每 1.8s 查一次，直到开关翻转。
    // 只在「已跳设置且在等开关」这一段时间运行；wifiOff 变 false 即自动停表。
    useEffect(() {
      if (!awaitingWifi.value || !wifiOff) return null;
      final Timer timer = Timer.periodic(const Duration(milliseconds: 1800), (_) {
        if (ref.read(adbStatusProvider).isLoading) return;
        ref.invalidate(adbStatusProvider);
      });
      return timer.cancel;
    }, <Object?>[awaitingWifi.value, wifiOff]);

    // 开关由「明确关闭」翻成「开启」，且用户刚才是从本卡片跳过去开的：自动接管。
    // 用 wifiState == on 而非「wifiOff 变 false」——off → unknown 同样会让 wifiOff 变
    // false，但那不是「用户开了开关」。
    useEffect(() {
      if (!awaitingWifi.value) return null;
      if (wifiState != AdbWifiState.on) return null;
      awaitingWifi.value = false;
      unawaited(() async {
        reconnecting.value = true;
        try {
          final AdbAutoConnectResult result = await ref.read(
            adbAutoConnectProvider,
          )();
          if (!context.mounted) return;
          if (result == AdbAutoConnectResult.ready) {
            ToastMessage.success(l10n.adbWifiDetectedConnected);
          }
          // needsCode / needsWifiOn / failed 由状态表自然呈现，不再额外弹提示。
        } finally {
          // 已卸载时 ValueNotifier 随之释放，不能再写。
          if (context.mounted) reconnecting.value = false;
        }
      }());
      return null;
    }, <Object?>[wifiState]);

    late final String statusText;
    String? actionLabel;
    IconData actionIcon = Icons.wifi_tethering_rounded;
    VoidCallback? action;
    String? hint;

    if (wifiOff) {
      // S1 / S2：开关明确关着时配对码在系统里生成不出来，只引导用户去打开开关。
      statusText = l10n.adbWifiOff;
      actionLabel = l10n.adbGoEnableWifi;
      actionIcon = Icons.settings_rounded;
      action = () => _goEnableWifi(ref, awaitingWifi);
      hint = everConnected
          ? l10n.adbWifiOffHintPaired
          : l10n.adbWifiOffHintFirst;
    } else if (pairing.active) {
      statusText = _stageLabel(l10n, pairing.stage);
      actionLabel = l10n.shellPairingCancel;
      actionIcon = Icons.close_rounded;
      action = () => ref.read(shellPairingProvider.notifier).cancel();
      // 卡片模式没有通知栏，别再提「在通知栏输入」。
      hint = cardInput ? null : l10n.shellPairingNotice;
    } else if (pairing.failed) {
      statusText = _reasonLabel(l10n, pairing.reason);
      // 卡片模式下上一份码已经作废，重输比「重试」更直接。
      if (!cardInput) {
        actionLabel = l10n.shellPairingRetry;
        actionIcon = Icons.refresh_rounded;
        action = () => _startPairing(ref);
      }
      hint = pairing.detail;
    } else if (link == null) {
      // 首次查询还没有结果，先只显示检测中，不给按钮。
      statusText = l10n.statusDetecting;
    } else if (connected) {
      final int uid = link.uid;
      statusText = uid > 0 ? l10n.shellConnectedUid(uid) : l10n.shellConnected;
    } else if (reconnecting.value) {
      // S4：开关刚被打开，正在替用户静默重连；此时不给按钮，避免叠出第二个动作。
      statusText = l10n.adbReconnecting;
    } else {
      statusText = l10n.shellDisconnected;
      if (!showCodeInput) {
        actionLabel = l10n.shellPairingStart;
        action = () => _startPairing(ref);
        hint = l10n.shellPairingNotice;
      }
    }

    // 失败时把原生回传的原文给出去，用户要能直接拷走。
    final String? copyableDetail = pairing.failed ? pairing.detail : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              connected ? Icons.link_rounded : Icons.link_off_rounded,
              size: isDesktop ? 16 : 16.sp,
              color: connected ? colors.primary : colors.onSurfaceVariant,
            ),
            SizedBox(width: isDesktop ? 8 : 8.w),
            Expanded(
              // 可选中：这行可能带原生回传的原始原因。
              child: SelectableText(
                statusText,
                style: TextStyle(
                  fontSize: isDesktop ? 12.5 : 12.sp,
                  height: 1.3,
                  fontWeight: FontWeight.w600,
                  color: connected ? colors.primary : colors.onSurfaceVariant,
                ),
              ),
            ),
            if (copyableDetail != null)
              IconButton(
                onPressed: () => _copy(context, copyableDetail),
                icon: Icon(Icons.copy_rounded, size: isDesktop ? 16 : 16.sp),
                color: colors.onSurfaceVariant,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: l10n.shellCopy,
              ),
          ],
        ),
        if (showCodeInput) ...<Widget>[
          SizedBox(height: isDesktop ? 10 : 10.h),
          const AdbPairingCodeInput(),
        ] else if (actionLabel != null) ...<Widget>[
          SizedBox(height: isDesktop ? 10 : 10.h),
          SizedBox(
            height: isDesktop ? 38 : 38.h,
            child: OutlinedButton.icon(
              onPressed: action,
              icon: Icon(actionIcon, size: isDesktop ? 16 : 16.sp),
              label: Text(
                actionLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isDesktop ? 12.5 : 12.5.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.primary,
                side: BorderSide(color: colors.primary.withValues(alpha: 0.45)),
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isDesktop ? 10 : 12.r),
                ),
              ),
            ),
          ),
        ],
        if (hint != null) ...<Widget>[
          SizedBox(height: isDesktop ? 6 : 6.h),
          Text(
            hint,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isDesktop ? 11 : 11.sp,
              height: 1.3,
              color: colors.onSurfaceVariant.withValues(alpha: 0.8),
            ),
          ),
        ],
      ],
    );
  }

  /// 只跳设置，不发起配对：开关关闭时配对码在系统里生成不出来。
  Future<void> _goEnableWifi(
    WidgetRef ref,
    ValueNotifier<bool> awaitingWifi,
  ) async {
    awaitingWifi.value = true;
    try {
      await ref.read(adbShellNativeProvider).openWirelessDebuggingSettings();
    } catch (_) {
      // ROM 拒绝跳转：等待态轮询仍在跑，用户手动去设置页打开同样能被识别。
    }
  }

  /// 配对前先要通知权限：没有权限，通知栏里的配对码输入框根本弹不出来。
  /// 被拒也继续发起，原生会立刻以配对失败收尾，好过点了按钮毫无反应。
  Future<void> _startPairing(WidgetRef ref) async {
    await Permission.notification.request();
    await ref.read(shellPairingProvider.notifier).start();
    // 配对码只能由系统的「无线调试」页面生成，发起后直接把用户送到那一页，
    // 省掉自己翻设置。跳转失败也不影响已经发起的配对，提示文案仍写着手动前往。
    try {
      await ref.read(adbShellNativeProvider).openWirelessDebuggingSettings();
    } catch (_) {
      // 原生未注册或 ROM 拒绝跳转：配对流程照常，用户可自行打开设置页。
    }
  }

  /// 复制原始失败原因：这行常带原生 stderr，用户要能直接贴出来。
  void _copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.maybeOf(
      context,
    )?.showSnackBar(SnackBar(content: Text(context.l10n.shellCopied)));
  }
}

/// 会话阶段对应的状态文案。
String _stageLabel(AppLocalizations l10n, PairingStage? stage) {
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

/// 原生原因码对应的文案，未知码兜底成「配对失败」。
String _reasonLabel(AppLocalizations l10n, String? reason) {
  switch (reason) {
    case 'hostAuthFailed':
      return l10n.shellReasonAuthRevoked;
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
