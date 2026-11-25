/// 键值存储中跨数据源共用的键。
abstract final class StorageKeys {
  /// 用户选定的 root 管理器包名。
  static const String escalationSelectedRootManager =
      'escalation.selected_root_manager';

  /// GhostKey 是否接受 calib_b 的 fallback 置信度。
  static const String ghostKeyAcceptFallbackPageOffset =
      'escalation.ghost_key.accept_fallback_page_offset';

  /// 用户导入的自定义载荷：一条一个键，键为「前缀 + 设备路径」。
  ///
  /// 拆成一条一键是为了让「导入 / 删除」只做单条写入与删除，不必先读回整份
  /// 列表再回写——那样写操作就带上了读职责。
  static const String escalationImportedPayloadPrefix =
      'escalation.imported_payload.';
}
