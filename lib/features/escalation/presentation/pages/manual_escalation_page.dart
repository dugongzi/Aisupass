import 'package:Aisupass/common/widgets/app_setting_icon.dart';
import 'package:Aisupass/common/widgets/app_settings_section.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/routes/app_route.dart';
import 'package:Aisupass/features/escalation/presentation/widgets/terminal_link_notice.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// 手动提权页：一屏提权操作入口。
///
/// 终端与提权流程都在 `TerminalPage` 里执行，这一页只负责挑动作：点哪一项就把
/// 动作名带进终端页，由终端页发起并写屏，输出与结果都在那一屏上。
class ManualEscalationPage extends HookWidget {
  const ManualEscalationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;

    /// 带着动作跳终端页，动作在终端页首帧之后执行。
    void openTerminal(String action) {
      context.push(AppRoute.manualEscalationTerminalPath(action: action));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.escalationTitle),
        actions: <Widget>[
          // 不带动作用途：只是进终端看看、敲点命令。
          IconButton(
            tooltip: l10n.escalationTerminalEntry,
            onPressed: () => context.push(AppRoute.manualEscalationTerminal),
            icon: Icon(Icons.terminal_rounded, size: 20.r),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          // 终端只跑在无线 ADB 上；没连上时在这里说明，并提供连接入口。
          const TerminalLinkNotice(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
              children: <Widget>[
                AppSettingsSection(
                  title: l10n.escalationToolSection,
                  children: <Widget>[
                    _ActionRow(
                      icon: Icons.security_rounded,
                      title: l10n.escalationPayloadRootTitle,
                      onTap: () => openTerminal('payload'),
                    ),
                    Divider(height: 1, indent: 62.w, endIndent: 16.w),
                    _ActionRow(
                      icon: Icons.memory_rounded,
                      title: l10n.escalationDirtyFragTitle,
                      onTap: () => openTerminal('dirtyFrag'),
                    ),
                    Divider(height: 1, indent: 62.w, endIndent: 16.w),
                    _ActionRow(
                      icon: Icons.vpn_key_rounded,
                      title: l10n.escalationGhostKeyTitle,
                      onTap: () => openTerminal('ghostKey'),
                    ),
                    Divider(height: 1, indent: 62.w, endIndent: 16.w),
                    _ActionRow(
                      icon: Icons.gpp_maybe_rounded,
                      title: l10n.escalationGhostLockTitle,
                      onTap: () => openTerminal('ghostLock'),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                AppSettingsSection(
                  title: l10n.escalationHandoffSection,
                  children: <Widget>[
                    _ActionRow(
                      icon: Icons.verified_user_rounded,
                      title: l10n.escalationHandoffCurrent,
                      onTap: () => openTerminal('handoff'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 提权操作的一行：图标 + 标题 + 箭头，版式与设置页的入口行一致。
class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: <Widget>[
            AppSettingIcon(icon: icon),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.chevron_right_rounded,
              size: 20.sp,
              color: context.colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ],
        ),
      ),
    );
  }
}
