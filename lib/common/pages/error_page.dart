import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/routes/app_route.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// 兜底错误页：路由未匹配或路由构建失败时展示。
class ErrorPage extends HookWidget {
  const ErrorPage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final String home = isDesktopPlatform
        ? AppRoute.desktopHome
        : AppRoute.home;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.error_outline, size: 72.sp),
              SizedBox(height: 16.h),
              Text(
                context.l10n.errorTitle,
                style: context.textTheme.headlineSmall,
              ),
              SizedBox(height: 8.h),
              Text(message, textAlign: TextAlign.center),
              SizedBox(height: 24.h),
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
