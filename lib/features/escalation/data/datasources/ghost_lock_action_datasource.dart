import 'package:Aisupass/features/escalation/data/models/ghost_lock_outcome_dto.dart';
import 'package:Aisupass/features/escalation/data/models/ghost_lock_preflight_dto.dart';
import 'package:Aisupass/generated/ghost_lock.g.dart' as pigeon;

/// 一次受理结果；原生 `GhostLockStartResult` 只在本层出现。
typedef GhostLockStartOutcome = ({
  bool accepted,
  String sessionId,
  String reason,
});

/// 一次轮询快照：输出已收敛成 [GhostLockOutcomeDto]，`finished` 留给仓储判终局。
typedef GhostLockPollSnapshot = ({GhostLockOutcomeDto outcome, bool finished});

/// GhostLock 运行数据源。
///
/// 只做原生转发与 DTO 收敛，受理判定与结果分型都在仓储实现里。
class GhostLockActionDatasource {
  GhostLockActionDatasource({required this._native});

  final pigeon.GhostLockNative _native;

  /// 运行前自检。
  ///
  /// [managerPackage] 只用于回填 `ksudPath`，让弹窗展示的路径与实际执行一致。
  Future<GhostLockPreflightDto> preflight({String managerPackage = ''}) async =>
      GhostLockPreflightDto.fromNative(
        await _native.preflight(managerPackage),
      );

  /// 受理一次运行。
  Future<GhostLockStartOutcome> start({
    required String managerPackage,
    required bool safeMode,
  }) async {
    final pigeon.GhostLockStartResult result = await _native.start(
      pigeon.GhostLockRequest(
        managerPackage: managerPackage,
        safeMode: safeMode,
      ),
    );
    return (
      accepted: result.accepted,
      sessionId: result.sessionId,
      reason: result.reason,
    );
  }

  /// 取走自上次轮询以来积累的输出。
  Future<GhostLockPollSnapshot> poll({required String sessionId}) async {
    final pigeon.GhostLockChunk chunk = await _native.poll(sessionId);
    return (
      outcome: GhostLockOutcomeDto.fromNative(chunk),
      finished: chunk.finished,
    );
  }

  /// 停止本侧读取。设备侧进程不受影响。
  Future<void> cancel({required String sessionId}) => _native.cancel(sessionId);
}
