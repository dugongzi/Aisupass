import 'dart:convert';
import 'dart:io';

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

/// 只替换 IO 两端的测试替身：清单由用例给定，设备身份由用例给定。
class _FakeDatasource extends EscalationQueryDatasource {
  _FakeDatasource({
    required this._payloads,
    required this._identity,
  }) : super(bundle: rootBundle, native: pigeon.DeviceIdentityNative());

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
}) => pigeon.DeviceIdentity(
  identityText: identityText,
  kernelRelease: '$kernelVersion-android14-11-g000000000000',
  kernelVersion: kernelVersion,
  kernelCommit: '000000000000',
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
}) => PayloadDto(
  id: id,
  library: library,
  vendor: 'vivo',
  displayName: displayName,
  models: models,
  kernelVersion: kernelVersion,
  size: 1,
  sha256: 'sha256',
  command: 'LD_PRELOAD=<payload> /system/bin/id',
);

void main() {
  group('载荷匹配验收（文档 §5.12）', () {
    late List<PayloadDto> catalog;

    setUpAll(() {
      final Map<String, dynamic> root =
          jsonDecode(File(_catalogPath).readAsStringSync())
              as Map<String, dynamic>;
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
