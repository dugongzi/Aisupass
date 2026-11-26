/// 酷安人机验证页的一次回传结果。
enum CoolapkCaptchaStatus {
  /// 验证组件渲染完成。
  ready,

  /// 票据已落盘，可以退出页面。
  saved,

  /// 验证失败或落盘失败。
  failed,

  /// 与当前流程无关的消息。
  ignored,
}
