import 'package:Aisupass/common/pages/desktop_page.dart';
import 'package:Aisupass/common/pages/main_page.dart';
import 'package:Aisupass/common/pages/open_source_license_page.dart';
import 'package:Aisupass/features/ai/presentation/pages/ai_config_edit_page.dart';
import 'package:Aisupass/features/ai/presentation/pages/ai_config_page.dart';
import 'package:Aisupass/features/chat/presentation/pages/chat_page.dart';
import 'package:Aisupass/features/chat/presentation/pages/in_app_browser_page.dart';
import 'package:Aisupass/features/coolapk/presentation/pages/coolapk_captcha_page.dart';
import 'package:Aisupass/features/coolapk/presentation/pages/coolapk_login_page.dart';
import 'package:Aisupass/features/escalation/presentation/pages/ghost_lock_profile_page.dart';
import 'package:Aisupass/features/escalation/presentation/pages/kernel_profile_edit_page.dart';
import 'package:Aisupass/features/escalation/presentation/pages/kernel_profile_page.dart';
import 'package:Aisupass/features/escalation/presentation/pages/manual_escalation_page.dart';
import 'package:Aisupass/features/escalation/presentation/pages/run_log_page.dart';
import 'package:Aisupass/features/escalation/presentation/pages/terminal_page.dart';
import 'package:go_router/go_router.dart';

/// 全局路由路径常量。
///
/// 页面内跳转一律引用这里的常量，不要在业务代码里写死路径字符串。
class AppRoute {
  AppRoute._();

  // 移动端
  static const home = '/';
  static const chat = '/chat';

  // 应用内浏览器（对话内网页卡片进入）
  static const browser = '/browser';

  /// 浏览器路径；[url] 会编码进 query，避免 `&` 被当成参数分隔符。
  static String browserPath(String url) =>
      '$browser?url=${Uri.encodeComponent(url)}';

  // 酷安登录页（WebView 里过验证码后抓取令牌）
  static const coolapkLogin = '/coolapk/login';

  // 酷安人机验证页（详情接口被风控时，过验证拿 validate 票据）
  static const coolapkCaptcha = '/coolapk/captcha';

  /// 人机验证页路径；[captchaId] 来自被风控接口的响应。
  static String coolapkCaptchaPath(String captchaId) =>
      '$coolapkCaptcha?captchaId=${Uri.encodeComponent(captchaId)}';

  // AI 配置
  static const aiConfig = '/aiConfig';
  static const aiConfigEdit = '/aiConfig/edit/:id';

  /// 新建 AI 配置时使用的占位 id。
  static const newConfigId = 'new';

  /// 拼接编辑页路径，[id] 传 [newConfigId] 表示新建。
  static String aiConfigEditPath(String id) => '/aiConfig/edit/$id';

  // 提权
  static const manualEscalation = '/escalation/manual';

  /// 手动提权页里的终端独立页（右上角进入），与提权页共用同一条 pty。
  static const manualEscalationTerminal = '/escalation/manual/terminal';

  /// 终端页路径；[action] 表示进页面后立刻执行的动作（见 `TerminalPage.initialAction`）。
  static String manualEscalationTerminalPath({String action = ''}) =>
      action.isEmpty
      ? manualEscalationTerminal
      : '$manualEscalationTerminal?action=$action';

  // 内核表（boot.img 导入，GhostKey / GhostLock 两个 Tab）
  static const kernelProfile = '/kernelProfile';

  /// 内核表页路径；[tab] 为 `ghostkey` 时直接落在 GhostKey 页签。
  static String kernelProfilePath({String tab = ''}) =>
      tab.isEmpty ? kernelProfile : '$kernelProfile?tab=$tab';

  // GhostKey 内核表字段编辑器
  static const kernelProfileEdit = '/kernelProfile/edit';

  /// 编辑器路径；[name] 是目标用户文档名（含 `.conf`）。
  static String kernelProfileEditPath(String name) =>
      '$kernelProfileEdit?name=${Uri.encodeComponent(name)}';

  // GhostLock 内核表编辑器
  static const ghostLockProfile = '/ghostLock/profile';

  /// 编辑器路径；[name] 为用户文档名，空串表示内置/设备态。
  static String ghostLockProfilePath([String name = '']) => name.isEmpty
      ? ghostLockProfile
      : '$ghostLockProfile?name=${Uri.encodeComponent(name)}';

  // 运行记录
  static const String runLog = '/runLog';

  /// 详情页路径。`fileName` 编码后作为 query 参数。
  static String runLogDetail(String fileName) =>
      '$runLog?file=${Uri.encodeComponent(fileName)}';

  // 开源许可（本项目协议、第三方声明与许可证全文）
  static const openSourceLicense = '/openSourceLicense';

  /// 许可页路径；[doc] 是文档下标，见 `AppLinks.licenseDocAssets`。
  static String licenseDocPath(int doc) => '$openSourceLicense?doc=$doc';

  // 桌面端
  static const desktopHome = '/desktop';

  /// 未匹配路径的兜底规则，放在路由表最后。
  static const notFound = '/:notFound(.*)';
}

/// 业务路由表。
///
/// 这里只放能正常打开的页面；兜底路由与错误页在 [appRouterProvider] 中追加。
final List<GoRoute> appRoutes = [
  GoRoute(path: AppRoute.home, builder: (context, state) => const MainPage()),
  GoRoute(path: AppRoute.chat, builder: (context, state) => const ChatPage()),
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
    path: AppRoute.manualEscalation,
    builder: (context, state) => const ManualEscalationPage(),
  ),
  GoRoute(
    path: AppRoute.manualEscalationTerminal,
    builder: (context, state) =>
        TerminalPage(initialAction: state.uri.queryParameters['action']),
  ),
  GoRoute(
    path: AppRoute.browser,
    builder: (context, state) =>
        InAppBrowserPage(initialUrl: state.uri.queryParameters['url'] ?? ''),
  ),
  GoRoute(
    path: AppRoute.coolapkLogin,
    builder: (context, state) => const CoolapkLoginPage(),
  ),
  GoRoute(
    path: AppRoute.coolapkCaptcha,
    builder: (context, state) => CoolapkCaptchaPage(
      captchaId: state.uri.queryParameters['captchaId'] ?? '',
    ),
  ),
  GoRoute(
    path: AppRoute.kernelProfile,
    builder: (context, state) => KernelProfilePage(
      initialTab: state.uri.queryParameters['tab'] == 'ghostkey' ? 1 : 0,
    ),
  ),
  GoRoute(
    path: AppRoute.kernelProfileEdit,
    builder: (context, state) =>
        KernelProfileEditPage(name: state.uri.queryParameters['name'] ?? ''),
  ),
  GoRoute(
    path: AppRoute.ghostLockProfile,
    builder: (context, state) =>
        GhostLockProfilePage(name: state.uri.queryParameters['name'] ?? ''),
  ),
  GoRoute(
    path: AppRoute.runLog,
    builder: (context, state) =>
        RunLogPage(openedFile: state.uri.queryParameters['file']),
  ),
  GoRoute(
    path: AppRoute.openSourceLicense,
    builder: (context, state) => OpenSourceLicensePage(
      initialDoc: int.tryParse(state.uri.queryParameters['doc'] ?? ''),
    ),
  ),
  GoRoute(
    path: AppRoute.desktopHome,
    builder: (context, state) => const DesktopPage(),
  ),
];
