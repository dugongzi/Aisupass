import 'package:Aisupass/features/escalation/data/datasources/escalation_query_datasource.dart';
import 'package:Aisupass/features/escalation/domain/models/device_fingerprint.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_capability_matrix.dart';
import 'package:Aisupass/features/escalation/domain/repositories/escalation_query_repository.dart';

/// 查询仓储实现：直接透传数据源，零副作用。
class EscalationQueryRepositoryImpl implements EscalationQueryRepository {
  const EscalationQueryRepositoryImpl({required this._datasource});

  final EscalationQueryDatasource _datasource;

  @override
  Future<DeviceFingerprint> readFingerprint() => _datasource.readFingerprint();

  @override
  Future<EscalationCapabilityMatrix> probeCapabilities() =>
      _datasource.probeCapabilities();
}
