/// 设备上可接收 root 的 KernelSU 系管理器。
///
/// 包名同时承担两个用途：在 `/data/app` 下按路径过滤出该管理器的
/// `libksud.so`，以及作为 `late-load --package-name` 的参数。
enum RootManager {
  /// 原版 KernelSU，KernelSU Next 等分支沿用同一包名。
  kernelsu(
    'me.weishu.kernelsu',
    'KernelSU',
    'https://kernelsu.org/',
  ),

  /// SukiSU Ultra。
  sukisu(
    'com.sukisu.ultra',
    'SukiSU Ultra',
    'https://github.com/SukiSU-Ultra/SukiSU-Ultra',
  );

  const RootManager(this.packageName, this.displayName, this.homeUrl);

  /// 管理器包名。
  final String packageName;

  /// UI 上显示的名字。
  final String displayName;

  /// 管理器官网 / 下载页。移交时找不到 `libksud.so` 说明没装，
  /// 这是用户唯一能自救的出路，必须能点开。
  final String homeUrl;

  /// 安全解析，非法值回落 [kernelsu]，禁止 `values.byName` 裸调。
  static RootManager fromName(String? value) {
    for (final RootManager manager in RootManager.values) {
      if (manager.name == value) return manager;
    }
    return RootManager.kernelsu;
  }
}
