import 'dart:async';
import 'dart:convert';

import 'package:Aisupass/features/ai/data/models/ai_config_dto.dart';
import 'package:Aisupass/features/ai/domain/enums/ai_api_type.dart';
import 'package:Aisupass/features/ai/domain/models/ai_chat_probe_event.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// 模型目录请求失败时抛出的异常。
///
/// 由数据源抛出、presentation 层捕获，[message] 已尽量取服务端返回的可读文案。
class AiRequestException implements Exception {
  const AiRequestException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

/// 模型目录的只读数据源：只做 `/models` 请求，不参与对话。
///
/// 拿到模型列表即说明地址、API Key 与协议都可用，
/// 因此它同时充当「连通性检测」，不需要额外发一条对话请求。
class AiModelQueryDatasource {
  AiModelQueryDatasource({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 20),
              sendTimeout: const Duration(seconds: 15),
            ),
          );

  final Dio _dio;

  /// 失败时展示的原始流内容上限，避免超长回复撑爆界面。
  static const int _maxRawLength = 8000;

  /// 单个 SSE 事件的字节上限，超过视为协议异常，避免恶意/异常数据撑爆内存。
  static const int _maxSseEventBytes = 1024 * 1024;

  /// 测试对话只取很短回复，便于快速看到返回。
  static const int _probeMaxTokens = 10;

  /// 调试日志前缀，方便在控制台过滤。
  static const String _tag = '[AiProbe]';

  /// 仅 debug 构建输出，避免发布包把请求参数打到日志里。
  static void _log(String message) {
    if (kDebugMode) debugPrint('$_tag $message');
  }

  /// 日志里展示的 API Key 只保留首尾，避免明文泄漏。
  static String _maskKey(String raw) {
    final String key = raw.trim();
    if (key.isEmpty) return '<empty>';
    if (key.length <= 10) return '****';
    return '${key.substring(0, 5)}****${key.substring(key.length - 4)}';
  }

  /// 日志里截断长文本，避免刷屏。
  static String _preview(String text, [int max = 60]) {
    final String flat = text.replaceAll('\n', r'\n');
    return flat.length <= max ? flat : '${flat.substring(0, max)}…';
  }

  Future<List<String>> fetchModels(AiConfigDto config) async {
    final String url = resolveModelsUrl(config.apiUrl);
    if (url.isEmpty) {
      throw const AiRequestException('API URL is empty');
    }

    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        url,
        options: Options(headers: _headers(config)),
      );
      return _parseModelIds(response.data);
    } on DioException catch (error) {
      throw AiRequestException(
        _serverMessage(error.response?.data) ??
            error.message ??
            error.type.name,
        statusCode: error.response?.statusCode,
      );
    }
  }

  /// 以流式方式发送一条测试消息，逐段吐出服务端返回的文本。
  ///
  /// 请求体与事件解析对齐 JSXPOSEDX 的三套协议适配器：
  /// `openai.chat.v1`、`openai.responses.v1`、`anthropic.messages.v1`。
  /// 失败不抛异常，而是以 [AiChatProbeFailed] 结束，附带原始返回，
  /// 让用户能在测试窗口里看到真实报错。
  Stream<AiChatProbeEvent> streamTestMessage(
    AiConfigDto config,
    String message,
  ) async* {
    final String url = resolveChatUrl(config.apiUrl, config.apiType);
    final Stopwatch watch = Stopwatch()..start();
    final Map<String, dynamic> requestBody = _chatBody(config, message);

    if (url.isEmpty) {
      _log('✗ API URL is empty (raw="${config.apiUrl}")');
      yield const AiChatProbeFailed(message: 'API URL is empty');
      return;
    }

    _log('→ POST $url');
    _log('  apiType=${config.apiType.name} model=${config.modelName} '
        'maxToken=$_probeMaxTokens temperature=${config.temperature}');
    _log('  apiKey=${_maskKey(config.apiKey)} '
        'message=${_preview(message)}');
    _log('  body=${jsonEncode(requestBody)}');

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
      watch.stop();
      _log('✗ DioException type=${error.type.name} '
          'msg=${error.message} status=${error.response?.statusCode} '
          'at ${watch.elapsedMilliseconds}ms');
      yield AiChatProbeFailed(
        message: error.message ?? error.type.name,
        requestUrl: url,
        statusCode: error.response?.statusCode,
        duration: watch.elapsed,
      );
      return;
    }

    final ResponseBody body = response.data!;
    final int? status = response.statusCode;

    _log('← status=$status at ${watch.elapsedMilliseconds}ms '
        'content-type=${response.headers.value('content-type')} '
        'transfer-encoding=${response.headers.value('transfer-encoding')} '
        'content-encoding=${response.headers.value('content-encoding')}');

    // 非 2xx：整段读出正文当错误信息。
    if (status == null || status < 200 || status >= 300) {
      final String raw = _pretty(await _readAll(body));
      watch.stop();
      _log('✗ HTTP $status raw=${_preview(raw, 300)}');
      yield AiChatProbeFailed(
        message: _errorDetail(_tryDecode(raw)) ?? 'HTTP $status',
        rawBody: raw,
        requestUrl: url,
        statusCode: status,
        duration: watch.elapsed,
      );
      return;
    }

    yield AiChatProbeStarted(requestUrl: url, statusCode: status);

    // 服务端若忽略 stream 参数，会直接返回整段 JSON，这里收集起来兜底。
    final StringBuffer plain = StringBuffer();
    final StringBuffer rawSse = StringBuffer();
    final StringBuffer answer = StringBuffer();
    bool sawSse = false;
    bool terminal = false;
    int chunkIndex = 0;

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
          _log('  [${watch.elapsedMilliseconds}ms] [DONE]');
          break;
        }

        final Object? decoded = _tryDecode(data);
        final Map<String, Object?>? payload = decoded is Map
            ? Map<String, Object?>.from(decoded)
            : null;

        // 流内报错（额度不足、模型不存在、网关业务错误信封）立即中断。
        if (_payloadIsError(payload, event.event)) {
          watch.stop();
          _log('✗ stream error at ${watch.elapsedMilliseconds}ms '
              '${_preview(rawSse.toString(), 300)}');
          yield AiChatProbeFailed(
            message: _errorDetail(payload) ?? 'Stream error',
            rawBody: _pretty(rawSse.toString()),
            requestUrl: url,
            statusCode: status,
            duration: watch.elapsed,
          );
          return;
        }

        final _ProbeFrame frame = _readFrame(
          config.apiType,
          payload,
          event.event,
        );
        if (frame.terminal) terminal = true;
        if (frame.text.isEmpty) {
          _log('  [${watch.elapsedMilliseconds}ms] skip ${_preview(data)}');
          continue;
        }

        chunkIndex += 1;
        _log('  [${watch.elapsedMilliseconds}ms] chunk#$chunkIndex '
            '${frame.text.length} chars: ${_preview(frame.text)}');
        answer.write(frame.text);
        yield AiChatProbeDelta(frame.text);
      }
    } on FormatException catch (error) {
      // 事件结构损坏或单事件超出上限，按协议错误处理。
      watch.stop();
      _log('✗ protocol malformed: ${error.message}');
      yield AiChatProbeFailed(
        message: 'Protocol malformed: ${error.message}',
        rawBody: _pretty(rawSse.toString()),
        requestUrl: url,
        statusCode: status,
        duration: watch.elapsed,
      );
      return;
    }

    if (!sawSse && plain.isNotEmpty) {
      // 整段 JSON：先看是不是错误信封，再按协议取正文。
      final Object? decoded = _tryDecode(plain.toString());
      _log('  non-stream body ${plain.length} chars: '
          '${_preview(plain.toString(), 200)}');
      if (_payloadIsError(
        decoded is Map ? Map<String, Object?>.from(decoded) : null,
        null,
      )) {
        watch.stop();
        yield AiChatProbeFailed(
          message: _errorDetail(decoded) ?? 'Request failed',
          rawBody: _pretty(plain.toString()),
          requestUrl: url,
          statusCode: status,
          duration: watch.elapsed,
        );
        return;
      }
      final String reply = _parseReply(decoded, config.apiType);
      if (reply.isEmpty) {
        watch.stop();
        yield AiChatProbeFailed(
          message: 'Unexpected response',
          rawBody: _pretty(plain.toString()),
          requestUrl: url,
          statusCode: status,
          duration: watch.elapsed,
        );
        return;
      }
      answer.write(reply);
      yield AiChatProbeDelta(reply);
    }

    watch.stop();
    _log('✓ done in ${watch.elapsedMilliseconds}ms, sse=$sawSse, '
        'terminal=$terminal, chunks=$chunkIndex, '
        'answer=${answer.length} chars');

    if (answer.isEmpty) {
      final String raw = sawSse ? rawSse.toString() : plain.toString();
      _log('✗ empty answer, raw=${_preview(raw, 300)}');
      yield AiChatProbeFailed(
        message: terminal ? 'Empty response' : 'Protocol truncated',
        rawBody: raw.isEmpty ? '' : _pretty(raw),
        requestUrl: url,
        statusCode: status,
        duration: watch.elapsed,
      );
      return;
    }

    if (!terminal) {
      // 部分网关直接断连而不发终止事件，正文已完整时不判失败，只记日志。
      _log('! stream ended without terminal event');
    }

    yield AiChatProbeFinished(
      requestUrl: url,
      statusCode: status,
      duration: watch.elapsed,
      streamed: sawSse,
    );
  }

  /// 把用户填写的地址补全成模型目录地址。
  ///
  /// 兼容 `https://host`、`https://host/v1`、`https://host/v1/chat/completions`
  /// 以及已经写到 `/models` 的几种写法。
  static String resolveModelsUrl(String raw) {
    final String base = _normalizeBase(raw);
    if (base.isEmpty) return '';
    if (base.endsWith('/models')) return base;
    if (base.endsWith('/v1')) return '$base/models';
    return '$base/v1/models';
  }

  /// 把用户填写的地址补全成对话地址，端点按协议区分。
  static String resolveChatUrl(String raw, AiApiType apiType) {
    final String base = _normalizeBase(raw);
    if (base.isEmpty) return '';
    final String endpoint = switch (apiType) {
      AiApiType.openai => '/chat/completions',
      AiApiType.openaiResponses => '/responses',
      AiApiType.anthropic => '/messages',
    };
    if (base.endsWith(endpoint)) return base;
    if (base.endsWith('/v1')) return '$base$endpoint';
    return '$base/v1$endpoint';
  }

  /// 去掉末尾斜杠与已写死的对话端点，得到 base。
  static String _normalizeBase(String raw) {
    String base = raw.trim();
    if (base.isEmpty) return '';
    base = base.replaceAll(RegExp(r'/+$'), '');

    const List<String> endpointSuffixes = <String>[
      '/chat/completions',
      '/completions',
      '/responses',
      '/messages',
    ];
    for (final String suffix in endpointSuffixes) {
      if (base.endsWith(suffix)) {
        base = base.substring(0, base.length - suffix.length);
        break;
      }
    }
    return base;
  }

  /// 组装测试消息的请求体，各协议的字段略有差异。
  Map<String, dynamic> _chatBody(AiConfigDto config, String message) {
    const int maxTokens = _probeMaxTokens;
    final List<Map<String, String>> messages = <Map<String, String>>[
      <String, String>{'role': 'user', 'content': message},
    ];

    return switch (config.apiType) {
      AiApiType.openai => <String, dynamic>{
        'model': config.modelName,
        'messages': messages,
        'max_tokens': maxTokens,
        // temperature 未配置时是 -1，直接下发会被服务端判为非法值。
        if (config.temperature >= 0) 'temperature': config.temperature,
        'stream': true,
      },
      // Responses 协议用 input 输入项数组取代 messages，
      // 文本片段要包成 input_text，max_tokens 改为 max_output_tokens。
      AiApiType.openaiResponses => <String, dynamic>{
        'model': config.modelName,
        'input': <Map<String, dynamic>>[
          <String, dynamic>{
            'role': 'user',
            'content': <Map<String, String>>[
              <String, String>{'type': 'input_text', 'text': message},
            ],
          },
        ],
        'max_output_tokens': maxTokens,
        if (config.temperature >= 0) 'temperature': config.temperature,
        'stream': true,
      },
      // Anthropic 的 max_tokens 为必填项。
      AiApiType.anthropic => <String, dynamic>{
        'model': config.modelName,
        'messages': messages,
        'max_tokens': maxTokens,
        if (config.temperature >= 0) 'temperature': config.temperature,
        'stream': true,
      },
    };
  }

  /// 把整个流读成字符串，用于非 2xx 时取错误正文。
  Future<String> _readAll(ResponseBody body) async {
    final List<int> bytes = <int>[];
    await for (final List<int> chunk in body.stream) {
      bytes.addAll(chunk);
    }
    return utf8.decode(bytes, allowMalformed: true);
  }

  /// 尝试解析 JSON，失败时原样返回字符串。
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
  /// 与服务端「忽略 stream 直接返回整段 JSON」的情况兼容：
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

  /// 按协议读取单个事件：返回正文增量与是否已到终止态。
  _ProbeFrame _readFrame(
    AiApiType apiType,
    Map<String, Object?>? payload,
    String? event,
  ) {
    if (payload == null) return const _ProbeFrame();

    switch (apiType) {
      case AiApiType.openai:
        final Object? choices = payload['choices'];
        if (choices is! List || choices.isEmpty || choices.first is! Map) {
          return const _ProbeFrame();
        }
        final Map<String, Object?> choice = Map<String, Object?>.from(
          choices.first as Map,
        );
        final Object? delta = choice['delta'];
        final String text = delta is Map
            ? (delta['content']?.toString() ?? '')
            : '';
        return _ProbeFrame(
          text: text,
          terminal: _isFinishReason(choice['finish_reason']),
        );

      case AiApiType.openaiResponses:
        // 正文只在 output_text.delta 里，reasoning_* 属于思考过程不计入。
        final String type = payload['type']?.toString() ?? event ?? '';
        return switch (type) {
          'response.output_text.delta' => _ProbeFrame(
            text: payload['delta']?.toString() ?? '',
          ),
          'response.completed' || 'response.incomplete' =>
            const _ProbeFrame(terminal: true),
          _ => const _ProbeFrame(),
        };

      case AiApiType.anthropic:
        final String type = payload['type']?.toString() ?? event ?? '';
        switch (type) {
          case 'content_block_delta':
            final Object? delta = payload['delta'];
            if (delta is! Map || delta['type'] != 'text_delta') {
              return const _ProbeFrame();
            }
            return _ProbeFrame(text: delta['text']?.toString() ?? '');
          case 'message_delta':
            final Object? delta = payload['delta'];
            return _ProbeFrame(
              terminal: delta is Map && delta['stop_reason'] != null,
            );
          case 'message_stop':
            return const _ProbeFrame(terminal: true);
          default:
            return const _ProbeFrame();
        }
    }
  }

  /// OpenAI 的 finish_reason 只有已知取值才代表正常终止。
  bool _isFinishReason(Object? value) => switch (value?.toString()) {
    'stop' || 'length' || 'tool_calls' || 'content_filter' => true,
    _ => false,
  };

  /// 识别错误信封：`error` 键、`status` 值、以及 `code + message` 的网关业务错误。
  ///
  /// 部分网关在 HTTP 200 的流内直接下发业务错误（如
  /// `{"code":30001,"message":"..."}`），既无 `error` 也无 `status`，
  /// 正常 chunk 不会同时带 code+message 且缺少 `choices`，以此区分。
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

  /// 把返回体格式化成带缩进的 JSON，便于阅读。
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

  /// 从返回体中提取回复文本，提取不到时返回空串。
  String _parseReply(Object? data, AiApiType apiType) {
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
        // 部分实现会直接给出聚合好的 output_text。
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
            // reasoning_text / summary_text 是思考过程，只取正文片段。
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
          // thinking / tool_use 条目也带字段，只取 text 类型的正文。
          if (item is! Map || item['type'] != 'text') continue;
          final String text = (item['text'] ?? '').toString();
          if (text.isNotEmpty) parts.add(text);
        }
        return parts.join('\n').trim();
    }
  }

  /// 兼容 content 为字符串或分段数组两种返回形式。
  String _contentToText(Object? content) {
    if (content is String) return content.trim();
    if (content is List) {
      final List<String> parts = <String>[];
      for (final Object? item in content) {
        if (item is Map && item['text'] != null) {
          parts.add(item['text'].toString());
        } else if (item is String) {
          parts.add(item);
        }
      }
      return parts.join('\n').trim();
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

  /// 流式请求头：显式声明 SSE，并禁用压缩与缓存，避免网关把整段回复攒完再下发。
  Map<String, String> _streamHeaders(AiConfigDto config) => <String, String>{
    'Accept': 'text/event-stream',
    'Cache-Control': 'no-cache',
    'Accept-Encoding': 'identity',
    ..._headers(config),
  };

  List<String> _parseModelIds(Object? data) {
    final List<Object?> items = switch (data) {
      final Map<dynamic, dynamic> map when map['data'] is List =>
        (map['data'] as List<dynamic>).cast<Object?>(),
      final Map<dynamic, dynamic> map when map['models'] is List =>
        (map['models'] as List<dynamic>).cast<Object?>(),
      final List<dynamic> list => list.cast<Object?>(),
      _ => const <Object?>[],
    };

    final List<String> ids = <String>[];
    for (final Object? item in items) {
      final String id = switch (item) {
        final Map<dynamic, dynamic> map => (map['id'] ?? map['name'] ?? '')
            .toString()
            .trim(),
        _ => item?.toString().trim() ?? '',
      };
      if (id.isNotEmpty) ids.add(id);
    }
    ids.sort();
    return ids;
  }

  String? _serverMessage(Object? data) {
    if (data is Map) {
      final Object? error = data['error'];
      if (error is Map) {
        final String message = (error['message'] ?? '').toString().trim();
        if (message.isNotEmpty) return message;
      }
      if (error != null) {
        final String message = error.toString().trim();
        if (message.isNotEmpty) return message;
      }
      final String message = (data['message'] ?? '').toString().trim();
      if (message.isNotEmpty) return message;
    }
    if (data is String && data.trim().isNotEmpty) return data.trim();
    return null;
  }
}

/// 一个 SSE 事件：`data` 已按行拼好，其余为可选元字段。
class _SseEvent {
  const _SseEvent({required this.data, this.event, this.id, this.retry});

  final String data;
  final String? event;
  final String? id;
  final int? retry;
}

/// 单个事件解析结果：正文增量与是否已到终止态。
class _ProbeFrame {
  const _ProbeFrame({this.text = '', this.terminal = false});

  final String text;
  final bool terminal;
}
