import 'dart:async';

import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/themes/app_fonts.dart';
import 'package:Aisupass/features/escalation/domain/models/imported_payload.dart';
import 'package:Aisupass/features/escalation/presentation/providers/payload_import_action_provider.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 弹出「导入自定义载荷」，成功返回落库后的条目；取消返回 `null`。
Future<ImportedPayload?> showPayloadImportDialog(BuildContext context) =>
    showDialog<ImportedPayload>(
      context: context,
      builder: (BuildContext context) => const PayloadImportDialog(),
    );

/// 导入自定义载荷：选文件、定名字、选运行方式、填参数。
///
/// 文件会被推到设备固定目录下，所以内容在导入时就确定；之后再跑这一条不需要
/// 再选一次文件。
class PayloadImportDialog extends HookConsumerWidget {
  const PayloadImportDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;

    final ValueNotifier<String> path = useState<String>('');
    final TextEditingController name = useTextEditingController();
    final ValueNotifier<bool> standalone = useState<bool>(false);
    final TextEditingController arguments = useTextEditingController();
    final ValueNotifier<bool> busy = useState<bool>(false);
    useEffect(() => arguments.dispose, <Object?>[arguments]);

    /// 选一个本机文件；.so 与可执行文件都没有标准 MIME，只能放开类型让用户挑。
    Future<void> pickFile() async {
      final FilePickerResult? picked;
      try {
        picked = await FilePicker.pickFiles(withData: false);
      } catch (error) {
        ToastMessage.error(error);
        return;
      }
      final String? filePath = picked == null || picked.files.isEmpty
          ? null
          : picked.files.first.path;
      if (filePath == null) return;
      path.value = filePath;
      if (name.text.trim().isEmpty) name.text = _fileNameOf(filePath);
    }

    /// 推送并落库；成功即关闭弹窗，列表由 Provider 失效刷新。
    Future<void> submit() async {
      if (busy.value) return;
      if (path.value.isEmpty) {
        ToastMessage.error(l10n.escalationPayloadImportNeedFile);
        return;
      }
      busy.value = true;
      try {
        final ImportedPayload imported = await ref
            .read(payloadImportActionsProvider)
            .importFile(
              localPath: path.value,
              displayName: name.text,
              standalone: standalone.value,
              // 助手加载方式不读参数，避免留下一条看不出来源的尾巴。
              arguments: standalone.value ? arguments.text : '',
            );
        if (!context.mounted) return;
        Navigator.of(context).pop(imported);
      } catch (error) {
        ToastMessage.error(_failureText(l10n, error));
      } finally {
        busy.value = false;
      }
    }

    final bool hasFile = path.value.isNotEmpty;

    return AlertDialog(
      title: Text(l10n.escalationPayloadImportTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            OutlinedButton.icon(
              onPressed: busy.value ? null : () => unawaited(pickFile()),
              icon: Icon(Icons.folder_open_rounded, size: 16.r),
              label: Text(
                hasFile
                    ? _fileNameOf(path.value)
                    : l10n.escalationPayloadImportPickFile,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: name,
              enabled: !busy.value,
              style: TextStyle(fontSize: 13.sp),
              decoration: InputDecoration(
                isDense: true,
                labelText: l10n.escalationPayloadImportName,
                hintText: l10n.escalationPayloadImportNameHint,
                border: const OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              l10n.escalationPayloadImportMode,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: scheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 6.h),
            SegmentedButton<bool>(
              segments: <ButtonSegment<bool>>[
                ButtonSegment<bool>(
                  value: false,
                  label: Text(l10n.escalationPayloadImportModeHelper),
                ),
                ButtonSegment<bool>(
                  value: true,
                  label: Text(l10n.escalationPayloadImportModeStandalone),
                ),
              ],
              selected: <bool>{standalone.value},
              showSelectedIcon: false,
              onSelectionChanged: busy.value
                  ? null
                  : (Set<bool> selected) => standalone.value = selected.first,
              style: ButtonStyle(
                textStyle: WidgetStatePropertyAll<TextStyle>(
                  TextStyle(fontSize: 11.sp),
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              standalone.value
                  ? l10n.escalationPayloadImportModeStandaloneDesc
                  : l10n.escalationPayloadImportModeHelperDesc,
              style: TextStyle(fontSize: 11.sp, color: scheme.onSurfaceVariant),
            ),
            if (standalone.value) ...<Widget>[
              SizedBox(height: 12.h),
              TextField(
                controller: arguments,
                enabled: !busy.value,
                style: TextStyle(fontFamily: AppFonts.code, fontSize: 12.sp),
                decoration: InputDecoration(
                  isDense: true,
                  labelText: l10n.escalationPayloadImportArguments,
                  hintText: l10n.escalationPayloadImportArgumentsHint,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: busy.value ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.aiCancel),
        ),
        FilledButton(
          onPressed: busy.value ? null : () => unawaited(submit()),
          child: busy.value
              ? SizedBox.square(
                  dimension: 16.r,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.escalationPayloadImportConfirm),
        ),
      ],
    );
  }
}

/// 取文件名：桌面与安卓的分隔符都要认。
String _fileNameOf(String path) {
  final int slash = path.lastIndexOf(RegExp(r'[/\\]'));
  return slash < 0 ? path : path.substring(slash + 1);
}

/// 导入失败 → 展示文案；非预期异常原样带上。
String _failureText(AppLocalizations l10n, Object error) {
  if (error is! PayloadImportException) return '$error';
  final String base = switch (error.code) {
    'fileMissing' => l10n.escalationPayloadImportFileMissing,
    'fileEmpty' => l10n.escalationPayloadImportFileEmpty,
    'pushFailed' => l10n.escalationPayloadImportPushFailed,
    _ => error.code,
  };
  return error.detail.isEmpty ? base : '$base：${error.detail}';
}
