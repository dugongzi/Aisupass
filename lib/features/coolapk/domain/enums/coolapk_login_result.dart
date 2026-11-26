/// 酷安登录抓取的结果，由页面决定提示文案。
enum CoolapkLoginResult {
  /// 会话已换发，登录生效。
  success,

  /// 会话没有变化，登录未完成。
  notDetected,

  /// 读取或网络失败。
  failed,
}
