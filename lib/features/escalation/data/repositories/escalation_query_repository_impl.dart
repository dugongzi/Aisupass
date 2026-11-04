import 'package:Aisupass/features/escalation/data/datasources/escalation_query_datasource.dart';
import 'package:Aisupass/features/escalation/data/models/device_identity_dto.dart';
import 'package:Aisupass/features/escalation/data/models/payload_dto.dart';
import 'package:Aisupass/features/escalation/domain/enums/match_tier.dart';
import 'package:Aisupass/features/escalation/domain/models/device_identity.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:Aisupass/features/escalation/domain/models/payload_match.dart';
import 'package:Aisupass/features/escalation/domain/repositories/escalation_query_repository.dart';
import 'package:Aisupass/generated/device_identity.g.dart' as pigeon;

/// 提权链路查询仓储实现：DTO -> Entity 的唯一转换点，
/// 同时承载不依赖 IO 的匹配算法。
class EscalationQueryRepositoryImpl implements EscalationQueryRepository {
  const EscalationQueryRepositoryImpl({
    required this._datasource,
  });

  final EscalationQueryDatasource _datasource;

  /// 机型关键词分隔符。`+` 与 `-` 是机型名的一部分，必须保留。
  static final RegExp _modelSeparator = RegExp(r'[^a-z0-9+\-]+');

  /// 6.6.89 特例：这几个机型共用 `libbs.so`。
  static const Map<String, Set<String>> _overrideToLibss = <String, Set<String>>{
    'iqoo neo10 pro+': <String>{'6.6.89'},
    'iqoo neo11': <String>{'6.6.89'},
    'iqoo 11': <String>{'6.6.89'},
    'iqoo 13': <String>{'6.6.89'},
  };

  /// 厂商别名归一。未登记的厂商直接放弃兜底。
  static const Map<String, String> _vendorAliases = <String, String>{
    'vivo': 'vivo',
    'iqoo': 'vivo',
    'xiaomi': 'xiaomi',
    'redmi': 'xiaomi',
    'poco': 'xiaomi',
  };

  /// `libbs.so` 对应的载荷文件名。
  static const String _libbsLibrary = 'libbs.so';

  @override
  Future<List<Payload>> listPayloads() async {
    final List<PayloadDto> dtos = await _datasource.loadPayloadCatalog();
    return dtos
        .map((PayloadDto dto) => dto.toEntity())
        .toList(growable: false);
  }

  @override
  Future<DeviceIdentity> deviceIdentity() async {
    final pigeon.DeviceIdentity native = await _datasource
        .readDeviceIdentity();
    return DeviceIdentityDto.fromNative(native).toEntity();
  }

  @override
  Future<PayloadMatch?> resolve({bool allowVendorFallback = true}) async {
    final List<Payload> all = await listPayloads();
    final DeviceIdentity device = await deviceIdentity();
    return _resolve(all, device, allowVendorFallback: allowVendorFallback);
  }

  @override
  Future<String> payloadPath(Payload payload) async {
    final String directory = await _datasource.readNativeLibraryDir();
    if (directory.isEmpty) return '';
    return '$directory/${payload.library}';
  }

  /// 机型关键词全中判定。分词后比较，不用子串匹配。
  bool _matchesModel(String keywordGroup, Set<String> haystack) {
    final List<String> parts = keywordGroup
        .toLowerCase()
        .split(_modelSeparator)
        .where((String part) => part.isNotEmpty)
        .toList();
    return parts.isNotEmpty && parts.every(haystack.contains);
  }

  /// 取 `libbs.so` 那条载荷；catalog 里没有则返回 `null`。
  Payload? _libbsPayload(List<Payload> all) {
    for (final Payload payload in all) {
      if (payload.library == _libbsLibrary) return payload;
    }
    return null;
  }

  /// 三档匹配：特例 -> 同内核 -> 同机型，最后才走厂商兜底。
  PayloadMatch? _resolve(
    List<Payload> all,
    DeviceIdentity device, {
    required bool allowVendorFallback,
  }) {
    final Set<String> haystack = device.identityText
        .toLowerCase()
        .split(_modelSeparator)
        .where((String part) => part.isNotEmpty)
        .toSet();

    // 第 0 步：6.6.89 特例，命中即返回 libbs.so。
    final Payload? libbs = _libbsPayload(all);
    if (libbs != null &&
        _overrideToLibss.entries.any(
          (MapEntry<String, Set<String>> entry) =>
              _matchesModel(entry.key, haystack) &&
              entry.value.contains(device.kernelVersion),
        )) {
      return PayloadMatch(payload: libbs, tier: MatchTier.libbsOverride);
    }

    // 候选：models 与 displayName 任一命中。
    final List<Payload> candidates = all
        .where(
          (Payload payload) => <String>[
            ...payload.models,
            payload.displayName,
          ].any((String group) => _matchesModel(group, haystack)),
        )
        .toList();

    if (candidates.isEmpty) {
      return allowVendorFallback ? _vendorFallback(all, device) : null;
    }

    // 档位一：内核版本相等。kernelUnknown 是硬闸门，必须先排除。
    for (final Payload payload in candidates) {
      if (!payload.kernelUnknown &&
          payload.kernelVersion == device.kernelVersion) {
        return PayloadMatch(payload: payload, tier: MatchTier.sameKernel);
      }
    }

    // 档位二：机型中、版本不等，优先非未知。
    final List<Payload> sorted = candidates.toList()
      ..sort(
        (Payload a, Payload b) => a.kernelUnknown == b.kernelUnknown
            ? 0
            : (a.kernelUnknown ? 1 : -1),
      );
    return PayloadMatch(payload: sorted.first, tier: MatchTier.similarDevice);
  }

  /// 厂商兜底：机型不中时，同厂商同版本取体积最小的一条。
  PayloadMatch? _vendorFallback(List<Payload> all, DeviceIdentity device) {
    final String? vendor = _vendorAliases[device.manufacturer.toLowerCase()];
    if (vendor == null) return null;

    // 允许的内核大版本白名单从数据现算，不硬编码。
    final bool seriesAllowed = all.any(
      (Payload payload) =>
          payload.vendor == vendor &&
          payload.models.isNotEmpty &&
          !payload.kernelUnknown &&
          payload.kernelSeries == device.kernelSeries,
    );
    if (!seriesAllowed) return null;

    final List<Payload> pool = all
        .where(
          (Payload payload) =>
              payload.vendor == vendor &&
              payload.kernelVersion == device.kernelVersion,
        )
        .toList();
    if (pool.isEmpty) return null;

    // 同厂商同版本取体积最小：覆盖最广的共同构建，失败面最小。
    pool.sort((Payload a, Payload b) => a.size.compareTo(b.size));
    return PayloadMatch(payload: pool.first, tier: MatchTier.vendorFallback);
  }
}
