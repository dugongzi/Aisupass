import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/routes/app_route.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_preflight.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// GhostLock 运行前二次确认。
///
/// 返回是否安全模式；`null` 表示取消。
Future<bool?> showGhostLockConfirmDialog(
  BuildContext context, {
  required RootManager? manager,
  required GhostLockPreflight preflight,
}) => showDialog<bool>(
  context: context,
  builder: (BuildContext dialogContext) =>
      _GhostLockConfirmDialog(manager: manager, preflight: preflight),
);

/// 确认弹窗：把自检快照与安全模式摊开。
///
/// 安全模式只在本次生效、不落偏好：它改变的是本轮执行时 root 脚本对
/// `/data/adb/modules/*` 的处理，不是用户长期意愿。
///
/// `ksud` 一行直接展示自检算出的路径（管理器自带优先、包内兜底），不再按
/// 「谁来提供」二次推断，避免展示与执行不一致。
class _GhostLockConfirmDialog extends HookWidget {
  const _GhostLockConfirmDialog({
    required this.manager,
    required this.preflight,
  });

  final RootManager? manager;
  final GhostLockPreflight preflight;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final String yes = l10n.escalationGhostLockValueYes;
    final String no = l10n.escalationGhostLockValueNo;

    final ValueNotifier<bool> safeMode = useState<bool>(false);

    return AlertDialog(
      title: Text(l10n.escalationGhostLockTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Field(
              label: l10n.escalationGhostLockFieldManager,
              value: manager?.displayName ?? l10n.escalationGhostLockValueNone,
            ),
            _Field(
              label: l10n.escalationGhostLockFieldRelease,
              value: preflight.release.isEmpty
                  ? l10n.escalationGhostLockValueUnknown
                  : preflight.release,
            ),
            _Field(
              label: l10n.escalationGhostLockFieldProfile,
              value: preflight.profileMatched ? yes : no,
            ),
            _Field(
              label: l10n.escalationGhostLockFieldRoute,
              value: preflight.route.isEmpty
                  ? l10n.escalationGhostLockValueUnknown
                  : preflight.route,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: preflight.release.isEmpty
                    ? null
                    : () => context.push(AppRoute.ghostLockProfilePath()),
                child: Text(
                  l10n.escalationGhostLockProfileEdit,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
            ),
            _Field(
              label: l10n.escalationGhostLockFieldSeccomp,
              value: '${preflight.seccomp}',
            ),
            _Field(
              label: l10n.escalationGhostLockFieldKsud,
              // 自检与实际执行同一个来源：全局选中管理器自带的 ksud。
              value: preflight.ksudPath.isNotEmpty
                  ? preflight.ksudPath
                  : l10n.escalationGhostLockValueNone,
            ),
            SizedBox(height: 4.h),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              value: safeMode.value,
              onChanged: (bool value) => safeMode.value = value,
              title: Text(
                l10n.escalationGhostLockSafeModeTitle,
                style: TextStyle(fontSize: 13.sp),
              ),
              subtitle: Text(
                l10n.escalationGhostLockSafeModeDesc,
                style: TextStyle(fontSize: 11.sp),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              l10n.escalationGhostLockConfirmRisk,
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
          onPressed: () => Navigator.of(context).pop(safeMode.value),
          child: Text(l10n.escalationGhostLockConfirmRun),
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
            width: 60.w,
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
