import 'package:Aisupass/core/providers/adb_shell_provider.dart';
import 'package:Aisupass/core/storage/storage_providers.dart';
import 'package:Aisupass/features/escalation/data/datasources/payload_import_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/repositories/payload_import_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/domain/models/imported_payload.dart';
import 'package:Aisupass/features/escalation/domain/repositories/payload_import_action_repository.dart';
import 'package:Aisupass/features/escalation/presentation/providers/payload_import_query_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payload_import_action_provider.g.dart';

/// 自定义载荷写数据源。
@riverpod
PayloadImportActionDatasource payloadImportActionDatasource(Ref ref) =>
    PayloadImportActionDatasource(
      native: ref.watch(adbShellNativeProvider),
      storage: ref.watch(preferencesStoreProvider),
    );

/// 自定义载荷动作仓储。
@riverpod
PayloadImportActionRepository payloadImportActionRepository(Ref ref) =>
    PayloadImportActionRepositoryImpl(
      datasource: ref.watch(payloadImportActionDatasourceProvider),
    );

/// 自定义载荷的写操作。
///
/// 同 [rootManagerActions]：无参类持有 [Ref]，参数走方法入参。
@Riverpod(keepAlive: true)
PayloadImportActions payloadImportActions(Ref ref) => PayloadImportActions(ref);

/// 见 [payloadImportActions]。
class PayloadImportActions {
  PayloadImportActions(this._ref);

  final Ref _ref;

  /// 推一份本机文件到设备并写进已导入列表；写完失效查询侧，列表立刻刷新。
  Future<ImportedPayload> importFile({
    required String localPath,
    required String displayName,
    required bool standalone,
    required String arguments,
  }) async {
    final ImportedPayload imported = await _ref
        .read(payloadImportActionRepositoryProvider)
        .importFile(
          localPath: localPath,
          displayName: displayName,
          standalone: standalone,
          arguments: arguments,
        );
    _ref.invalidate(importedPayloadsProvider);
    return imported;
  }

  /// 删除一条已导入的载荷：设备文件与列表条目一起清掉。
  ///
  /// 失败时异常上抛，由页面给出提示；不在这里吞掉，否则列表会停在一个
  /// 「看起来删了、其实还在」的状态。
  Future<void> delete({required String devicePath}) async {
    await _ref
        .read(payloadImportActionRepositoryProvider)
        .delete(devicePath: devicePath);
    _ref.invalidate(importedPayloadsProvider);
  }
}
