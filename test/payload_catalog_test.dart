import 'dart:convert';
import 'dart:io';

import 'package:Aisupass/features/escalation/data/models/payload_dto.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:flutter_test/flutter_test.dart';

/// 载荷清单在仓库内的真实路径。
const String _catalogPath = 'assets/escalation/payloads/catalog.json';

/// 载荷 so 的落盘目录，与目录结构一一对应。
const String _jniLibsDir = 'android/app/src/main/jniLibs/arm64-v8a';

/// 文档 §3 认定的条目总数。执行助手 `libcve43499root.so` 不是载荷，不计入。
const int _entryCount = 126;

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
          .map(
            (Map<String, dynamic> entry) =>
                PayloadDto.fromJson(entry).toEntity(),
          )
          .toList();
    });

    test('126 条全部解析成功且 id 唯一', () {
      expect(payloads.length, _entryCount);
      expect(rawEntries.length, _entryCount);
      expect(
        payloads.map((Payload payload) => payload.id).toSet().length,
        _entryCount,
      );
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

    test('standalone 只标注在助手无法 dlopen 的条目上', () {
      final List<String> standaloneIds = payloads
          .where((Payload payload) => payload.standalone)
          .map((Payload payload) => payload.id)
          .toList();

      // 两条 `ET_EXEC`（不可 dlopen）+ 一条主体挂在 `DT_PREINIT_ARRAY` 的 PIE。
      expect(standaloneIds, <String>[
        'mi_k70u_os3',
        'mi_8g2_6m',
        'mi_mt6895_43499',
      ]);
      expect(
        payloads.where((Payload payload) => !payload.standalone).length,
        _entryCount - 3,
      );
    });

    test('kernelCommits 格式合法，且与 source 内嵌 commit 一致', () {
      final RegExp hex12 = RegExp(r'^[0-9a-f]{12}$');
      final RegExp sourceCommit = RegExp(r'-g([0-9a-f]{12})');
      int withCommit = 0;

      for (final Payload payload in payloads) {
        if (payload.kernelCommits.isEmpty) continue;
        withCommit++;

        // commit 是「内核版本相等」之外的额外闸门，未知内核的条目不该有。
        expect(payload.kernelUnknown, isFalse, reason: payload.id);
        for (final String commit in payload.kernelCommits) {
          expect(hex12.hasMatch(commit), isTrue, reason: '${payload.id}: $commit');
        }

        // source 里内嵌了 `-g<commit>` 的条目必须能对上。
        final String? inSource = sourceCommit
            .firstMatch(payload.source)
            ?.group(1);
        if (inSource != null) {
          expect(payload.kernelCommits, contains(inSource), reason: payload.id);
        }
      }

      // 只有 vivo 批次登记了 commit，共 31 条；其余为空集。
      expect(withCommit, 31);
      expect(
        payloads
            .where((Payload payload) => payload.kernelCommits.isNotEmpty)
            .every((Payload payload) => payload.vendor == 'vivo'),
        isTrue,
      );
    });

    test('kernelUnknown 只认 catalog 显式字段，null 内核不自动等于未知', () {
      for (int index = 0; index < rawEntries.length; index++) {
        final Object? rawKernel = rawEntries[index]['kernelVersion'];
        final Object? rawUnknown = rawEntries[index]['kernelUnknown'];
        final Payload payload = payloads[index];

        if (rawKernel == null) {
          expect(payload.kernelVersion, isEmpty, reason: payload.id);
        } else {
          expect(payload.kernelVersion, rawKernel, reason: payload.id);
        }

        // 未登记的条目按 `false` 处理；「内核未知」必须由 catalog 显式声明，
        // 不能从 `kernelVersion: null` 推出来 —— 后者正是「不限内核」的写法。
        expect(
          payload.kernelUnknown,
          rawUnknown ?? false,
          reason: payload.id,
        );
      }

      // 未知内核条目必须真实存在，否则这条断言形同虚设。
      expect(
        payloads.where((Payload payload) => payload.kernelUnknown),
        isNotEmpty,
      );
    });

    test('未知内核条目一律不得被当成「不限内核」', () {
      // `kernelAgnostic` 会把条目放进「内核版本相等」档，等于对任意内核放行；
      // 未知内核条目一旦被算成 agnostic，就会在任意设备上被自动命中。
      for (final Payload payload in payloads) {
        if (!payload.kernelUnknown) continue;
        expect(payload.kernelAgnostic, isFalse, reason: payload.id);
      }
    });

    test('只有手写批次允许「不限内核」，并入批次全部标为未知内核', () {
      final List<String> agnostic =
          payloads
              .where((Payload payload) => payload.kernelAgnostic)
              .map((Payload payload) => payload.id)
              .toList()
            ..sort();

      // 这 9 条来自手写批次：上游没有给它们设 `kernelUnknown`，语义是
      // 「不限内核」（其中 8 条 models 为空，本来就不会自动命中）。
      expect(agnostic, <String>[
        'libbs',
        'libionstack',
        'mi_8g2_6m',
        'mi_k70u_os3',
        'mi_mt6895_43499',
        'mi_sm8550_a',
        'mi_sm8650_a',
        'mi_sm8750_a',
        'vivo_iqoo12_a15',
      ]);

      // 另外 57 条是「内核未知 + 只允许手动选用」：56 条并入批次
      // （上游 `kernelUnknown = kernel == null`）+ 1 条显式声明的 w26。
      expect(
        payloads.where((Payload payload) => payload.kernelUnknown).length,
        57,
      );
    });
  });
}
