import 'dart:async';

import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/ai/domain/constants/builtin_ai_config.dart';
import 'package:Aisupass/features/ai/domain/models/ai_builtin_group.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_brand_icon.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

/// 弹出分组选择弹层，返回用户选中的分组；取消返回 `null`。
Future<AiBuiltinGroup?> showAiBuiltinGroupPickerSheet(
  BuildContext context, {
  required List<AiBuiltinGroup> groups,
}) {
  return showModalBottomSheet<AiBuiltinGroup>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) => _AiBuiltinGroupSheet(groups: groups),
  );
}

/// 分组单选弹层：名称、平台、倍率与模型数量一目了然。
///
/// 顶部给出渠道状态看板入口：分组稳定性差异很大，让用户先看哪个分组
/// 的绿色（在线）节点更多，再决定选哪个，而不是由我们替他推荐。
class _AiBuiltinGroupSheet extends HookWidget {
  const _AiBuiltinGroupSheet({required this.groups});

  final List<AiBuiltinGroup> groups;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final bool isDark = context.isDark;
    final ValueNotifier<String> query = useState<String>('');

    final String keyword = query.value.trim().toLowerCase();
    final List<AiBuiltinGroup> filtered = keyword.isEmpty
        ? groups
        : groups
              .where(
                (AiBuiltinGroup group) =>
                    group.name.toLowerCase().contains(keyword) ||
                    group.platform.toLowerCase().contains(keyword),
              )
              .toList(growable: false);

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.78,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
        border: Border.all(
          color: scheme.outline.withValues(alpha: isDark ? 0.28 : 0.14),
        ),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: 8.h),
          Container(
            width: 36.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: scheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
            child: Row(
              children: <Widget>[
                Icon(Icons.layers_outlined, size: 18.sp, color: scheme.primary),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    l10n.aiBuiltinGroupTitle,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: context.textTheme.titleMedium?.color,
                    ),
                  ),
                ),
                Text(
                  '${filtered.length}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
            child: const _MonitorTip(),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
            child: TextField(
              onChanged: (String text) => query.value = text,
              style: TextStyle(fontSize: 14.sp, color: scheme.onSurface),
              decoration: InputDecoration(
                hintText: l10n.aiBuiltinGroupSearchHint,
                hintStyle: TextStyle(
                  fontSize: 13.sp,
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 18.sp,
                  color: scheme.onSurfaceVariant,
                ),
                filled: true,
                fillColor: isDark
                    ? scheme.onSurface.withValues(alpha: 0.04)
                    : scheme.surfaceContainerHighest.withValues(alpha: 0.35),
                contentPadding: EdgeInsets.symmetric(vertical: 13.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide(
                    color: scheme.outline.withValues(
                      alpha: isDark ? 0.28 : 0.16,
                    ),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide(
                    color: scheme.outline.withValues(
                      alpha: isDark ? 0.28 : 0.16,
                    ),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide(color: scheme.primary, width: 1.5),
                ),
              ),
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.5,
            color: scheme.outline.withValues(alpha: 0.24),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Text(
                        l10n.aiBuiltinGroupEmpty,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          height: 1.5,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    itemCount: filtered.length,
                    itemBuilder: (BuildContext context, int index) =>
                        _GroupTile(group: filtered[index]),
                  ),
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }
}

/// 渠道状态提示条：引导用户去公开看板挑绿色多的分组。
class _MonitorTip extends HookWidget {
  const _MonitorTip();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(10.w, 8.h, 6.w, 8.h),
      decoration: BoxDecoration(
        color: scheme.tertiary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: scheme.tertiary.withValues(alpha: 0.22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.monitor_heart_outlined,
            size: 15.sp,
            color: scheme.tertiary,
          ),
          SizedBox(width: 7.w),
          Expanded(
            child: Text(
              l10n.aiBuiltinMonitorHint,
              style: TextStyle(
                fontSize: 11.sp,
                height: 1.4,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          TextButton(
            onPressed: () => unawaited(
              launchUrl(
                Uri.parse(builtinAiConfigMonitorUrl),
                mode: LaunchMode.externalApplication,
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: scheme.tertiary,
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size.zero,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            ),
            child: Text(
              l10n.aiBuiltinMonitorOpen,
              style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

/// 单个分组行。
class _GroupTile extends StatelessWidget {
  const _GroupTile({required this.group});

  final AiBuiltinGroup group;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    final AppLocalizations l10n = context.l10n;

    return InkWell(
      onTap: () => Navigator.of(context).pop(group),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 11.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                AiBrandIcon(
                  brand: resolveAiBrandForPlatform(group.platform),
                  size: 22.w,
                  fallbackIcon: Icons.layers_outlined,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    group.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurface,
                    ),
                  ),
                ),
                if (group.isExclusive) ...<Widget>[
                  SizedBox(width: 6.w),
                  _Badge(
                    text: l10n.aiBuiltinGroupExclusive,
                    color: scheme.tertiary,
                  ),
                ],
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              l10n.aiBuiltinGroupMeta(
                group.rateMultiplier.toStringAsFixed(3),
                group.models.length,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5.sp,
                color: scheme.onSurfaceVariant,
              ),
            ),
            if (group.description.trim().isNotEmpty) ...<Widget>[
              SizedBox(height: 3.h),
              Text(
                group.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.8),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 行内小徽标。
class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
