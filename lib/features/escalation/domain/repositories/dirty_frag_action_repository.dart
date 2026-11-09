import 'package:Aisupass/features/escalation/domain/models/dirty_frag_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/dirty_frag_run_defaults.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:Aisupass/features/escalation/domain/models/vr_derive_progress.dart';
import 'package:Aisupass/features/escalation/domain/models/vr_offset_result.dart';

/// DirtyFrag 运行仓储接口。
abstract class DirtyFragActionRepository {
  /// 本次开机是否已经注入过。
  Future<bool> isArmed();

  /// 读运行默认值（VR 反制 / 自动解析 / 手动偏移 / 成功后软重启）。
  Future<DirtyFragRunDefaults> runDefaults();

  /// 写运行默认值。设置页改开关时调用。
  Future<void> saveRunDefaults({required DirtyFragRunDefaults defaults});

  /// 启动一次运行，按块吐出证据直到终局。
  ///
  /// 受理被拒时只吐一个 [DirtyFragKind.notStarted] 块后关闭。
  ///
  /// [vrOffsetOverride] 是本次临时指定的手动偏移；为 `null` 时用
  /// [runDefaults] 里存的值。**只有这一项允许临时覆盖**——VR 反制开关
  /// 与软重启开关的唯一入口是设置页，不在这里开第二扇门。
  Stream<DirtyFragOutcome> run({
    required RootManager manager,
    int? vrOffsetOverride,
  });

  /// 中止正在进行的运行；没有运行在跑时直接返回。
  Future<void> cancel();

  /// 专家模式开关当前是否为开。
  Future<bool> isExpertModeEnabled();

  /// 切换专家模式。只写偏好，不碰组件启用态。
  Future<void> setExpertModeEnabled({required bool enabled});

  /// 开机自启开关当前是否为开。真相是组件启用态。
  Future<bool> isBootAutostartEnabled();

  /// 切换开机自启。只改组件启用态，不落偏好。
  Future<void> setBootAutostartEnabled({required bool enabled});

  /// 从 boot.img / payload.bin / OTA 直链算出 vr 偏移。
  ///
  /// 阻塞到结束；进度用 [vrDeriveProgress] 取。失败时返回
  /// `VrOffsetResult.ok == false`，不抛异常。
  Future<VrOffsetResult> deriveVrOffset({
    required String input,
    bool insecure = false,
  });

  /// 提取进度的即时快照。
  Future<VrDeriveProgress> vrDeriveProgress();
}
