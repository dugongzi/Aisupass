import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/ai/domain/models/ai_builtin_group.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_brand_icon.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 一个模型厂商，聚合其下的全部分组。
///
/// 只在本文件内使用：厂商由分组聚合而来，不单独请求接口，
/// 因此用记录类型承载，不额外定义实体与生成物。
typedef _Platform = ({
  String platform,
  String label,
  List<AiBuiltinGroup> groups,
});

/// 把分组按平台聚合，顺序沿用传入顺序（即倍率升序）。
List<_Platform> _groupByPlatform(List<AiBuiltinGroup> groups) {
  final Map<String, List<AiBuiltinGroup>> buckets =
      <String, List<AiBuiltinGroup>>{};
  for (final AiBuiltinGroup group in groups) {
    final String key = group.platform.trim().toLowerCase();
    buckets.putIfAbsent(key, () => <AiBuiltinGroup>[]).add(group);
  }

  return <_Platform>[
    for (final MapEntry<String, List<AiBuiltinGroup>> entry in buckets.entries)
      (
        platform: entry.key,
        label: entry.value.first.platformLabel,
        groups: List<AiBuiltinGroup>.unmodifiable(entry.value),
      ),
  ];
}

/// 弹出厂商选择弹层，返回用户选中厂商下的分组；取消返回 `null`。
///
/// 返回分组列表而非厂商标识，调用方拿到后可直接进入分组选择。
Future<List<AiBuiltinGroup>?> showAiBuiltinPlatformPickerSheet(
  BuildContext context, {
  required List<AiBuiltinGroup> groups,
}) {
  return showModalBottomSheet<List<AiBuiltinGroup>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) => _AiBuiltinPlatformSheet(
      platforms: _groupByPlatform(groups),
    ),
  );
}

/// 厂商单选弹层：先选厂商，再落到该厂商下的分组，缩短后续列表。
class _AiBuiltinPlatformSheet extends HookWidget {
  const _AiBuiltinPlatformSheet({required this.platforms});

  final List<_Platform> platforms;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final bool isDark = context.isDark;
    final ValueNotifier<String> query = useState<String>('');

    final String keyword = query.value.trim().toLowerCase();
    final List<_Platform> filtered = keyword.isEmpty
        ? platforms
        : platforms
              .where(
                (_Platform item) =>
                    item.label.toLowerCase().contains(keyword) ||
                    item.platform.contains(keyword),
              )
              .toList(growable: false);

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.62,
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
                Icon(
                  Icons.category_outlined,
                  size: 18.sp,
                  color: scheme.primary,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    l10n.aiBuiltinPlatformTitle,
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
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 10.h),
            child: TextField(
              onChanged: (String text) => query.value = text,
              style: TextStyle(fontSize: 14.sp, color: scheme.onSurface),
              decoration: InputDecoration(
                hintText: l10n.aiBuiltinPlatformSearchHint,
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
                        l10n.aiBuiltinPlatformEmpty,
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
                    itemBuilder: (BuildContext context, int index) {
                      final _Platform item = filtered[index];
                      final int modelCount = item.groups.fold(
                        0,
                        (int sum, AiBuiltinGroup group) =>
                            sum + group.models.length,
                      );
                      return InkWell(
                        onTap: () => Navigator.of(context).pop(item.groups),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 12.h,
                          ),
                          child: Row(
                            children: <Widget>[
                              AiBrandIcon(
                                brand: resolveAiBrandForPlatform(item.platform),
                                size: 26.w,
                                fallbackIcon: Icons.memory_rounded,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      item.label,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: scheme.onSurface,
                                      ),
                                    ),
                                    SizedBox(height: 3.h),
                                    Text(
                                      l10n.aiBuiltinPlatformMeta(
                                        item.groups.length,
                                        modelCount,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11.5.sp,
                                        color: scheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                size: 18.sp,
                                color: scheme.onSurfaceVariant.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }
}
