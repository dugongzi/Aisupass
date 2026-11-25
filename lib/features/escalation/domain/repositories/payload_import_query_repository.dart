import 'package:Aisupass/features/escalation/domain/models/imported_payload.dart';

/// 自定义载荷查询仓储。
abstract class PayloadImportQueryRepository {
  /// 读取已导入的自定义载荷；没有时返回空列表。
  Future<List<ImportedPayload>> loadImported();
}
