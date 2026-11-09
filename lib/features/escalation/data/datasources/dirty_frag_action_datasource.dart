import 'package:Aisupass/generated/dirty_frag.g.dart' as pigeon;

/// DirtyFrag 运行数据源。
///
/// 只做原生转发，受理判定与结果分型都在仓储实现里。
class DirtyFragActionDatasource {
  DirtyFragActionDatasource({required this._native});

  final pigeon.DirtyFragNative _native;

  /// 本次开机是否已经注入过。
  Future<bool> isArmed() => _native.isArmed();

  /// 读运行默认值（VR 反制 / 自动解析 / 手动偏移 / 成功后软重启）。
  Future<pigeon.DirtyFragRunDefaults> getRunDefaults() =>
      _native.getRunDefaults();

  /// 写运行默认值。设置页改开关时调用。
  Future<void> setRunDefaults({
    required pigeon.DirtyFragRunDefaults defaults,
  }) => _native.setRunDefaults(defaults);

  /// 受理一次运行。
  Future<pigeon.DirtyFragStartResult> start({
    required pigeon.DirtyFragRequest request,
  }) => _native.start(request);

  /// 取走自上次轮询以来积累的输出。
  Future<pigeon.DirtyFragChunk> poll({required String sessionId}) =>
      _native.poll(sessionId);

  /// 取消运行。进入内核侧之后的阶段取消不掉，只会停止本侧读取。
  Future<void> cancel({required String sessionId}) => _native.cancel(sessionId);

  /// 专家模式开关当前是否为开。
  Future<bool> isExpertModeEnabled() => _native.isExpertModeEnabled();

  /// 切换专家模式。只写偏好，不碰组件启用态。
  Future<void> setExpertModeEnabled({required bool enabled}) =>
      _native.setExpertModeEnabled(enabled);

  /// 开机自启开关当前是否为开。真相是组件启用态，不是偏好。
  Future<bool> isBootAutostartEnabled() => _native.isBootAutostartEnabled();

  /// 切换开机自启。只改组件启用态，不落偏好。
  Future<void> setBootAutostartEnabled({required bool enabled}) =>
      _native.setBootAutostartEnabled(enabled);

  /// 起一次离线偏移提取。阻塞到结束，进度另用 [vrDeriveProgress] 取。
  Future<pigeon.VrDeriveResult> deriveVrOffset({
    required String input,
    bool insecure = false,
  }) => _native.deriveVrOffset(input, insecure);

  /// 即时进度三元组串。
  Future<String> vrDeriveProgress() => _native.vrDeriveProgress();
}
