import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// 侧边栏导航项。
class AppDesktopNavItem {
  const AppDesktopNavItem({
    required this.label,
    required this.outlinedIcon,
    required this.filledIcon,
  });

  final String label;
  final IconData outlinedIcon;
  final IconData filledIcon;
}

/// 桌面端左侧导航栏。
///
/// 替代 `NavigationRail`：固定宽度、紧凑行高、明确的悬停反馈，
/// 顶部为应用标识，右侧用一条细分割线与内容区隔开。
class AppDesktopSidebar extends HookWidget {
  const AppDesktopSidebar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onSelected,
    this.width = 208,
  });

  final List<AppDesktopNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelected;
  final double width;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final bool isDark = context.isDark;

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: colorScheme.outline.withValues(alpha: isDark ? 0.26 : 0.12),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
            child: Row(
              children: <Widget>[
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.bolt_rounded,
                    size: 17,
                    color: colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.l10n.appName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: <Widget>[
                for (int i = 0; i < items.length; i++)
                  _SidebarTile(
                    item: items[i],
                    selected: i == currentIndex,
                    onTap: () => onSelected(i),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _SidebarTile extends HookWidget {
  const _SidebarTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AppDesktopNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> hovered = useState<bool>(false);
    final ColorScheme colorScheme = context.colorScheme;
    final bool isDark = context.isDark;

    final Color foreground = selected
        ? colorScheme.primary
        : colorScheme.onSurface.withValues(alpha: 0.72);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => hovered.value = true,
      onExit: (_) => hovered.value = false,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 38,
          margin: const EdgeInsets.only(bottom: 2),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: selected
                ? colorScheme.primary.withValues(alpha: isDark ? 0.18 : 0.10)
                : hovered.value
                ? colorScheme.onSurface.withValues(alpha: 0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                selected ? item.filledIcon : item.outlinedIcon,
                size: 18,
                color: foreground,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: foreground,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
