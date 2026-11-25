import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/core/models/stellar_service_status.dart';
import 'package:Aisupass/core/providers/stellar_service_provider.dart';
import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/tool_schema.dart';

/// Stellar 通道自己的工具集。
///
/// 只读 [stellarServiceStatusProvider]，不认识也不引用 ADB 的任何状态。
/// 服务端接入后在这里追加执行类工具，ADB 侧工具不受影响。
List<ChatToolDefinition> stellarTools(Ref ref) => <ChatToolDefinition>[
  ChatToolDefinition(
    name: 'stellar_service_status',
    description:
        'Read the status of the Stellar privileged service: whether it is '
        'available, which uid it runs as, and the failure reason when it is '
        'not. This is the only Stellar tool in this build; when the service is '
        'not available there is no way to run commands on the Stellar channel, '
        'so report that plainly and let the user decide whether to switch the '
        'command channel in Settings.',
    parameters: noArgsSchema,
    execute: (Map<String, dynamic> arguments) async {
      final StellarServiceStatus status = await ref.read(
        stellarServiceStatusProvider.future,
      );
      return jsonEncode(<String, Object?>{
        'available': status.available,
        'uid': status.uid,
        'state': status.reason,
        'next': status.available
            ? 'The Stellar service is ready. Command execution tools are not '
                  'part of this build yet; tell the user the service is up.'
            : 'The Stellar service is not available, so no command can run on '
                  'this channel. Tell the user they can switch the command '
                  'channel in Settings.',
        'forbidden':
            'Do not ask for a pairing code, do not suggest installing any app, '
            'do not simulate command output, and do not claim a command ran.',
      });
    },
  ),
];
