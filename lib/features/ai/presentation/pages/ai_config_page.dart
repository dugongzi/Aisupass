import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/routes/app_route.dart';
import 'package:Aisupass/core/themes/ai_activation_theme.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/ai/domain/constants/builtin_ai_config.dart';
import 'package:Aisupass/features/ai/domain/models/ai_config.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_config_query_provider.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_brand_icon.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// AI 配置列表页。
///
/// 新建入口统一放在标题栏右上角的「+」图标；
/// 点击卡片进入编辑页，切换与删除在编辑页底部操作。
class AiConfigPage extends HookConsumerWidget {
  const AiConfigPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final bool isDesktop = isDesktopPlatform;
    final AsyncValue<AiConfigState> configsAsync = ref.watch(aiConfigProvider);

    void openEditor(String id) =>
        context.push(AppRoute.aiConfigEditPath(id));

    /// 打开内置服务的站点获取 API Key。
    Future<void> openGetKey() => launchUrl(
      Uri.parse(builtinAiConfigPurchaseUrl),
      mode: LaunchMode.externalApplication,
    );

    final Widget content = configsAsync.when(
      loading: () => const Loading(),
      error: (Object error, StackTrace stackTrace) =>
          RefError(onRetry: () => ref.invalidate(aiConfigProvider)),
      data: (AiConfigState state) => state.configs.isEmpty
          ? const _EmptyState()
          : _ConfigList(
              configs: state.configs,
              currentId: state.currentId,
              onEdit: (AiConfig config) => openEditor(config.id),
              onGetKey: openGetKey,
            ),
    );

    if (!isDesktop) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.aiConfigTitle),
          actions: <Widget>[
            IconButton(
              onPressed: () => openEditor(AppRoute.newConfigId),
              icon: Icon(Icons.add_rounded, size: 22.sp),
              tooltip: l10n.aiConfigNew,
            ),
            SizedBox(width: 6.w),
          ],
        ),
        body: content,
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
                IconButton(
                  onPressed: () => openEditor(AppRoute.newConfigId),
                  icon: const Icon(Icons.add_rounded, size: 22),
                  tooltip: l10n.aiConfigNew,
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
    required this.onGetKey,
  });

  final List<AiConfig> configs;
  final String currentId;
  final ValueChanged<AiConfig> onEdit;
  final VoidCallback onGetKey;

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
              : EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
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
                onGetKey: onGetKey,
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
    required this.onGetKey,
  });

  final AiConfig config;
  final bool isCurrent;
  final VoidCallback onEdit;
  final VoidCallback onGetKey;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final bool isDark = context.isDark;
    final bool isDesktop = isDesktopPlatform;
    final bool isBuiltin = isBuiltinAiConfig(config);
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
                ? const EdgeInsets.fromLTRB(16, 14, 16, 14)
                : EdgeInsets.fromLTRB(14.w, 13.h, 14.w, 13.h),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: isDesktop ? 40 : 40.w,
                  height: isDesktop ? 40 : 40.w,
                  child: Center(
                    child: AiBrandIcon(
                      brand: resolveAiBrand(
                        apiUrl: config.apiUrl,
                        modelName: config.modelName,
                        name: config.name,
                      ),
                      size: isDesktop ? 26 : 26.w,
                    ),
                  ),
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
                          if (isBuiltin) ...<Widget>[
                            SizedBox(width: 8.w),
                            _BuiltinBadge(label: l10n.aiConfigBuiltin),
                          ],
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
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              config.apiUrl,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.5.sp,
                                color: scheme.onSurfaceVariant.withValues(
                                  alpha: 0.72,
                                ),
                              ),
                            ),
                          ),
                          if (isBuiltin) ...<Widget>[
                            SizedBox(width: 6.w),
                            _GetKeyLink(
                              label: l10n.aiConfigGetKey,
                              onTap: onGetKey,
                            ),
                          ],
                        ],
                      ),
                    ],
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

/// 卡片上的「内置」标记，用中性色与「当前」区分。
class _BuiltinBadge extends HookWidget {
  const _BuiltinBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: scheme.onSurfaceVariant.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9.5.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          color: scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// 卡片上的「获取 Key」入口，点击跳转内置服务站点。
class _GetKeyLink extends HookWidget {
  const _GetKeyLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: scheme.primary,
              ),
            ),
            SizedBox(width: 2.w),
            Icon(
              Icons.open_in_new_rounded,
              size: 11.sp,
              color: scheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

/// 空态：仅引导文案。
class _EmptyState extends HookWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
        child: Text(
          l10n.aiConfigEmpty,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.sp,
            height: 1.5,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
