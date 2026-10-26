import 'package:meta/meta.dart';

/// 对话角色。工具结果不单独成条，挂在发起调用的 assistant 轮次上。
enum ChatRole { user, assistant }

/// 单次工具调用的执行状态。
enum ChatToolStatus { running, succeeded, failed }

/// 对话轮次上的非错误提示，文案由 UI 侧按语言映射。
enum ChatNotice { toolCallLimit, emptyReply }

/// 一次工具调用及其执行结果。
@immutable
class ChatToolCall {
  const ChatToolCall({
    required this.callId,
    required this.name,
    this.argumentsJson = '',
    this.status = ChatToolStatus.running,
    this.result = '',
    this.error,
    this.duration,
  });

  final String callId;
  final String name;
  final String argumentsJson;
  final ChatToolStatus status;
  final String result;
  final String? error;
  final Duration? duration;

  ChatToolCall copyWith({
    String? callId,
    String? name,
    String? argumentsJson,
    ChatToolStatus? status,
    String? result,
    String? error,
    Duration? duration,
  }) {
    return ChatToolCall(
      callId: callId ?? this.callId,
      name: name ?? this.name,
      argumentsJson: argumentsJson ?? this.argumentsJson,
      status: status ?? this.status,
      result: result ?? this.result,
      error: error ?? this.error,
      duration: duration ?? this.duration,
    );
  }
}

/// 一条对话消息。assistant 消息由正文、思考过程与工具调用组成。
@immutable
class ChatTurn {
  const ChatTurn({
    required this.id,
    required this.role,
    this.text = '',
    this.reasoning = '',
    this.toolCalls = const <ChatToolCall>[],
    this.streaming = false,
    this.error,
    this.notice,
  });

  final String id;
  final ChatRole role;
  final String text;
  final String reasoning;
  final List<ChatToolCall> toolCalls;
  final bool streaming;
  final String? error;
  final ChatNotice? notice;

  bool get isUser => role == ChatRole.user;

  /// 是否包含可发送给模型的有效内容。
  bool get hasPayload => text.trim().isNotEmpty || toolCalls.isNotEmpty;

  ChatTurn copyWith({
    String? id,
    ChatRole? role,
    String? text,
    String? reasoning,
    List<ChatToolCall>? toolCalls,
    bool? streaming,
    String? error,
    ChatNotice? notice,
  }) {
    return ChatTurn(
      id: id ?? this.id,
      role: role ?? this.role,
      text: text ?? this.text,
      reasoning: reasoning ?? this.reasoning,
      toolCalls: toolCalls ?? this.toolCalls,
      streaming: streaming ?? this.streaming,
      error: error ?? this.error,
      notice: notice ?? this.notice,
    );
  }
}
