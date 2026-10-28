import 'package:Aisupass/features/escalation/data/datasources/escalation_catalog_datasource.dart';
import 'package:Aisupass/features/escalation/data/repositories/escalation_catalog_repository_impl.dart';
import 'package:Aisupass/features/escalation/domain/repositories/escalation_catalog_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'escalation_catalog_provider.g.dart';

/// 资产目录快照。
///
/// M0 不随包提供任何载荷与内核配置，两个列表都为空；
/// 该结构留在表现层，避免为一个纯展示用的只读聚合类型污染领域层。
@immutable
class EscalationCatalog {
  const EscalationCatalog({
    required this.payloadIds,
    required this.kernelProfiles,
  });

  /// 可用载荷 id。
  final List<String> payloadIds;

  /// 可用内核配置名。
  final List<String> kernelProfiles;

  /// 是否没有任何资产；M0 恒为 `true`。
  bool get isEmpty => payloadIds.isEmpty && kernelProfiles.isEmpty;
}

/// 资产目录数据源。
@riverpod
EscalationCatalogDatasource escalationCatalogDatasource(Ref ref) {
  return EscalationCatalogDatasource();
}

/// 资产目录仓储。
@riverpod
EscalationCatalogRepository escalationCatalogRepository(Ref ref) {
  return EscalationCatalogRepositoryImpl(
    datasource: ref.watch(escalationCatalogDatasourceProvider),
  );
}

/// 读取资产目录，资产缺失时返回空目录而非报错。
@riverpod
Future<EscalationCatalog> escalationCatalog(Ref ref) async {
  final EscalationCatalogRepository repository = ref.watch(
    escalationCatalogRepositoryProvider,
  );
  final List<List<String>> loaded = await Future.wait(<Future<List<String>>>[
    repository.loadPayloadIds(),
    repository.loadKernelProfiles(),
  ]);
  return EscalationCatalog(
    payloadIds: loaded[0],
    kernelProfiles: loaded[1],
  );
}
