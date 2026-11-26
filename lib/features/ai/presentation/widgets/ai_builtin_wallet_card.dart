import 'dart:async';

import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/network/api_exception.dart';
import 'package:Aisupass/core/routes/app_route.dart';
import 'package:Aisupass/features/ai/domain/constants/builtin_ai_config.dart';
import 'package:Aisupass/features/ai/domain/models/ai_builtin_wallet.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_builtin_action_provider.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_builtin_query_provider.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_section_card.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// 内置配置的账户额度卡片。
///
/// 展示面板账户的当前额度，低于阈值时标红并提示充值；
/// 右侧「获取额度」跳到说明文档，「兑换码兑换」直接在这里兑换并刷新额度。
class AiBuiltinWalletCard extends HookConsumerWidget {
  const AiBuiltinWalletCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final AsyncValue<AiBuiltinWallet> wallet = ref.watch(builtinWalletProvider);
    final ValueNotifier<bool> redeeming = useState<bool>(false);

    /// 打开额度说明文档，用户在里面看怎么充值。
    Future<void> openCreditDoc() async {
      await launchUrl(
        Uri.parse(builtinAiConfigCreditDocUrl),
        mode: LaunchMode.externalApplication,
      );
    }

    /// 令牌失效时回内置登录页重新走一遍，返回后刷新额度。
    Future<void> openLogin() async {
      await context.push<String>(AppRoute.aiBuiltinLogin);
      if (!context.mounted) return;
      ref.invalidate(builtinWalletProvider);
    }

    /// 弹框输入兑换码，兑换成功后由写侧失效额度查询，卡片自动重拉。
    Future<void> handleRedeem() async {
      if (redeeming.value) return;
      final String? code = await showDialog<String>(
        context: context,
        builder: (BuildContext dialogContext) => const _RedeemDialog(),
      );
      if (code == null || code.trim().isEmpty || !context.mounted) return;

      redeeming.value = true;
      try {
        await ref.read(aiBuiltinActionsProvider).redeemCode(code);
        if (!context.mounted) return;
        ToastMessage.success(l10n.aiBuiltinWalletRedeemSuccess);
      } on ApiException catch (error) {
        if (!context.mounted) return;
        ToastMessage.error(error.message);
      } catch (error) {
        if (!context.mounted) return;
        ToastMessage.error(l10n.aiBuiltinWalletRedeemFailed('$error'));
      } finally {
        redeeming.value = false;
      }
    }

    return AiSectionCard(
      title: l10n.aiBuiltinWalletTitle,
      icon: Icons.account_balance_wallet_outlined,
      children: <Widget>[
        wallet.when(
          loading: () => SizedBox(
            height: 46.h,
            child: Center(
              child: SizedBox(
                width: 16.w,
                height: 16.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: context.colorScheme.primary,
                ),
              ),
            ),
          ),
          error: (Object error, StackTrace stackTrace) => _WalletFailed(
            message: error is ApiException
                ? error.message
                : l10n.aiBuiltinWalletFailed,
            onLogin: () => unawaited(openLogin()),
          ),
          data: (AiBuiltinWallet value) => _WalletBalance(
            balance: value.balance,
            onGetCredit: () => unawaited(openCreditDoc()),
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: <Widget>[
            OutlinedButton.icon(
              onPressed: redeeming.value
                  ? null
                  : () => unawaited(handleRedeem()),
              icon: redeeming.value
                  ? SizedBox(
                      width: 14.w,
                      height: 14.w,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.card_giftcard_rounded, size: 16.sp),
              label: Text(l10n.aiBuiltinWalletRedeem),
              style: OutlinedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                textStyle: TextStyle(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => ref.invalidate(builtinWalletProvider),
              icon: Icon(
                Icons.refresh_rounded,
                size: 18.sp,
                color: context.colorScheme.onSurfaceVariant,
              ),
              tooltip: l10n.aiBuiltinWalletRefresh,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints.tightFor(width: 34.w, height: 34.w),
            ),
          ],
        ),
      ],
    );
  }
}

/// 额度正常态：金额 + 低额度提示 + 「获取额度」文字按钮。
class _WalletBalance extends StatelessWidget {
  const _WalletBalance({required this.balance, required this.onGetCredit});

  final double balance;
  final VoidCallback onGetCredit;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final bool low = balance < builtinAiConfigLowBalanceThreshold;
    final Color amountColor = low ? scheme.error : scheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              l10n.aiBuiltinWalletBalance,
              style: TextStyle(
                fontSize: 11.5.sp,
                color: scheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: onGetCredit,
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size.zero,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              ),
              child: Text(
                l10n.aiBuiltinWalletGetCredit,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          '\$${balance.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 26.sp,
            height: 1.1,
            fontWeight: FontWeight.w700,
            color: amountColor,
            fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
          ),
        ),
        if (low) ...<Widget>[
          SizedBox(height: 6.h),
          Row(
            children: <Widget>[
              Icon(
                Icons.error_outline_rounded,
                size: 14.sp,
                color: scheme.error,
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: Text(
                  l10n.aiBuiltinWalletLow,
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    height: 1.35,
                    color: scheme.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// 额度读取失败：说明原因并给出重新登录入口。
class _WalletFailed extends StatelessWidget {
  const _WalletFailed({required this.message, required this.onLogin});

  final String message;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;

    return Row(
      children: <Widget>[
        Icon(Icons.error_outline_rounded, size: 15.sp, color: scheme.error),
        SizedBox(width: 7.w),
        Expanded(
          child: Text(
            message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.5.sp,
              height: 1.35,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
        SizedBox(width: 6.w),
        TextButton(
          onPressed: onLogin,
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: Size.zero,
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          ),
          child: Text(
            l10n.aiBuiltinWalletRelogin,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

/// 兑换码输入框；确认后把兑换码回传给调用方。
class _RedeemDialog extends HookWidget {
  const _RedeemDialog();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final TextEditingController controller = useTextEditingController();
    final ValueNotifier<bool> canSubmit = useState<bool>(false);

    void submit() {
      final String code = controller.text.trim();
      if (code.isEmpty) return;
      Navigator.of(context).pop(code);
    }

    return AlertDialog(
      title: Text(l10n.aiBuiltinWalletRedeemTitle),
      content: TextField(
        controller: controller,
        autofocus: true,
        onChanged: (String text) => canSubmit.value = text.trim().isNotEmpty,
        onSubmitted: (String _) => submit(),
        style: TextStyle(fontSize: 14.sp),
        decoration: InputDecoration(
          hintText: l10n.aiBuiltinWalletRedeemHint,
          hintStyle: TextStyle(fontSize: 13.sp),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.aiCancel),
        ),
        FilledButton(
          onPressed: canSubmit.value ? submit : null,
          child: Text(l10n.aiBuiltinWalletRedeemConfirm),
        ),
      ],
    );
  }
}
