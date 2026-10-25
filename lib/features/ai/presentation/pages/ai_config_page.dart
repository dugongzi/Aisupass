import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/routes/app_route.dart';
import 'package:Aisupass/core/themes/ai_activation_theme.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/ai/domain/models/ai_config.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_config_action_provider.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_config_query_provider.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_brand_icon.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// AI 配置列表页。
///
/// 移动端用悬浮按钮新建，桌面端在标题行右侧放新建按钮；
/// 点击卡片进入编辑页，卡片右上角菜单可切换、编辑与删除。
class AiConfigPage extends HookConsumerWidget {
  const AiConfigPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final bool isDesktop = isDesktopPlatform;
    final AsyncValue<AiConfigState> configsAsync = ref.watch(aiConfigProvider);

    void openEditor(String id) =>
        context.push(AppRoute.aiConfigEditPath(id));

    Future<void> confirmDelete(AiConfig config) async {
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) {
          final ColorScheme scheme = dialogContext.colorScheme;
          return AlertDialog(
            title: Text(l10n.aiConfigDelete),
            content: Text(l10n.aiConfigDeleteConfirm(config.name)),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l10n.aiCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.error,
                  foregroundColor: scheme.onError,
                ),
                child: Text(l10n.aiDelete),
              ),
            ],
          );
        },
      );
      if (confirmed != true || !context.mounted) return;

      await ref.read(aiConfigActionsProvider).remove(config.id);
      ToastMessage.success(l10n.aiConfigDeleted);
    }

    Future<void> activate(AiConfig config) async {
      await ref.read(aiConfigActionsProvider).setCurrent(config.id);
      ToastMessage.success(l10n.aiConfigSwitched);
    }

    final Widget content = configsAsync.when(
      loading: () => const Loading(),
      error: (Object error, StackTrace stackTrace) =>
          RefError(onRetry: () => ref.invalidate(aiConfigProvider)),
      data: (AiConfigState state) => state.configs.isEmpty
          ? _EmptyState(onCreate: () => openEditor(AppRoute.newConfigId))
          : _ConfigList(
              configs: state.configs,
              currentId: state.currentId,
              onEdit: (AiConfig config) => openEditor(config.id),
              onActivate: activate,
              onDelete: confirmDelete,
            ),
    );

    if (!isDesktop) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.aiConfigTitle)),
        body: content,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => openEditor(AppRoute.newConfigId),
          icon: Icon(Icons.add_rounded, size: 20.sp),
          label: Text(
            l10n.aiConfigNew,
            style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 28, 8),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    l10n.aiConfigTitle,
                    style: context.textTheme.titleLarge?.copyWith(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: () => openEditor(AppRoute.newConfigId),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(
                    l10n.aiConfigNew,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 38),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: content),
        ],
      ),
    );
  }
}

/// 配置列表本体：小标题 + 卡片。
class _ConfigList extends HookWidget {
  const _ConfigList({
    required this.configs,
    required this.currentId,
    required this.onEdit,
    required this.onActivate,
    required this.onDelete,
  });

  final List<AiConfig> configs;
  final String currentId;
  final ValueChanged<AiConfig> onEdit;
  final ValueChanged<AiConfig> onActivate;
  final ValueChanged<AiConfig> onDelete;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final bool isDesktop = isDesktopPlatform;
    final ColorScheme scheme = context.colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isDesktop ? 760 : double.infinity),
        child: ListView(
          padding: isDesktop
              ? const EdgeInsets.fromLTRB(28, 6, 28, 28)
              : EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 100.h),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 4.w, bottom: 10.h),
              child: Row(
                children: <Widget>[
                  Text(
                    l10n.aiConfigList,
                    style: context.textTheme.labelSmall?.copyWith(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.72),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 1.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      '${configs.length}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: scheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            for (int index = 0; index < configs.length; index++) ...<Widget>[
              if (index > 0) SizedBox(height: 12.h),
              _ConfigCard(
                config: configs[index],
                isCurrent: configs[index].id == currentId,
                onEdit: () => onEdit(configs[index]),
                onActivate: () => onActivate(configs[index]),
                onDelete: () => onDelete(configs[index]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 单条配置卡片。
class _ConfigCard extends HookWidget {
  const _ConfigCard({
    required this.config,
    required this.isCurrent,
    required this.onEdit,
    required this.onActivate,
    required this.onDelete,
  });

  final AiConfig config;
  final bool isCurrent;
  final VoidCallback onEdit;
  final VoidCallback onActivate;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final bool isDark = context.isDark;
    final bool isDesktop = isDesktopPlatform;
    final double radius = isDesktop ? 12 : 18.r;

    // 当前配置用渐变描边 + 微发光，与底栏、圆球的激活态保持同一套视觉。
    final BoxDecoration outer = isCurrent
        ? BoxDecoration(
            gradient: aiActivationGradient,
            borderRadius: BorderRadius.circular(radius + 1.5),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: aiActivationGradientColors.first.withValues(
                  alpha: isDark ? 0.16 : 0.22,
                ),
                blurRadius: 14,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: scheme.shadow.withValues(alpha: isDark ? 0.20 : 0.04),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          )
        : BoxDecoration(
            color: scheme.outline.withValues(alpha: isDark ? 0.30 : 0.14),
            borderRadius: BorderRadius.circular(radius + 1),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: scheme.shadow.withValues(alpha: isDark ? 0.20 : 0.04),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          );

    return Container(
      padding: EdgeInsets.all(isCurrent ? 1.5 : 1),
      decoration: outer,
      child: Material(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(radius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onEdit,
          child: Padding(
            padding: isDesktop
                ? const EdgeInsets.fromLTRB(16, 14, 8, 14)
                : EdgeInsets.fromLTRB(14.w, 13.h, 4.w, 13.h),
            child: Row(
              children: <Widget>[
                AiBrandIcon(
                  brand: resolveAiBrand(
                    apiUrl: config.apiUrl,
                    modelName: config.modelName,
                    name: config.name,
                  ),
                  size: isDesktop ? 40 : 40.w,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              config.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: scheme.onSurface,
                              ),
                            ),
                          ),
                          if (isCurrent) ...<Widget>[
                            SizedBox(width: 8.w),
                            _CurrentBadge(label: l10n.aiConfigCurrent),
                          ],
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        config.hasModel ? config.modelName : l10n.aiModelUnset,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w600,
                          color: config.hasModel
                              ? scheme.onSurfaceVariant
                              : scheme.error,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        config.apiUrl,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.5.sp,
                          color: scheme.onSurfaceVariant.withValues(alpha: 0.72),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<_ConfigAction>(
                  tooltip: '',
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.more_horiz_rounded,
                    size: 20.sp,
                    color: scheme.onSurfaceVariant,
                  ),
                  onSelected: (_ConfigAction action) => switch (action) {
                    _ConfigAction.activate => onActivate(),
                    _ConfigAction.edit => onEdit(),
                    _ConfigAction.delete => onDelete(),
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<_ConfigAction>>[
                        if (!isCurrent)
                          PopupMenuItem<_ConfigAction>(
                            value: _ConfigAction.activate,
                            child: _MenuRow(
                              icon: Icons.check_circle_outline_rounded,
                              label: l10n.aiConfigUse,
                            ),
                          ),
                        PopupMenuItem<_ConfigAction>(
                          value: _ConfigAction.edit,
                          child: _MenuRow(
                            icon: Icons.edit_outlined,
                            label: l10n.aiConfigEdit,
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem<_ConfigAction>(
                          value: _ConfigAction.delete,
                          child: _MenuRow(
                            icon: Icons.delete_outline_rounded,
                            label: l10n.aiConfigDelete,
                            color: scheme.error,
                          ),
                        ),
                      ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _ConfigAction { activate, edit, delete }

/// 卡片上的「当前」标记。
class _CurrentBadge extends HookWidget {
  const _CurrentBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9.5.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          color: scheme.primary,
        ),
      ),
    );
  }
}

/// 弹出菜单里的一行：图标 + 文案。
class _MenuRow extends HookWidget {
  const _MenuRow({required this.icon, required this.label, this.color});

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Color effective = color ?? context.colorScheme.onSurface;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 18.sp, color: effective),
        SizedBox(width: 10.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: effective,
          ),
        ),
      ],
    );
  }
}

/// 空态：渐变图标 + 引导文案 + 新建按钮。
class _EmptyState extends HookWidget {
  const _EmptyState({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(1.6),
              decoration: BoxDecoration(
                gradient: aiActivationGradient,
                borderRadius: BorderRadius.circular(25.r),
                boxShadow: buildAiActivationGlowShadows(
                  isDark: context.isDark,
                ),
              ),
              child: Container(
                width: 74.w,
                height: 74.w,
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(23.r),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: 32.sp,
                  color: scheme.primary,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              l10n.aiConfigEmpty,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                height: 1.5,
                color: scheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 22.h),
            FilledButton.icon(
              onPressed: onCreate,
              icon: Icon(Icons.add_rounded, size: 18.sp),
              label: Text(l10n.aiConfigNew),
              style: FilledButton.styleFrom(
                minimumSize: Size(0, 42.h),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                textStyle: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
