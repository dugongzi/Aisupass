import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/tool_schema.dart';
import 'package:Aisupass/features/escalation/domain/models/device_identity.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:Aisupass/features/escalation/domain/models/payload_match.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';

/// 设备身份、载荷清单与 root 管理器相关工具。
List<ChatToolDefinition> escalationQueryTools(Ref ref) => <ChatToolDefinition>[
  ChatToolDefinition(
    name: 'escalation_get_device_identity',
    description:
        'Read the device identity used by payload matching: manufacturer, '
        'model, kernel release/version/commit, kernel series and page size.',
    parameters: noArgsSchema,
    execute: (Map<String, dynamic> arguments) async {
      final DeviceIdentity identity = await ref.read(
        currentDeviceIdentityProvider.future,
      );
      return jsonEncode(<String, Object?>{
        'identityText': identity.identityText,
        'manufacturer': identity.manufacturer,
        'model': identity.model,
        'kernelRelease': identity.kernelRelease,
        'kernelVersion': identity.kernelVersion,
        'kernelCommit': identity.kernelCommit,
        'kernelSeries': identity.kernelSeries,
        'kernelUnknown': identity.kernelUnknown,
        'pageSize': identity.pageSize,
      });
    },
  ),
  ChatToolDefinition(
    name: 'escalation_list_payloads',
    description:
        'List exploit payloads shipped in the app catalog. Optional vendor '
        'filters by vendor name (for example vivo, xiaomi, google).',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'vendor': stringProperty(
          description: 'Optional vendor filter, case-insensitive.',
        ),
        'limit': intProperty(
          description: 'Maximum number of entries to return, default 50.',
          minimum: 1,
          maximum: 200,
        ),
      },
    ),
    execute: (Map<String, dynamic> arguments) async {
      final String vendor = stringArg(arguments, 'vendor').toLowerCase();
      final int limit = intArg(arguments, 'limit', fallback: 50) ?? 50;
      final List<Payload> all = await ref.read(payloadsProvider.future);
      final List<Payload> filtered = vendor.isEmpty
          ? all
          : all
                .where(
                  (Payload payload) => payload.vendor.toLowerCase() == vendor,
                )
                .toList(growable: false);
      return jsonEncode(<String, Object?>{
        'total': filtered.length,
        'items': <Map<String, Object?>>[
          for (final Payload payload in filtered.take(limit))
            payloadJson(payload),
        ],
      });
    },
  ),
  ChatToolDefinition(
    name: 'escalation_resolve_payload',
    description:
        'Auto-select the best payload for the current device. Returns null in '
        'match when no candidate exists. Set allowVendorFallback=true only '
        'when a degraded same-vendor candidate is acceptable.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'allowVendorFallback': boolProperty(
          description: 'Allow same-vendor fallback when model does not match.',
        ),
      },
    ),
    execute: (Map<String, dynamic> arguments) async {
      final bool allowVendorFallback = boolArg(
        arguments,
        'allowVendorFallback',
        fallback: false,
      );
      final PayloadMatch? match = await ref.read(
        resolvedPayloadProvider(
          allowVendorFallback: allowVendorFallback,
        ).future,
      );
      return jsonEncode(<String, Object?>{
        'match': match == null
            ? null
            : <String, Object?>{
                'tier': match.tier.name,
                'isDegraded': match.isDegraded,
                'payload': payloadJson(match.payload),
              },
      });
    },
  ),
  ChatToolDefinition(
    name: 'escalation_list_root_managers',
    description:
        'List root managers actually installed on the device. '
        'Each entry can be handed off to after a temporary root is obtained.',
    parameters: noArgsSchema,
    execute: (Map<String, dynamic> arguments) async {
      final List<RootManager> managers = await ref.read(
        installedRootManagersProvider.future,
      );
      return jsonEncode(<String, Object?>{
        'items': <Map<String, Object?>>[
          for (final RootManager manager in managers) managerJson(manager),
        ],
      });
    },
  ),
  ChatToolDefinition(
    name: 'escalation_get_selected_root_manager',
    description:
        'Read the root manager selected by the user. Returns null when no '
        'manager is installed.',
    parameters: noArgsSchema,
    execute: (Map<String, dynamic> arguments) async {
      final RootManager? manager = await ref.read(
        selectedRootManagerProvider.future,
      );
      return jsonEncode(<String, Object?>{
        'manager': manager == null ? null : managerJson(manager),
      });
    },
  ),
];

Map<String, Object?> payloadJson(Payload payload) => <String, Object?>{
  'id': payload.id,
  'library': payload.library,
  'vendor': payload.vendor,
  'displayName': payload.displayName,
  'models': payload.models,
  'kernelUnknown': payload.kernelUnknown,
  'kernelVersion': payload.kernelVersion,
  'kernelSeries': payload.kernelSeries,
  'kernelAgnostic': payload.kernelAgnostic,
  'kernelCommits': payload.kernelCommits,
  'buildId': payload.buildId,
  'size': payload.size,
  'sha256': payload.sha256,
  'standalone': payload.standalone,
  'command': payload.command,
  'source': payload.source,
};

Map<String, Object?> managerJson(RootManager manager) => <String, Object?>{
  'packageName': manager.packageName,
  'displayName': manager.displayName,
  'homeUrl': manager.homeUrl,
};
