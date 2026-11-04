import 'package:Aisupass/core/providers/adb_shell_provider.dart';
import 'package:Aisupass/features/escalation/data/datasources/escalation_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/repositories/escalation_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_run_result.dart';
import 'package:Aisupass/features/escalation/domain/repositories/escalation_action_repository.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'escalation_action_provider.g.dart';

/// 提权链路执行数据源。
@riverpod
EscalationActionDatasource escalationActionDatasource(Ref ref) =>
    EscalationActionDatasource(native: ref.watch(adbShellNativeProvider));

/// 提权链路执行仓储。
@riverpod
EscalationActionRepository escalationActionRepository(Ref ref) =>
    EscalationActionRepositoryImpl(
      datasource: ref.watch(escalationActionDatasourceProvider),
      query: ref.watch(escalationQueryRepositoryProvider),
    );

/// 自动匹配并执行一次载荷提权。
///
/// 成功后刷新查询侧，避免 UI 还拿着旧的匹配结果。
@riverpod
Future<EscalationRunResult> runPayload(Ref ref) async {
  final EscalationRunResult result = await ref
      .watch(escalationActionRepositoryProvider)
      .runResolvedPayload();
  if (result.success) ref.invalidate(resolvedPayloadProvider);
  return result;
}
