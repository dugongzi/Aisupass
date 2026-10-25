import 'package:Aisupass/common/widgets/app_bootstrap.dart';
import 'package:Aisupass/core/providers/locale_provider.dart';
import 'package:Aisupass/core/providers/theme_provider.dart';
import 'package:Aisupass/core/routes/app_router.dart';
import 'package:Aisupass/core/themes/app_theme.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: AiSuPassApp()));
}

class AiSuPassApp extends HookConsumerWidget {
  const AiSuPassApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Locale locale = ref.watch(localeProvider);
    final AppThemeSettings themeSettings = ref.watch(themeSettingsProvider);

    return AppBootstrap(
      builder: (context) => MaterialApp.router(
        title: 'AiSuPass',
        debugShowCheckedModeBanner: false,
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        // 语言由 localeProvider 决定，不再跟随系统。
        localeResolutionCallback: (deviceLocale, supportedLocales) => locale,
        routerConfig: ref.watch(appRouterProvider),
        theme: AppTheme.light(themeSettings.seedColor),
        darkTheme: AppTheme.dark(themeSettings.seedColor),
        themeMode: themeSettings.themeMode,
        // 挂载 SmartDialog，ToastMessage 依赖它。
        builder: FlutterSmartDialog.init(),
      ),
    );
  }
}
