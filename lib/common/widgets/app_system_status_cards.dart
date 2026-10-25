import 'package:Aisupass/common/widgets/app_status_card.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/providers/system_status_provider.dart';
import 'package:Aisupass/generated/system_status.g.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ROOT 与 ADB 两张状态卡片，各自独立检测、独立刷新。
class AppSystemStatusCards extends HookConsumerWidget {
  const AppSystemStatusCards({super.key, this.spacing = 12});

  /// 两张卡片之间的间距，桌面端可调小。
  final double spacing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<bool> rootAsync = ref.watch(rootStatusProvider);
    final AsyncValue<AdbStatus> adbAsync = ref.watch(adbStatusProvider);

    return Column(
      children: <Widget>[
        AppStatusCard(
          title: context.l10n.rootTitle,
          subtitle: _rootSubtitle(context, rootAsync),
          icon: Icons.admin_panel_settings_outlined,
          isActivated: rootAsync.value ?? false,
          // 首次没有结果才降级为检测中，刷新时保留上一次的状态。
          isLoading: !rootAsync.hasValue,
          isRefreshing: rootAsync.isLoading,
          onRefresh: () => ref.invalidate(rootStatusProvider),
        ),
        SizedBox(height: spacing),
        AppStatusCard(
          title: context.l10n.adbTitle,
          subtitle: _adbSubtitle(context, adbAsync),
          icon: Icons.developer_mode_rounded,
          isActivated: _isAdbEnabled(adbAsync.value),
          isLoading: !adbAsync.hasValue,
          isRefreshing: adbAsync.isLoading,
          onRefresh: () => ref.invalidate(adbStatusProvider),
        ),
      ],
    );
  }

  bool _isAdbEnabled(AdbStatus? adb) => adb != null && (adb.usb || adb.wifi);

  String _rootSubtitle(BuildContext context, AsyncValue<bool> rootAsync) {
    final bool? rooted = rootAsync.value;
    if (rooted == null) return context.l10n.statusDetecting;
    return rooted ? context.l10n.activated : context.l10n.notActivated;
  }

  /// ADB 副标题按实际开启的调试类型拼接，顺序为无线在前、有线在后。
  String _adbSubtitle(BuildContext context, AsyncValue<AdbStatus> adbAsync) {
    final AdbStatus? adb = adbAsync.value;
    if (adb == null) return context.l10n.statusDetecting;
    if (!_isAdbEnabled(adb)) return context.l10n.notActivated;

    final List<String> types = <String>[
      if (adb.wifi) context.l10n.adbTypeWifi,
      if (adb.usb) context.l10n.adbTypeUsb,
    ];
    return context.l10n.adbActivatedWithType(
      types.join(context.l10n.listSeparator),
    );
  }
}
