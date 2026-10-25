import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 设置项左侧图标胶囊，与设置卡片的圆角、主色保持一致。
class AppSettingIcon extends HookWidget {
  const AppSettingIcon({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;

    return Container(
      width: 34.w,
      height: 34.w,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(11.r),
      ),
      child: Icon(icon, size: 18.sp, color: colorScheme.primary),
    );
  }
}
