import 'dart:async';

import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/terminal_key_bar.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 底栏菜单的选项。
///
/// 提权、移交、清屏共用一个枚举，选中后只有一处 switch。
enum EscalationMenuAction { exploit, handoffKernelsu, handoffSukisu, clear }

/// 底栏最左侧的三点菜单键。
///
/// 外观与功能键同属一套键帽（[TerminalIconKey]），位置由按键栏固定在最左，
/// 不随功能键横向滚动。点开的是同一份菜单：提权、移交、清屏。
class EscalationMenuButton extends HookWidget {
  const EscalationMenuButton({super.key, required this.onSelected});

  /// 选中菜单项后回调，具体干什么由页面决定。
  final ValueChanged<EscalationMenuAction> onSelected;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ThemeData theme = Theme.of(context);

    // 菜单键在底栏里，位置由布局决定，弹出锚点要自己按按钮的实际位置算。
    final GlobalKey anchorKey = useMemoized(GlobalKey.new, const <Object?>[]);

    Future<void> openMenu() async {
      final RenderObject? anchor = anchorKey.currentContext?.findRenderObject();
      final RenderObject? overlay = Overlay.maybeOf(
        context,
      )?.context.findRenderObject();
      if (anchor is! RenderBox || overlay is! RenderBox) return;

      final RelativeRect position = RelativeRect.fromRect(
        Rect.fromPoints(
          anchor.localToGlobal(Offset.zero, ancestor: overlay),
          anchor.localToGlobal(
            anchor.size.bottomRight(Offset.zero),
            ancestor: overlay,
          ),
        ),
        Offset.zero & overlay.size,
      );
      final EscalationMenuAction? action = await showMenu<EscalationMenuAction>(
        context: context,
        position: position,
        items: _menuEntries(l10n, theme),
      );
      // 菜单要等用户选完才回来，期间页面可能已经被销毁。
      if (action != null && context.mounted) onSelected(action);
    }

    return Tooltip(
      message: l10n.escalationMenuTitle,
      excludeFromSemantics: true,
      child: TerminalIconKey(
        key: anchorKey,
        semanticLabel: l10n.escalationMenuTitle,
        onTap: () => unawaited(openMenu()),
        // 图标是白色填充，换成键帽前景色，和文字键一个调子。
        icon: SvgPicture.asset(
          kMoreVertIconAsset,
          width: 18.r,
          height: 18.r,
          colorFilter: const ColorFilter.mode(
            TerminalKeyBar.keyForeground,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  /// 菜单内容。
  List<PopupMenuEntry<EscalationMenuAction>> _menuEntries(
    AppLocalizations l10n,
    ThemeData theme,
  ) => <PopupMenuEntry<EscalationMenuAction>>[
    _item(
      EscalationMenuAction.exploit,
      Icons.security_rounded,
      l10n.escalationExploitButton,
    ),
    const PopupMenuDivider(),
    // 分组头不可点，菜单长了才好找。
    _header(theme, l10n.escalationHandoffSection),
    _item(
      EscalationMenuAction.handoffKernelsu,
      Icons.verified_user_rounded,
      l10n.escalationHandoffManagerKernelsu,
    ),
    _item(
      EscalationMenuAction.handoffSukisu,
      Icons.verified_user_rounded,
      l10n.escalationHandoffManagerSukisu,
    ),
    const PopupMenuDivider(),
    _item(
      EscalationMenuAction.clear,
      Icons.cleaning_services_rounded,
      l10n.escalationMenuClear,
    ),
  ];

  PopupMenuItem<EscalationMenuAction> _item(
    EscalationMenuAction action,
    IconData icon,
    String label,
  ) => PopupMenuItem<EscalationMenuAction>(
    value: action,
    child: Row(
      children: <Widget>[
        Icon(icon, size: 18.r),
        SizedBox(width: 10.w),
        Text(label),
      ],
    ),
  );

  PopupMenuItem<EscalationMenuAction> _header(ThemeData theme, String label) =>
      PopupMenuItem<EscalationMenuAction>(
        enabled: false,
        height: 32.h,
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
}
