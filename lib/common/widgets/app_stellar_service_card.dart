import 'package:Aisupass/common/widgets/app_status_card.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/models/stellar_service_status.dart';
import 'package:Aisupass/core/providers/stellar_service_provider.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 首页的 Stellar 卡片：只回答「这条通道现在能不能用」。
///
/// 它只读 [stellarServiceStatusProvider]，不知道也不关心另一条通道的存在。
class AppStellarServiceCard extends HookConsumerWidget {
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
    final StellarServiceStatus? value = status.value;
    final bool available = value?.available ?? false;

    late final String subtitle;
    if (!status.hasValue) {
      subtitle = status.hasError
          ? l10n.stellarStatusNotReady
          : l10n.statusDetecting;
    } else {
      subtitle = available
          ? l10n.stellarStatusReady(value!.uid)
          : l10n.stellarStatusNotReady;
    }

    return AppStatusCard(
      title: l10n.stellarCardTitle,
      subtitle: subtitle,
      icon: Icons.verified_user_outlined,
      isActivated: available,
      isLoading: !status.hasValue,
      isRefreshing: status.isLoading,
      onRefresh: () => ref.invalidate(stellarServiceStatusProvider),
      footer: available
          ? null
          : Text(
              l10n.stellarNotReadyHint,
              style: TextStyle(
                fontSize: isDesktop ? 11 : 11.sp,
                height: 1.35,
                color: colors.onSurfaceVariant.withValues(alpha: 0.8),
              ),
            ),
    );
  }
}
