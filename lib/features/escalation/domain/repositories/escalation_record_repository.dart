import 'package:Aisupass/features/escalation/domain/models/escalation_run_record.dart';

/// 提权运行记录仓储，负责本地历史与遗留状态判定。
abstract class EscalationRecordRepository {
  /// 读取全部记录，按开始时间倒序。
  Future<List<EscalationRunRecord>> loadAll();

  /// 写入一条记录，同 runId 覆盖。
  Future<void> save(EscalationRunRecord record);

  /// 是否存在遗留状态（有未结束的运行，或上次运行标记了残留）。
  Future<bool> hasResidual();

  /// 清空全部记录。
  Future<void> clear();
}
