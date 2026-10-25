import 'package:Aisupass/common/tabs/home/home_tab.dart';
import 'package:Aisupass/common/tabs/setting/setting_tab.dart';
import 'package:Aisupass/common/widgets/app_bottom_bar.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

/// 移动端根页面：持有标题栏、底部导航与各 tab 内容。
///
/// tab 切换只做页内滑动，不改变路由地址，与 JsxposedX 保持一致。
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _changeTab(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<AppBottomBarItem> items = <AppBottomBarItem>[
      AppBottomBarItem(
        label: context.l10n.homeTitle,
        outlinedIcon: Icons.home_outlined,
        filledIcon: Icons.home_rounded,
      ),
      AppBottomBarItem(
        label: context.l10n.settingsTitle,
        outlinedIcon: Icons.settings_outlined,
        filledIcon: Icons.settings_rounded,
      ),
    ];

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(items[_currentIndex].label),
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: const <Widget>[HomeTab(), SettingTab()],
      ),
      bottomNavigationBar: AppBottomBar(
        items: items,
        currentIndex: _currentIndex,
        onTap: _changeTab,
      ),
    );
  }
}
