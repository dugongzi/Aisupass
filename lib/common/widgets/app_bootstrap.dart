import 'dart:ui';

import 'package:Aisupass/core/utils/platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 全局尺寸适配入口。
///
/// 移动端以 [mobileDesignSize] 为设计基准等比缩放，配合 `flutter_screenutil`
/// 的 `.w` / `.h` / `.sp` / `.r` / `.sw` / `.sh` 使用；
/// 桌面端直接把当前窗口逻辑尺寸当作设计基准，缩放比恒为 1，避免 PC 上被放大失真。
class AppBootstrap extends HookWidget {
  const AppBootstrap({super.key, required this.builder});

  /// 移动端设计稿尺寸。
  static const Size mobileDesignSize = Size(375, 812);

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    final FlutterView view = View.of(context);
    final Size windowSize = view.physicalSize / view.devicePixelRatio;

    return ScreenUtilInit(
      designSize: isDesktopPlatform ? windowSize : mobileDesignSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => builder(context),
    );
  }
}
