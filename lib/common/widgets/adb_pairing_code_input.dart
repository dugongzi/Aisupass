import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/providers/adb_shell_provider.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 卡片内的配对码输入：六位码输入框 + 配对按钮 + 打开系统无线调试页的入口。
///
/// 只在「卡片输入」模式下渲染。通知栏的 RemoteInput 在部分 ROM（如 MIUI/HyperOS）
/// 上点不开，这条路让用户把系统配对弹窗里的码直接填进卡片。端点仍由原生 mDNS
/// 发现，用户不需要抄 IP 与端口。
class AdbPairingCodeInput extends HookConsumerWidget {
  const AdbPairingCodeInput({super.key, this.onSubmitted});

  /// 配对会话已发起后的回调。
  ///
  /// 给「配对只是前置步骤」的调用方用：码交出去之后紧接着该做的那件事（例如
  /// 拉起服务）可以挂在这里，用户不必再回去点一次按钮。
  final VoidCallback? onSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDesktop = isDesktopPlatform;
    final AppLocalizations l10n = context.l10n;
    final ColorScheme colors = context.colorScheme;

    final TextEditingController controller = useTextEditingController();
    final TextEditingValue value = useValueListenable(controller);
    // 输入法可能塞进空格或连字符，只认数字。
    final String code = value.text.replaceAll(RegExp(r'[^0-9]'), '');
    final bool canSubmit = code.length == 6;

    Future<void> submit() async {
      if (!canSubmit) return;
      controller.clear();
      await ref.read(shellPairingProvider.notifier).start(code: code);
      onSubmitted?.call();
    }

    Future<void> openSettings() async {
      try {
        await ref.read(adbShellNativeProvider).openWirelessDebuggingSettings();
      } catch (_) {
        // ROM 拒绝跳转时，用户可自行去设置页打开。
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: SizedBox(
                height: isDesktop ? 36 : 36.h,
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  onSubmitted: (_) => submit(),
                  style: TextStyle(
                    fontSize: isDesktop ? 13 : 13.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: l10n.shellPairingCodeHint,
                    hintStyle: TextStyle(
                      fontSize: isDesktop ? 12 : 12.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w400,
                      color: colors.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 10 : 10.w,
                      vertical: isDesktop ? 8 : 8.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(isDesktop ? 8 : 10.r),
                      borderSide: BorderSide(
                        color: colors.outlineVariant.withValues(alpha: 0.8),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(isDesktop ? 8 : 10.r),
                      borderSide: BorderSide(
                        color: colors.outlineVariant.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: isDesktop ? 8 : 8.w),
            SizedBox(
              height: isDesktop ? 36 : 36.h,
              child: FilledButton(
                onPressed: canSubmit ? submit : null,
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(isDesktop ? 8 : 10.r),
                  ),
                ),
                child: Text(
                  l10n.shellPairingCodeSubmit,
                  style: TextStyle(
                    fontSize: isDesktop ? 12.5 : 12.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: isDesktop ? 6 : 6.h),
        Text(
          l10n.shellPairingCardHint,
          style: TextStyle(
            fontSize: isDesktop ? 11 : 11.sp,
            height: 1.35,
            color: colors.onSurfaceVariant.withValues(alpha: 0.8),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: openSettings,
            icon: Icon(Icons.settings_rounded, size: isDesktop ? 13 : 13.sp),
            label: Text(
              l10n.shellPairingOpenDebugSettings,
              style: TextStyle(fontSize: isDesktop ? 11.5 : 11.5.sp),
            ),
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
      ],
    );
  }
}
