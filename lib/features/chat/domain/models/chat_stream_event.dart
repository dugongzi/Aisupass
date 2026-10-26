import 'package:meta/meta.dart';

/// 对话流式事件。数据源负责把三家协议统一成同一套事件。
@immutable
sealed class ChatStreamEvent {
  const ChatStreamEvent();
}

/// 请求已建立，开始接收流。
final class ChatStreamStarted extends ChatStreamEvent {
  const ChatStreamStarted({this.requestUrl = '', this.statusCode});

  final String requestUrl;
  final int? statusCode;
}

/// 正文增量。
final class ChatTextDelta extends ChatStreamEvent {
  const ChatTextDelta(this.text);

  final String text;
}

/// 思考过程增量（DeepSeek reasoning / Anthropic thinking / Responses summary）。
final class ChatReasoningDelta extends ChatStreamEvent {
  const ChatReasoningDelta(this.text);

  final String text;
}

/// 新的工具调用开始。
final class ChatToolCallStarted extends ChatStreamEvent {
  const ChatToolCallStarted({
    required this.index,
    required this.callId,
    required this.name,
  });

  final int index;
  final String callId;
  final String name;
}

/// 工具调用参数 JSON 片段。
final class ChatToolCallArgumentsDelta extends ChatStreamEvent {
  const ChatToolCallArgumentsDelta({
    required this.index,
    required this.fragment,
  });

  final int index;
  final String fragment;
}

/// 本轮响应正常结束。
final class ChatStreamFinished extends ChatStreamEvent {
  const ChatStreamFinished({this.finishReason});

  final String? finishReason;
}

/// 本轮响应失败。
final class ChatStreamFailed extends ChatStreamEvent {
  const ChatStreamFailed({
    required this.message,
    this.rawBody = '',
    this.statusCode,
  });

  final String message;
  final String rawBody;
  final int? statusCode;
}
