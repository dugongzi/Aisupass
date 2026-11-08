import 'dart:async';

import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/features/escalation/domain/enums/root_manager.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 标题栏右侧的 root 管理器胶囊。
///
/// 左侧图标、右侧名字，点击弹出选择框。
class AppRootManagerPill extends HookConsumerWidget {
  const AppRootManagerPill({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final AsyncValue<RootManager> selected = ref.watch(
      selectedRootManagerProvider,
    );

    // 读取失败时没有名字可显示，退回标题文案，点一下就地重试。
    final RootManager? manager = selected.value;
    final bool hasError = selected.hasError;
    final bool isLoading = selected.isLoading;
    final String label = manager?.displayName ?? l10n.rootManagerTitle;
    final IconData icon = manager == null
        ? Icons.admin_panel_settings_rounded
        : _iconOf(manager);

    return Tooltip(
      message: l10n.rootManagerPillTooltip,
      excludeFromSemantics: true,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(999.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(999.r),
          onTap: () {
            if (hasError) {
              ref.invalidate(selectedRootManagerProvider);
              return;
            }
            unawaited(showRootManagerDialog(context));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(
                color: scheme.primary.withValues(alpha: hasError ? 0.6 : 0.28),
                width: 0.8.r,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (isLoading)
                  SizedBox(
                    width: 14.sp,
                    height: 14.sp,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.6.r,
                      color: scheme.primary,
                    ),
                  )
                else
                  Icon(icon, size: 14.sp, color: scheme.primary),
                SizedBox(width: 6.w),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 96.w),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppFonts.primary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: scheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 弹出 root 管理器选择框。
Future<void> showRootManagerDialog(BuildContext context) => showDialog<void>(
  context: context,
  builder: (BuildContext context) => const _RootManagerDialog(),
);

/// root 管理器选择框：列出全部已知管理器，点一条即切换。
///
/// 切换会写存储并失效查询缓存。
class _RootManagerDialog extends HookConsumerWidget {
  const _RootManagerDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final AsyncValue<RootManager> selected = ref.watch(
      selectedRootManagerProvider,
    );
    // 写盘期间禁止重复点选，避免连点写出两条相互覆盖的记录。
    final ValueNotifier<bool> busy = useState<bool>(false);

    Future<void> pick(RootManager manager) async {
      if (busy.value) return;
      // 点当前项没有意义，直接关掉。
      if (manager == selected.value) {
        Navigator.of(context).pop();
        return;
      }
      busy.value = true;
      try {
        await ref.read(selectRootManagerProvider(manager: manager).future);
        if (!context.mounted) return;
        Navigator.of(context).pop();
        ToastMessage.success(l10n.rootManagerSwitched(manager.displayName));
      } catch (error) {
        if (context.mounted) {
          ToastMessage.error(l10n.rootManagerSaveFailed('$error'));
        }
      } finally {
        if (context.mounted) busy.value = false;
      }
    }

    return Dialog(
      backgroundColor: scheme.surface,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _DialogHeader(onClose: () => Navigator.of(context).pop()),
          Divider(
            height: 1,
            thickness: 0.5,
            color: scheme.outline.withValues(alpha: 0.24),
          ),
          selected.when(
            loading: () => SizedBox(height: 160.h, child: const Loading()),
            error: (Object error, StackTrace stackTrace) => SizedBox(
              height: 180.h,
              child: RefError(
                onRetry: () => ref.invalidate(selectedRootManagerProvider),
              ),
            ),
            data: (RootManager current) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (final RootManager manager in RootManager.values)
                  _ManagerTile(
                    manager: manager,
                    isCurrent: manager == current,
                    onTap: () => unawaited(pick(manager)),
                  ),
                SizedBox(height: 6.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 弹窗头部：标题 + 关闭键。
class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 8.w, 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.admin_panel_settings_rounded,
            size: 18.sp,
            color: scheme.primary,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.rootManagerTitle,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            icon: Icon(
              Icons.close_rounded,
              size: 20.sp,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// 一个管理器条目：图标、名字、包名，当前项打勾。
class _ManagerTile extends StatelessWidget {
  const _ManagerTile({
    required this.manager,
    required this.isCurrent,
    required this.onTap,
  });

  final RootManager manager;

  final bool isCurrent;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Row(
          children: <Widget>[
            Icon(
              _iconOf(manager),
              size: 20.sp,
              color: isCurrent ? scheme.primary : scheme.onSurfaceVariant,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    manager.displayName,
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    manager.packageName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppFonts.code,
                      fontSize: 10.5.sp,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            if (isCurrent)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.check_rounded, size: 16.sp, color: scheme.primary),
                  SizedBox(width: 4.w),
                  Text(
                    l10n.rootManagerCurrent,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: scheme.primary,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// 管理器的展示图标。
IconData _iconOf(RootManager manager) => switch (manager) {
  RootManager.kernelsu => Icons.shield_rounded,
  RootManager.sukisu => Icons.bolt_rounded,
};
