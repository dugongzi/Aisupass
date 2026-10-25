import 'package:Aisupass/common/tabs/home/pc_home_tab.dart';
import 'package:Aisupass/common/tabs/setting/pc_setting_tab.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 桌面端根页面：持有标题栏、左侧导航与各 tab 内容。
///
/// 与 [MainPage] 一致，tab 只写内容，外壳统一由这里提供；
/// 桌面端不支持左右滑动切换，因此用 [IndexedStack] 保留各 tab 状态。
class DesktopPage extends HookConsumerWidget {
  const DesktopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<int> currentIndex = useState<int>(0);

    final List<String> titles = <String>[
      context.l10n.desktopHomeTitle,
      context.l10n.desktopSettingsTitle,
    ];
    final List<NavigationRailDestination> destinations =
        <NavigationRailDestination>[
          NavigationRailDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: Text(titles[0]),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings_rounded),
            label: Text(titles[1]),
          ),
        ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex.value]),
        centerTitle: true,
      ),
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: currentIndex.value,
            onDestinationSelected: (int index) => currentIndex.value = index,
            labelType: NavigationRailLabelType.all,
            destinations: destinations,
          ),
          VerticalDivider(width: 1.w),
          Expanded(
            child: IndexedStack(
              index: currentIndex.value,
              children: const <Widget>[PcHomeTab(), PcSettingTab()],
            ),
          ),
        ],
      ),
    );
  }
}
