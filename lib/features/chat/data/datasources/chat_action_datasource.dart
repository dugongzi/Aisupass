import 'dart:async';
import 'dart:convert';
import 'dart:developer' show log;
import 'dart:io';

import 'package:Aisupass/features/ai/data/datasources/ai_model_query_datasource.dart';
import 'package:Aisupass/features/ai/data/models/ai_config_dto.dart';
import 'package:Aisupass/features/ai/domain/enums/ai_api_type.dart';
import 'package:Aisupass/features/chat/data/datasources/chat_attachment_store.dart';
import 'package:Aisupass/features/chat/domain/constants/chat_system_prompt.dart';
import 'package:Aisupass/features/chat/domain/enums/chat_tool_status.dart';
import 'package:Aisupass/features/chat/domain/models/chat_attachment.dart';
import 'package:Aisupass/features/chat/domain/models/chat_stream_event.dart';
import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/domain/models/chat_tool_call.dart';
import 'package:Aisupass/features/chat/domain/models/chat_turn.dart';
import 'package:dio/dio.dart';

/// 对话数据源：把完整历史与工具清单发给模型，逐段吐出统一的流式事件。
///
/// 请求体与事件解析对齐三套协议：
/// `openai.chat.v1`、`openai.responses.v1`、`anthropic.messages.v1`。
/// 失败不抛异常，而是以 [ChatStreamFailed] 结束，附带原始返回，
/// 便于在对话流里直接展示真实报错。
class ChatActionDatasource {
  ChatActionDatasource({Dio? dio})
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

  Stream<ChatStreamEvent> streamChat({
    required AiConfigDto config,
    required List<ChatTurn> history,
    required List<ChatToolDefinition> tools,
  }) async* {
    final _ResponseLog responseLog = _ResponseLog(_debugEnabled);
    try {
      yield* _streamChat(
        config: config,
        history: history,
        tools: tools,
        responseLog: responseLog,
      );
    } finally {
      // 正常结束、异常退出、消费端取消都会走到这里，保证日志不丢。
      responseLog.flush();
    }
  }

  Stream<ChatStreamEvent> _streamChat({
    required AiConfigDto config,
    required List<ChatTurn> history,
    required List<ChatToolDefinition> tools,
    required _ResponseLog responseLog,
  }) async* {
    final String url = AiModelQueryDatasource.resolveChatUrl(
      config.apiUrl,
      config.apiType,
    );
    if (url.isEmpty) {
      yield _track(
        responseLog,
        const ChatStreamFailed(message: 'API URL is empty'),
      );
      return;
    }

    final Map<String, dynamic> requestBody = _requestBody(
      config: config,
      history: history,
      tools: tools,
      payloads: await _loadPayloads(history),
    );
    _logRequest(requestBody);

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
      yield _track(
        responseLog,
        ChatStreamFailed(
          message: error.message ?? error.type.name,
          statusCode: error.response?.statusCode,
        ),
      );
      return;
    }

    final ResponseBody body = response.data!;
    final int? status = response.statusCode;

    // 非 2xx：整段读出正文当错误信息。
    if (status == null || status < 200 || status >= 300) {
      final String raw = _pretty(await _readAll(body));
      yield _track(
        responseLog,
        ChatStreamFailed(
          message: _errorDetail(_tryDecode(raw)) ?? 'HTTP $status',
          rawBody: raw,
          statusCode: status,
        ),
      );
      return;
    }

    yield _track(
      responseLog,
      ChatStreamStarted(requestUrl: url, statusCode: status),
    );

    // 服务端若忽略 stream 参数，会直接返回整段 JSON，这里收集起来兜底。
    final StringBuffer plain = StringBuffer();
    final StringBuffer rawSse = StringBuffer();
    final _FrameParser parser = _FrameParser(config.apiType);
    bool sawSse = false;

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
        if (data == '[DONE]') break;

        final Object? decoded = _tryDecode(data);
        final Map<String, Object?>? payload = decoded is Map
            ? Map<String, Object?>.from(decoded)
            : null;

        // 流内报错（额度不足、模型不存在、网关业务错误信封）立即中断。
        if (_payloadIsError(payload, event.event)) {
          yield _track(
            responseLog,
            ChatStreamFailed(
              message: _errorDetail(payload) ?? 'Stream error',
              rawBody: _pretty(rawSse.toString()),
              statusCode: status,
            ),
          );
          return;
        }

        final _Frame frame = parser.parse(payload, event.event);
        for (final ChatStreamEvent item in frame.events) {
          yield _track(responseLog, item);
        }
      }
    } on FormatException catch (error) {
      // 事件结构损坏或单事件超出上限，按协议错误处理。
      yield _track(
        responseLog,
        ChatStreamFailed(
          message: 'Protocol malformed: ${error.message}',
          rawBody: _pretty(rawSse.toString()),
          statusCode: status,
        ),
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
        yield _track(
          responseLog,
          ChatStreamFailed(
            message: _errorDetail(decoded) ?? 'Request failed',
            rawBody: _pretty(plain.toString()),
            statusCode: status,
          ),
        );
        return;
      }
      final String reply = _parsePlainReply(decoded, config.apiType);
      if (reply.isNotEmpty) yield _track(responseLog, ChatTextDelta(reply));
    }

    yield _track(responseLog, const ChatStreamFinished());
  }

  /// 记录事件后原样返回，保证日志与实际下发的事件完全一致。
  ChatStreamEvent _track(_ResponseLog log, ChatStreamEvent event) {
    log.record(event);
    return event;
  }

  /// 是否处于 debug 运行；release 下恒为 false。
  ///
  /// 用 assert 探测而不引入 flutter/foundation，保持数据层不依赖 UI 框架。
  static final bool _debugEnabled = () {
    bool enabled = false;
    assert(() {
      enabled = true;
      return true;
    }());
    return enabled;
  }();

  /// 把即将发送的提示词、工具清单与历史消息打到日志。
  ///
  /// 只在 debug 构建输出；附件图片与 base64 一律折叠成占位符，避免日志被撑爆。
  void _logRequest(Map<String, dynamic> body) {
    if (!_debugEnabled) return;

    final List<Map<String, dynamic>> toolBriefs = _toolBriefs(body);
    final StringBuffer buffer = StringBuffer()
      ..writeln('model: ${body['model']}')
      ..writeln('tools: ${toolBriefs.length}')
      ..writeln('--- system prompt ---')
      ..writeln(_systemText(body));

    for (final Map<String, dynamic> tool in toolBriefs) {
      buffer
        ..writeln('--- tool: ${tool['name']} ---')
        ..writeln(tool['description']);
    }

    log(buffer.toString(), name: 'chat.request');

    final List<String> history = _historyBriefs(body);
    if (history.isEmpty) return;
    log(
      <String>[
        'messages: ${history.length}',
        for (final String line in history) '---\n$line',
      ].join('\n'),
      name: 'chat.history',
    );
  }

  /// 历史消息的可读摘要：role + 正文 + 工具调用 + 工具结果。
  List<String> _historyBriefs(Map<String, dynamic> body) {
    final Object? messages = body['messages'] ?? body['input'];
    if (messages is! List) return const <String>[];
    return <String>[
      for (final Object? item in messages)
        if (item is Map && item['role'] != 'system') _messageBrief(item),
    ];
  }

  /// 单条消息摘要；图片块只留占位符。
  String _messageBrief(Map<dynamic, dynamic> item) {
    final String role = (item['role'] ?? item['type'] ?? '?').toString();
    final StringBuffer out = StringBuffer(role);

    for (final String part in _contentParts(item['content'])) {
      out.write('\n  $part');
    }
    for (final String part in _contentParts(item['output'])) {
      out.write('\n  $part');
    }

    // OpenAI assistant 的工具调用单独列出参数，便于核对模型到底传了什么。
    final Object? calls = item['tool_calls'];
    if (calls is List) {
      for (final Object? call in calls) {
        if (call is! Map) continue;
        final Object? function = call['function'];
        if (function is! Map) continue;
        out.write(
          '\n  -> ${function['name']}(${_clamp('${function['arguments']}', 800)})',
        );
      }
    }

    // Responses 协议的 function_call 项把 name/arguments 放在顶层。
    if (item['type'] == 'function_call') {
      out.write(
        '\n  -> ${item['name']}(${_clamp('${item['arguments']}', 800)})',
      );
    }

    return _clamp(out.toString(), 4000);
  }

  /// 把 content 块拆成可读文本；图片与未知块折成占位符。
  List<String> _contentParts(Object? content) {
    if (content == null) return const <String>[];
    if (content is String) return <String>[content];
    if (content is! List) return <String>[content.toString()];

    final List<String> parts = <String>[];
    for (final Object? block in content) {
      if (block is String) {
        parts.add(block);
        continue;
      }
      if (block is! Map) continue;

      final String type = (block['type'] ?? '').toString();
      if (type.contains('image')) {
        parts.add('[image]');
        continue;
      }
      if (type == 'tool_use') {
        parts.add(
          'tool_use ${block['name']}(${_clamp('${block['input']}', 800)})',
        );
        continue;
      }
      if (type == 'tool_result') {
        parts.add('tool_result: ${_clamp(_flatten(block['content']), 4000)}');
        continue;
      }
      if (type == 'function_call_output') {
        parts.add('tool_result: ${_clamp('${block['output']}', 4000)}');
        continue;
      }
      final Object? text = block['text'];
      if (text != null) parts.add(text.toString());
    }
    return parts;
  }

  /// tool_result 的 content 可能是字符串，也可能是文本块数组。
  String _flatten(Object? content) {
    if (content == null) return '';
    if (content is String) return content;
    if (content is List) {
      final List<String> parts = <String>[];
      for (final Object? block in content) {
        if (block is String) {
          parts.add(block);
        } else if (block is Map && block['text'] != null) {
          parts.add(block['text'].toString());
        }
      }
      return parts.join('\n');
    }
    return content.toString();
  }

  /// 超长文本截断并标注原始长度，避免日志刷屏。
  String _clamp(String text, int limit) {
    if (text.length <= limit) return text;
    return '${text.substring(0, limit)}…(+${text.length - limit} chars)';
  }

  /// 取系统提示词：OpenAI 在 messages[0]，Responses 在 instructions，
  /// Anthropic 在顶层 system。
  String _systemText(Map<String, dynamic> body) {
    final Object? direct = body['system'] ?? body['instructions'];
    if (direct is String && direct.isNotEmpty) return direct;

    final Object? messages = body['messages'];
    if (messages is List && messages.isNotEmpty) {
      final Object? first = messages.first;
      if (first is Map && first['role'] == 'system') {
        return first['content']?.toString() ?? '';
      }
    }
    return '';
  }

  /// 工具清单统一成 `{name, description, ...}`；OpenAI 多包一层 function。
  List<Map<String, dynamic>> _toolBriefs(Map<String, dynamic> body) {
    final Object? tools = body['tools'];
    if (tools is! List) return const <Map<String, dynamic>>[];
    return <Map<String, dynamic>>[
      for (final Object? item in tools)
        if (item is Map)
          if (item['function'] is Map)
            Map<String, dynamic>.from(item['function'] as Map)
          else
            Map<String, dynamic>.from(item),
    ];
  }

  /// 组装请求体，各协议的字段与消息结构差异较大。
  Map<String, dynamic> _requestBody({
    required AiConfigDto config,
    required List<ChatTurn> history,
    required List<ChatToolDefinition> tools,
    required Map<String, _AttachmentPayload> payloads,
  }) {
    return switch (config.apiType) {
      AiApiType.openai => <String, dynamic>{
        'model': config.modelName,
        // 系统提示词必须排在最前，否则模型把自己当成普通聊天机器人。
        'messages': <Map<String, dynamic>>[
          <String, dynamic>{'role': 'system', 'content': chatSystemPrompt},
          ..._openAiMessages(history, payloads),
        ],
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
        // 让 OpenAI 兼容网关在流末尾补一帧 usage，否则拿不到 token 统计。
        'stream_options': <String, dynamic>{'include_usage': true},
      },
      AiApiType.openaiResponses => <String, dynamic>{
        'model': config.modelName,
        'instructions': chatSystemPrompt,
        'input': _responsesInput(history, payloads),
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
        'system': chatSystemPrompt,
        'messages': _anthropicMessages(history, payloads),
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
  List<Map<String, dynamic>> _openAiMessages(
    List<ChatTurn> history,
    Map<String, _AttachmentPayload> payloads,
  ) {
    final List<Map<String, dynamic>> messages = <Map<String, dynamic>>[];
    for (final ChatTurn turn in history) {
      final String text = turn.text.trim();
      if (turn.isUser) {
        if (text.isEmpty && turn.attachments.isEmpty) continue;
        if (turn.attachments.isEmpty) {
          messages.add(<String, dynamic>{'role': 'user', 'content': text});
          continue;
        }
        final List<Map<String, dynamic>> content = <Map<String, dynamic>>[
          if (text.isNotEmpty) <String, dynamic>{'type': 'text', 'text': text},
          for (final ChatAttachment attachment in turn.attachments)
            ?_openAiAttachmentBlock(attachment, payloads[attachment.id]),
        ];
        if (content.isEmpty) continue;
        messages.add(<String, dynamic>{'role': 'user', 'content': content});
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
  List<Map<String, dynamic>> _responsesInput(
    List<ChatTurn> history,
    Map<String, _AttachmentPayload> payloads,
  ) {
    final List<Map<String, dynamic>> input = <Map<String, dynamic>>[];
    for (final ChatTurn turn in history) {
      final String text = turn.text.trim();
      if (turn.isUser) {
        if (text.isEmpty && turn.attachments.isEmpty) continue;
        input.add(<String, dynamic>{
          'role': 'user',
          'content': <Map<String, dynamic>>[
            if (text.isNotEmpty)
              <String, dynamic>{'type': 'input_text', 'text': text},
            for (final ChatAttachment attachment in turn.attachments)
              ?_responsesAttachmentBlock(attachment, payloads[attachment.id]),
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
  List<Map<String, dynamic>> _anthropicMessages(
    List<ChatTurn> history,
    Map<String, _AttachmentPayload> payloads,
  ) {
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
        if (text.isEmpty && turn.attachments.isEmpty) continue;
        addBlocks('user', <Map<String, dynamic>>[
          if (text.isNotEmpty) <String, dynamic>{'type': 'text', 'text': text},
          for (final ChatAttachment attachment in turn.attachments)
            ?_anthropicAttachmentBlock(attachment, payloads[attachment.id]),
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
      final String error = call.error.trim();
      if (error.isNotEmpty) return error;
    }
    final String result = call.result.trim();
    return result.isEmpty ? '(empty result)' : result;
  }

  /// 读取用户轮次里附件的实际内容：图片转 base64，文本读成 UTF-8，
  /// 镜像与压缩包只生成路径说明。
  ///
  /// 文件在发送前被删除或超过上限时直接跳过，不影响其余内容发出。
  Future<Map<String, _AttachmentPayload>> _loadPayloads(
    List<ChatTurn> history,
  ) async {
    final Map<String, _AttachmentPayload> payloads =
        <String, _AttachmentPayload>{};
    for (final ChatTurn turn in history) {
      if (!turn.isUser) continue;
      for (final ChatAttachment attachment in turn.attachments) {
        if (payloads.containsKey(attachment.id)) continue;
        // 只传路径的附件不读盘，路径可能指向外部存储里的大文件。
        if (attachment.isBinary) {
          payloads[attachment.id] = _AttachmentPayload(
            reference: _attachmentReference(attachment),
          );
          continue;
        }
        final File file = File(attachment.path);
        if (!await file.exists()) continue;
        final int length = await file.length();
        if (length <= 0) continue;
        if (attachment.isImage) {
          if (length > maxChatImageBytes) continue;
          payloads[attachment.id] = _AttachmentPayload(
            base64: base64Encode(await file.readAsBytes()),
          );
        } else {
          if (length > maxChatTextBytes) continue;
          payloads[attachment.id] = _AttachmentPayload(
            text: utf8.decode(await file.readAsBytes(), allowMalformed: true),
          );
        }
      }
    }
    return payloads;
  }

  Map<String, dynamic>? _openAiAttachmentBlock(
    ChatAttachment attachment,
    _AttachmentPayload? payload,
  ) {
    if (payload == null) return null;
    if (attachment.isImage && payload.base64 != null) {
      return <String, dynamic>{
        'type': 'image_url',
        'image_url': <String, dynamic>{
          'url': _dataUrl(attachment, payload.base64!),
        },
      };
    }
    final String? text = _blockText(attachment, payload);
    return text == null
        ? null
        : <String, dynamic>{'type': 'text', 'text': text};
  }

  Map<String, dynamic>? _responsesAttachmentBlock(
    ChatAttachment attachment,
    _AttachmentPayload? payload,
  ) {
    if (payload == null) return null;
    if (attachment.isImage && payload.base64 != null) {
      return <String, dynamic>{
        'type': 'input_image',
        'image_url': _dataUrl(attachment, payload.base64!),
      };
    }
    final String? text = _blockText(attachment, payload);
    return text == null
        ? null
        : <String, dynamic>{'type': 'input_text', 'text': text};
  }

  Map<String, dynamic>? _anthropicAttachmentBlock(
    ChatAttachment attachment,
    _AttachmentPayload? payload,
  ) {
    if (payload == null) return null;
    if (attachment.isImage && payload.base64 != null) {
      return <String, dynamic>{
        'type': 'image',
        'source': <String, dynamic>{
          'type': 'base64',
          'media_type': attachment.mimeType,
          'data': payload.base64,
        },
      };
    }
    final String? text = _blockText(attachment, payload);
    return text == null
        ? null
        : <String, dynamic>{'type': 'text', 'text': text};
  }

  /// 非图片附件的文本块内容：路径引用直接返回，文本文件加围栏。
  String? _blockText(ChatAttachment attachment, _AttachmentPayload payload) {
    final String? reference = payload.reference;
    if (reference != null) return reference;
    final String? text = payload.text;
    return text == null ? null : _attachmentText(attachment, text);
  }

  String _dataUrl(ChatAttachment attachment, String base64) =>
      'data:${attachment.mimeType};base64,$base64';

  /// 文本附件统一用围栏包起来，让模型能区分文件和正文。
  String _attachmentText(ChatAttachment attachment, String content) =>
      '文件 ${attachment.name}：\n```\n$content\n```';

  /// 镜像与压缩包只给路径，并说明沙箱限制与对应解析工具。
  ///
  /// 这些文件位于应用私有目录，adb shell（uid 2000）无权读取，
  /// 必须交给应用内的流式解析工具处理。
  String _attachmentReference(ChatAttachment attachment) =>
      '本地文件 ${attachment.name}（路径：${attachment.path}，'
      '${_formatSize(attachment.size)}）。'
      '该路径在应用沙箱内，adb shell（uid 2000）没有读取权限，'
      '不要用 adb_shell_exec 探测它。'
      '先用 local_file_inspect 确认容器格式，'
      'payload.bin 或 OTA 压缩包用 ghost_lock_probe_profile 流式切分，'
      '单个 boot.img 才用 kernel_profile_import_start（上限 512 MiB）。';

  String _formatSize(int bytes) {
    if (bytes <= 0) return '大小未知';
    if (bytes >= 1 << 30) {
      return '${(bytes / (1 << 30)).toStringAsFixed(2)} GB';
    }
    if (bytes >= 1 << 20) {
      return '${(bytes / (1 << 20)).toStringAsFixed(1)} MB';
    }
    if (bytes >= 1 << 10) return '${(bytes / (1 << 10)).toStringAsFixed(1)} KB';
    return '$bytes B';
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

  Map<String, String> _headers(AiConfigDto config) => switch (config.apiType) {
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

/// 本轮响应的日志累积器：文本、思考过程、工具调用、用量与失败原因。
///
/// 流式增量太碎，逐条打日志既刷屏又难读，因此在流结束时汇总成一条输出。
class _ResponseLog {
  _ResponseLog(this.enabled);

  /// release 构建下为 false，此时不累积任何内容。
  final bool enabled;

  /// 正文与思考过程各自的最大保留长度。
  static const int _maxChars = 20000;

  final StringBuffer _text = StringBuffer();
  final StringBuffer _reasoning = StringBuffer();
  final Map<int, String> _names = <int, String>{};
  final Map<int, StringBuffer> _args = <int, StringBuffer>{};

  int _promptTokens = 0;
  int _completionTokens = 0;
  String? _finishReason;
  String? _failure;
  String _rawBody = '';

  /// 累积一个事件；非 debug 构建直接返回。
  void record(ChatStreamEvent event) {
    if (!enabled) return;
    switch (event) {
      case ChatStreamStarted():
        break;
      case ChatTextDelta(:final String text):
        if (_text.length < _maxChars) _text.write(text);
      case ChatReasoningDelta(:final String text):
        if (_reasoning.length < _maxChars) _reasoning.write(text);
      case ChatToolCallStarted(:final int index, :final String name):
        _names[index] = name;
      case ChatToolCallArgumentsDelta(:final int index, :final String fragment):
        (_args[index] ??= StringBuffer()).write(fragment);
      case ChatStreamUsage(
        :final int promptTokens,
        :final int completionTokens,
      ):
        _promptTokens += promptTokens;
        _completionTokens += completionTokens;
      case ChatStreamFinished(:final String? finishReason):
        _finishReason = finishReason ?? '';
      case ChatStreamFailed(:final String message, :final String rawBody):
        _failure = message;
        _rawBody = rawBody;
    }
  }

  /// 输出汇总日志；本轮什么都没有时保持安静。
  void flush() {
    if (!enabled) return;
    if (_text.isEmpty &&
        _reasoning.isEmpty &&
        _names.isEmpty &&
        _failure == null &&
        _finishReason == null) {
      return;
    }

    final StringBuffer out = StringBuffer();
    if (_finishReason != null) out.writeln('finished: $_finishReason');
    if (_failure != null) {
      out.writeln('FAILED: $_failure');
      if (_rawBody.isNotEmpty) out.writeln('raw body:\n${_clamp(_rawBody)}');
    }
    if (_promptTokens > 0 || _completionTokens > 0) {
      out.writeln('usage: prompt=$_promptTokens completion=$_completionTokens');
    }

    if (_names.isNotEmpty) {
      out.writeln('--- tool calls ---');
      final List<int> indexes = _names.keys.toList()..sort();
      for (final int index in indexes) {
        final String args = _args[index]?.toString() ?? '';
        out.writeln('${_names[index]}(${_clamp(args, 1500)})');
      }
    }

    if (_reasoning.isNotEmpty) {
      out
        ..writeln('--- reasoning ---')
        ..writeln(_reasoning);
    }

    out
      ..writeln('--- reply ---')
      ..writeln(_text.isEmpty ? '(empty)' : _text);

    log(out.toString(), name: 'chat.response');
  }

  String _clamp(String text, [int limit = 4000]) =>
      text.length <= limit ? text : '${text.substring(0, limit)}…(truncated)';
}

/// 已读取的附件内容：图片带 base64，文本带正文，路径引用带说明文本。
class _AttachmentPayload {
  const _AttachmentPayload({this.base64, this.text, this.reference});

  final String? base64;
  final String? text;
  final String? reference;
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
  const _Frame({
    this.events = const <ChatStreamEvent>[],
    this.terminal = false,
  });

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
    final List<ChatStreamEvent> events = <ChatStreamEvent>[];

    // usage 帧通常只有 usage、没有 choices，必须先于 choices 判断处理。
    final ChatStreamEvent? usage = _openAiUsage(payload['usage']);
    if (usage != null) events.add(usage);

    final Object? choices = payload['choices'];
    if (choices is! List || choices.isEmpty || choices.first is! Map) {
      return _Frame(events: events);
    }
    final Map<String, Object?> choice = Map<String, Object?>.from(
      choices.first as Map,
    );
    final Object? delta = choice['delta'];

    if (delta is Map) {
      final String text = _contentToText(delta['content']);
      if (text.isNotEmpty) events.add(ChatTextDelta(text));

      // DeepSeek 等实现把思考过程放在 reasoning_content，部分网关用 reasoning。
      final Object? reasoning =
          delta['reasoning_content'] ?? delta['reasoning'];
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
        final Object? response = payload['response'];
        final Object? usage = response is Map ? response['usage'] : null;
        final ChatStreamEvent? usageEvent = _responsesUsage(usage);
        return _Frame(
          events: usageEvent == null
              ? const <ChatStreamEvent>[]
              : <ChatStreamEvent>[usageEvent],
          terminal: true,
        );

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

      case 'message_start':
        // input_tokens 只在起始帧下发，output_tokens 在结束帧下发。
        final Object? message = payload['message'];
        final Object? usage = message is Map ? message['usage'] : null;
        final ChatStreamEvent? usageEvent = _anthropicUsage(
          usage,
          prompt: true,
        );
        return _Frame(
          events: usageEvent == null
              ? const <ChatStreamEvent>[]
              : <ChatStreamEvent>[usageEvent],
        );

      case 'message_delta':
        final Object? delta = payload['delta'];
        final Object? usage = payload['usage'];
        final ChatStreamEvent? usageEvent = _anthropicUsage(
          usage,
          prompt: false,
        );
        return _Frame(
          events: usageEvent == null
              ? const <ChatStreamEvent>[]
              : <ChatStreamEvent>[usageEvent],
          terminal: delta is Map && delta['stop_reason'] != null,
        );

      case 'message_stop':
        return const _Frame(terminal: true);

      default:
        return const _Frame();
    }
  }

  /// OpenAI 兼容协议的 usage 帧：`prompt_tokens` / `completion_tokens`。
  ChatStreamEvent? _openAiUsage(Object? usage) {
    if (usage is! Map) return null;
    final int prompt = _intOf(usage['prompt_tokens']);
    final int completion = _intOf(usage['completion_tokens']);
    if (prompt <= 0 && completion <= 0) return null;
    return ChatStreamUsage(promptTokens: prompt, completionTokens: completion);
  }

  /// Responses 协议的 usage：`input_tokens` / `output_tokens`。
  ChatStreamEvent? _responsesUsage(Object? usage) {
    if (usage is! Map) return null;
    final int prompt = _intOf(usage['input_tokens']);
    final int completion = _intOf(usage['output_tokens']);
    if (prompt <= 0 && completion <= 0) return null;
    return ChatStreamUsage(promptTokens: prompt, completionTokens: completion);
  }

  /// Anthropic 的用量分两帧：起始帧给输入，结束帧给输出。
  ChatStreamEvent? _anthropicUsage(Object? usage, {required bool prompt}) {
    if (usage is! Map) return null;
    final int value = _intOf(
      prompt ? usage['input_tokens'] : usage['output_tokens'],
    );
    if (value <= 0) return null;
    return ChatStreamUsage(
      promptTokens: prompt ? value : 0,
      completionTokens: prompt ? 0 : value,
    );
  }

  int _intOf(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
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
