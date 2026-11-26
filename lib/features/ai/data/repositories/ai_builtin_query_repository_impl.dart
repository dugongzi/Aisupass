import 'package:Aisupass/core/network/api_exception.dart';
import 'package:Aisupass/features/ai/data/datasources/ai_builtin_query_datasource.dart';
import 'package:Aisupass/features/ai/data/models/ai_builtin_group_dto.dart';
import 'package:Aisupass/features/ai/domain/models/ai_builtin_group.dart';
import 'package:Aisupass/features/ai/domain/models/ai_builtin_wallet.dart';
import 'package:Aisupass/features/ai/domain/repositories/ai_builtin_query_repository.dart';

/// 内置面板的只读仓储实现：DTO -> Entity 的唯一转换点。
///
/// 分组可见性与倍率的合并都收敛在这里，数据源保持纯转发。
class AiBuiltinQueryRepositoryImpl implements AiBuiltinQueryRepository {
  const AiBuiltinQueryRepositoryImpl({required this._datasource});

  final AiBuiltinQueryDatasource _datasource;

  @override
  Future<List<AiBuiltinGroup>> getVisibleGroups({String token = ''}) async {
    final List<AiBuiltinGroupDto> plaza = await _datasource.fetchPlazaGroups();
    if (plaza.isEmpty) return const <AiBuiltinGroup>[];

    Set<int> allowed = const <int>{};
    Map<int, double> rates = const <int, double>{};
    if (token.trim().isNotEmpty) {
      // 这两项只影响过滤与排序，取不到就降级为空，不拦整条流程。
      try {
        allowed = await _datasource.fetchAvailableGroupIds(token: token);
      } on ApiException {
        allowed = const <int>{};
      }
      try {
        rates = await _datasource.fetchGroupRates(token: token);
      } on ApiException {
        rates = const <int, double>{};
      }
    }

    // 专属倍率覆盖广场上的通用倍率，账号实际按专属价计费。
    final List<AiBuiltinGroup> merged = <AiBuiltinGroup>[
      for (final AiBuiltinGroupDto dto in plaza)
        _withRate(dto.toEntity(), rates[dto.id]),
    ];

    // 可绑定集合为空（未登录、接口失败或不限制）时不过滤；
    // 过滤后为空说明两边数据不一致，退回全量避免把用户挡死。
    final List<AiBuiltinGroup> filtered = allowed.isEmpty
        ? merged
        : merged
              .where((AiBuiltinGroup group) => allowed.contains(group.id))
              .toList(growable: false);
    final List<AiBuiltinGroup> visible = filtered.isEmpty ? merged : filtered;

    final List<AiBuiltinGroup> sorted = List<AiBuiltinGroup>.of(visible)
      ..sort((AiBuiltinGroup a, AiBuiltinGroup b) {
        final int byRate = a.rateMultiplier.compareTo(b.rateMultiplier);
        return byRate != 0 ? byRate : a.id.compareTo(b.id);
      });
    return List<AiBuiltinGroup>.unmodifiable(sorted);
  }

  @override
  Future<AiBuiltinWallet> getWallet({required String token}) async =>
      (await _datasource.fetchWallet(token: token)).toEntity();

  @override
  Future<List<String>> getMyKeys({required String token}) =>
      _datasource.fetchMyKeys(token: token);

  @override
  Future<int> findKeyId({required String token, required String key}) =>
      _datasource.fetchKeyId(token: token, key: key);

  /// 覆盖倍率；[rate] 为 `null` 时保持广场原值。
  static AiBuiltinGroup _withRate(AiBuiltinGroup group, double? rate) =>
      rate == null ? group : group.copyWith(rateMultiplier: rate);
}
