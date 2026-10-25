import 'package:Aisupass/common/pages/desktop_page.dart';
import 'package:Aisupass/common/pages/main_page.dart';
import 'package:Aisupass/features/ai/presentation/pages/ai_config_edit_page.dart';
import 'package:Aisupass/features/ai/presentation/pages/ai_config_page.dart';
import 'package:Aisupass/features/chat/presentation/pages/chat_page.dart';
import 'package:go_router/go_router.dart';

/// 全局路由路径常量。
///
/// 页面内跳转一律引用这里的常量，不要在业务代码里写死路径字符串。
class AppRoute {
  AppRoute._();

  // 移动端
  static const home = '/';
  static const chat = '/chat';

  // AI 配置
  static const aiConfig = '/aiConfig';
  static const aiConfigEdit = '/aiConfig/edit/:id';

  /// 新建 AI 配置时使用的占位 id。
  static const newConfigId = 'new';

  /// 拼接编辑页路径，[id] 传 [newConfigId] 表示新建。
  static String aiConfigEditPath(String id) => '/aiConfig/edit/$id';

  // 桌面端
  static const desktopHome = '/desktop';

  /// 未匹配路径的兜底规则，放在路由表最后。
  static const notFound = '/:notFound(.*)';
}

/// 业务路由表。
///
/// 这里只放能正常打开的页面；兜底路由与错误页在 [appRouterProvider] 中追加。
final List<GoRoute> appRoutes = [
  GoRoute(
    path: AppRoute.home,
    builder: (context, state) => const MainPage(),
  ),
  GoRoute(
    path: AppRoute.chat,
    builder: (context, state) => const ChatPage(),
  ),
  GoRoute(
    path: AppRoute.aiConfig,
    builder: (context, state) => const AiConfigPage(),
    routes: <RouteBase>[
      GoRoute(
        path: 'edit/:id',
        builder: (context, state) => AiConfigEditPage(
          configId: state.pathParameters['id'] ?? AppRoute.newConfigId,
        ),
      ),
    ],
  ),
  GoRoute(
    path: AppRoute.desktopHome,
    builder: (context, state) => const DesktopPage(),
  ),
];
