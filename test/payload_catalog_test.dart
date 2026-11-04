import 'dart:convert';
import 'dart:io';

import 'package:Aisupass/features/escalation/data/models/payload_dto.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:flutter_test/flutter_test.dart';

/// 载荷清单在仓库内的真实路径。
const String _catalogPath = 'assets/escalation/payloads/catalog.json';

/// 载荷 so 的落盘目录，与目录结构一一对应。
const String _jniLibsDir = 'android/app/src/main/jniLibs/arm64-v8a';

/// 文档 §3 认定的条目总数。
const int _entryCount = 127;

List<Map<String, dynamic>> _loadRawEntries() {
  final String raw = File(_catalogPath).readAsStringSync();
  final Map<String, dynamic> root = jsonDecode(raw) as Map<String, dynamic>;
  return (root['entries'] as List<dynamic>)
      .map((dynamic entry) => entry as Map<String, dynamic>)
      .toList();
}

void main() {
  group('载荷清单解析验收（文档 §5.4）', () {
    late List<Map<String, dynamic>> rawEntries;
    late List<Payload> payloads;

    setUpAll(() {
      rawEntries = _loadRawEntries();
      payloads = rawEntries
          .map((Map<String, dynamic> entry) => PayloadDto.fromJson(entry).toEntity())
          .toList();
    });

    test('127 条全部解析成功且 id 唯一', () {
      expect(payloads.length, _entryCount);
      expect(rawEntries.length, _entryCount);
      expect(payloads.map((Payload payload) => payload.id).toSet().length, _entryCount);
    });

    test('library 与 sha256 非空', () {
      for (final Payload payload in payloads) {
        expect(payload.library, isNotEmpty, reason: payload.id);
        expect(payload.sha256, isNotEmpty, reason: payload.id);
      }
    });

    test('size 与实体文件长度一致', () {
      for (final Payload payload in payloads) {
        final File file = File('$_jniLibsDir/${payload.library}');
        expect(file.existsSync(), isTrue, reason: payload.library);
        expect(file.lengthSync(), payload.size, reason: payload.library);
      }
    });

    test('kernelVersion 为 null 的条目在实体侧 kernelUnknown 为 true', () {
      for (int index = 0; index < rawEntries.length; index++) {
        final Object? rawKernel = rawEntries[index]['kernelVersion'];
        final Payload payload = payloads[index];

        if (rawKernel == null) {
          expect(payload.kernelVersion, isEmpty, reason: payload.id);
          expect(payload.kernelUnknown, isTrue, reason: payload.id);
        } else {
          expect(payload.kernelVersion, rawKernel, reason: payload.id);
          expect(payload.kernelUnknown, isFalse, reason: payload.id);
        }
      }

      // 未知内核条目必须真实存在，否则这条断言形同虚设。
      expect(
        payloads.where((Payload payload) => payload.kernelUnknown),
        isNotEmpty,
      );
    });
  });
}
