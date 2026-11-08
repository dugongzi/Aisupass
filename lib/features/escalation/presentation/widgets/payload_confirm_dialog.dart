import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 二次确认：手工指定载荷会在设备上真实执行，落键之前再问一次。
///
/// 返回 `true` 表示用户确认执行；关掉弹窗或点取消都是 `false`。
Future<bool> showPayloadConfirmDialog(
  BuildContext context,
  Payload payload,
) async {
  final bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext dialogContext) =>
        _PayloadConfirmDialog(payload: payload),
  );
  return confirmed ?? false;
}

/// 确认弹窗：把「要跑哪一条」摊开，避免点错机型。
class _PayloadConfirmDialog extends StatelessWidget {
  const _PayloadConfirmDialog({required this.payload});

  final Payload payload;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;

    // 与清单里同一套表述：已知写版本号，未知/不限用文字。
    final String kernelLabel = payload.kernelUnknown
        ? l10n.escalationPayloadKernelUnknown
        : payload.kernelAgnostic
        ? l10n.escalationPayloadKernelAgnostic
        : payload.kernelVersion;

    return AlertDialog(
      title: Text(l10n.escalationPayloadConfirmTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Field(
            label: l10n.escalationPayloadConfirmModel,
            value: payload.displayName,
          ),
          _Field(
            label: l10n.escalationPayloadConfirmVendor,
            value: payload.vendor,
          ),
          _Field(
            label: l10n.escalationPayloadConfirmKernel,
            value: kernelLabel,
          ),
          _Field(
            label: l10n.escalationPayloadConfirmLibrary,
            value: payload.library,
          ),
          SizedBox(height: 12.h),
          Text(
            l10n.escalationPayloadConfirmBody,
            style: TextStyle(
              fontSize: 12.sp,
              height: 1.5,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.aiCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.escalationPayloadConfirmAction),
        ),
      ],
    );
  }
}

/// 一行「字段：值」，值用等宽字体，文件名和版本号对齐了才好核对。
class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 56.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: AppFonts.code,
                fontSize: 12.sp,
                color: scheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
