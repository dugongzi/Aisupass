import 'dart:convert';

import 'package:Aisupass/features/chat/domain/enums/chat_tool_status.dart';
import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/domain/models/chat_tool_call.dart';

/// 一轮内的工具调用执行。
///
/// 顺序执行、逐条回填，把「调用 → 结果」的时序与耗时收敛在一处，
/// 供 [ChatStreamSession] 在多轮推进中复用。
class ChatToolSession {
  const ChatToolSession();

  /// 依次执行 [calls]；每条结果通过 [onUpdated] 按位置回填。
  ///
  /// 返回是否有工具声明了「必须等用户操作」：判定直接用刚算出来的结果串，
  /// 不再回头翻轮次里的副本，避免回填与判定的时序差导致漏判。
  ///
  /// [isCancelled] 返回 true 时立即停止后续调用。
  Future<bool> execute({
    required List<ChatToolCall> calls,
    required List<ChatToolDefinition> tools,
    required bool Function() isCancelled,
    required void Function(int position, ChatToolCall call) onUpdated,
  }) async {
    bool awaitsUser = false;
    for (int i = 0; i < calls.length; i += 1) {
      if (isCancelled()) return awaitsUser;
      final ChatToolCall call = calls[i];
      final Stopwatch watch = Stopwatch()..start();

      ChatToolDefinition? definition;
      for (final ChatToolDefinition item in tools) {
        if (item.name == call.name) {
          definition = item;
          break;
        }
      }

      late final ChatToolCall updated;
      if (definition == null) {
        watch.stop();
        updated = call.copyWith(
          status: ChatToolStatus.failed,
          error: 'Unknown tool: ${call.name}',
          duration: watch.elapsed,
        );
      } else {
        try {
          final String result = await definition.execute(
            _decodeArguments(call.argumentsJson),
          );
          watch.stop();
          updated = call.copyWith(
            status: ChatToolStatus.succeeded,
            result: result,
            duration: watch.elapsed,
          );
          if (_declaresAwaitsUser(result)) awaitsUser = true;
        } catch (error) {
          watch.stop();
          updated = call.copyWith(
            status: ChatToolStatus.failed,
            error: error.toString(),
            duration: watch.elapsed,
          );
        }
      }

      onUpdated(i, updated);
    }
    return awaitsUser;
  }

  /// 结果里是否带 `awaitsUser: true`。
  bool _declaresAwaitsUser(String result) {
    final String text = result.trim();
    if (!text.startsWith('{')) return false;
    try {
      final Object? decoded = jsonDecode(text);
      return decoded is Map && decoded['awaitsUser'] == true;
    } on FormatException {
      return false;
    }
  }

  /// 参数 JSON 必须是对象；空串与非法内容统一退化成空表。
  Map<String, dynamic> _decodeArguments(String raw) {
    final String text = raw.trim();
    if (text.isEmpty) return <String, dynamic>{};
    try {
      final Object? decoded = jsonDecode(text);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } on FormatException {
      return <String, dynamic>{};
    }
    return <String, dynamic>{};
  }
}
