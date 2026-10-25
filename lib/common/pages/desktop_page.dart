import 'package:Aisupass/common/tabs/home/pc_home_tab.dart';
import 'package:Aisupass/common/tabs/setting/pc_setting_tab.dart';
import 'package:Aisupass/common/widgets/app_desktop_sidebar.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// 桌面端根页面：持有左侧导航、内容标题与各 tab 内容。
///
/// 与 [MainPage] 一致，tab 只写内容，外壳统一由这里提供；
/// 桌面端不支持左右滑动切换，因此用 [IndexedStack] 保留各 tab 状态。
/// 标题左对齐放在内容区顶部，而不是 Android 风格的居中标题栏。
class DesktopPage extends HookWidget {
  const DesktopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> currentIndex = useState<int>(0);

    final List<AppDesktopNavItem> navItems = <AppDesktopNavItem>[
      AppDesktopNavItem(
        label: context.l10n.homeTitle,
        outlinedIcon: Icons.home_outlined,
        filledIcon: Icons.home_rounded,
      ),
      AppDesktopNavItem(
        label: context.l10n.settingsTitle,
        outlinedIcon: Icons.settings_outlined,
        filledIcon: Icons.settings_rounded,
      ),
    ];

    return Scaffold(
      body: Row(
        children: <Widget>[
          AppDesktopSidebar(
            items: navItems,
            currentIndex: currentIndex.value,
            onSelected: (int index) => currentIndex.value = index,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 26, 28, 14),
                  child: Text(
                    navItems[currentIndex.value].label,
                    style: context.textTheme.titleLarge?.copyWith(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: IndexedStack(
                    index: currentIndex.value,
                    children: const <Widget>[PcHomeTab(), PcSettingTab()],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
