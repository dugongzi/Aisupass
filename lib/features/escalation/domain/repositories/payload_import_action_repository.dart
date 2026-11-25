import 'package:Aisupass/features/escalation/domain/models/imported_payload.dart';

/// 自定义载荷动作仓储。
abstract class PayloadImportActionRepository {
  /// 把本机文件推到设备并写进已导入列表，返回落库后的条目。
  ///
  /// 同一文件名重复导入时覆盖同一条记录，不产生重复项。
  Future<ImportedPayload> importFile({
    required String localPath,
    required String displayName,
    required bool standalone,
    required String arguments,
  });

  /// 删除一条已导入的载荷：设备上的文件与列表里的条目一起清掉。
  ///
  /// [devicePath] 是条目在设备上的绝对路径。设备文件已经不存在时不报错，
  /// 列表条目照样删除。
  Future<void> delete({required String devicePath});
}
