/// 内置登录页所处的阶段。
///
/// 只描述界面需要区分的状态，不参与任何持久化。
enum AiBuiltinLoginStage {
  /// 已打开网页，等待用户在网页里完成注册或登录。
  waitingLogin,

  /// 已拿到登录令牌，正在读取分组。
  loadingGroups,

  /// 已选好分组与模型，正在创建密钥。
  creating,

  /// 密钥已建好并写进内置配置。
  done,

  /// 任一环节失败，原因见页面的失败文案。
  failed;

  /// 从持久化的枚举名还原，未知值回退到等待登录。
  static AiBuiltinLoginStage fromName(String? name) {
    for (final AiBuiltinLoginStage stage in AiBuiltinLoginStage.values) {
      if (stage.name == name) return stage;
    }
    return AiBuiltinLoginStage.waitingLogin;
  }
}
