import 'package:Aisupass/common/tabs/home/home_tab.dart';
import 'package:Aisupass/common/tabs/home/pc_home_tab.dart';
import 'package:Aisupass/common/tabs/setting/pc_setting_tab.dart';
import 'package:Aisupass/common/tabs/setting/setting_tab.dart';
import 'package:Aisupass/features/ai/presentation/pages/ai_setting_page.dart';
import 'package:Aisupass/features/chat/presentation/pages/chat_page.dart';
import 'package:go_router/go_router.dart';

/// 全局路由路径常量。
///
/// 页面内跳转一律引用这里的常量，不要在业务代码里写死路径字符串。
class AppRoute {
  AppRoute._();

  // 移动端
  static const home = '/';
  static const settings = '/settings';
  static const chat = '/chat';
  static const aiSetting = '/aiSetting';

  // 桌面端
  static const desktopHome = '/desktop';
  static const desktopSettings = '/desktop/settings';

  /// 未匹配路径的兜底规则，放在路由表最后。
  static const notFound = '/:notFound(.*)';
}

/// 业务路由表。
///
/// 这里只放能正常打开的页面；兜底路由与错误页在 [appRouterProvider] 中追加。
final List<GoRoute> appRoutes = [
  GoRoute(
    path: AppRoute.home,
    builder: (context, state) => const HomeTab(),
  ),
  GoRoute(
    path: AppRoute.settings,
    builder: (context, state) => const SettingTab(),
  ),
  GoRoute(
    path: AppRoute.chat,
    builder: (context, state) => const ChatPage(),
  ),
  GoRoute(
    path: AppRoute.aiSetting,
    builder: (context, state) => const AiSettingPage(),
  ),
  GoRoute(
    path: AppRoute.desktopHome,
    builder: (context, state) => const PcHomeTab(),
  ),
  GoRoute(
    path: AppRoute.desktopSettings,
    builder: (context, state) => const PcSettingTab(),
  ),
];
