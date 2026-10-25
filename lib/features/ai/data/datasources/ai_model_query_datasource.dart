import 'package:Aisupass/features/ai/data/models/ai_config_dto.dart';
import 'package:Aisupass/features/ai/domain/enums/ai_api_type.dart';
import 'package:dio/dio.dart';

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

  /// 把用户填写的地址补全成模型目录地址。
  ///
  /// 兼容 `https://host`、`https://host/v1`、`https://host/v1/chat/completions`
  /// 以及已经写到 `/models` 的几种写法。
  static String resolveModelsUrl(String raw) {
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

    if (base.endsWith('/models')) return base;
    if (base.endsWith('/v1')) return '$base/models';
    return '$base/v1/models';
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
