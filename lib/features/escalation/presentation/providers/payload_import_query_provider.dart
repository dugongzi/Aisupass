import 'package:Aisupass/core/storage/storage_providers.dart';
import 'package:Aisupass/features/escalation/data/datasources/payload_import_query_datasource.dart';
import 'package:Aisupass/features/escalation/data/repositories/payload_import_query_repository_impl.dart';
import 'package:Aisupass/features/escalation/domain/models/imported_payload.dart';
import 'package:Aisupass/features/escalation/domain/repositories/payload_import_query_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payload_import_query_provider.g.dart';

/// 自定义载荷只读数据源。
@riverpod
PayloadImportQueryDatasource payloadImportQueryDatasource(Ref ref) =>
    PayloadImportQueryDatasource(storage: ref.watch(preferencesStoreProvider));

/// 自定义载荷查询仓储。
@riverpod
PayloadImportQueryRepository payloadImportQueryRepository(Ref ref) =>
    PayloadImportQueryRepositoryImpl(
      datasource: ref.watch(payloadImportQueryDatasourceProvider),
    );

/// 已导入的自定义载荷列表。
@riverpod
Future<List<ImportedPayload>> importedPayloads(Ref ref) =>
    ref.watch(payloadImportQueryRepositoryProvider).loadImported();
