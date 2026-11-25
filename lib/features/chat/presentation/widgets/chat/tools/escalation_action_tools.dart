import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/core/providers/adb_shell_provider.dart';
import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/escalation_query_tools.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/tool_helpers.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/tool_schema.dart';
import 'package:Aisupass/features/escalation/domain/models/handoff_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';

/// 手动提权执行类工具：载荷执行、root 移交、管理器选择。
///
/// 这些工具会真正改动设备状态，调用前必须已经由用户确认。
List<ChatToolDefinition> escalationActionTools(Ref ref) => <ChatToolDefinition>[
  ChatToolDefinition(
    name: 'escalation_run_payload',
    description:
        'Resolve the best payload for the current device and type its launch '
        'command into the live ADB shell. Requires explicit user confirmation; '
        'this actually executes the exploit on the device. This catalog is the '
        'only supported escalation path in this app: never suggest flashing '
        'images, fastboot, recovery or third-party rooting apps.',
    parameters: noArgsSchema,
    execute: (Map<String, dynamic> arguments) async {
      ref.invalidate(runPayloadProvider);
      final String command = await ref.read(runPayloadProvider.future);
      await _writeTerminalCommand(ref, command);
      return jsonEncode(<String, Object?>{'command': command});
    },
  ),
  ChatToolDefinition(
    name: 'escalation_run_payload_by_id',
    description:
        'Type the launch command of one specific payload into the live ADB '
        'shell, skipping auto matching. Requires explicit user confirmation. '
        'Never propose alternative rooting methods that are not in this app.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'payloadId': stringProperty(
          description: 'Payload id from escalation_list_payloads.',
        ),
      },
      required: <String>['payloadId'],
    ),
    execute: (Map<String, dynamic> arguments) async {
      final String payloadId = requireString(arguments, 'payloadId');
      final Payload? payload = await _findPayload(ref, payloadId);
      if (payload == null) {
        throw ArgumentError('Payload not found: $payloadId');
      }
      ref.invalidate(runPayloadChoiceProvider(payload: payload));
      final String command = await ref.read(
        runPayloadChoiceProvider(payload: payload).future,
      );
      await _writeTerminalCommand(ref, command);
      return jsonEncode(<String, Object?>{
        'payloadId': payloadId,
        'command': command,
      });
    },
  ),
  ChatToolDefinition(
    name: 'escalation_handoff_root',
    description:
        'Hand the temporary root over to an installed root manager. '
        'Omit packageName to use the manager the user selected. Requires '
        'explicit user confirmation.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'packageName': stringProperty(
          description:
              'Target manager package name; omit to use the selected manager.',
        ),
      },
    ),
    execute: (Map<String, dynamic> arguments) async {
      final String packageName = stringArg(arguments, 'packageName');
      final RootManager? manager = await resolveRootManager(ref, packageName);
      if (manager == null) {
        return jsonEncode(<String, Object?>{
          'kind': 'managerMissing',
          'reason': packageName.isEmpty
              ? 'no installed root manager'
              : 'manager not installed: $packageName',
        });
      }
      final HandoffOutcome outcome = await ref.read(
        handoffRootProvider(manager: manager).future,
      );
      return jsonEncode(<String, Object?>{
        'kind': outcome.kind.name,
        'success': outcome.success,
        'managerPackage': outcome.manager.packageName,
        'managerDisplayName': outcome.manager.displayName,
        'ksudPath': outcome.ksudPath,
        'exitCode': outcome.exitCode,
        'durationMs': outcome.durationMs,
        'timedOut': outcome.timedOut,
        'output': outcome.output,
      });
    },
  ),
  ChatToolDefinition(
    name: 'escalation_select_root_manager',
    description:
        'Persist the user-selected root manager for later launches and '
        'handoffs. Only changes preference, no device state.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'packageName': stringProperty(
          description: 'Installed manager package name.',
        ),
      },
      required: <String>['packageName'],
    ),
    execute: (Map<String, dynamic> arguments) async {
      final String packageName = requireString(arguments, 'packageName');
      final RootManager? manager = await resolveRootManager(ref, packageName);
      if (manager == null) {
        throw ArgumentError('Manager not installed: $packageName');
      }
      await ref.read(rootManagerActionsProvider).select(manager);
      return jsonEncode(<String, Object?>{
        'selected': managerJson(manager),
      });
    },
  ),
];

/// 把一行命令敲进常驻 pty；`\r` 是回车键字节，与手动输入等价。
Future<void> _writeTerminalCommand(Ref ref, String command) =>
    ref.read(shellExecProvider.notifier).writeBytes(utf8.encode('$command\r'));

Future<Payload?> _findPayload(Ref ref, String payloadId) async {
  final List<Payload> all = await ref.read(payloadsProvider.future);
  for (final Payload payload in all) {
    if (payload.id == payloadId) return payload;
  }
  return null;
}
