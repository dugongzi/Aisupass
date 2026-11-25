import 'package:Aisupass/common/widgets/app_status_card.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/models/stellar_launch_state.dart';
import 'package:Aisupass/core/models/stellar_service_status.dart';
import 'package:Aisupass/core/providers/stellar_service_provider.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 首页的 Stellar 卡片：只回答「这条通道现在能不能用、不能的话怎么起来」。
///
/// 它只读 Stellar 自己的两个 Provider，不知道也不关心另一条通道的存在。
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
    final StellarLaunchState launch = ref.watch(stellarLaunchProvider);
    final StellarServiceStatus? value = status.value;
    final bool available = value?.available ?? false;

    late final String subtitle;
    if (launch.busy) {
      subtitle = l10n.stellarLaunching;
    } else if (!status.hasValue) {
      subtitle = status.hasError
          ? l10n.stellarStatusNotReady
          : l10n.statusDetecting;
    } else {
      subtitle = available
          ? l10n.stellarStatusReady(value!.uid)
          : l10n.stellarStatusNotReady;
    }

    // 失败原因优先展示上一次拉起的结果，其次才是通用的未就绪说明。
    final String? hint = _launchHint(l10n, launch.reason) ??
        (available ? null : l10n.stellarNotReadyHint);

    return AppStatusCard(
      title: l10n.stellarCardTitle,
      subtitle: subtitle,
      icon: Icons.verified_user_outlined,
      isActivated: available,
      isLoading: !status.hasValue && !launch.busy,
      isRefreshing: status.isLoading || launch.busy,
      onRefresh: () => ref.invalidate(stellarServiceStatusProvider),
      footer: available
          ? null
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (hint != null)
                  Text(
                    hint,
                    style: TextStyle(
                      fontSize: isDesktop ? 11 : 11.sp,
                      height: 1.35,
                      color: launch.reason.isEmpty
                          ? colors.onSurfaceVariant.withValues(alpha: 0.8)
                          : colors.error,
                    ),
                  ),
                SizedBox(height: isDesktop ? 8 : 8.h),
                SizedBox(
                  height: isDesktop ? 36 : 36.h,
                  child: OutlinedButton.icon(
                    // 启动中禁用，避免连点叠出多个拉起请求。
                    onPressed: launch.busy
                        ? null
                        : () => ref
                              .read(stellarLaunchProvider.notifier)
                              .start(),
                    icon: Icon(
                      Icons.play_arrow_rounded,
                      size: isDesktop ? 15 : 15.sp,
                    ),
                    label: Text(
                      l10n.stellarStartService,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isDesktop ? 12.5 : 12.5.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.primary,
                      side: BorderSide(
                        color: colors.primary.withValues(alpha: 0.45),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
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
    );
  }

  /// 拉起失败原因码 → 一句可读说明；未失败时返回 null。
  String? _launchHint(AppLocalizations l10n, String reason) {
    switch (reason) {
      case StellarLaunchState.reasonNoRunner:
        return l10n.stellarLaunchNoRunner;
      case StellarLaunchState.reasonLauncherMissing:
        return l10n.stellarLaunchLauncherMissing;
      case StellarLaunchState.reasonNotAnswering:
        return l10n.stellarLaunchNotAnswering;
      default:
        return null;
    }
  }
}
