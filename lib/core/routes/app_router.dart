import 'package:Aisupass/common/pages/error_page.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/core/routes/app_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 全局唯一的 [GoRouter] 实例。
///
/// 桌面端从 `/desktop` 起步，移动端从 `/` 起步；
/// 两者共用同一张路由表，只是初始位置不同。
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: isDesktopPlatform ? AppRoute.desktopHome : AppRoute.home,
    debugLogDiagnostics: kDebugMode,
    routes: [
      ...appRoutes,
      GoRoute(
        path: AppRoute.notFound,
        builder: (context, state) => ErrorPage(
          message: context.l10n.errorNotFound(state.matchedLocation),
        ),
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(
      message: state.error?.toString() ?? context.l10n.errorBuildFailed,
    ),
  );
});
