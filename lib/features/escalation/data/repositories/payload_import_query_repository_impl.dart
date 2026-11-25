import 'package:Aisupass/features/escalation/data/datasources/payload_import_query_datasource.dart';
import 'package:Aisupass/features/escalation/data/models/imported_payload_dto.dart';
import 'package:Aisupass/features/escalation/domain/models/imported_payload.dart';
import 'package:Aisupass/features/escalation/domain/repositories/payload_import_query_repository.dart';

/// 自定义载荷查询仓储实现。
class PayloadImportQueryRepositoryImpl implements PayloadImportQueryRepository {
  const PayloadImportQueryRepositoryImpl({required this._datasource});

  final PayloadImportQueryDatasource _datasource;

  @override
  Future<List<ImportedPayload>> loadImported() async {
    final List<ImportedPayloadDto> dtos = await _datasource.loadImported();
    return dtos
        .map((ImportedPayloadDto dto) => dto.toEntity())
        .toList(growable: false);
  }
}
