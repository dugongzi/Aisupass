import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/exploit_run_sessions.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/tool_helpers.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/tool_schema.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_preflight.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_run_defaults.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';

/// GhostKey（CVE-98260）工具：自检、偏好、启动与运行会话。
List<ChatToolDefinition> ghostKeyTools(Ref ref) {
  return <ChatToolDefinition>[
    ChatToolDefinition(
      name: 'ghost_key_preflight',
      description:
          'Run the GhostKey readiness preflight: ADB connection, shell uid, '
          'seccomp, kernel release, profile match and native binary presence.',
      parameters: noArgsSchema,
      execute: (Map<String, dynamic> arguments) async {
        final GhostKeyPreflight preflight = await ref.read(
          ghostKeyPreflightProvider.future,
        );
        return jsonEncode(<String, Object?>{
          'adbConnected': preflight.adbConnected,
          'shellUid': preflight.shellUid,
          'isShell': preflight.isShell,
          'isRoot': preflight.isRoot,
          'seccomp': preflight.seccomp,
          'seccompClean': preflight.seccompClean,
          'release': preflight.release,
          'profileMatched': preflight.profileMatched,
          'binaryPresent': preflight.binaryPresent,
        });
      },
    ),
    ChatToolDefinition(
      name: 'ghost_key_get_run_defaults',
      description:
          'Read the persisted GhostKey preference: whether to accept the '
          'fallback page offset. Root handoff always uses the selected manager.',
      parameters: noArgsSchema,
      execute: (Map<String, dynamic> arguments) async {
        final GhostKeyRunDefaults defaults = await ref.read(
          ghostKeyRunDefaultsProvider.future,
        );
        return jsonEncode(<String, Object?>{
          'acceptFallbackPageOffset': defaults.acceptFallbackPageOffset,
        });
      },
    ),
    ChatToolDefinition(
      name: 'ghost_key_save_run_defaults',
      description:
          'Persist the GhostKey preference. Only changes preferences, no device '
          'state and no run.',
      parameters: objectSchema(
        properties: <String, dynamic>{
          'acceptFallbackPageOffset': boolProperty(
            description: 'Accept calibrate-b fallback confidence.',
          ),
        },
        required: <String>['acceptFallbackPageOffset'],
      ),
      execute: (Map<String, dynamic> arguments) async {
        final GhostKeyRunDefaults current = await ref.read(
          ghostKeyRunDefaultsProvider.future,
        );
        final GhostKeyRunDefaults defaults = current.copyWith(
          acceptFallbackPageOffset: boolArg(
            arguments,
            'acceptFallbackPageOffset',
            fallback: current.acceptFallbackPageOffset,
          ),
        );
        await ref.read(ghostKeyActionsProvider).saveRunDefaults(defaults);
        return jsonEncode(<String, Object?>{
          'acceptFallbackPageOffset': defaults.acceptFallbackPageOffset,
        });
      },
    ),
    ChatToolDefinition(
      name: 'ghost_key_start',
      description:
          'Start one GhostKey run and return a session id immediately. Poll '
          'with ghost_key_status and stop with ghost_key_cancel. Requires '
          'explicit user confirmation.',
      parameters: objectSchema(
        properties: <String, dynamic>{
          'managerPackage': stringProperty(
            description:
                'Manager package for the KSU takeover; omit to use the '
                'selected manager.',
          ),
        },
      ),
      execute: (Map<String, dynamic> arguments) async {
        final String packageName = stringArg(arguments, 'managerPackage');
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
        final ExploitRunSession session = registry.create('ghost_key_start');
        session.cancel = ref.read(ghostKeyActionsProvider).cancel;
        session.subscription = ref
            .read(ghostKeyActionsProvider)
            .run(manager: manager)
            .listen(
              (GhostKeyOutcome outcome) {
                session.appendOutput(outcome.output);
                session.status = outcome.kind.name;
                session.finished = outcome.isFinal;
                session.exitCode = outcome.exitCode;
                session.durationMs = outcome.durationMs;
                session.timedOut = outcome.timedOut;
                session.failure = outcome.failure;
                session.reason = outcome.reason;
                session.fraction = outcome.fraction;
                session.log = outcome.log;
                session.stageStatuses = <String>[
                  for (final item in outcome.stageStatuses) item.name,
                ];
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
      name: 'ghost_key_status',
      description:
          'Read the latest snapshot of one GhostKey run session. Omit '
          'sessionId to read the most recent run.',
      parameters: objectSchema(
        properties: <String, dynamic>{
          'sessionId': stringProperty(
            description: 'Session id returned by ghost_key_start.',
          ),
        },
      ),
      execute: (Map<String, dynamic> arguments) async =>
          snapshotRunSession(ref, 'ghost_key_start', arguments),
    ),
    ChatToolDefinition(
      name: 'ghost_key_cancel',
      description:
          'Stop reading the current GhostKey run. Device-side processes are '
          'not signalled.',
      parameters: objectSchema(
        properties: <String, dynamic>{
          'sessionId': stringProperty(
            description: 'Session id returned by ghost_key_start.',
          ),
        },
      ),
      execute: (Map<String, dynamic> arguments) =>
          cancelRunSession(ref, 'ghost_key_start', arguments),
    ),
  ];
}
