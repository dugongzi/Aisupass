import 'package:Aisupass/common/tabs/home/home_tab.dart';
import 'package:Aisupass/common/tabs/setting/setting_tab.dart';
import 'package:Aisupass/common/widgets/app_bottom_bar.dart';
import 'package:Aisupass/common/widgets/app_bottom_center_ball.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 底栏正中圆球的直径与下移距离（设计稿值）。
///
/// 圆球与底栏缺口必须同尺寸，两处都从这里取值。
const double _centerBallSize = 58;
const double _centerBallOffsetY = 9;

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
      // 圆球位置固定在缺口中心，切换 tab 时不做位移动画。
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
      floatingActionButtonLocation: AppBottomCenterBallLocation(
        offsetY: _centerBallOffsetY.h,
      ),
      floatingActionButton: AppBottomCenterBall(
        size: _centerBallSize.w,
        // 点击事件暂未接入。
      ),
      appBar: AppBar(
        // 首页内容里已有品牌标题，标题栏不再重复显示，仅保留高度占位。
        title: currentIndex.value == 0 ? null : Text(titles[currentIndex.value]),
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
        fabSize: _centerBallSize,
        fabOffsetY: _centerBallOffsetY,
        // TODO: 接入 AI 激活状态后改为读取真实状态，当前先固定为已激活。
        isAiActivated: true,
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
