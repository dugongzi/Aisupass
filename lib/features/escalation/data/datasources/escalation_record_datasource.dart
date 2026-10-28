import 'dart:convert';

import 'package:Aisupass/core/storage/preferences_store.dart';
import 'package:Aisupass/features/escalation/data/models/escalation_run_dto.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_run_record.dart';

/// 提权运行记录的本地数据源。
///
/// 整表以 JSON 字符串存一个键，遗留标记单独存一个布尔键；
/// 记录数量级在几十条以内，整表覆盖写足够，无需分片。
class EscalationRecordDatasource {
  const EscalationRecordDatasource({required this._preferences});

  /// 运行记录列表的存储键，值为 JSON 数组字符串。
  static const String listKey = 'escalation_runs';

  /// 遗留状态的存储键。
  static const String residualKey = 'escalation_residual';

  /// 最多保留的记录条数，避免 preferences 无限膨胀。
  static const int maxRecords = 20;

  final PreferencesStore _preferences;

  /// 读取全部记录，按开始时间倒序。
  ///
  /// 本地数据被外部破坏（JSON 非法 / 字段类型异常）时返回空表，
  /// 属于可预期的降级场景，不向页面抛异常。
  Future<List<EscalationRunRecord>> loadAll() async {
    final String raw = await _preferences.read<String>(
      listKey,
      defaultValue: '',
    );
    if (raw.trim().isEmpty) return const <EscalationRunRecord>[];

    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is! List) return const <EscalationRunRecord>[];

      final List<EscalationRunRecord> records = <EscalationRunRecord>[];
      for (final Object? item in decoded) {
        if (item is! Map) continue;
        final Map<String, dynamic> map = item.map(
          (Object? key, Object? value) => MapEntry(key.toString(), value),
        );
        final EscalationRunRecord? record = EscalationRunDto.fromJson(
          map,
        ).toEntity();
        if (record == null) continue;
        records.add(record);
      }
      records.sort(
        (EscalationRunRecord a, EscalationRunRecord b) =>
            b.startedAtMs.compareTo(a.startedAtMs),
      );
      return records;
    } catch (_) {
      return const <EscalationRunRecord>[];
    }
  }

  /// 整体覆盖写，超出 [maxRecords] 时从尾部（最旧）裁剪。
  Future<void> writeAll(List<EscalationRunRecord> records) async {
    final List<EscalationRunRecord> capped = records.length > maxRecords
        ? records.sublist(0, maxRecords)
        : records;
    final String raw = jsonEncode(
      capped
          .map(
            (EscalationRunRecord record) =>
                EscalationRunDto.fromEntity(record).toJson(),
          )
          .toList(growable: false),
    );
    await _preferences.write<String>(listKey, raw);
  }

  /// 读取遗留标记。
  Future<bool> readResidual() =>
      _preferences.read<bool>(residualKey, defaultValue: false);

  /// 写入遗留标记。
  Future<void> writeResidual(bool value) =>
      _preferences.write<bool>(residualKey, value);

  /// 清空记录与遗留标记。
  Future<void> clear() async {
    await _preferences.remove(listKey);
    await _preferences.remove(residualKey);
  }
}
