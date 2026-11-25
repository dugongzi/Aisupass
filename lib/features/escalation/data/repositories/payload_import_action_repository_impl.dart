import 'package:Aisupass/features/escalation/data/datasources/payload_import_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/models/imported_payload_dto.dart';
import 'package:Aisupass/features/escalation/domain/models/imported_payload.dart';
import 'package:Aisupass/features/escalation/domain/repositories/payload_import_action_repository.dart';

/// 自定义载荷动作仓储实现。
///
/// 只做写：推文件、写单条记录、删文件、删单条记录。存储按一条一键组织，所以
/// 这里不需要读回整份列表，也就没有夹带查询职责。
class PayloadImportActionRepositoryImpl
    implements PayloadImportActionRepository {
  const PayloadImportActionRepositoryImpl({required this._datasource});

  final PayloadImportActionDatasource _datasource;

  @override
  Future<ImportedPayload> importFile({
    required String localPath,
    required String displayName,
    required bool standalone,
    required String arguments,
  }) async {
    final String deviceName = _fileNameOf(localPath);
    final int size = await _datasource.pushFile(
      localPath: localPath,
      deviceName: deviceName,
    );

    final ImportedPayload imported = ImportedPayload(
      displayName: displayName.trim().isEmpty ? deviceName : displayName.trim(),
      devicePath: '${PayloadImportActionDatasource.deviceDir}/$deviceName',
      standalone: standalone,
      arguments: arguments.trim(),
      size: size,
    );
    await _datasource.saveEntry(ImportedPayloadDto.fromEntity(imported));
    return imported;
  }

  @override
  Future<void> delete({required String devicePath}) async {
    // 先删设备文件：文件还在而记录没了，用户就再也点不到这一条去清理。
    await _datasource.removeFile(devicePath: devicePath);
    await _datasource.removeEntry(devicePath: devicePath);
  }

  /// 取文件名：桌面与安卓的分隔符都要认。
  static String _fileNameOf(String path) {
    final int slash = path.lastIndexOf(RegExp(r'[/\\]'));
    return slash < 0 ? path : path.substring(slash + 1);
  }
}
