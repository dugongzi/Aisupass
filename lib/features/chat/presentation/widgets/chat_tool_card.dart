import 'dart:convert';

import 'package:Aisupass/common/widgets/app_data_table.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/providers/device_info_provider.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/chat/domain/models/chat_turn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 展开后正文的最大行数，超出部分折叠。
const int _maxBodyLines = 12;

/// 单次工具调用的一行步骤。
///
/// 参考主流 Agent 的呈现方式：默认只有一行图标 + 动作短语 + 耗时，
/// 不填充、不描边、不用彩色标题；需要细节时再展开等宽正文。
class ChatToolCard extends HookWidget {
  const ChatToolCard({super.key, required this.call, this.indent = false});

  final ChatToolCall call;

  /// 是否作为多工具合并组的子项缩进显示。
  final bool indent;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;
    final ValueNotifier<bool> expanded = useState(false);

    final bool failed = call.status == ChatToolStatus.failed;
    final Color tint = failed ? colors.error : colors.onSurfaceVariant;
    final Color muted = colors.onSurfaceVariant.withValues(alpha: 0.6);

    final String arguments = call.argumentsJson.trim();
    final bool hasArguments =
        arguments.isNotEmpty && arguments != '{}' && arguments != 'null';
    final String result = call.result.trim();
    final String error = (call.error ?? '').trim();
    final bool hasBody =
        hasArguments || result.isNotEmpty || error.isNotEmpty;

    final Widget row = InkWell(
      onTap: hasBody ? () => expanded.value = !expanded.value : null,
      borderRadius: BorderRadius.circular(isDesktop ? 6 : 6.r),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: isDesktop ? 5 : 5.h,
          horizontal: isDesktop ? 2 : 2.w,
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: isDesktop ? 16 : 16.w,
              height: isDesktop ? 16 : 16.w,
              child: Center(child: _StatusMark(status: call.status, tint: tint)),
            ),
            SizedBox(width: isDesktop ? 8 : 8.w),
            Expanded(
              child: Text(
                _toolLabel(context, call.name),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isDesktop ? 12.5 : 12.5.sp,
                  height: 1.3,
                  color: tint,
                ),
              ),
            ),
            if (call.duration != null)
              Text(
                formatToolDuration(call.duration!),
                style: TextStyle(
                  fontSize: isDesktop ? 10.5 : 10.5.sp,
                  fontFamily: 'monospace',
                  color: muted,
                ),
              ),
            SizedBox(width: isDesktop ? 4 : 4.w),
            SizedBox(
              width: isDesktop ? 15 : 15.w,
              height: isDesktop ? 15 : 15.w,
              child: hasBody
                  ? Icon(
                      expanded.value
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      size: isDesktop ? 15 : 15.sp,
                      color: muted,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.only(
        left: indent ? (isDesktop ? 10 : 10.w) : 0,
        bottom: isDesktop ? 2 : 2.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          row,
          if (expanded.value && hasBody)
            _ToolBody(
              arguments: hasArguments ? arguments : '',
              result: result,
              error: error,
              rows: hasArguments ? null : _resultRows(context, call),
            ),
        ],
      ),
    );
  }
}

/// 同一轮次内的多个工具调用合并成一行，默认折叠。
class ChatToolGroup extends HookWidget {
  const ChatToolGroup({super.key, required this.calls});

  final List<ChatToolCall> calls;

  @override
  Widget build(BuildContext context) {
    if (calls.isEmpty) return const SizedBox.shrink();
    if (calls.length == 1) return ChatToolCard(call: calls.first);

    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;
    final ValueNotifier<bool> expanded = useState(false);

    final bool anyRunning = calls.any(
      (ChatToolCall call) => call.status == ChatToolStatus.running,
    );
    final bool anyFailed = calls.any(
      (ChatToolCall call) => call.status == ChatToolStatus.failed,
    );
    final Color tint = anyFailed ? colors.error : colors.onSurfaceVariant;
    final Color muted = colors.onSurfaceVariant.withValues(alpha: 0.6);

    Duration? total;
    for (final ChatToolCall call in calls) {
      if (call.duration != null) total = (total ?? Duration.zero) + call.duration!;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: isDesktop ? 2 : 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InkWell(
            onTap: () => expanded.value = !expanded.value,
            borderRadius: BorderRadius.circular(isDesktop ? 6 : 6.r),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: isDesktop ? 5 : 5.h,
                horizontal: isDesktop ? 2 : 2.w,
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: isDesktop ? 16 : 16.w,
                    height: isDesktop ? 16 : 16.w,
                    child: Center(
                      child: _StatusMark(
                        status: anyRunning
                            ? ChatToolStatus.running
                            : (anyFailed
                                  ? ChatToolStatus.failed
                                  : ChatToolStatus.succeeded),
                        tint: tint,
                      ),
                    ),
                  ),
                  SizedBox(width: isDesktop ? 8 : 8.w),
                  Expanded(
                    child: Text(
                      context.l10n.chatToolGroupSummary(calls.length),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isDesktop ? 12.5 : 12.5.sp,
                        height: 1.3,
                        color: tint,
                      ),
                    ),
                  ),
                  if (total != null)
                    Text(
                      formatToolDuration(total),
                      style: TextStyle(
                        fontSize: isDesktop ? 10.5 : 10.5.sp,
                        fontFamily: 'monospace',
                        color: muted,
                      ),
                    ),
                  SizedBox(width: isDesktop ? 4 : 4.w),
                  SizedBox(
                    width: isDesktop ? 15 : 15.w,
                    height: isDesktop ? 15 : 15.w,
                    child: Icon(
                      expanded.value
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      size: isDesktop ? 15 : 15.sp,
                      color: muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (expanded.value)
            for (final ChatToolCall call in calls)
              ChatToolCard(call: call, indent: true),
        ],
      ),
    );
  }
}

/// 工具动作短语：已知工具走本地化文案，未知工具回退到原始工具名。
String _toolLabel(BuildContext context, String name) {
  return switch (name) {
    'get_device_info' => context.l10n.chatToolReadDevice,
    'get_root_status' => context.l10n.chatToolCheckRoot,
    'get_adb_status' => context.l10n.chatToolCheckAdb,
    _ => name.isEmpty ? context.l10n.chatToolRunning : name,
  };
}

/// 耗时展示：不足 1s 用毫秒，其余用秒。
String formatToolDuration(Duration duration) {
  final int ms = duration.inMilliseconds;
  if (ms < 1000) return '${ms}ms';
  final double seconds = ms / 1000;
  return '${seconds.toStringAsFixed(seconds >= 10 ? 0 : 1)}s';
}

/// 把工具结果解析成表格行。
///
/// 只接受「全部键都能映射到设备字段」的扁平 JSON，其余情况返回 null，
/// 由调用方回退到等宽正文，避免把内部字段名直接暴露给用户。
List<AppDataRow>? _resultRows(BuildContext context, ChatToolCall call) {
  if (call.status != ChatToolStatus.succeeded) return null;
  final String raw = call.result.trim();
  if (!raw.startsWith('{')) return null;

  final Object? decoded;
  try {
    decoded = jsonDecode(raw);
  } on FormatException {
    return null;
  }
  if (decoded is! Map) return null;

  final List<AppDataRow> rows = <AppDataRow>[];
  for (final MapEntry<dynamic, dynamic> entry in decoded.entries) {
    final DeviceInfoField? field = _parseField('${entry.key}');
    if (field == null) return null;
    rows.add(
      AppDataRow(
        label: _fieldLabel(context, field),
        value: '${entry.value}',
      ),
    );
  }
  return rows.isEmpty ? null : rows;
}

DeviceInfoField? _parseField(String key) {
  for (final DeviceInfoField field in DeviceInfoField.values) {
    if (field.name == key) return field;
  }
  return null;
}

/// 设备字段的中文/英文标题。
String _fieldLabel(BuildContext context, DeviceInfoField field) {
  return switch (field) {
    DeviceInfoField.selinuxStatus => context.l10n.deviceSelinux,
    DeviceInfoField.deviceModel => context.l10n.deviceModel,
    DeviceInfoField.osVersion => context.l10n.deviceOsVersion,
    DeviceInfoField.kernelVersion => context.l10n.deviceKernelVersion,
    DeviceInfoField.securityPatch => context.l10n.deviceSecurityPatch,
    DeviceInfoField.baseband => context.l10n.deviceBaseband,
    DeviceInfoField.buildNumber => context.l10n.deviceBuildNumber,
    DeviceInfoField.sotaVersion => context.l10n.deviceSotaVersion,
    DeviceInfoField.apiLevel => context.l10n.deviceApiLevel,
    DeviceInfoField.cpuAbi => context.l10n.deviceCpuAbi,
    DeviceInfoField.appVersion => context.l10n.deviceAppVersion,
  };
}

/// 状态标记：执行中转圈，成功打勾，失败提示。
class _StatusMark extends StatelessWidget {
  const _StatusMark({required this.status, required this.tint});

  final ChatToolStatus status;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDesktopPlatform;
    if (status == ChatToolStatus.running) {
      return SizedBox(
        width: isDesktop ? 12 : 12.w,
        height: isDesktop ? 12 : 12.w,
        child: CircularProgressIndicator(strokeWidth: 1.6, color: tint),
      );
    }
    return Icon(
      status == ChatToolStatus.succeeded
          ? Icons.check_rounded
          : Icons.close_rounded,
      size: isDesktop ? 15 : 15.sp,
      color: tint,
    );
  }
}

/// 展开后的正文：结构化结果走表格，其余走等宽文本。
class _ToolBody extends HookWidget {
  const _ToolBody({
    required this.arguments,
    required this.result,
    required this.error,
    this.rows,
  });

  final String arguments;
  final String result;
  final String error;

  /// 已解析成表格的结果；为空时按等宽文本渲染。
  final List<AppDataRow>? rows;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;
    final ValueNotifier<bool> showAll = useState(false);
    final double fontSize = isDesktop ? 11.5 : 11.5.sp;

    Future<void> copy(String text) async {
      await Clipboard.setData(ClipboardData(text: text));
      if (!context.mounted) return;
      ToastMessage.success(context.l10n.chatCopied);
    }

    final Widget content;
    final String copyText;

    if (rows != null) {
      content = AppDataTable(
        rows: rows!,
        onCopy: (AppDataRow row) => copy('${row.label}: ${row.value}'),
      );
      copyText = rows!
          .map((AppDataRow row) => '${row.label}: ${row.value}')
          .join('\n');
    } else {
      final List<String> blocks = <String>[
        if (arguments.isNotEmpty) arguments,
        if (result.isNotEmpty) result,
        if (error.isNotEmpty) error,
      ];
      final String fullText = blocks.join('\n\n');
      final List<String> lines = fullText.split('\n');
      final bool overflowing = lines.length > _maxBodyLines;
      final String visible = overflowing && !showAll.value
          ? lines.take(_maxBodyLines).join('\n')
          : fullText;

      final TextStyle style = TextStyle(
        fontSize: fontSize,
        height: 1.5,
        fontFamily: 'monospace',
        color: error.isNotEmpty && result.isEmpty && arguments.isEmpty
            ? colors.error
            : colors.onSurface.withValues(alpha: 0.82),
      );

      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SelectableText(visible, style: style),
          if (overflowing)
            Padding(
              padding: EdgeInsets.only(top: isDesktop ? 2 : 2.h),
              child: InkWell(
                onTap: () => showAll.value = !showAll.value,
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: isDesktop ? 2 : 2.h,
                  ),
                  child: Text(
                    showAll.value
                        ? context.l10n.chatToolCollapse
                        : context.l10n.chatToolMoreLines(lines.length),
                    style: TextStyle(
                      fontSize: isDesktop ? 11 : 11.sp,
                      color: colors.primary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
      copyText = fullText;
    }

    return Container(
      margin: EdgeInsets.only(
        left: isDesktop ? 8 : 8.w,
        bottom: isDesktop ? 4 : 4.h,
      ),
      padding: EdgeInsets.only(
        left: isDesktop ? 10 : 10.w,
        top: isDesktop ? 2 : 2.h,
        bottom: isDesktop ? 2 : 2.h,
      ),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: colors.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(child: content),
          IconButton(
            onPressed: () => copy(copyText),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(
              width: 24,
              height: 24,
            ),
            iconSize: isDesktop ? 14 : 14.sp,
            color: colors.onSurfaceVariant.withValues(alpha: 0.7),
            icon: const Icon(Icons.copy_rounded),
          ),
        ],
      ),
    );
  }
}
