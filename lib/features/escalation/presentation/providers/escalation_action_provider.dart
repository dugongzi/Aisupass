import 'package:Aisupass/core/providers/adb_shell_provider.dart';
import 'package:Aisupass/core/storage/storage_providers.dart';
import 'package:Aisupass/features/escalation/data/datasources/escalation_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/repositories/escalation_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/domain/enums/root_manager.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_run_result.dart';
import 'package:Aisupass/features/escalation/domain/models/handoff_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/payload_match.dart';
import 'package:Aisupass/features/escalation/domain/repositories/escalation_action_repository.dart';
import 'package:Aisupass/features/escalation/domain/repositories/escalation_query_repository.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'escalation_action_provider.g.dart';

/// 提权链路执行数据源。
@riverpod
EscalationActionDatasource escalationActionDatasource(Ref ref) =>
    EscalationActionDatasource(
      native: ref.watch(adbShellNativeProvider),
      storage: ref.watch(preferencesStoreProvider),
    );

/// 提权链路执行仓储。
@riverpod
EscalationActionRepository escalationActionRepository(Ref ref) =>
    EscalationActionRepositoryImpl(
      datasource: ref.watch(escalationActionDatasourceProvider),
    );

/// 自动匹配并执行一次载荷提权。
///
/// 「选哪份」归查询仓储，「跑」归执行仓储，两者的装配只在这里发生。
/// 成功后刷新查询侧，避免 UI 还拿着旧的匹配结果。
@riverpod
Future<EscalationRunResult> runPayload(Ref ref) async {
  final EscalationQueryRepository query = ref.watch(
    escalationQueryRepositoryProvider,
  );
  final EscalationActionRepository action = ref.watch(
    escalationActionRepositoryProvider,
  );

  final PayloadMatch? match = await query.resolve();
  if (match == null) {
    return EscalationRunResult.failure('当前设备在载荷清单里没有候选');
  }

  final EscalationRunResult result = await action.runPayload(match.payload);
  if (result.success) ref.invalidate(resolvedPayloadProvider);
  return result;
}

/// 把临时 root 移交给用户选定的 [manager]。
///
/// 与 [runPayload] 分开是刻意的：提权拿到的一次性 root 与「谁接管」是两件
/// 事，上游也把移交做成了独立入口。移交必然失败于「管理器没装」，这种情况下
/// 返回的是 [HandoffKind.managerMissing] 而非异常，UI 直接渲染即可。
@riverpod
Future<HandoffOutcome> handoffRoot(Ref ref, {required RootManager manager}) =>
    ref.watch(escalationActionRepositoryProvider).handoffRoot(manager: manager);
