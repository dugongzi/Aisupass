import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 通用加载态：居中进度圈，可附带一行说明文案。
class Loading extends HookWidget {
  const Loading({super.key, this.message});

  /// 进度圈下方的说明文案，为空时只显示进度圈。
  final String? message;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    final String? text = message;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 26.w,
            height: 26.w,
            child: CircularProgressIndicator(strokeWidth: 2.4.r),
          ),
          if (text != null) ...<Widget>[
            SizedBox(height: 12.h),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
