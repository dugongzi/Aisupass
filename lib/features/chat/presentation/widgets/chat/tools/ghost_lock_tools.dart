import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/exploit_run_sessions.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/tool_helpers.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/tool_schema.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_preflight.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';

/// GhostLock 工具：自检、启动与运行会话。
List<ChatToolDefinition> ghostLockTools(Ref ref) {
  return <ChatToolDefinition>[
    ChatToolDefinition(
      name: 'ghost_lock_preflight',
      description:
          'Run the GhostLock readiness preflight: ADB, shell uid, seccomp, '
          'kernel release, matched profile release and route, native binary, '
          'ksud path and profile encoding error.',
      parameters: noArgsSchema,
      execute: (Map<String, dynamic> arguments) async {
        final GhostLockPreflight preflight = await ref.read(
          ghostLockPreflightProvider.future,
        );
        return jsonEncode(<String, Object?>{
          'adbConnected': preflight.adbConnected,
          'shellUid': preflight.shellUid,
          'seccomp': preflight.seccomp,
          'release': preflight.release,
          'profileRelease': preflight.profileRelease,
          'profileMatched': preflight.profileMatched,
          'route': preflight.route,
          'binaryPresent': preflight.binaryPresent,
          'ksudPath': preflight.ksudPath,
          'profileError': preflight.profileError,
        });
      },
    ),
    ChatToolDefinition(
      name: 'ghost_lock_start',
      description:
          'Start one GhostLock run and return a session id immediately. Poll '
          'with ghost_lock_status and stop with ghost_lock_cancel. Requires '
          'explicit user confirmation.',
      parameters: objectSchema(
        properties: <String, dynamic>{
          'managerPackage': stringProperty(
            description:
                'Manager package used to locate its bundled ksud; omit to use '
                'the selected manager.',
          ),
          'safeMode': boolProperty(
            description:
                'Disable /data/adb modules before running (meta.safe_mode).',
          ),
        },
      ),
      execute: (Map<String, dynamic> arguments) async {
        final String packageName = stringArg(arguments, 'managerPackage');
        final bool safeMode = boolArg(arguments, 'safeMode', fallback: false);
        RootManager? manager;
        if (packageName.isNotEmpty) {
          manager = await resolveRootManager(ref, packageName);
          if (manager == null) {
            throw ArgumentError('Manager not installed: $packageName');
          }
        } else {
          manager = await ref.read(selectedRootManagerProvider.future);
        }

        final ExploitRunRegistry registry = ref.read(
          exploitRunRegistryProvider,
        );
        final ExploitRunSession session = registry.create('ghost_lock_start');
        session.cancel = ref.read(ghostLockActionsProvider).cancel;
        session.subscription = ref
            .read(ghostLockActionsProvider)
            .run(manager: manager, safeMode: safeMode)
            .listen(
              (GhostLockOutcome outcome) {
                session.appendOutput(outcome.output);
                session.status = outcome.kind.name;
                session.finished = outcome.isFinal;
                session.exitCode = outcome.exitCode;
                session.durationMs = outcome.durationMs;
                session.timedOut = outcome.timedOut;
                session.reason = outcome.reason;
                session.failure = outcome.failure;
                session.log = outcome.log;
              },
              onError: (Object error, StackTrace stackTrace) {
                session.status = 'failed';
                session.failure = '$error';
                session.finished = true;
              },
            );
        await Future<void>.delayed(const Duration(milliseconds: 300));
        return jsonEncode(session.toJson());
      },
    ),
    ChatToolDefinition(
      name: 'ghost_lock_status',
      description:
          'Read the latest snapshot of one GhostLock run session. Omit '
          'sessionId to read the most recent run.',
      parameters: objectSchema(
        properties: <String, dynamic>{
          'sessionId': stringProperty(
            description: 'Session id returned by ghost_lock_start.',
          ),
        },
      ),
      execute: (Map<String, dynamic> arguments) async =>
          snapshotRunSession(ref, 'ghost_lock_start', arguments),
    ),
    ChatToolDefinition(
      name: 'ghost_lock_cancel',
      description:
          'Stop reading the current GhostLock run. Device-side processes are '
          'not signalled.',
      parameters: objectSchema(
        properties: <String, dynamic>{
          'sessionId': stringProperty(
            description: 'Session id returned by ghost_lock_start.',
          ),
        },
      ),
      execute: (Map<String, dynamic> arguments) =>
          cancelRunSession(ref, 'ghost_lock_start', arguments),
    ),
  ];
}
