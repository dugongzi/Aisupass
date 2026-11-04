/// 载荷匹配档位，精度由高到低。
enum MatchTier {
  /// 6.6.89 特例：多个机型共用 `libbs.so`
  libbsOverride,

  /// 机型全中且内核版本相等
  sameKernel,

  /// 机型全中但内核版本不等（同机型其它 OTA，可能可用）
  similarDevice,

  /// 机型不中，同厂商同版本兜底
  vendorFallback;

  /// 安全解析，非法值回落 [similarDevice]。
  ///
  /// 禁止直接调用 `values.byName`：遇到未知名字会抛异常。
  static MatchTier fromName(String? value) {
    for (final MatchTier tier in MatchTier.values) {
      if (tier.name == value) return tier;
    }
    return MatchTier.similarDevice;
  }
}
