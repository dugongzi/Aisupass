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
          headers: <String, String>{
            ..._headers(config),
            // 明确声明接受事件流，否则部分网关会把整段回复缓存后一次性下发。
            'Accept': 'text/event-stream',
            'Cache-Control': 'no-cache',
            // 禁止压缩：gzip 会把 SSE 攒成块，配合 nginx 缓冲会等到结束才吐。
            'Accept-Encoding': 'identity',
          },
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
        message:
            error.message ?? error.type.name,
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
        message: _serverMessage(_tryDecode(raw)) ?? 'HTTP $status',
        rawBody: raw,
        requestUrl: url,
        statusCode: status,
        duration: watch.elapsed,
      );
      return;
    }

    yield AiChatProbeStarted(requestUrl: url, statusCode: status);

    // 服务端若忽略 stream 参数，会直接返回整段 JSON，这里做兜底。
    final StringBuffer plain = StringBuffer();
    final StringBuffer rawSse = StringBuffer();
    final StringBuffer answer = StringBuffer();
    bool sawSse = false;
    int chunkIndex = 0;
    int rawBytes = 0;

    final Stream<String> lines = const Utf8Decoder(allowMalformed: true)
        .bind(body.stream)
        .transform(const LineSplitter());

    await for (final String line in lines) {
      final String trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith(':')) continue;

      // SSE 的 event / id / retry 字段与正文无关，Anthropic 会大量发送。
      if (trimmed.startsWith('event:') ||
          trimmed.startsWith('id:') ||
          trimmed.startsWith('retry:')) {
        _log('  [${watch.elapsedMilliseconds}ms] sse-meta ${_preview(trimmed)}');
        continue;
      }

      if (!trimmed.startsWith('data:')) {
        plain.write(line);
        continue;
      }

      sawSse = true;
      if (rawSse.length < _maxRawLength) rawSse.writeln(trimmed);
      final String payload = trimmed.substring(5).trim();
      if (payload.isEmpty) continue;
      if (payload == '[DONE]') {
        _log('  [${watch.elapsedMilliseconds}ms] [DONE]');
        break;
      }

      final Object? decoded = _tryDecode(payload);
      // 流内报错（如额度不足、模型不存在）应立即中断并交给 UI 展示。
      if (decoded is Map && decoded['error'] != null) {
        watch.stop();
        _log('✗ stream error at ${watch.elapsedMilliseconds}ms '
            '${_preview(rawSse.toString(), 300)}');
        yield AiChatProbeFailed(
          message: _serverMessage(decoded) ?? 'Stream error',
          rawBody: _pretty(rawSse.toString()),
          requestUrl: url,
          statusCode: status,
          duration: watch.elapsed,
        );
        return;
      }

      final String delta = _deltaText(decoded, config.apiType);
      if (delta.isEmpty) {
        // 只有 role、usage 之类的非正文事件，记下来便于排查。
        _log('  [${watch.elapsedMilliseconds}ms] skip ${_preview(payload)}');
        continue;
      }
      chunkIndex += 1;
      rawBytes += payload.length;
      _log('  [${watch.elapsedMilliseconds}ms] chunk#$chunkIndex '
          '${delta.length} chars: ${_preview(delta)}');
      answer.write(delta);
      yield AiChatProbeDelta(delta);
    }

    if (!sawSse && plain.isNotEmpty) {
      final Object? decoded = _tryDecode(plain.toString());
      final String reply = _parseReply(decoded, config.apiType);
      _log('  non-stream body ${plain.length} chars: '
          '${_preview(plain.toString(), 200)}');
      if (reply.isEmpty) {
        watch.stop();
        yield AiChatProbeFailed(
          message: _serverMessage(decoded) ?? 'Unexpected response',
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
        'chunks=$chunkIndex, answer=${answer.length} chars, '
        'payload=$rawBytes chars');
    if (answer.isEmpty) {
      final String raw = sawSse ? rawSse.toString() : plain.toString();
      _log('✗ empty answer, raw=${_preview(raw, 300)}');
      yield AiChatProbeFailed(
        message: 'Empty response',
        rawBody: raw.isEmpty ? '' : _pretty(raw),
        requestUrl: url,
        statusCode: status,
        duration: watch.elapsed,
      );
      return;
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

  /// 组装测试消息的请求体，两种协议的字段略有差异。
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
        'temperature': config.temperature,
        'stream': true,
      },
      // Anthropic 的 max_tokens 为必填项。
      AiApiType.anthropic => <String, dynamic>{
        'model': config.modelName,
        'messages': messages,
        'max_tokens': maxTokens,
        'temperature': config.temperature,
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

  /// 从单个 SSE 事件里取出增量文本。
  String _deltaText(Object? data, AiApiType apiType) {
    if (data is! Map) return data is String ? data : '';

    switch (apiType) {
      case AiApiType.openai:
        final Object? choices = data['choices'];
        if (choices is! List || choices.isEmpty) return '';
        final Object? first = choices.first;
        if (first is! Map) return '';
        final Object? delta = first['delta'];
        if (delta is Map) return (delta['content'] ?? '').toString();
        // 少数实现会忽略 stream，直接给 message。
        final Object? message = first['message'];
        if (message is Map) return (message['content'] ?? '').toString();
        return '';

      case AiApiType.anthropic:
        if (data['type'] != 'content_block_delta') return '';
        final Object? delta = data['delta'];
        if (delta is Map) return (delta['text'] ?? '').toString();
        return '';
    }
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

      case AiApiType.anthropic:
        final Object? content = data['content'];
        if (content is! List) return '';
        final List<String> parts = <String>[];
        for (final Object? item in content) {
          if (item is Map && item['text'] != null) {
            parts.add(item['text'].toString());
          }
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
        AiApiType.openai => <String, String>{
          'Authorization': 'Bearer ${config.apiKey.trim()}',
          'Content-Type': 'application/json',
        },
        AiApiType.anthropic => <String, String>{
          'x-api-key': config.apiKey.trim(),
          'anthropic-version': '2023-06-01',
          'Content-Type': 'application/json',
        },
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
