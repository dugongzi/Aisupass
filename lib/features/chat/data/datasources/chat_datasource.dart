import 'dart:async';
import 'dart:convert';

import 'package:Aisupass/features/ai/data/datasources/ai_model_query_datasource.dart';
import 'package:Aisupass/features/ai/data/models/ai_config_dto.dart';
import 'package:Aisupass/features/ai/domain/enums/ai_api_type.dart';
import 'package:Aisupass/features/chat/domain/models/chat_stream_event.dart';
import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/domain/models/chat_turn.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// 对话数据源：把完整历史与工具清单发给模型，逐段吐出统一的流式事件。
///
/// 请求体与事件解析对齐三套协议：
/// `openai.chat.v1`、`openai.responses.v1`、`anthropic.messages.v1`。
/// 失败不抛异常，而是以 [ChatStreamFailed] 结束，附带原始返回，
/// 便于在对话流里直接展示真实报错。
class ChatDatasource {
  ChatDatasource({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 20),
              // 对话回复可能很长，接收超时放宽到 5 分钟。
              receiveTimeout: const Duration(minutes: 5),
              sendTimeout: const Duration(seconds: 20),
            ),
          );

  final Dio _dio;

  /// 失败时展示的原始流内容上限，避免超长回复撑爆界面。
  static const int _maxRawLength = 8000;

  /// 单个 SSE 事件的字节上限，超过视为协议异常。
  static const int _maxSseEventBytes = 1024 * 1024;

  /// Anthropic 的 max_tokens 为必填项，未配置时用这个兜底。
  static const int _defaultAnthropicMaxTokens = 4096;

  static const String _tag = '[AiChat]';

  static void _log(String message) {
    if (kDebugMode) debugPrint('$_tag $message');
  }

  Stream<ChatStreamEvent> streamChat({
    required AiConfigDto config,
    required List<ChatTurn> history,
    required List<ChatToolDefinition> tools,
  }) async* {
    final String url = AiModelQueryDatasource.resolveChatUrl(
      config.apiUrl,
      config.apiType,
    );
    if (url.isEmpty) {
      yield const ChatStreamFailed(message: 'API URL is empty');
      return;
    }

    final Map<String, dynamic> requestBody = _requestBody(
      config: config,
      history: history,
      tools: tools,
    );

    _log('→ POST $url apiType=${config.apiType.name} '
        'model=${config.modelName} turns=${history.length} tools=${tools.length}');

    final Response<ResponseBody> response;
    try {
      response = await _dio.post<ResponseBody>(
        url,
        data: requestBody,
        options: Options(
          headers: _streamHeaders(config),
          responseType: ResponseType.stream,
          // 状态码自己判断，避免 4xx/5xx 时拿不到正文。
          validateStatus: (int? status) => status != null,
        ),
      );
    } on DioException catch (error) {
      _log('✗ DioException type=${error.type.name} msg=${error.message}');
      yield ChatStreamFailed(
        message: error.message ?? error.type.name,
        statusCode: error.response?.statusCode,
      );
      return;
    }

    final ResponseBody body = response.data!;
    final int? status = response.statusCode;

    // 非 2xx：整段读出正文当错误信息。
    if (status == null || status < 200 || status >= 300) {
      final String raw = _pretty(await _readAll(body));
      _log('✗ HTTP $status');
      yield ChatStreamFailed(
        message: _errorDetail(_tryDecode(raw)) ?? 'HTTP $status',
        rawBody: raw,
        statusCode: status,
      );
      return;
    }

    yield ChatStreamStarted(requestUrl: url, statusCode: status);

    // 服务端若忽略 stream 参数，会直接返回整段 JSON，这里收集起来兜底。
    final StringBuffer plain = StringBuffer();
    final StringBuffer rawSse = StringBuffer();
    final _FrameParser parser = _FrameParser(config.apiType);
    bool sawSse = false;
    bool terminal = false;

    try {
      await for (final _SseEvent event in _decodeSse(
        body.stream,
        plain: plain,
      )) {
        sawSse = true;
        if (rawSse.length < _maxRawLength) {
          if (event.event != null) rawSse.writeln('event: ${event.event}');
          rawSse.writeln('data: ${event.data}');
        }

        final String data = event.data.trim();
        if (data.isEmpty) continue;
        if (data == '[DONE]') {
          terminal = true;
          break;
        }

        final Object? decoded = _tryDecode(data);
        final Map<String, Object?>? payload = decoded is Map
            ? Map<String, Object?>.from(decoded)
            : null;

        // 流内报错（额度不足、模型不存在、网关业务错误信封）立即中断。
        if (_payloadIsError(payload, event.event)) {
          _log('✗ stream error');
          yield ChatStreamFailed(
            message: _errorDetail(payload) ?? 'Stream error',
            rawBody: _pretty(rawSse.toString()),
            statusCode: status,
          );
          return;
        }

        final _Frame frame = parser.parse(payload, event.event);
        if (frame.terminal) terminal = true;
        for (final ChatStreamEvent item in frame.events) {
          yield item;
        }
      }
    } on FormatException catch (error) {
      // 事件结构损坏或单事件超出上限，按协议错误处理。
      _log('✗ protocol malformed: ${error.message}');
      yield ChatStreamFailed(
        message: 'Protocol malformed: ${error.message}',
        rawBody: _pretty(rawSse.toString()),
        statusCode: status,
      );
      return;
    }

    // 整段 JSON 兜底：只取正文，不解析工具调用。
    if (!sawSse && plain.isNotEmpty) {
      final Object? decoded = _tryDecode(plain.toString());
      if (_payloadIsError(
        decoded is Map ? Map<String, Object?>.from(decoded) : null,
        null,
      )) {
        yield ChatStreamFailed(
          message: _errorDetail(decoded) ?? 'Request failed',
          rawBody: _pretty(plain.toString()),
          statusCode: status,
        );
        return;
      }
      final String reply = _parsePlainReply(decoded, config.apiType);
      if (reply.isNotEmpty) yield ChatTextDelta(reply);
      terminal = true;
    }

    if (!terminal) {
      _log('! stream ended without terminal event');
    }
    yield const ChatStreamFinished();
  }

  /// 组装请求体，各协议的字段与消息结构差异较大。
  Map<String, dynamic> _requestBody({
    required AiConfigDto config,
    required List<ChatTurn> history,
    required List<ChatToolDefinition> tools,
  }) {
    return switch (config.apiType) {
      AiApiType.openai => <String, dynamic>{
        'model': config.modelName,
        'messages': _openAiMessages(history),
        if (config.maxToken > 0) 'max_tokens': config.maxToken,
        // temperature 未配置时是 -1，直接下发会被服务端判为非法值。
        if (config.temperature >= 0) 'temperature': config.temperature,
        if (tools.isNotEmpty)
          'tools': <Map<String, dynamic>>[
            for (final ChatToolDefinition tool in tools)
              <String, dynamic>{
                'type': 'function',
                'function': <String, dynamic>{
                  'name': tool.name,
                  'description': tool.description,
                  'parameters': tool.parameters,
                },
              },
          ],
        'stream': true,
      },
      AiApiType.openaiResponses => <String, dynamic>{
        'model': config.modelName,
        'input': _responsesInput(history),
        if (config.maxToken > 0) 'max_output_tokens': config.maxToken,
        if (config.temperature >= 0) 'temperature': config.temperature,
        if (tools.isNotEmpty)
          'tools': <Map<String, dynamic>>[
            for (final ChatToolDefinition tool in tools)
              <String, dynamic>{
                'type': 'function',
                'name': tool.name,
                'description': tool.description,
                'parameters': tool.parameters,
              },
          ],
        'stream': true,
      },
      AiApiType.anthropic => <String, dynamic>{
        'model': config.modelName,
        'messages': _anthropicMessages(history),
        'max_tokens': config.maxToken > 0
            ? config.maxToken
            : _defaultAnthropicMaxTokens,
        if (config.temperature >= 0) 'temperature': config.temperature,
        if (tools.isNotEmpty)
          'tools': <Map<String, dynamic>>[
            for (final ChatToolDefinition tool in tools)
              <String, dynamic>{
                'name': tool.name,
                'description': tool.description,
                'input_schema': tool.parameters,
              },
          ],
        'stream': true,
      },
    };
  }

  /// OpenAI Chat Completions 的消息序列：工具结果作为独立的 `tool` 消息，
  /// 紧跟在其所属的 assistant 消息之后。
  List<Map<String, dynamic>> _openAiMessages(List<ChatTurn> history) {
    final List<Map<String, dynamic>> messages = <Map<String, dynamic>>[];
    for (final ChatTurn turn in history) {
      final String text = turn.text.trim();
      if (turn.isUser) {
        if (text.isEmpty) continue;
        messages.add(<String, dynamic>{'role': 'user', 'content': text});
        continue;
      }

      final List<ChatToolCall> calls = turn.toolCalls;
      if (text.isEmpty && calls.isEmpty) continue;
      messages.add(<String, dynamic>{
        'role': 'assistant',
        if (text.isNotEmpty) 'content': text,
        if (calls.isNotEmpty)
          'tool_calls': <Map<String, dynamic>>[
            for (final ChatToolCall call in calls)
              <String, dynamic>{
                'id': call.callId,
                'type': 'function',
                'function': <String, dynamic>{
                  'name': call.name,
                  'arguments': _normalizeArguments(call.argumentsJson),
                },
              },
          ],
      });
      for (final ChatToolCall call in calls) {
        messages.add(<String, dynamic>{
          'role': 'tool',
          'tool_call_id': call.callId,
          'content': _toolResultText(call),
        });
      }
    }
    return messages;
  }

  /// Responses 协议的输入项数组：正文用 message 项，工具调用与结果各自成项。
  List<Map<String, dynamic>> _responsesInput(List<ChatTurn> history) {
    final List<Map<String, dynamic>> input = <Map<String, dynamic>>[];
    for (final ChatTurn turn in history) {
      final String text = turn.text.trim();
      if (turn.isUser) {
        if (text.isEmpty) continue;
        input.add(<String, dynamic>{
          'role': 'user',
          'content': <Map<String, String>>[
            <String, String>{'type': 'input_text', 'text': text},
          ],
        });
        continue;
      }

      if (text.isNotEmpty) {
        input.add(<String, dynamic>{
          'role': 'assistant',
          'content': <Map<String, String>>[
            <String, String>{'type': 'output_text', 'text': text},
          ],
        });
      }
      for (final ChatToolCall call in turn.toolCalls) {
        input.add(<String, dynamic>{
          'type': 'function_call',
          'call_id': call.callId,
          'name': call.name,
          'arguments': _normalizeArguments(call.argumentsJson),
        });
        input.add(<String, dynamic>{
          'type': 'function_call_output',
          'call_id': call.callId,
          'output': _toolResultText(call),
        });
      }
    }
    return input;
  }

  /// Anthropic 的消息序列：工具结果必须放在紧随 assistant 的 user 消息里，
  /// 因此相邻的 user 内容块要合并成一条消息。
  List<Map<String, dynamic>> _anthropicMessages(List<ChatTurn> history) {
    final List<Map<String, dynamic>> messages = <Map<String, dynamic>>[];

    void addBlocks(String role, List<Map<String, dynamic>> blocks) {
      if (blocks.isEmpty) return;
      if (messages.isNotEmpty && messages.last['role'] == role) {
        final List<Map<String, dynamic>> content =
            messages.last['content'] as List<Map<String, dynamic>>;
        content.addAll(blocks);
        return;
      }
      messages.add(<String, dynamic>{'role': role, 'content': blocks});
    }

    for (final ChatTurn turn in history) {
      final String text = turn.text.trim();
      if (turn.isUser) {
        if (text.isEmpty) continue;
        addBlocks('user', <Map<String, dynamic>>[
          <String, dynamic>{'type': 'text', 'text': text},
        ]);
        continue;
      }

      final List<Map<String, dynamic>> blocks = <Map<String, dynamic>>[
        if (text.isNotEmpty) <String, dynamic>{'type': 'text', 'text': text},
        for (final ChatToolCall call in turn.toolCalls)
          <String, dynamic>{
            'type': 'tool_use',
            'id': call.callId,
            'name': call.name,
            'input': _decodeArguments(call.argumentsJson),
          },
      ];
      if (blocks.isEmpty) continue;
      messages.add(<String, dynamic>{'role': 'assistant', 'content': blocks});

      addBlocks('user', <Map<String, dynamic>>[
        for (final ChatToolCall call in turn.toolCalls)
          <String, dynamic>{
            'type': 'tool_result',
            'tool_use_id': call.callId,
            'content': _toolResultText(call),
          },
      ]);
    }
    return messages;
  }

  /// 工具结果文本：失败时优先给出错误原因，保证模型能看到失败信息。
  String _toolResultText(ChatToolCall call) {
    if (call.status == ChatToolStatus.failed) {
      final String error = (call.error ?? '').trim();
      if (error.isNotEmpty) return error;
    }
    final String result = call.result.trim();
    return result.isEmpty ? '(empty result)' : result;
  }

  /// 参数 JSON 必须是合法对象，空串或非法内容统一退化成 `{}`。
  String _normalizeArguments(String raw) {
    final String text = raw.trim();
    if (text.isEmpty) return '{}';
    try {
      final Object? decoded = jsonDecode(text);
      if (decoded is Map) return jsonEncode(decoded);
    } on FormatException {
      return '{}';
    }
    return '{}';
  }

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

  /// 把整个流读成字符串，用于非 2xx 时取错误正文。
  Future<String> _readAll(ResponseBody body) async {
    final List<int> bytes = <int>[];
    await for (final List<int> chunk in body.stream) {
      bytes.addAll(chunk);
    }
    return utf8.decode(bytes, allowMalformed: true);
  }

  Object? _tryDecode(String text) {
    final String trimmed = text.trim();
    if (trimmed.isEmpty) return null;
    try {
      return jsonDecode(trimmed);
    } on FormatException {
      return trimmed;
    }
  }

  /// 增量解析 SSE：按空行切分事件，`:` 开头为注释，
  /// `field: value` 去掉一个前导空格，多行 `data` 用 `\n` 拼接。
  ///
  /// 若整条流没有出现任何 SSE 字段，则把原始正文写进 [plain] 交由调用方兜底解析。
  Stream<_SseEvent> _decodeSse(
    Stream<List<int>> bytes, {
    StringBuffer? plain,
  }) async* {
    String? event;
    String? id;
    int? retry;
    final List<String> dataLines = <String>[];
    int eventBytes = 0;
    final StringBuffer raw = StringBuffer();
    bool looksLikeSse = false;
    bool dispatched = false;

    void reset() {
      event = null;
      id = null;
      retry = null;
      dataLines.clear();
      eventBytes = 0;
    }

    _SseEvent? dispatch() {
      if (dataLines.isEmpty) {
        reset();
        return null;
      }
      final _SseEvent result = _SseEvent(
        data: dataLines.join('\n'),
        event: event,
        id: id,
        retry: retry,
      );
      reset();
      return result;
    }

    await for (final String line
        in utf8.decoder.bind(bytes).transform(const LineSplitter())) {
      if (!looksLikeSse) raw.writeln(line);

      if (line.isEmpty) {
        final _SseEvent? result = dispatch();
        if (result != null) {
          dispatched = true;
          yield result;
        }
        continue;
      }
      if (line.startsWith(':')) continue;

      final int separator = line.indexOf(':');
      final String field = separator < 0 ? line : line.substring(0, separator);
      String value = separator < 0 ? '' : line.substring(separator + 1);
      if (value.startsWith(' ')) value = value.substring(1);

      switch (field) {
        case 'event':
          looksLikeSse = true;
          event = value;
        case 'id':
          looksLikeSse = true;
          id = value;
        case 'retry':
          looksLikeSse = true;
          retry = int.tryParse(value);
        case 'data':
          looksLikeSse = true;
          eventBytes += utf8.encode(value).length + 1;
          if (eventBytes > _maxSseEventBytes) {
            throw const FormatException('SSE event exceeds configured limit');
          }
          dataLines.add(value);
      }
      if (looksLikeSse) raw.clear();
    }

    final _SseEvent? last = dispatch();
    if (last != null) {
      dispatched = true;
      yield last;
    }
    if (!dispatched && plain != null && raw.isNotEmpty) {
      plain.write(raw.toString());
    }
  }

  /// 识别错误信封：`error` 键、`status` 值、以及 `code + message` 的网关业务错误。
  bool _payloadIsError(Map<String, Object?>? payload, String? event) {
    if (payload == null) return event == 'error';

    if (payload['error'] != null) return true;
    final String status = payload['status']?.toString().toLowerCase() ?? '';
    if (status == 'error' || status == 'failed' || status == 'failure') {
      return true;
    }
    final String type = payload['type']?.toString().toLowerCase() ?? '';
    if (type == 'error' || type == 'response.failed') return true;

    final Object? code = payload['code'];
    final Object? message = payload['message'];
    return code != null &&
        message is String &&
        message.trim().isNotEmpty &&
        !payload.containsKey('choices');
  }

  /// 从错误信封里取出可读文案，依次尝试 error.* → 顶层字段 → 嵌套 response。
  String? _errorDetail(Object? data) {
    if (data is Map) {
      final Map<String, Object?> payload = Map<String, Object?>.from(data);
      final Object? error = payload['error'];
      if (error is Map) {
        final Map<String, Object?> nested = Map<String, Object?>.from(error);
        for (final String key in const ['message', 'detail', 'error']) {
          final String value = nested[key]?.toString().trim() ?? '';
          if (value.isNotEmpty) return value;
        }
      }
      for (final String key in const ['detail', 'message', 'error']) {
        final String value = payload[key]?.toString().trim() ?? '';
        if (value.isNotEmpty) return value;
      }
      final Object? response = payload['response'];
      if (response is Map) return _errorDetail(response);
    }
    if (data is String && data.trim().isNotEmpty) return data.trim();
    return null;
  }

  String _pretty(Object? data) {
    if (data == null) return '';
    Object? decoded = data;
    if (data is String) {
      final String text = data.trim();
      if (text.isEmpty) return '';
      try {
        decoded = jsonDecode(text);
      } on FormatException {
        return text;
      }
    }
    try {
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } on JsonUnsupportedObjectError {
      return decoded.toString();
    }
  }

  /// 非流式返回时提取正文。
  String _parsePlainReply(Object? data, AiApiType apiType) {
    if (data is! Map) return '';

    switch (apiType) {
      case AiApiType.openai:
        final Object? choices = data['choices'];
        if (choices is! List || choices.isEmpty) return '';
        final Object? first = choices.first;
        if (first is! Map) return '';
        final Object? content = first['message'] is Map
            ? (first['message'] as Map)['content']
            : first['text'];
        return _contentToText(content);

      case AiApiType.openaiResponses:
        final Object? aggregated = data['output_text'];
        if (aggregated is String && aggregated.trim().isNotEmpty) {
          return aggregated.trim();
        }
        final Object? output = data['output'];
        if (output is! List) return '';
        final List<String> parts = <String>[];
        for (final Object? item in output) {
          if (item is! Map) continue;
          final Object? content = item['content'];
          if (content is! List) continue;
          for (final Object? part in content) {
            if (part is! Map || part['type'] != 'output_text') continue;
            final String text = (part['text'] ?? '').toString();
            if (text.isNotEmpty) parts.add(text);
          }
        }
        return parts.join('\n').trim();

      case AiApiType.anthropic:
        final Object? content = data['content'];
        if (content is! List) return '';
        final List<String> parts = <String>[];
        for (final Object? item in content) {
          if (item is! Map || item['type'] != 'text') continue;
          final String text = (item['text'] ?? '').toString();
          if (text.isNotEmpty) parts.add(text);
        }
        return parts.join('\n').trim();
    }
  }

  /// 兼容 content 为字符串或分段数组两种返回形式。
  String _contentToText(Object? content) {
    if (content is String) return content;
    if (content is List) {
      final List<String> parts = <String>[];
      for (final Object? item in content) {
        if (item is Map && item['text'] != null) {
          parts.add(item['text'].toString());
        } else if (item is String) {
          parts.add(item);
        }
      }
      return parts.join();
    }
    return '';
  }

  Map<String, String> _headers(AiConfigDto config) =>
      switch (config.apiType) {
        AiApiType.openai || AiApiType.openaiResponses => <String, String>{
          'Authorization': 'Bearer ${config.apiKey.trim()}',
          'Content-Type': 'application/json',
        },
        AiApiType.anthropic => <String, String>{
          'x-api-key': config.apiKey.trim(),
          'anthropic-version': '2023-06-01',
          'Content-Type': 'application/json',
        },
      };

  /// 流式请求头：显式声明 SSE，并禁用压缩与缓存。
  Map<String, String> _streamHeaders(AiConfigDto config) => <String, String>{
    'Accept': 'text/event-stream',
    'Cache-Control': 'no-cache',
    'Accept-Encoding': 'identity',
    ..._headers(config),
  };
}

/// 一个 SSE 事件：`data` 已按行拼好，其余为可选元字段。
class _SseEvent {
  const _SseEvent({required this.data, this.event, this.id, this.retry});

  final String data;
  final String? event;
  final String? id;
  final int? retry;
}

/// 单个事件解析结果：需要抛给控制器的增量事件与是否已到终止态。
class _Frame {
  const _Frame({this.events = const <ChatStreamEvent>[], this.terminal = false});

  final List<ChatStreamEvent> events;
  final bool terminal;
}

/// 按协议把单个 SSE 事件翻译成统一事件。
///
/// Responses 协议的工具调用以 item id 标识，没有稳定的数字下标，
/// 这里维护一份 item id → 下标的映射，保证控制器能按同一份下标归并参数片段。
class _FrameParser {
  _FrameParser(this.apiType);

  final AiApiType apiType;
  final Map<String, int> _toolIndexes = <String, int>{};
  int _nextToolIndex = 0;

  _Frame parse(Map<String, Object?>? payload, String? event) {
    if (payload == null) return const _Frame();
    return switch (apiType) {
      AiApiType.openai => _parseOpenAi(payload),
      AiApiType.openaiResponses => _parseResponses(payload, event),
      AiApiType.anthropic => _parseAnthropic(payload, event),
    };
  }

  int _indexFor(String id) {
    if (id.isEmpty) return 0;
    final int? existing = _toolIndexes[id];
    if (existing != null) return existing;
    final int index = _nextToolIndex++;
    _toolIndexes[id] = index;
    return index;
  }

  _Frame _parseOpenAi(Map<String, Object?> payload) {
    final Object? choices = payload['choices'];
    if (choices is! List || choices.isEmpty || choices.first is! Map) {
      return const _Frame();
    }
    final Map<String, Object?> choice = Map<String, Object?>.from(
      choices.first as Map,
    );
    final Object? delta = choice['delta'];
    final List<ChatStreamEvent> events = <ChatStreamEvent>[];

    if (delta is Map) {
      final String text = _contentToText(delta['content']);
      if (text.isNotEmpty) events.add(ChatTextDelta(text));

      // DeepSeek 等实现把思考过程放在 reasoning_content，部分网关用 reasoning。
      final Object? reasoning = delta['reasoning_content'] ?? delta['reasoning'];
      final String reasoningText = reasoning is String ? reasoning : '';
      if (reasoningText.isNotEmpty) {
        events.add(ChatReasoningDelta(reasoningText));
      }

      final Object? toolCalls = delta['tool_calls'];
      if (toolCalls is List) {
        for (final Object? raw in toolCalls) {
          if (raw is! Map) continue;
          final int index = int.tryParse(raw['index']?.toString() ?? '') ?? 0;
          final String id = raw['id']?.toString() ?? '';
          final Object? function = raw['function'];
          final String name = function is Map
              ? (function['name']?.toString() ?? '')
              : '';
          final String arguments = function is Map
              ? (function['arguments']?.toString() ?? '')
              : '';
          // 首帧带 id/name，后续帧只带参数片段。
          if (id.isNotEmpty || name.isNotEmpty) {
            events.add(
              ChatToolCallStarted(index: index, callId: id, name: name),
            );
          }
          if (arguments.isNotEmpty) {
            events.add(
              ChatToolCallArgumentsDelta(index: index, fragment: arguments),
            );
          }
        }
      }
    }

    return _Frame(
      events: events,
      terminal: _isFinishReason(choice['finish_reason']),
    );
  }

  _Frame _parseResponses(Map<String, Object?> payload, String? event) {
    final String type = payload['type']?.toString() ?? event ?? '';
    switch (type) {
      case 'response.output_text.delta':
        final String delta = payload['delta']?.toString() ?? '';
        return delta.isEmpty
            ? const _Frame()
            : _Frame(events: <ChatStreamEvent>[ChatTextDelta(delta)]);

      case 'response.reasoning_summary_text.delta':
      case 'response.reasoning_text.delta':
        final String delta = payload['delta']?.toString() ?? '';
        return delta.isEmpty
            ? const _Frame()
            : _Frame(events: <ChatStreamEvent>[ChatReasoningDelta(delta)]);

      case 'response.output_item.added':
        final Object? item = payload['item'];
        if (item is! Map || item['type'] != 'function_call') {
          return const _Frame();
        }
        final String itemId = item['id']?.toString() ?? '';
        return _Frame(
          events: <ChatStreamEvent>[
            ChatToolCallStarted(
              index: _indexFor(itemId),
              callId: (item['call_id'] ?? itemId).toString(),
              name: item['name']?.toString() ?? '',
            ),
          ],
        );

      case 'response.function_call_arguments.delta':
        final String delta = payload['delta']?.toString() ?? '';
        if (delta.isEmpty) return const _Frame();
        return _Frame(
          events: <ChatStreamEvent>[
            ChatToolCallArgumentsDelta(
              index: _indexFor(payload['item_id']?.toString() ?? ''),
              fragment: delta,
            ),
          ],
        );

      case 'response.completed':
      case 'response.incomplete':
        return const _Frame(terminal: true);

      default:
        return const _Frame();
    }
  }

  _Frame _parseAnthropic(Map<String, Object?> payload, String? event) {
    final String type = payload['type']?.toString() ?? event ?? '';
    switch (type) {
      case 'content_block_start':
        final Object? block = payload['content_block'];
        if (block is! Map || block['type'] != 'tool_use') {
          return const _Frame();
        }
        return _Frame(
          events: <ChatStreamEvent>[
            ChatToolCallStarted(
              index: int.tryParse(payload['index']?.toString() ?? '') ?? 0,
              callId: block['id']?.toString() ?? '',
              name: block['name']?.toString() ?? '',
            ),
          ],
        );

      case 'content_block_delta':
        final Object? delta = payload['delta'];
        if (delta is! Map) return const _Frame();
        final String deltaType = delta['type']?.toString() ?? '';
        if (deltaType == 'text_delta') {
          final String text = delta['text']?.toString() ?? '';
          return text.isEmpty
              ? const _Frame()
              : _Frame(events: <ChatStreamEvent>[ChatTextDelta(text)]);
        }
        if (deltaType == 'thinking_delta') {
          final String text = delta['thinking']?.toString() ?? '';
          return text.isEmpty
              ? const _Frame()
              : _Frame(events: <ChatStreamEvent>[ChatReasoningDelta(text)]);
        }
        if (deltaType == 'input_json_delta') {
          final String partial = delta['partial_json']?.toString() ?? '';
          if (partial.isEmpty) return const _Frame();
          return _Frame(
            events: <ChatStreamEvent>[
              ChatToolCallArgumentsDelta(
                index: int.tryParse(payload['index']?.toString() ?? '') ?? 0,
                fragment: partial,
              ),
            ],
          );
        }
        return const _Frame();

      case 'message_delta':
        final Object? delta = payload['delta'];
        return _Frame(
          terminal: delta is Map && delta['stop_reason'] != null,
        );

      case 'message_stop':
        return const _Frame(terminal: true);

      default:
        return const _Frame();
    }
  }

  /// OpenAI 的 finish_reason 只有已知取值才代表正常终止。
  bool _isFinishReason(Object? value) => switch (value?.toString()) {
    'stop' || 'length' || 'tool_calls' || 'content_filter' => true,
    _ => false,
  };

  String _contentToText(Object? content) {
    if (content is String) return content;
    if (content is List) {
      final List<String> parts = <String>[];
      for (final Object? item in content) {
        if (item is Map && item['text'] != null) {
          parts.add(item['text'].toString());
        } else if (item is String) {
          parts.add(item);
        }
      }
      return parts.join();
    }
    return '';
  }
}
