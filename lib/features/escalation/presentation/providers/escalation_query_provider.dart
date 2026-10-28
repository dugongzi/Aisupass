import 'package:Aisupass/core/providers/system_status_provider.dart';
import 'package:Aisupass/features/escalation/data/datasources/escalation_query_datasource.dart';
import 'package:Aisupass/features/escalation/data/repositories/escalation_query_repository_impl.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_capability_matrix.dart';
import 'package:Aisupass/features/escalation/domain/repositories/escalation_query_repository.dart';
import 'package:Aisupass/generated/escalation.g.dart' as pigeon;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'escalation_query_provider.g.dart';

/// 原生提权客户端。
///
/// 全工程只从这里取实例，保证宿主通道只有一份；Client 内部仅持有通道，
/// 重建开销可以忽略，因此不需要 `keepAlive`。
@riverpod
pigeon.EscalationNative escalationNative(Ref ref) => pigeon.EscalationNative();

/// 提权只读数据源。
///
/// rootCheck 的可用性复用现有 [rootStatusProvider]，原生只提供静态证据。
@riverpod
EscalationQueryDatasource escalationQueryDatasource(Ref ref) {
  return EscalationQueryDatasource(
    native: ref.watch(escalationNativeProvider),
    rootStatusReader: () => ref.read(rootStatusProvider.future),
  );
}

/// 提权只读仓储。
@riverpod
EscalationQueryRepository escalationQueryRepository(Ref ref) {
  return EscalationQueryRepositoryImpl(
    datasource: ref.watch(escalationQueryDatasourceProvider),
  );
}

/// 能力矩阵：进页面自动触发，**零副作用**。
///
/// 只调用原生 `probeAll`，不产生任何系统改动；页面每次进入重新探测，
/// 保证展示的是当前设备状态而不是上次缓存的结论。
@riverpod
Future<EscalationCapabilityMatrix> escalationCapabilityMatrix(Ref ref) {
  return ref.watch(escalationQueryRepositoryProvider).probeCapabilities();
}

/// 宿主连接状态：只读查询，**零副作用**。
///
/// M0 原生实现固定返回 `alive = false`，页面据此展示连接提示；
/// 通道未就绪或查询失败时同样降级为「未连接」，不向上抛异常。
@riverpod
Future<pigeon.HostStatus> escalationHostStatus(Ref ref) async {
  try {
    return await ref.watch(escalationNativeProvider).hostStatus();
  } catch (_) {
    return pigeon.HostStatus(alive: false, uid: 0, reconnectAttempts: 0);
  }
}
