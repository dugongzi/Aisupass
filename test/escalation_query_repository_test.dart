import 'dart:convert';
import 'dart:io';

import 'package:Aisupass/core/storage/json_codec.dart';
import 'package:Aisupass/core/storage/key_value_store.dart';
import 'package:Aisupass/features/escalation/data/datasources/escalation_query_datasource.dart';
import 'package:Aisupass/features/escalation/data/models/payload_dto.dart';
import 'package:Aisupass/features/escalation/data/repositories/escalation_query_repository_impl.dart';
import 'package:Aisupass/features/escalation/domain/enums/match_tier.dart';
import 'package:Aisupass/features/escalation/domain/models/device_identity.dart';
import 'package:Aisupass/features/escalation/domain/models/payload_match.dart';
import 'package:Aisupass/generated/device_identity.g.dart' as pigeon;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

/// 载荷清单在仓库内的真实路径。
const String _catalogPath = 'assets/escalation/payloads/catalog.json';

/// 内存版键值存储。
class _FakeStore implements KeyValueStore {
  final Map<String, Object?> values = <String, Object?>{};

  @override
  Future<T> read<T>(
    String key, {
    T? defaultValue,
    JsonDecoder<T>? fromJson,
  }) async {
    final Object? raw = values[key];
    if (raw is T) return raw;
    if (defaultValue != null) return defaultValue;
    if (T == String) return '' as T;
    if (T == bool) return false as T;
    if (T == int) return -1 as T;
    if (T == double) return -1.0 as T;
    if (T == List<String>) return const <String>[] as T;
    throw StateError('缺少 defaultValue：$key');
  }

  @override
  Future<void> write<T>(String key, T value) async {
    values[key] = value;
  }

  @override
  Future<bool> containsKey(String key) async => values.containsKey(key);

  @override
  Future<Set<String>> keys() async => values.keys.toSet();

  @override
  Future<void> remove(String key) async {
    values.remove(key);
  }

  @override
  Future<void> clear() async {
    values.clear();
  }
}

/// 只替换 IO 两端的测试替身：清单由用例给定，设备身份由用例给定。
class _FakeDatasource extends EscalationQueryDatasource {
  _FakeDatasource({required this._payloads, required this._identity})
    : super(
        bundle: rootBundle,
        native: pigeon.DeviceIdentityNative(),
        storage: _FakeStore(),
      );

  final List<PayloadDto> _payloads;
  final pigeon.DeviceIdentity _identity;

  @override
  Future<List<PayloadDto>> loadPayloadCatalog() async => _payloads;

  @override
  Future<pigeon.DeviceIdentity> readDeviceIdentity() async => _identity;
}

pigeon.DeviceIdentity _identity({
  required String identityText,
  required String kernelVersion,
  String manufacturer = 'vivo',
  String model = '',
  String kernelCommit = '000000000000',
}) => pigeon.DeviceIdentity(
  identityText: identityText,
  kernelRelease: '$kernelVersion-android14-11-g$kernelCommit',
  kernelVersion: kernelVersion,
  kernelCommit: kernelCommit,
  manufacturer: manufacturer,
  model: model,
  pageSize: 4096,
);

EscalationQueryRepositoryImpl _repository({
  required List<PayloadDto> payloads,
  required pigeon.DeviceIdentity identity,
}) => EscalationQueryRepositoryImpl(
  datasource: _FakeDatasource(payloads: payloads, identity: identity),
);

/// 载荷实体数量断言用的最小构造：只关心匹配字段。
PayloadDto _entry({
  required String id,
  required List<String> models,
  required String displayName,
  required String kernelVersion,
  String library = 'libksu_test.so',
  List<String> kernelCommits = const <String>[],
}) => PayloadDto(
  id: id,
  library: library,
  vendor: 'vivo',
  displayName: displayName,
  models: models,
  kernelVersion: kernelVersion,
  kernelCommits: kernelCommits,
  size: 1,
  sha256: 'sha256',
  command: 'LD_PRELOAD=<payload> /system/bin/id',
);

void main() {
  group('载荷匹配验收（文档 §5.12）', () {
    late List<PayloadDto> catalog;

    setUpAll(() {
      final Map<String, dynamic> root = jsonDecode(
        File(_catalogPath).readAsStringSync(),
      ) as Map<String, dynamic>;
      catalog = (root['entries'] as List<dynamic>)
          .map(
            (dynamic entry) =>
                PayloadDto.fromJson(entry as Map<String, dynamic>),
          )
          .toList();
    });

    test('iQOO 13 + 6.6.89 走 6.6.89 特例，命中 libbs.so', () async {
      final PayloadMatch? match = await _repository(
        payloads: catalog,
        identity: _identity(
          identityText: 'vivo iqoo 13 v2463a',
          kernelVersion: '6.6.89',
        ),
      ).resolve();

      expect(match, isNotNull);
      expect(match!.tier, MatchTier.libbsOverride);
      expect(match.payload.library, 'libbs.so');
    });

    test('iQOO 13 + 6.6.57 同内核命中 vivo_iqoo13_6657_a', () async {
      // commit 用默认的 `000000000000`，与条目登记的 `da7e4eafe109` 不符，
      // 因此只能落在同内核档，不得升到精确档。
      final PayloadMatch? match = await _repository(
        payloads: catalog,
        identity: _identity(
          identityText: 'vivo iqoo 13 v2463a',
          kernelVersion: '6.6.57',
        ),
      ).resolve();

      expect(match, isNotNull);
      expect(match!.tier, MatchTier.sameKernel);
      expect(match.payload.id, 'vivo_iqoo13_6657_a');
    });

    test('iQOO 13 + 6.6.57 + commit 命中登记值走精确档', () async {
      final PayloadMatch? match = await _repository(
        payloads: catalog,
        identity: _identity(
          identityText: 'vivo iqoo 13 v2463a',
          kernelVersion: '6.6.57',
          kernelCommit: 'da7e4eafe109',
        ),
      ).resolve();

      expect(match, isNotNull);
      expect(match!.tier, MatchTier.exact);
      expect(match.payload.id, 'vivo_iqoo13_6657_a');
      expect(match.isDegraded, isFalse);
    });

    test('kernelCommits 为空集的条目永不进精确档', () async {
      final List<PayloadDto> crafted = <PayloadDto>[
        _entry(
          id: 'vivo_no_commit',
          displayName: 'iQOO 13',
          models: <String>['iqoo 13'],
          kernelVersion: '6.6.57',
        ),
      ];

      final PayloadMatch? match = await _repository(
        payloads: crafted,
        identity: _identity(
          identityText: 'vivo iqoo 13',
          kernelVersion: '6.6.57',
          kernelCommit: 'da7e4eafe109',
        ),
      ).resolve();

      expect(match, isNotNull);
      expect(match!.tier, MatchTier.sameKernel);
      expect(match.payload.id, 'vivo_no_commit');
    });

    test('同厂商兜底默认不执行，显式开启才产出候选', () async {
      final pigeon.DeviceIdentity identity = _identity(
        identityText: 'vivo mysteryphone',
        kernelVersion: '6.6.57',
      );

      final PayloadMatch? defaultResolve = await _repository(
        payloads: catalog,
        identity: identity,
      ).resolve();
      final PayloadMatch? fallback = await _repository(
        payloads: catalog,
        identity: identity,
      ).resolve(allowVendorFallback: true);

      expect(defaultResolve, isNull);
      expect(fallback, isNotNull);
      expect(fallback!.tier, MatchTier.vendorFallback);
    });

    test('iQOO 13 + 6.7.0 只落到同机型降级档', () async {
      final PayloadMatch? match = await _repository(
        payloads: catalog,
        identity: _identity(
          identityText: 'vivo iqoo 13 v2463a',
          kernelVersion: '6.7.0',
        ),
      ).resolve();

      expect(match, isNotNull);
      expect(match!.tier, MatchTier.similarDevice);
      expect(match.payload.models, contains('iqoo 13'));
    });

    test('Pixel 9a + 任意内核只能落在降级档', () async {
      final PayloadMatch? match = await _repository(
        payloads: catalog,
        identity: _identity(
          identityText: 'google pixel 9a tegu',
          kernelVersion: '6.6.57',
          manufacturer: 'google',
          model: 'tegu',
        ),
      ).resolve();

      expect(match, isNotNull);
      expect(match!.tier, MatchTier.similarDevice);
      expect(match.payload.id, 'google_tegu_any_1bc5');
    });

    test('完全未知机型 + 未知厂商返回 null，关掉兜底后同样 null', () async {
      final pigeon.DeviceIdentity identity = _identity(
        identityText: 'acme mysteryphone x1',
        kernelVersion: '6.6.57',
        manufacturer: 'acme',
      );

      final PayloadMatch? withFallback = await _repository(
        payloads: catalog,
        identity: identity,
      ).resolve();
      final PayloadMatch? withoutFallback = await _repository(
        payloads: catalog,
        identity: identity,
      ).resolve(allowVendorFallback: false);

      expect(withFallback, isNull);
      expect(withoutFallback, isNull);
    });

    test('未知小米机型 + 6.6.x 返回 null（无「机型 + 内核」组合）', () async {
      final PayloadMatch? match = await _repository(
        payloads: catalog,
        identity: _identity(
          identityText: 'xiaomi mysteryphone',
          kernelVersion: '6.6.30',
          manufacturer: 'xiaomi',
        ),
      ).resolve();

      expect(match, isNull);
    });

    test('iqoo neo10 pro+ 不命中只登记了 neo10 pro 的条目', () async {
      final List<PayloadDto> crafted = <PayloadDto>[
        _entry(
          id: 'vivo_neon10pro',
          displayName: 'iQOO Neo10 Pro',
          models: <String>['iqoo neo10 pro'],
          kernelVersion: '6.6.57',
        ),
        _entry(
          id: 'vivo_neon10proplus',
          displayName: 'iQOO Neo10 Pro+',
          models: <String>['iqoo neo10 pro+'],
          kernelVersion: '6.6.57',
        ),
      ];

      final PayloadMatch? match = await _repository(
        payloads: crafted,
        identity: _identity(
          identityText: 'vivo iqoo neo10 pro+',
          kernelVersion: '6.6.57',
        ),
      ).resolve();

      // 分词后 `pro+` 与 `pro` 是两个词，`pro` 那条不得被召回。
      expect(match, isNotNull);
      expect(match!.payload.id, 'vivo_neon10proplus');
    });
  });

  group('设备身份实体派生字段', () {
    test('kernelUnknown 与 kernelSeries 由 kernelVersion 推导', () {
      final DeviceIdentity unknown = DeviceIdentity(
        identityText: 'vivo iqoo 13',
        kernelRelease: '',
        kernelVersion: '',
        kernelCommit: '',
        manufacturer: 'vivo',
        model: 'V2463A',
        pageSize: 4096,
      );
      expect(unknown.kernelUnknown, isTrue);
      expect(unknown.kernelSeries, isEmpty);

      final DeviceIdentity known = DeviceIdentity(
        identityText: 'vivo iqoo 13',
        kernelRelease: '6.6.57-android14-11-g000000000000',
        kernelVersion: '6.6.57',
        kernelCommit: '000000000000',
        manufacturer: 'vivo',
        model: 'V2463A',
        pageSize: 4096,
      );
      expect(known.kernelUnknown, isFalse);
      expect(known.kernelSeries, '6.6');
    });
  });
}
