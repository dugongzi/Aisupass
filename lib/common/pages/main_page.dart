import 'package:Aisupass/common/tabs/home/home_tab.dart';
import 'package:Aisupass/common/tabs/setting/setting_tab.dart';
import 'package:Aisupass/common/widgets/app_bottom_bar.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 移动端根页面：持有标题栏、底部导航与各 tab 内容。
///
/// tab 切换只做页内滑动，不改变路由地址，与 JsxposedX 保持一致。
class MainPage extends HookConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<int> currentIndex = useState<int>(0);
    final PageController pageController = usePageController();

    final List<String> titles = <String>[
      context.l10n.homeTitle,
      context.l10n.settingsTitle,
    ];
    final List<AppBottomBarItem> navItems = <AppBottomBarItem>[
      AppBottomBarItem(
        label: titles[0],
        outlinedIcon: Icons.home_outlined,
        filledIcon: Icons.home_rounded,
      ),
      AppBottomBarItem(
        label: titles[1],
        outlinedIcon: Icons.settings_outlined,
        filledIcon: Icons.settings_rounded,
      ),
    ];

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(titles[currentIndex.value]),
        centerTitle: true,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (int index) => currentIndex.value = index,
        children: const <Widget>[HomeTab(), SettingTab()],
      ),
      bottomNavigationBar: AppBottomBar(
        items: navItems,
        currentIndex: currentIndex.value,
        onTap: (int index) => _changeTab(currentIndex, pageController, index),
      ),
    );
  }
}

void _changeTab(
  ValueNotifier<int> currentIndex,
  PageController pageController,
  int index,
) {
  currentIndex.value = index;
  pageController.animateToPage(
    index,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );
}
