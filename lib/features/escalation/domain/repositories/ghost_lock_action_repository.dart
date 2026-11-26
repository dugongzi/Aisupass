import 'package:Aisupass/features/escalation/domain/models/ghost_lock_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_preflight.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';

/// GhostLock 运行仓储接口。
abstract class GhostLockActionRepository {
  /// 运行前自检：ADB、shell 身份、seccomp、内核、内核表、二进制。
  ///
  /// [manager] 只用于回填自检里的 `ksudPath`（与实际执行同一条解析顺序），可空。
  Future<GhostLockPreflight> preflight({RootManager? manager});

  /// 跑一次，按块吐出证据直到终局。
  ///
  /// 受理被拒时只吐一个 [GhostLockKind.notStarted] 块后关闭。
  ///
  /// 接管方是全局选中的 [manager]：末段用它自带的 ksud，找不到才用包内兜底；
  /// 可空。[safeMode] 会改写 GLK1 的 `meta.safe_mode`，由原生在执行前给
  /// `/data/adb/modules/*` 打 `disable`。
  Stream<GhostLockOutcome> run({RootManager? manager, bool safeMode});

  /// 停止本侧读取；设备侧进程不受影响。
  Future<void> cancel();
}
