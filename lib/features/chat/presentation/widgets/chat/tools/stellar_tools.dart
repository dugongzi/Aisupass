import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/core/models/stellar_service_status.dart';
import 'package:Aisupass/core/providers/stellar_exec_provider.dart';
import 'package:Aisupass/core/providers/stellar_service_provider.dart';
import 'package:Aisupass/core/utils/su_shell.dart';
import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/tool_schema.dart';
import 'package:Aisupass/generated/adb_shell.g.dart';

/// 回传给模型的单路输出上限；与 adb_tools.dart 同值，两条通道工具互不引用。
const int _maxOutputChars = 8000;

/// 默认超时与上限；模型给的超时统一夹在这个区间内。
const int _defaultTimeoutMs = 30000;
const int _maxTimeoutMs = 120000;

/// Stellar 通道自己的工具集。
///
/// 只读 [stellarServiceStatusProvider]，不认识也不引用 ADB 的任何状态。
/// 两条通道的工具集互不引用：本文件不 import adb_tools.dart，也不共享常量。
List<ChatToolDefinition> stellarTools(Ref ref) => <ChatToolDefinition>[
  ChatToolDefinition(
    name: 'stellar_service_status',
    description:
        'Read the status of the local Stellar privileged service: whether it '
        'is available, which uid it runs as, and the failure reason when it is '
        'not. The service is managed from the Stellar card on the home screen; '
        'it needs no pairing and no external app.',
    parameters: noArgsSchema,
    execute: (Map<String, dynamic> arguments) async {
      final StellarServiceStatus status = await _readStatus(ref);
      return jsonEncode(<String, Object?>{
        'available': status.available,
        'uid': status.uid,
        'state': status.reason,
        'next': status.available
            ? 'The Stellar service is ready. Call stellar_shell_exec to run '
                  'commands.'
            : 'The Stellar service is not running, so no command can run. Tell '
                  'the user to start it from the Stellar card on the home '
                  'screen, or to switch the command channel in Settings.',
        'forbidden':
            'Do not ask for a pairing code, do not suggest installing any app, '
            'do not simulate command output, and do not claim a command ran.',
      });
    },
  ),
  ChatToolDefinition(
    name: 'stellar_shell_exec',
    description:
        'Run one shell command through the local Stellar privileged service '
        '(uid 2000) and return exit code, stdout and stderr. Use this to '
        'actually inspect or operate the device. If it returns '
        'connected=false, the service is not running: tell the user to start '
        'it from the Stellar card on the home screen.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'command': stringProperty(
          description:
              'Shell command to run, e.g. "id", "ls -l /data/local/tmp".',
        ),
        'timeoutMs': intProperty(
          description: 'Timeout in milliseconds. Defaults to $_defaultTimeoutMs.',
          minimum: 1000,
          maximum: _maxTimeoutMs,
        ),
      },
      required: <String>['command'],
    ),
    execute: (Map<String, dynamic> arguments) async {
      final String command = requireString(arguments, 'command');
      final int timeoutMs = _clampTimeout(
        intArg(arguments, 'timeoutMs', fallback: _defaultTimeoutMs)!,
      );

      final StellarServiceStatus status = await _readStatus(ref);
      if (!status.available) {
        return jsonEncode(<String, Object?>{
          'connected': false,
          'uid': status.uid,
          'exitCode': -1,
          'stdout': '',
          'stderr': '',
          'timedOut': false,
          'state': status.reason,
          'next':
              'The Stellar service is not running. Tell the user to open the '
              'Stellar card on the home screen and tap the start button, then '
              'retry this command.',
          'forbidden':
              'Do not ask for a pairing code, do not suggest installing any '
              'app, do not simulate output, and do not claim a command ran.',
        });
      }

      final ShellExec exec = ref.read(stellarShellExecProvider);
      final ShellExecResult result = await exec(command, timeoutMs);
      return jsonEncode(<String, Object?>{
        'connected': true,
        'uid': status.uid,
        'exitCode': result.exitCode,
        'stdout': _truncate(result.stdout),
        'stderr': _truncate(result.stderr),
        'durationMs': result.durationMs,
        'timedOut': result.timedOut,
      });
    },
  ),
];

/// 连接态不是推送式的，先失效再读，拿到的是当下探测结论。
Future<StellarServiceStatus> _readStatus(Ref ref) {
  ref.invalidate(stellarServiceStatusProvider);
  return ref.read(stellarServiceStatusProvider.future);
}

int _clampTimeout(int value) {
  if (value < 1000) return 1000;
  return value > _maxTimeoutMs ? _maxTimeoutMs : value;
}

/// 超长输出保留尾部：命令失败的线索通常落在最后几行。
String _truncate(String text) {
  if (text.length <= _maxOutputChars) return text;
  final int cut = text.length - _maxOutputChars;
  return '[truncated $cut chars]\n${text.substring(cut)}';
}
