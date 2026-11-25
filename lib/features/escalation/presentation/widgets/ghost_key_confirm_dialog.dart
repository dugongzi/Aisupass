import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_preflight.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_run_defaults.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// GhostKey 运行前二次确认。
///
/// 返回 `true` 表示开跑，`null` 表示取消。
Future<bool?> showGhostKeyConfirmDialog(
  BuildContext context, {
  required RootManager? manager,
  required GhostKeyPreflight preflight,
  required GhostKeyRunDefaults defaults,
}) => showDialog<bool>(
  context: context,
  builder: (BuildContext dialogContext) => _GhostKeyConfirmDialog(
    manager: manager,
    preflight: preflight,
    defaults: defaults,
  ),
);

/// 确认弹窗：把自检快照与持久开关摊开。
///
/// `acceptFallbackPageOffset` **只读展示**——它的开关在设置页，
/// 这里开第二扇门会让「唯一真相」变成两份。
/// 末段恒定把临时 root 移交给全局选中的管理器，不单独展示。
class _GhostKeyConfirmDialog extends HookWidget {
  const _GhostKeyConfirmDialog({
    required this.manager,
    required this.preflight,
    required this.defaults,
  });

  final RootManager? manager;
  final GhostKeyPreflight preflight;
  final GhostKeyRunDefaults defaults;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final String onOff = l10n.escalationGhostKeyToggleOn;
    final String offOn = l10n.escalationGhostKeyToggleOff;
    final String yesNo = l10n.escalationGhostKeyValueYes;
    final String noNo = l10n.escalationGhostKeyValueNo;

    return AlertDialog(
      title: Text(l10n.escalationGhostKeyConfirmTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Field(
              label: l10n.escalationGhostKeyFieldManager,
              value: manager?.displayName ?? l10n.escalationGhostKeyValueNone,
            ),
            _Field(
              label: l10n.escalationGhostKeyFieldRelease,
              value: preflight.release.isEmpty
                  ? l10n.escalationGhostKeyValueUnknown
                  : preflight.release,
            ),
            _Field(
              label: l10n.escalationGhostKeyFieldShellUid,
              value: '${preflight.shellUid}',
            ),
            _Field(
              label: l10n.escalationGhostKeyFieldSeccomp,
              value: '${preflight.seccomp}',
            ),
            _Field(
              label: l10n.escalationGhostKeyFieldProfile,
              value: preflight.profileMatched ? yesNo : noNo,
            ),
            _Field(
              label: l10n.escalationGhostKeyFieldFallback,
              value: defaults.acceptFallbackPageOffset ? onOff : offOn,
            ),
            SizedBox(height: 4.h),
            Text(
              l10n.escalationGhostKeyConfirmRisk,
              style: TextStyle(
                fontSize: 11.sp,
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.aiCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.escalationGhostKeyConfirmRun),
        ),
      ],
    );
  }
}

/// 一行只读字段。
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
              style: TextStyle(fontSize: 12.sp, color: scheme.onSurfaceVariant),
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
