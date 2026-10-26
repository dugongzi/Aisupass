import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// AI 配置页统一输入框：标题在上、填充式圆角输入框、可选密码显隐。
class AiTextField extends HookWidget {
  const AiTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.errorText,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.obscure = false,
    this.readOnly = false,
    this.prefixIcon,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? errorText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final bool obscure;

  /// 只读：用于内置配置等不允许修改的字段。
  final bool readOnly;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    final bool isDark = context.isDark;
    final ValueNotifier<bool> hidden = useState<bool>(obscure);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 2.w, bottom: 7.h),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w600,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: obscure ? 1 : maxLines,
          obscureText: obscure && hidden.value,
          readOnly: readOnly,
          onChanged: onChanged,
          style: TextStyle(
            fontSize: 14.sp,
            color: readOnly
                ? scheme.onSurface.withValues(alpha: 0.72)
                : scheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 13.sp,
              color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            filled: true,
            fillColor: readOnly
                ? scheme.onSurface.withValues(alpha: isDark ? 0.02 : 0.03)
                : (isDark
                      ? scheme.onSurface.withValues(alpha: 0.04)
                      : scheme.surfaceContainerHighest.withValues(alpha: 0.35)),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 14.h,
            ),
            prefixIcon: prefixIcon == null
                ? null
                : Icon(prefixIcon, size: 18.sp, color: scheme.onSurfaceVariant),
            suffixIcon: !obscure
                ? null
                : IconButton(
                    onPressed: () => hidden.value = !hidden.value,
                    icon: Icon(
                      hidden.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18.sp,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
            border: _border(scheme, scheme.outline.withValues(alpha: 0.16)),
            enabledBorder: _border(
              scheme,
              scheme.outline.withValues(alpha: isDark ? 0.28 : 0.16),
            ),
            focusedBorder: _border(scheme, scheme.primary, width: 1.5),
            errorBorder: _border(scheme, scheme.error),
            focusedErrorBorder: _border(scheme, scheme.error, width: 1.5),
            errorText: errorText,
            errorStyle: TextStyle(fontSize: 11.5.sp),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(ColorScheme scheme, Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.r),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
