/// 提权资产目录仓储（M0 只读，可缺失）。
///
/// 目录只用于展示可用载荷与内核配置；M0 阶段不随包提供任何资产，
/// 因此实现必须在文件缺失时返回空列表，而不是抛异常。
abstract class EscalationCatalogRepository {
  /// 读取可用载荷 id 列表；资产缺失时返回空列表。
  Future<List<String>> loadPayloadIds();

  /// 读取可用内核配置名列表；资产缺失时返回空列表。
  Future<List<String>> loadKernelProfiles();
}
