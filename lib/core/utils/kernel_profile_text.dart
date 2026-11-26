import 'package:Aisupass/features/escalation/domain/models/kernel_profile_import_result.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile_import_state.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

// 内核 profile 导入的展示映射：只把原生回的错误码与进度相位翻成可读文案，不做判定。

/// 导入阶段名：0 定位 OTA 包 / 1 下载镜像 / 2 解析内核 / 3 写 profile / 4 完成。
String kernelProfilePhaseLabel(AppLocalizations l10n, int phase) =>
    switch (phase) {
      KernelProfileImportState.phaseLocate => l10n.kernelProfilePhaseLocate,
      KernelProfileImportState.phaseDownload => l10n.kernelProfilePhaseRead,
      KernelProfileImportState.phaseParse => l10n.kernelProfilePhaseParse,
      KernelProfileImportState.phaseSave => l10n.kernelProfilePhaseSave,
      _ => l10n.kernelProfilePhaseDone,
    };

/// 下载相位的字节进度文案；其它相位返回 null（由调用方显示不确定进度）。
String? kernelProfileByteProgress(
  AppLocalizations l10n,
  KernelProfileImportState state,
) {
  if (!state.determinate) return null;
  return l10n.kernelProfileBytesProgress(
    _formatBytes(state.done),
    _formatBytes(state.total),
  );
}

String _formatBytes(int bytes) {
  const List<String> units = <String>['B', 'KiB', 'MiB', 'GiB'];
  double value = bytes.toDouble();
  int unit = 0;
  while (value >= 1024 && unit < units.length - 1) {
    value /= 1024;
    unit++;
  }
  return '${value.toStringAsFixed(unit == 0 ? 0 : 1)} ${units[unit]}';
}

/// 错误码 → 可读文案；追加缺失字段与非空的原始错误详情。
///
/// 原始详情（`result.error`）来自原生侧异常类名/消息，不做翻译，原样展示，
/// 便于在 UI 上直接定位失败原因。
String kernelProfileErrorText(
  AppLocalizations l10n,
  KernelProfileImportState state,
) {
  final String mapped = switch (state.result.errorCode) {
    'emptyPath' => l10n.kernelProfileErrorEmptyPath,
    'notFound' => l10n.kernelProfileErrorNotFound,
    'tooLarge' => l10n.kernelProfileErrorTooLarge,
    'notBootImage' => l10n.kernelProfileErrorNotBootImage,
    'decode' => l10n.kernelProfileErrorDecode,
    'incomplete' => l10n.kernelProfileErrorIncomplete,
    'noBtf' => l10n.kernelProfileErrorNoBtf,
    'io' => l10n.kernelProfileErrorIo,
    'badUrl' => l10n.kernelProfileErrorBadUrl,
    'download' => l10n.kernelProfileErrorDownload,
    'oom' => l10n.kernelProfileErrorOom,
    _ => l10n.kernelProfileErrorUnknown,
  };
  final List<String> lines = <String>[mapped];
  if (state.result.missing.isNotEmpty) {
    lines.add(l10n.kernelProfileMissingFields(state.result.missing.join(', ')));
  }
  final String detail = state.result.error.trim();
  if (detail.isNotEmpty) {
    lines.add(l10n.kernelProfileErrorDetail(detail));
  }
  return lines.join('\n');
}

/// 编辑器保存失败文案：错误码 + 缺失字段 + 原始详情。
String kernelProfileEditErrorText(
  AppLocalizations l10n,
  KernelProfileImportResult result,
) {
  final String mapped = switch (result.errorCode) {
    'invalidField' => l10n.kernelProfileEditInvalidField,
    'notFound' => l10n.kernelProfileErrorNotFound,
    'incomplete' => l10n.kernelProfileErrorIncomplete,
    'io' => l10n.kernelProfileErrorIo,
    _ => l10n.kernelProfileErrorUnknown,
  };
  final List<String> lines = <String>[mapped];
  if (result.missing.isNotEmpty) {
    lines.add(l10n.kernelProfileMissingFields(result.missing.join(', ')));
  }
  final String detail = result.error.trim();
  if (detail.isNotEmpty) {
    lines.add(l10n.kernelProfileErrorDetail(detail));
  }
  return lines.join('\n');
}

/// 取 `offset.*` 前缀的字段，键去掉前缀后按原顺序返回，值转十六进制。
///
/// 入参是 `flattenHocon` 拍平后的表，因此偏移量键已带 `offset.` 前缀。
List<(String, String)> kernelProfileOffsetRows(Map<String, String> fields) {
  const String prefix = 'offset.';
  return <(String, String)>[
    for (final MapEntry<String, String> e in fields.entries)
      if (e.key.startsWith(prefix))
        (e.key.substring(prefix.length), kernelProfileHex(e.value)),
  ];
}

/// 十进制转 `0x` 十六进制；非数值原样返回。
///
/// 偏移量落盘后是负数（基址减物理内存起点），按 64 位补码展示。
String kernelProfileHex(String? value) {
  if (value == null || value.isEmpty) return '-';
  final int? parsed = int.tryParse(value);
  if (parsed == null) return value;
  final BigInt big = parsed < 0
      ? BigInt.from(parsed) + (BigInt.one << 64)
      : BigInt.from(parsed);
  return '0x${big.toRadixString(16).toUpperCase()}';
}
