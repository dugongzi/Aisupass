import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// 轻提示类型，决定底色与图标。
enum ToastType { info, success, warning, error }

/// 全局轻提示。
///
/// 依赖 `MaterialApp.builder` 里的 `FlutterSmartDialog.init()`，
/// 因此在路由页面之外、以及桌面端同样可用。
///
/// 用法：
/// ```dart
/// ToastMessage.show('已复制');
/// ToastMessage.success('保存成功');
/// ToastMessage.error('保存失败：$e');
/// ```
class ToastMessage {
  const ToastMessage._();

  static const Duration _defaultDuration = Duration(seconds: 2);

  static void show(dynamic msg, {Duration duration = _defaultDuration}) =>
      _show(msg, ToastType.info, duration);

  static void success(dynamic msg, {Duration duration = _defaultDuration}) =>
      _show(msg, ToastType.success, duration);

  static void warning(dynamic msg, {Duration duration = _defaultDuration}) =>
      _show(msg, ToastType.warning, duration);

  static void error(dynamic msg, {Duration duration = _defaultDuration}) =>
      _show(msg, ToastType.error, duration);

  static void _show(dynamic msg, ToastType type, Duration duration) {
    final String text = msg?.toString().trim() ?? '';
    if (text.isEmpty) return;

    SmartDialog.showToast(
      '',
      displayTime: duration,
      alignment: Alignment.bottomCenter,
      builder: (context) {
        final _ToastStyle style = _ToastStyle.of(
          type,
          Theme.of(context).colorScheme,
        );
        return Container(
          margin: EdgeInsets.only(bottom: 100.h),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          constraints: BoxConstraints(
            maxWidth: 0.8.sw,
            maxHeight: 0.9.sh,
          ),
          decoration: BoxDecoration(
            color: style.background,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(style.icon, size: 20.sp, color: Colors.white),
              SizedBox(width: 10.w),
              Flexible(
                child: Text(
                  text,
                  maxLines: 15,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppFonts.primary,
                    color: Colors.white,
                    fontSize: 14.sp,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ToastStyle {
  const _ToastStyle({required this.background, required this.icon});

  final Color background;
  final IconData icon;

  static _ToastStyle of(ToastType type, ColorScheme colorScheme) {
    switch (type) {
      case ToastType.info:
        return _ToastStyle(
          background: colorScheme.primary,
          icon: Icons.info_outline,
        );
      case ToastType.success:
        return const _ToastStyle(
          background: Color(0xFF2E7D32),
          icon: Icons.check_circle_outline,
        );
      case ToastType.warning:
        return const _ToastStyle(
          background: Color(0xFFEF6C00),
          icon: Icons.warning_amber_rounded,
        );
      case ToastType.error:
        return const _ToastStyle(
          background: Color(0xFFC62828),
          icon: Icons.error_outline,
        );
    }
  }
}
