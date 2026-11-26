import 'package:Aisupass/features/escalation/data/datasources/ghost_lock_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/models/ghost_lock_outcome_dto.dart';
import 'package:Aisupass/features/escalation/domain/enums/ghost_lock_kind.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_preflight.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:Aisupass/features/escalation/domain/repositories/ghost_lock_action_repository.dart';

/// GhostLock 运行仓储实现：DTO -> Entity 的唯一转换点，同时承载轮询与判定表。
class GhostLockActionRepositoryImpl implements GhostLockActionRepository {
  GhostLockActionRepositoryImpl({required this._datasource});

  final GhostLockActionDatasource _datasource;

  /// 两次轮询之间的间隔。
  ///
  /// 原生把 stdout 一次性重定向到 `run.log`（`04` 第 3 步），本侧只能按块读；
  /// 500 ms 让几十 KB 的日志分成 20～40 块上屏，不刷屏也不迟滞。
  static const Duration _pollInterval = Duration(milliseconds: 500);

  String _sessionId = '';

  @override
  Future<GhostLockPreflight> preflight({RootManager? manager}) async =>
      (await _datasource.preflight(
        managerPackage: manager?.packageName ?? '',
      )).toEntity();

  @override
  Stream<GhostLockOutcome> run({
    RootManager? manager,
    bool safeMode = false,
  }) async* {
    final GhostLockStartOutcome accepted = await _datasource.start(
      managerPackage: manager?.packageName ?? '',
      safeMode: safeMode,
    );

    if (!accepted.accepted) {
      // 被拒也要走一次 DTO -> Entity：Entity 只能由 DTO 转出来。
      yield GhostLockOutcomeDto(
        sessionId: accepted.sessionId,
        kind: GhostLockKind.notStarted,
        reason: accepted.reason,
      ).toEntity();
      return;
    }

    _sessionId = accepted.sessionId;
    final StringBuffer accumulated = StringBuffer();

    try {
      while (true) {
        final GhostLockPollSnapshot polled = await _datasource.poll(
          sessionId: accepted.sessionId,
        );
        final GhostLockOutcomeDto dto = polled.outcome;
        accumulated.write(dto.output);

        if (polled.finished) {
          yield dto
              .copyWith(
                kind: _classify(accumulated.toString(), dto),
                log: accumulated.toString(),
              )
              .toEntity();
          return;
        }

        yield dto.toEntity();
        await Future<void>.delayed(_pollInterval);
      }
    } finally {
      _sessionId = '';
    }
  }

  @override
  Future<void> cancel() async {
    final String sessionId = _sessionId;
    if (sessionId.isEmpty) return;
    await _datasource.cancel(sessionId: sessionId);
  }

  /// 判定表。只有这里掌握「成功/失败」的解释权。
  ///
  /// 顺序不可调换：先看本侧超时与原生脏停，再看不可逆的 profile / 阶段失败，
  /// 再看 KSU 结论，最后兜底。所有串逐字取自上游 `src/core/`。
  GhostLockKind _classify(String log, GhostLockOutcomeDto dto) {
    if (dto.timedOut) return GhostLockKind.timedOut;

    // 1) 竞争脏停：原生自己 exit_group(70)，之后不再有输出。
    if (log.contains('terminal dirty race:')) return GhostLockKind.dirtyRace;

    // 2) profile 与内核不匹配：native 在装表阶段就退出。
    if (log.contains('profile release mismatch: expected')) {
      return GhostLockKind.releaseMismatch;
    }

    // 3) 阶段失败（W1/W2/W3）。
    if (log.contains('Write 1 failed')) return GhostLockKind.w1Failed;
    if (log.contains('W2 failed after') ||
        log.contains('w2 never rooted a child')) {
      return GhostLockKind.w2Failed;
    }
    if (log.contains('W3 seccomp bypass failed after') ||
        log.contains('W3 seccomp clear failed')) {
      return GhostLockKind.w3Failed;
    }

    // 4) KSU 未接管：seccomp 未清 / 加载失败 / 只拿到临时 root。
    if (log.contains(
      'temporary root ready; KernelSU module not loaded (W3 seccomp clear failed)',
    )) {
      return GhostLockKind.seccompBlocked;
    }
    if (log.contains('KernelSU module load failed')) {
      return GhostLockKind.ksuFailed;
    }
    if (log.contains('temporary root ready; KernelSU module load pending')) {
      return GhostLockKind.tempRootOnly;
    }

    // 5) 成功与「已接管」。两条互斥，先判成功。
    if (log.contains('KernelSU ready')) return GhostLockKind.succeeded;
    if (log.contains('KernelSU already has root; skipping exploit')) {
      return GhostLockKind.alreadyRooted;
    }

    // 6) 有输出但没有可识别结论：不猜。
    return GhostLockKind.failed;
  }
}
