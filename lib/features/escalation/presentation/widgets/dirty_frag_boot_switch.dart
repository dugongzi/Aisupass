import 'package:Aisupass/common/widgets/app_setting_icon.dart';
import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/escalation/domain/models/dirty_frag_run_defaults.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// DirtyFrag 设置组：专家模式、开机自启、成功后软重启、VR 反制、自动解析。
///
/// 专家模式是整个 DirtyFrag 功能的二级门：关着的时候下面四行全部不可点，
/// 开机自启那一行还会把标题换成带「需先开专家模式」后缀的版本。
///
/// 后三项（软重启 / VR 反制 / 自动解析）存在 DE 偏好里，开机广播直接读，
/// 因此它们的唯一入口是这里——确认弹窗只读展示，不再开第二扇门。
class DirtyFragBootSwitch extends HookConsumerWidget {
  const DirtyFragBootSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final AsyncValue<bool> expert = ref.watch(dirtyFragExpertModeProvider);
    final AsyncValue<bool> boot = ref.watch(dirtyFragBootAutostartProvider);
    final AsyncValue<DirtyFragRunDefaults> runDefaults = ref.watch(
      dirtyFragRunDefaultsProvider,
    );

    // 任一读到一半都先整组不动，避免开关先亮后灭的跳动。
    if (expert.isLoading || boot.isLoading || runDefaults.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Loading(),
      );
    }
    if (expert.hasError || boot.hasError || runDefaults.hasError) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: RefError(
          onRetry: () {
            ref.invalidate(dirtyFragExpertModeProvider);
            ref.invalidate(dirtyFragBootAutostartProvider);
            ref.invalidate(dirtyFragRunDefaultsProvider);
          },
        ),
      );
    }

    final bool expertOn = expert.value ?? false;
    final bool bootOn = boot.value ?? false;
    final DirtyFragRunDefaults defaults = runDefaults.value!;

    // 专家模式关着时，下面四行全部锁死。
    ValueChanged<bool>? gate(ValueChanged<bool> handler) =>
        expertOn ? handler : null;

    return Column(
      children: <Widget>[
        _SwitchRow(
          icon: Icons.build_circle_outlined,
          title: l10n.settingsExpertModeTitle,
          subtitle: l10n.settingsExpertModeDesc,
          value: expertOn,
          onChanged: (bool value) => _toggleExpert(ref, value),
        ),
        Divider(height: 1, indent: 62.w, endIndent: 16.w),
        _SwitchRow(
          icon: Icons.restart_alt_rounded,
          title: expertOn
              ? l10n.settingsBootAutostartTitle
              : l10n.settingsBootAutostartTitleLocked,
          subtitle: l10n.settingsBootAutostartDesc,
          value: bootOn,
          onChanged: gate((bool value) => _toggleBoot(context, ref, value)),
        ),
        Divider(height: 1, indent: 62.w, endIndent: 16.w),
        _SwitchRow(
          icon: Icons.power_settings_new_rounded,
          title: l10n.escalationDirtyFragSoftRebootTitle,
          subtitle: l10n.escalationDirtyFragSoftRebootDesc,
          value: defaults.softReboot,
          onChanged: gate(
            (bool value) => _saveDefaults(
              ref,
              defaults.copyWith(softReboot: value),
            ),
          ),
        ),
        Divider(height: 1, indent: 62.w, endIndent: 16.w),
        _SwitchRow(
          icon: Icons.shield_outlined,
          title: l10n.escalationDirtyFragVrDisarmTitle,
          subtitle: l10n.escalationDirtyFragVrDisarmDesc,
          value: defaults.vrDisarm,
          onChanged: gate(
            (bool value) => _saveDefaults(
              ref,
              defaults.copyWith(vrDisarm: value),
            ),
          ),
        ),
        Divider(height: 1, indent: 62.w, endIndent: 16.w),
        _SwitchRow(
          icon: Icons.tune_rounded,
          title: l10n.escalationDirtyFragVrAutoTitle,
          subtitle: l10n.escalationDirtyFragVrAutoDesc,
          // 没开 VR 反制时自动解析没有意义，跟着锁死。
          value: defaults.vrAuto,
          onChanged: expertOn && defaults.vrDisarm
              ? (bool value) => _saveDefaults(
                  ref,
                  defaults.copyWith(vrAuto: value),
                )
              : null,
        ),
      ],
    );
  }

  Future<void> _toggleExpert(WidgetRef ref, bool enabled) async {
    try {
      await ref.read(setDirtyFragExpertModeProvider(enabled: enabled).future);
    } catch (error) {
      ToastMessage.error(error);
    }
  }

  /// 写运行参数。四个字段整体覆盖，原生侧 `writeRunDefaults` 是一次 edit。
  Future<void> _saveDefaults(
    WidgetRef ref,
    DirtyFragRunDefaults defaults,
  ) async {
    try {
      await ref.read(
        saveDirtyFragRunDefaultsProvider(defaults: defaults).future,
      );
    } catch (error) {
      ToastMessage.error(error);
    }
  }

  /// 开启前问一次：开机阶段失败会把用户挡在只能刷机的路上。
  Future<void> _toggleBoot(
    BuildContext context,
    WidgetRef ref,
    bool enabled,
  ) async {
    if (enabled) {
      final AppLocalizations l10n = context.l10n;
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
          title: Text(l10n.settingsBootAutostartConfirmTitle),
          content: Text(
            l10n.settingsBootAutostartConfirmBody,
            style: TextStyle(
              fontSize: 12.sp,
              height: 1.5,
              color: dialogContext.colorScheme.onSurfaceVariant,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.aiCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.settingsBootAutostartConfirmAction),
            ),
          ],
        ),
      );
      if (confirmed != true || !context.mounted) return;
    }
    try {
      await ref.read(
        setDirtyFragBootAutostartProvider(enabled: enabled).future,
      );
    } catch (error) {
      ToastMessage.error(error);
    }
  }
}

/// 一行「图标 + 标题/说明 + 开关」。与设置页其它行同版式。
class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;

  /// 为 `null` 时整行不可点（专家模式关闭时的开机自启行）。
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    final bool enabled = onChanged != null;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: <Widget>[
          AppSettingIcon(icon: icon),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: enabled
                        ? scheme.onSurface
                        : scheme.onSurface.withValues(alpha: 0.38),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: scheme.onSurfaceVariant.withValues(
                      alpha: enabled ? 1 : 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
