import 'package:Aisupass/core/storage/storage_providers.dart';
import 'package:Aisupass/features/escalation/data/datasources/escalation_record_datasource.dart';
import 'package:Aisupass/features/escalation/data/repositories/escalation_record_repository_impl.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_run_record.dart';
import 'package:Aisupass/features/escalation/domain/repositories/escalation_record_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'escalation_record_provider.g.dart';

/// 运行记录数据源。
@riverpod
EscalationRecordDatasource escalationRecordDatasource(Ref ref) {
  return EscalationRecordDatasource(
    preferences: ref.watch(preferencesStoreProvider),
  );
}

/// 运行记录仓储。
@riverpod
EscalationRecordRepository escalationRecordRepository(Ref ref) {
  return EscalationRecordRepositoryImpl(
    datasource: ref.watch(escalationRecordDatasourceProvider),
  );
}

/// 历史运行记录，按开始时间倒序。
///
/// 只读；每次运行结束后由 `EscalationRunController` 主动失效。
@riverpod
Future<List<EscalationRunRecord>> escalationRecords(Ref ref) {
  return ref.watch(escalationRecordRepositoryProvider).loadAll();
}

/// 是否存在遗留状态，供页面横幅与快捷面板红点共用。
@riverpod
Future<bool> escalationResidual(Ref ref) {
  return ref.watch(escalationRecordRepositoryProvider).hasResidual();
}
