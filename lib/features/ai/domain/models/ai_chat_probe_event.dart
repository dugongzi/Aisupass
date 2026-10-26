import 'package:flutter/foundation.dart';

/// 测试对话的流式事件。
///
/// 请求按 SSE 增量返回，界面边收边渲染；
/// 任何异常都以 [AiChatProbeFailed] 收尾，并带上服务端原始返回便于排查。
@immutable
sealed class AiChatProbeEvent {
  const AiChatProbeEvent();
}

/// 请求已建立，服务端开始返回。
final class AiChatProbeStarted extends AiChatProbeEvent {
  const AiChatProbeStarted({required this.requestUrl, this.statusCode});

  /// 实际请求的地址，便于用户核对拼接是否正确。
  final String requestUrl;
  final int? statusCode;
}

/// 收到一段增量文本。
final class AiChatProbeDelta extends AiChatProbeEvent {
  const AiChatProbeDelta(this.text);

  final String text;
}

/// 正常结束。
final class AiChatProbeFinished extends AiChatProbeEvent {
  const AiChatProbeFinished({
    required this.requestUrl,
    required this.duration,
    this.statusCode,
    this.streamed = true,
  });

  final String requestUrl;
  final Duration duration;
  final int? statusCode;

  /// 服务端是否真的按 SSE 增量返回。
  ///
  /// 为 false 说明它忽略了 `stream: true`，整段 JSON 一次给全，
  /// 这种情况下界面无法做到逐字出现。
  final bool streamed;
}

/// 失败。[rawBody] 为服务端原始返回，为空表示网络层直接失败。
final class AiChatProbeFailed extends AiChatProbeEvent {
  const AiChatProbeFailed({
    required this.message,
    this.rawBody = '',
    this.requestUrl = '',
    this.statusCode,
    this.duration = Duration.zero,
  });

  final String message;
  final String rawBody;
  final String requestUrl;
  final int? statusCode;
  final Duration duration;
}
