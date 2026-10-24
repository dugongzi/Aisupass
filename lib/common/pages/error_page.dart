import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/core/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 兜底错误页：路由未匹配或路由构建失败时展示。
class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final home = isDesktopPlatform ? AppRoute.desktopHome : AppRoute.home;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 72),
              const SizedBox(height: 16),
              Text(
                context.l10n.errorTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => context.go(home),
                icon: const Icon(Icons.home),
                label: Text(context.l10n.backToHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
