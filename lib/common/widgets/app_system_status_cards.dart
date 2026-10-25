import 'package:Aisupass/common/widgets/app_status_card.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/providers/system_status_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ROOT 与 ADB 两张状态卡片。
class AppSystemStatusCards extends HookConsumerWidget {
  const AppSystemStatusCards({super.key, this.spacing = 12});

  /// 两张卡片之间的间距，桌面端可调小。
  final double spacing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<SystemStatus> status = ref.watch(systemStatusProvider);
    final SystemStatus? data = status.value;
    final bool isLoading = status.isLoading;

    return Column(
      children: <Widget>[
        AppStatusCard(
          title: context.l10n.rootTitle,
          subtitle: _rootSubtitle(context, data, isLoading),
          icon: Icons.admin_panel_settings_outlined,
          isActivated: data?.isRooted ?? false,
          isLoading: isLoading,
        ),
        SizedBox(height: spacing),
        AppStatusCard(
          title: context.l10n.adbTitle,
          subtitle: _adbSubtitle(context, data, isLoading),
          icon: Icons.developer_mode_rounded,
          isActivated: data?.isAdbEnabled ?? false,
          isLoading: isLoading,
        ),
      ],
    );
  }

  String _rootSubtitle(
    BuildContext context,
    SystemStatus? data,
    bool isLoading,
  ) {
    if (isLoading || data == null) return context.l10n.statusDetecting;
    return data.isRooted ? context.l10n.activated : context.l10n.notActivated;
  }

  /// ADB 副标题区分无线与有线，两者同时开启时合并展示。
  String _adbSubtitle(
    BuildContext context,
    SystemStatus? data,
    bool isLoading,
  ) {
    if (isLoading || data == null) return context.l10n.statusDetecting;
    if (!data.isAdbEnabled) return context.l10n.notActivated;
    if (data.adbUsbEnabled && data.adbWifiEnabled) {
      return context.l10n.adbActivatedBoth;
    }
    return data.adbWifiEnabled
        ? context.l10n.adbActivatedWifi
        : context.l10n.adbActivatedUsb;
  }
}
