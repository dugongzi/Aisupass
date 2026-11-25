import 'dart:async';

import 'package:Aisupass/common/widgets/adb_pairing_code_input.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/providers/adb_shell_provider.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 终端页顶部的连接处理。
///
/// 终端跑在无线 ADB 的 pty 上，判断依据是**实际连接**而不是「命令通道」这个设置
/// ——通道选了 Stellar，终端一样走 ADB。
///
/// 姿态是「先自己动手，失败才说话」：
/// 1. 进页面若没连上，先静默重连一次（已配对过的设备不需要用户参与）；
/// 2. 仍未连上才出现一行字与一个重试按钮；
/// 3. 重试时才走需要用户参与的配对流程（通知栏输码 / 小窗输码）。
class TerminalLinkNotice extends HookConsumerWidget {
  const TerminalLinkNotice({super.key});

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
