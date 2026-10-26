import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_brand_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 模型选择器：点击弹出可搜索的底部弹层。
///
/// 模型数量可能上百，普通下拉框不可用，因此统一走弹层。
class AiModelPicker extends HookWidget {
  const AiModelPicker({
    super.key,
    required this.value,
    required this.models,
    required this.loading,
    required this.onChanged,
    this.label,
    this.errorText,
  });

  final String value;
  final List<String> models;
  final bool loading;
  final ValueChanged<String> onChanged;

  /// 标题文案；放在分组卡片里时可传 null，避免与分组标题重复。
  final String? label;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    final bool isDark = context.isDark;
    final bool hasValue = value.trim().isNotEmpty;

    Future<void> openPicker() async {
      if (loading) return;
      if (models.isEmpty) {
        ToastMessage.show(context.l10n.aiModelRequired);
        return;
      }
      final String? picked = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) =>
            _AiModelSheet(models: models, selected: value),
      );
      if (picked != null) onChanged(picked);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (label != null)
          Padding(
            padding: EdgeInsets.only(left: 2.w, bottom: 7.h),
            child: Row(
              children: <Widget>[
                Text(
                  label!,
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                if (loading) ...[
                  SizedBox(width: 8.w),
                  SizedBox(
                    width: 12.w,
                    height: 12.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.6,
                      color: scheme.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        InkWell(
          onTap: openPicker,
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: isDark
                  ? scheme.onSurface.withValues(alpha: 0.04)
                  : scheme.surfaceContainerHighest.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: errorText == null
                    ? scheme.outline.withValues(alpha: isDark ? 0.28 : 0.16)
                    : scheme.error,
              ),
            ),
            child: Row(
              children: <Widget>[
                if (hasValue) ...[
                  AiBrandIcon(
                    brand: resolveAiBrand(modelName: value),
                    size: 22.w,
                  ),
                  SizedBox(width: 10.w),
                ],
                Expanded(
                  child: Text(
                    hasValue
                        ? value
                        : models.isEmpty
                        ? context.l10n.aiModelHint
                        : context.l10n.aiModelPickHint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: hasValue
                          ? scheme.onSurface
                          : scheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                Icon(
                  Icons.unfold_more_rounded,
                  size: 20.sp,
                  color: scheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(left: 4.w, top: 6.h),
            child: Text(
              errorText!,
              style: TextStyle(fontSize: 11.5.sp, color: scheme.error),
            ),
          ),
      ],
    );
  }
}

/// 带搜索框的模型列表弹层。
class _AiModelSheet extends HookWidget {
  const _AiModelSheet({required this.models, required this.selected});

  final List<String> models;
  final String selected;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    final bool isDark = context.isDark;
    final TextEditingController controller = useTextEditingController();
    final ValueNotifier<String> query = useState<String>('');

    final String keyword = query.value.trim().toLowerCase();
    final List<String> filtered = keyword.isEmpty
        ? models
        : models
              .where((String id) => id.toLowerCase().contains(keyword))
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
                Icon(Icons.hub_outlined, size: 18.sp, color: scheme.primary),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    context.l10n.aiModelSelect,
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
              controller: controller,
              autofocus: true,
              onChanged: (String text) => query.value = text,
              style: TextStyle(fontSize: 14.sp, color: scheme.onSurface),
              decoration: InputDecoration(
                hintText: context.l10n.aiModelSearch,
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.search_off_rounded,
                          size: 38.sp,
                          color: scheme.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          context.l10n.aiModelEmpty,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    itemCount: filtered.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String id = filtered[index];
                      final bool isSelected = id == selected;
                      return InkWell(
                        onTap: () => Navigator.of(context).pop(id),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 11.h,
                          ),
                          child: Row(
                            children: <Widget>[
                              AiBrandIcon(
                                brand: resolveAiBrand(modelName: id),
                                size: 22.w,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  id,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13.5.sp,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? scheme.primary
                                        : scheme.onSurface,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: 18.sp,
                                  color: scheme.primary,
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
