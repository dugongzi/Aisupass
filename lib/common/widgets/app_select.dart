import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// 下拉选项数据。
@immutable
class AppSelectItem<T> {
  const AppSelectItem({required this.value, required this.label});

  final T value;
  final String label;
}

/// 桌面端下拉选择控件。
///
/// 桌面应用的单选习惯用下拉框而不是分段按钮，因此这里做成
/// 细描边输入框样式：左侧当前值、右侧展开箭头，点击弹出菜单。
/// 尺寸使用固定逻辑像素，不随窗口等比缩放。
class AppSelect<T> extends HookWidget {
  const AppSelect({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.width = 152,
  });

  final T value;
  final List<AppSelectItem<T>> items;
  final ValueChanged<T> onChanged;

  /// 控件宽度，默认 152，刚好容纳「跟随系统」这类较长文案。
  final double width;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> hovered = useState<bool>(false);
    final ColorScheme colorScheme = context.colorScheme;
    final AppSelectItem<T> current = items.firstWhere(
      (AppSelectItem<T> item) => item.value == value,
      orElse: () => items.first,
    );

    return PopupMenuButton<T>(
      tooltip: '',
      position: PopupMenuPosition.under,
      offset: const Offset(0, 4),
      color: colorScheme.surface,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.24)),
      ),
      onSelected: onChanged,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<T>>[
        for (final AppSelectItem<T> item in items)
          PopupMenuItem<T>(
            value: item.value,
            height: 38,
            child: Row(
              children: <Widget>[
                // 固定占位，保证所有选项文字左对齐。
                SizedBox(
                  width: 22,
                  child: item.value == value
                      ? Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: colorScheme.primary,
                        )
                      : null,
                ),
                Expanded(
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => hovered.value = true,
        onExit: (_) => hovered.value = false,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: width,
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: hovered.value
                ? colorScheme.onSurface.withValues(alpha: 0.04)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.outline.withValues(
                alpha: hovered.value ? 0.50 : 0.28,
              ),
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  current.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(
                Icons.expand_more_rounded,
                size: 18,
                color: colorScheme.onSurface.withValues(alpha: 0.55),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
