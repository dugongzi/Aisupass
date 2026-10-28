import 'package:Aisupass/features/escalation/data/datasources/escalation_record_datasource.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_run_record.dart';
import 'package:Aisupass/features/escalation/domain/repositories/escalation_record_repository.dart';

/// 运行记录仓储实现：同 runId 覆盖、按开始时间倒序、最多保留 20 条。
class EscalationRecordRepositoryImpl implements EscalationRecordRepository {
  const EscalationRecordRepositoryImpl({required this._datasource});

  final EscalationRecordDatasource _datasource;

  @override
  Future<List<EscalationRunRecord>> loadAll() => _datasource.loadAll();

  @override
  Future<void> save(EscalationRunRecord record) async {
    final List<EscalationRunRecord> current = await _datasource.loadAll();
    final List<EscalationRunRecord> updated = <EscalationRunRecord>[
      record,
      ...current.where(
        (EscalationRunRecord item) => item.runId != record.runId,
      ),
    ];
    await _datasource.writeAll(updated);
    if (record.residual) await _datasource.writeResidual(true);
  }

  @override
  Future<bool> hasResidual() async {
    final List<EscalationRunRecord> records = await _datasource.loadAll();
    if (records.any((EscalationRunRecord record) => record.isRunning)) {
      return true;
    }
    return _datasource.readResidual();
  }

  @override
  Future<void> clear() => _datasource.clear();
}
