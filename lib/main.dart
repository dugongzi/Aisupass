import 'package:Aisupass/common/widgets/app_bootstrap.dart';
import 'package:Aisupass/core/providers/locale_provider.dart';
import 'package:Aisupass/core/routes/app_router.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

void main() {
  runApp(const ProviderScope(child: AiSuPassApp()));
}

class AiSuPassApp extends ConsumerWidget {
  const AiSuPassApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Locale locale = ref.watch(localeProvider);

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
        theme: ThemeData(
          colorScheme: .fromSeed(seedColor: Colors.deepPurple),
          // 全局字体：阿里妈妈方圆体。
          fontFamily: AppFonts.primary,
        ),
        // 挂载 SmartDialog，ToastMessage 依赖它。
        builder: FlutterSmartDialog.init(),
      ),
    );
  }
}
