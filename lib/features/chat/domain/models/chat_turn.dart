import 'package:meta/meta.dart';

/// 对话角色。工具结果不单独成条，挂在发起调用的 assistant 轮次上。
enum ChatRole { user, assistant }

/// 单次工具调用的执行状态。
enum ChatToolStatus { running, succeeded, failed }

/// 对话轮次上的非错误提示，文案由 UI 侧按语言映射。
enum ChatNotice { toolCallLimit, emptyReply }

/// 一次模型调用的 token 用量。
///
/// 工具续跑会产生多次调用，展示时按段累加。
@immutable
class ChatUsage {
  const ChatUsage({this.promptTokens = 0, this.completionTokens = 0});

  final int promptTokens;
  final int completionTokens;

  int get totalTokens => promptTokens + completionTokens;

  bool get isEmpty => totalTokens <= 0;

  ChatUsage operator +(ChatUsage other) {
    return ChatUsage(
      promptTokens: promptTokens + other.promptTokens,
      completionTokens: completionTokens + other.completionTokens,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (promptTokens > 0) 'promptTokens': promptTokens,
      if (completionTokens > 0) 'completionTokens': completionTokens,
    };
  }

  factory ChatUsage.fromJson(Map<String, dynamic> json) {
    return ChatUsage(
      promptTokens: (json['promptTokens'] as num?)?.toInt() ?? 0,
      completionTokens: (json['completionTokens'] as num?)?.toInt() ?? 0,
    );
  }
}

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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'callId': callId,
      'name': name,
      'argumentsJson': argumentsJson,
      'status': status.name,
      'result': result,
      if (error != null) 'error': error,
      if (duration != null) 'durationMs': duration!.inMilliseconds,
    };
  }

  factory ChatToolCall.fromJson(Map<String, dynamic> json) {
    final int? durationMs = json['durationMs'] as int?;
    return ChatToolCall(
      callId: json['callId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      argumentsJson: json['argumentsJson'] as String? ?? '',
      status: ChatToolStatus.values.firstWhere(
        (ChatToolStatus item) => item.name == json['status'],
        orElse: () => ChatToolStatus.succeeded,
      ),
      result: json['result'] as String? ?? '',
      error: json['error'] as String?,
      duration: durationMs == null
          ? null
          : Duration(milliseconds: durationMs),
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
    this.createdAt,
    this.duration,
    this.usage,
  });

  final String id;
  final ChatRole role;
  final String text;
  final String reasoning;
  final List<ChatToolCall> toolCalls;
  final bool streaming;
  final String? error;
  final ChatNotice? notice;

  /// 轮次创建时间，用于在回答末尾展示时刻。
  final DateTime? createdAt;

  /// 本轮模型调用的总耗时。
  final Duration? duration;

  /// 本轮模型调用的 token 用量。
  final ChatUsage? usage;

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
    DateTime? createdAt,
    Duration? duration,
    ChatUsage? usage,
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
      createdAt: createdAt ?? this.createdAt,
      duration: duration ?? this.duration,
      usage: usage ?? this.usage,
    );
  }

  /// 落盘时不保存流式标记，重载后一律视为已完成。
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'role': role.name,
      'text': text,
      if (reasoning.isNotEmpty) 'reasoning': reasoning,
      if (toolCalls.isNotEmpty)
        'toolCalls': toolCalls
            .map((ChatToolCall call) => call.toJson())
            .toList(growable: false),
      if (error != null) 'error': error,
      if (notice != null) 'notice': notice!.name,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (duration != null) 'durationMs': duration!.inMilliseconds,
      if (usage != null && !usage!.isEmpty) 'usage': usage!.toJson(),
    };
  }

  factory ChatTurn.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawCalls =
        json['toolCalls'] as List<dynamic>? ?? const <dynamic>[];
    final String? noticeName = json['notice'] as String?;
    final int? durationMs = (json['durationMs'] as num?)?.toInt();
    final Object? rawUsage = json['usage'];
    return ChatTurn(
      id: json['id'] as String? ?? '',
      role: ChatRole.values.firstWhere(
        (ChatRole item) => item.name == json['role'],
        orElse: () => ChatRole.assistant,
      ),
      text: json['text'] as String? ?? '',
      reasoning: json['reasoning'] as String? ?? '',
      toolCalls: rawCalls
          .whereType<Map<dynamic, dynamic>>()
          .map((Map<dynamic, dynamic> item) =>
              ChatToolCall.fromJson(Map<String, dynamic>.from(item)))
          .toList(growable: false),
      error: json['error'] as String?,
      notice: noticeName == null
          ? null
          : ChatNotice.values.firstWhere(
              (ChatNotice item) => item.name == noticeName,
              orElse: () => ChatNotice.emptyReply,
            ),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
      duration: durationMs == null
          ? null
          : Duration(milliseconds: durationMs),
      usage: rawUsage is Map
          ? ChatUsage.fromJson(Map<String, dynamic>.from(rawUsage))
          : null,
    );
  }
}
