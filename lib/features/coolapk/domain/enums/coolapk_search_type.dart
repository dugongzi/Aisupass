/// 酷安搜索维度。
///
/// 枚举名与 `/v6/search` 的 `type` 参数取值一一对应，出参直接取 `name`。
enum CoolapkSearchType {
  /// 动态（帖子）。
  feed,

  /// 用户。
  user,

  /// 话题。
  feedTopic,

  /// 混合卡片列表，同时含动态、用户与话题。
  all;

  /// 从接口值还原，未知值回退到 [feed]。
  static CoolapkSearchType fromName(String? name) {
    for (final CoolapkSearchType type in CoolapkSearchType.values) {
      if (type.name == name) return type;
    }
    return CoolapkSearchType.feed;
  }
}
