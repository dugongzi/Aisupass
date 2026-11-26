import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/ai/domain/models/ai_builtin_group.dart';
import 'package:Aisupass/features/ai/domain/models/ai_builtin_model.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_brand_icon.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 弹出模型选择弹层，返回用户选中的模型；取消返回 `null`。
Future<AiBuiltinModel?> showAiBuiltinModelPickerSheet(
  BuildContext context, {
  required AiBuiltinGroup group,
}) {
  return showModalBottomSheet<AiBuiltinModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) => _AiBuiltinModelSheet(group: group),
  );
}

/// 模型单选弹层：只列所选分组的模型，支持搜索。
class _AiBuiltinModelSheet extends HookWidget {
  const _AiBuiltinModelSheet({required this.group});

  final AiBuiltinGroup group;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final bool isDark = context.isDark;
    final ValueNotifier<String> query = useState<String>('');

    final String keyword = query.value.trim().toLowerCase();
    final List<AiBuiltinModel> filtered = keyword.isEmpty
        ? group.models
        : group.models
              .where(
                (AiBuiltinModel model) =>
                    model.name.toLowerCase().contains(keyword),
              )
              .toList(growable: false);

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.72,
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
                  Icons.hub_outlined,
                  size: 18.sp,
                  color: scheme.primary,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        l10n.aiBuiltinModelTitle,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: context.textTheme.titleMedium?.color,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        group.name,
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
              autofocus: true,
              onChanged: (String text) => query.value = text,
              style: TextStyle(fontSize: 14.sp, color: scheme.onSurface),
              decoration: InputDecoration(
                hintText: l10n.aiBuiltinModelSearchHint,
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
                        l10n.aiBuiltinModelEmpty,
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
                      final AiBuiltinModel model = filtered[index];
                      return InkWell(
                        onTap: () => Navigator.of(context).pop(model),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 11.h,
                          ),
                          child: Row(
                            children: <Widget>[
                              AiBrandIcon(
                                brand: resolveAiBrand(modelName: model.name),
                                size: 22.w,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  model.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13.5.sp,
                                    color: scheme.onSurface,
                                  ),
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
