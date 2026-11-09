import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/features/escalation/domain/models/dirty_frag_run_defaults.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:Aisupass/features/escalation/domain/models/vr_derive_progress.dart';
import 'package:Aisupass/features/escalation/domain/models/vr_offset_result.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 运行前二次确认。
///
/// 返回本次临时指定的手动偏移；`null` 表示取消，或本次不需要手动偏移。
Future<int?> showDirtyFragConfirmDialog(
  BuildContext context, {
  required RootManager manager,
  required String kernelVersion,
  required bool kernelSupported,
  required DirtyFragRunDefaults defaults,
}) => showDialog<int>(
  context: context,
  builder: (BuildContext dialogContext) => _DirtyFragConfirmDialog(
    manager: manager,
    kernelVersion: kernelVersion,
    kernelSupported: kernelSupported,
    defaults: defaults,
  ),
);

/// 确认弹窗：把要跑的对象、内核与风险摊开。
///
/// VR 反制 / 自动解析 / 软重启三项**只读展示**——它们的开关在设置页，
/// 这里开第二扇门会让「唯一真相」变成两份。本弹窗唯一可改的是手动偏移。
class _DirtyFragConfirmDialog extends HookConsumerWidget {
  const _DirtyFragConfirmDialog({
    required this.manager,
    required this.kernelVersion,
    required this.kernelSupported,
    required this.defaults,
  });

  final RootManager manager;
  final String kernelVersion;
  final bool kernelSupported;
  final DirtyFragRunDefaults defaults;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;

    // 初值取设置里存过的偏移，用户不必每次重填。
    final TextEditingController vrOffset = useTextEditingController(
      text: defaults.hasManualOffset ? defaults.vrOffset.toString() : '',
    );

    // 提取中只显示进度，按钮变不可点，避免并发起第二次下载。
    final ValueNotifier<bool> deriving = useState<bool>(false);
    final AsyncValue<VrDeriveProgress> progress = deriving.value
        ? ref.watch(vrDeriveProgressProvider)
        : const AsyncValue<VrDeriveProgress>.data(
            VrDeriveProgress(phase: 0, done: 0, total: 0),
          );

    // 手动偏移只要不是 1..256 的整数就直接拦下，不给原生再报一次错。
    final String offsetText = useValueListenable(vrOffset).text;
    final int manualOffset = int.tryParse(offsetText.trim()) ?? 0;
    final bool offsetValid = defaults.needsManualOffset
        ? manualOffset >= 1 && manualOffset <= 256
        : true;
    final String onOff = l10n.escalationDirtyFragToggleOn;
    final String offOn = l10n.escalationDirtyFragToggleOff;

    return AlertDialog(
      title: Text(l10n.escalationDirtyFragTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Field(
              label: l10n.escalationDirtyFragFieldManager,
              value: manager.displayName,
            ),
            _Field(
              label: l10n.escalationDirtyFragFieldKernel,
              value: kernelSupported
                  ? kernelVersion
                  : '$kernelVersion ${l10n.escalationDirtyFragKernelUnsupportedShort}',
            ),
            _Field(
              label: l10n.escalationDirtyFragFieldVrDisarm,
              value: defaults.vrDisarm ? onOff : offOn,
            ),
            _Field(
              label: l10n.escalationDirtyFragFieldVrAuto,
              value: defaults.vrAuto ? onOff : offOn,
            ),
            _Field(
              label: l10n.escalationDirtyFragFieldSoftReboot,
              value: defaults.softReboot ? onOff : offOn,
            ),
            if (defaults.needsManualOffset) ...<Widget>[
              SizedBox(height: 8.h),
              TextField(
                controller: vrOffset,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  isDense: true,
                  labelText: l10n.escalationDirtyFragVrOffsetLabel,
                  helperText: l10n.escalationDirtyFragVrOffsetHint,
                  helperMaxLines: 2,
                ),
                style: TextStyle(fontFamily: AppFonts.code, fontSize: 13.sp),
              ),
              SizedBox(height: 8.h),
              OutlinedButton.icon(
                onPressed: deriving.value
                    ? null
                    : () => _derive(context, ref, deriving, vrOffset),
                icon: Icon(Icons.auto_fix_high_rounded, size: 16.sp),
                label: Text(
                  l10n.escalationDirtyFragVrExtractAction,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
              if (deriving.value) ...<Widget>[
                SizedBox(height: 8.h),
                LinearProgressIndicator(value: progress.value?.fraction ?? 0),
                SizedBox(height: 4.h),
                Text(
                  l10n.escalationDirtyFragVrExtractProgress(
                    progress.value?.downloading == true
                        ? l10n.escalationDirtyFragVrExtractPhaseDownload
                        : l10n.escalationDirtyFragVrExtractPhaseUnpack,
                    ((progress.value?.fraction ?? 0) * 100).round(),
                  ),
                  style: TextStyle(fontSize: 11.sp, color: scheme.onSurfaceVariant),
                ),
              ],
            ],
            SizedBox(height: 12.h),
            Text(
              l10n.escalationDirtyFragConfirmBody,
              style: TextStyle(
                fontSize: 12.sp,
                height: 1.5,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.aiCancel),
        ),
        FilledButton(
          onPressed: offsetValid && !deriving.value
              ? () => Navigator.of(context).pop(
                  defaults.needsManualOffset ? manualOffset : null,
                )
              : null,
          child: Text(l10n.escalationDirtyFragConfirmAction),
        ),
      ],
    );
  }

  /// 起一次提取，成功后回填手动偏移输入框。
  Future<void> _derive(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> deriving,
    TextEditingController vrOffset,
  ) async {
    final AppLocalizations l10n = context.l10n;
    final String input = vrOffset.text.trim();
    if (input.isEmpty) {
      ToastMessage.warning(l10n.escalationDirtyFragVrExtractEmpty);
      return;
    }

    deriving.value = true;
    try {
      final VrOffsetResult result = await ref.read(
        deriveVrOffsetProvider(input: input).future,
      );
      if (!context.mounted) return;
      if (!result.usable) {
        ToastMessage.error(
          l10n.escalationDirtyFragVrExtractFailed(
            result.error.isEmpty ? 'unknown' : result.error,
          ),
        );
        return;
      }
      vrOffset.text = result.member.toString();
      ToastMessage.success(
        l10n.escalationDirtyFragVrOffsetResolved(result.member.toString()),
      );
    } catch (error) {
      ToastMessage.error(error);
    } finally {
      deriving.value = false;
    }
  }
}

/// 一行「字段：值」，值用等宽字体。
class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 56.w,
            child: Text(
              label,
              style: TextStyle(fontSize: 12.sp, color: scheme.onSurfaceVariant),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: AppFonts.code,
                fontSize: 12.sp,
                color: scheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
