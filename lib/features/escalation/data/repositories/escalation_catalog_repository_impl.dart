import 'package:Aisupass/features/escalation/data/datasources/escalation_catalog_datasource.dart';
import 'package:Aisupass/features/escalation/domain/repositories/escalation_catalog_repository.dart';

/// 资产目录仓储实现：直接透传数据源。
class EscalationCatalogRepositoryImpl implements EscalationCatalogRepository {
  const EscalationCatalogRepositoryImpl({required this._datasource});

  final EscalationCatalogDatasource _datasource;

  @override
  Future<List<String>> loadPayloadIds() => _datasource.loadPayloadIds();

  @override
  Future<List<String>> loadKernelProfiles() =>
      _datasource.loadKernelProfiles();
}
