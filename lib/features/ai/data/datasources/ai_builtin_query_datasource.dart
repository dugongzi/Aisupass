import 'package:Aisupass/core/network/api_client.dart';
import 'package:Aisupass/core/network/api_exception.dart';
import 'package:Aisupass/features/ai/data/models/ai_builtin_group_dto.dart';
import 'package:Aisupass/features/ai/data/models/ai_builtin_wallet_dto.dart';
import 'package:Aisupass/features/ai/domain/constants/builtin_ai_config.dart';

/// 内置面板的只读数据源。
///
/// 只负责发请求与把响应体解析成 DTO，不做「哪个分组该显示」这类判断，
/// 也不把异常吞成空集合：失败一律由 `ApiClient` 抛给上层。
class AiBuiltinQueryDatasource {
  AiBuiltinQueryDatasource({ApiClient? client})
    : _client = client ?? ApiClient(baseUrl: builtinAiConfigBaseUrl);

  final ApiClient _client;

  /// 读当前账户的额度信息，需要登录令牌。
  Future<AiBuiltinWalletDto> fetchWallet({required String token}) async {
    final Object? data = await _client.get(
      '$builtinAiConfigApiPath/auth/me',
      token: token,
    );
    final Map<String, dynamic>? map = _asMap(data);
    if (map == null) {
      throw const ApiException('账户信息响应格式异常');
    }
    return AiBuiltinWalletDto.fromJson(map);
  }

  /// 读模型广场：匿名即可访问，返回全部分组及各分组的模型清单。
  Future<List<AiBuiltinGroupDto>> fetchPlazaGroups() async {
    final Object? data = await _client.get(
      '$builtinAiConfigApiPath/model-plaza',
    );
    if (data is! Map) return const <AiBuiltinGroupDto>[];
    final Object? groups = data['groups'];
    if (groups is! List) return const <AiBuiltinGroupDto>[];

    final List<AiBuiltinGroupDto> result = <AiBuiltinGroupDto>[];
    for (final Object? item in groups) {
      final Map<String, dynamic>? map = _asMap(item);
      if (map == null) continue;
      result.add(AiBuiltinGroupDto.fromJson(map));
    }
    return List<AiBuiltinGroupDto>.unmodifiable(result);
  }

  /// 读当前账号可绑定的分组 id 集合，需要登录令牌。
  Future<Set<int>> fetchAvailableGroupIds({required String token}) async {
    final Object? data = await _client.get(
      '$builtinAiConfigApiPath/groups/available',
      token: token,
    );
    if (data is! List) return <int>{};

    final Set<int> ids = <int>{};
    for (final Object? item in data) {
      final Map<String, dynamic>? map = _asMap(item);
      if (map == null) continue;
      final int id = _asInt(map['id']);
      if (id > 0) ids.add(id);
    }
    return ids;
  }

  /// 读当前账号的分组专属倍率，键为分组 id。
  ///
  /// 服务端返回 `{group_id: multiplier}`；也兼容每项是对象、
  /// 倍率放在 `rate_multiplier` / `multiplier` 字段里的形态。
  Future<Map<int, double>> fetchGroupRates({required String token}) async {
    final Object? data = await _client.get(
      '$builtinAiConfigApiPath/groups/rates',
      token: token,
    );
    if (data is! Map) return <int, double>{};

    final Map<int, double> rates = <int, double>{};
    data.forEach((Object? key, Object? value) {
      final int id = _asInt(key);
      if (id <= 0) return;
      final double? rate = _asRate(value);
      if (rate != null) rates[id] = rate;
    });
    return rates;
  }

  /// 读当前账号已有的 API Key 明文列表，供「使用已有密钥」选择。
  ///
  /// 列表接口可能返回分页信封（`{items:[...]}`）或直接是数组，两种都兼容。
  Future<List<String>> fetchMyKeys({required String token}) async {
    final Object? data = await _client.get(
      '$builtinAiConfigApiPath/keys',
      token: token,
    );

    final List<Object?> items;
    if (data is List) {
      items = data;
    } else if (data is Map && data['items'] is List) {
      items = data['items'] as List<Object?>;
    } else {
      return const <String>[];
    }

    final List<String> keys = <String>[];
    for (final Object? item in items) {
      final Map<String, dynamic>? map = _asMap(item);
      if (map == null) continue;
      final Object? key = map['key'];
      if (key is! String) continue;
      final String trimmed = key.trim();
      if (trimmed.isNotEmpty) keys.add(trimmed);
    }
    return List<String>.unmodifiable(keys);
  }

  /// 用明文密钥在密钥列表里定位它的 id，找不到返回 `0`。
  ///
  /// 面板换分组打的是 `PUT /keys/:id`，而本地只存了明文密钥，
  /// 因此按明文在一页列表里匹配一次。内置流程新建的密钥总是最新的，
  /// 取第一页（100 条）足以覆盖。
  Future<int> fetchKeyId({required String token, required String key}) async {
    final String target = key.trim();
    if (target.isEmpty) return 0;

    final Object? data = await _client.get(
      '$builtinAiConfigApiPath/keys',
      query: const <String, dynamic>{'page': 1, 'page_size': 100},
      token: token,
    );

    final List<Object?> items;
    if (data is List) {
      items = data;
    } else if (data is Map && data['items'] is List) {
      items = data['items'] as List<Object?>;
    } else {
      return 0;
    }

    for (final Object? item in items) {
      final Map<String, dynamic>? map = _asMap(item);
      if (map == null) continue;
      final Object? key = map['key'];
      if (key is! String || key.trim() != target) continue;
      return _asInt(map['id']);
    }
    return 0;
  }

  /// 把 JSON 对象转成字符串键的 Map；类型不符返回 `null`。
  static Map<String, dynamic>? _asMap(Object? raw) {
    if (raw is! Map) return null;
    return raw.map(
      (Object? key, Object? value) => MapEntry(key.toString(), value),
    );
  }

  /// 宽松取整数：兼容数字与数字字符串。
  static int _asInt(Object? raw) {
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    if (raw is String) return int.tryParse(raw.trim()) ?? 0;
    return 0;
  }

  /// 宽松取倍率：兼容数字、数字字符串与带字段的对象。
  static double? _asRate(Object? raw) {
    if (raw is num) return raw.toDouble();
    if (raw is String) return double.tryParse(raw.trim());
    final Map<String, dynamic>? map = _asMap(raw);
    if (map == null) return null;
    return _asRate(map['rate_multiplier'] ?? map['multiplier']);
  }
}
