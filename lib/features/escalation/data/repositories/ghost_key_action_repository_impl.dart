import 'dart:math' as math;

import 'package:Aisupass/features/escalation/data/datasources/ghost_key_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/models/ghost_key_outcome_dto.dart';
import 'package:Aisupass/features/escalation/data/models/ghost_key_preflight_dto.dart';
import 'package:Aisupass/features/escalation/data/models/ghost_key_run_defaults_dto.dart';
import 'package:Aisupass/features/escalation/domain/enums/ghost_key_kind.dart';
import 'package:Aisupass/features/escalation/domain/enums/ghost_key_stage.dart';
import 'package:Aisupass/features/escalation/domain/enums/ghost_key_stage_status.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_preflight.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_run_defaults.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:Aisupass/features/escalation/domain/repositories/ghost_key_action_repository.dart';

/// GhostKey 运行仓储实现。
///
/// 唯一的判定点：[_classify]。判定只看退出码、`ksu` 阶段状态与 `timedOut`，
/// 不 grep 任何输出串——原生已经把分层结果写进分段退出码（`04:185-192`）。
class GhostKeyActionRepositoryImpl implements GhostKeyActionRepository {
  GhostKeyActionRepositoryImpl({required this._datasource});

  /// 轮询间隔。
  ///
  /// `04` 第 7 步已定：`start` / `poll` 走 `exec`，注入段看不到逐行
  /// stdout，只能按块刷新。500 ms 取法：注入段 60 块左右，`verify` 段 6 s
  /// 仍有 12 次采样，不会漏掉阶段切换。
  static const Duration _pollInterval = Duration(milliseconds: 500);

  final GhostKeyActionDatasource _datasource;

  String _sessionId = '';

  @override
  Future<GhostKeyPreflight> preflight() async {
    final GhostKeyPreflightDto dto = await _datasource.preflight();
    return dto.toEntity();
  }

  @override
  Future<GhostKeyRunDefaults> runDefaults() async {
    final GhostKeyRunDefaultsDto dto = GhostKeyRunDefaultsDto(
      acceptFallbackPageOffset: await _datasource.readAcceptFallback(),
    );
    return dto.toEntity();
  }

  @override
  Future<void> saveRunDefaults({required GhostKeyRunDefaults defaults}) async {
    await _datasource.writeAcceptFallback(
      value: defaults.acceptFallbackPageOffset,
    );
  }

  @override
  Stream<GhostKeyOutcome> run({RootManager? manager}) async* {
    final GhostKeyRunDefaults defaults = await runDefaults();
    // 接管方就是全局选中的 root 管理器：选中了才在末段移交，没选就只拿临时 root。
    final String managerPackage = manager?.packageName ?? '';

    final GhostKeyStartOutcome accepted = await _datasource.start(
      managerPackage: managerPackage,
      acceptFallbackPageOffset: defaults.acceptFallbackPageOffset,
    );
    if (!accepted.accepted) {
      // 被拒也要走一次 DTO -> Entity：Entity 只能由 DTO 转出来，不在别处 new。
      yield _notStarted(accepted.reason);
      return;
    }

    _sessionId = accepted.sessionId;
    final _StageTracker tracker = _StageTracker();
    final StringBuffer accumulated = StringBuffer();
    try {
      while (true) {
        final GhostKeyPollSnapshot polled = await _datasource.poll(
          sessionId: _sessionId,
        );
        GhostKeyOutcomeDto dto = polled.outcome;
        final int now = dto.durationMs;
        for (final ({String stage, String status}) event in polled.events) {
          tracker.onEvent(event, now);
        }
        accumulated.write(dto.output);
        if (polled.finished) {
          tracker.finish(dto.exitCode, now);
          dto = dto.copyWith(
            kind: _classify(dto, tracker),
            log: accumulated.toString(),
          );
          yield dto
              .copyWith(
                fraction: tracker.progress(now),
                stageStatuses: tracker.stageStatuses,
                stageDurations: tracker.liveDurations(now),
              )
              .toEntity();
          return;
        }
        yield dto
            .copyWith(
              fraction: tracker.progress(now),
              stageStatuses: tracker.stageStatuses,
              stageDurations: tracker.liveDurations(now),
            )
            .toEntity();
        await Future<void>.delayed(_pollInterval);
      }
    } finally {
      _sessionId = '';
    }
  }

  @override
  Future<void> cancel() async {
    if (_sessionId.isEmpty) return;
    await _datasource.cancel(sessionId: _sessionId);
  }

  /// 被拒/前置不满足时的首块。
  ///
  /// 五个阶段全部填 `pending`、耗时为 0，保证进度面板不用做长度守卫。
  GhostKeyOutcome _notStarted(String reason) => GhostKeyOutcomeDto(
    kind: GhostKeyKind.notStarted,
    reason: reason,
    stageStatuses: List<GhostKeyStageStatus>.filled(
      GhostKeyStage.values.length,
      GhostKeyStageStatus.pending,
      growable: false,
    ),
    stageDurations: List<int>.filled(
      GhostKeyStage.values.length,
      0,
      growable: false,
    ),
  ).toEntity();

  /// 终局分类。**判定顺序不可调换。**
  ///
  /// 1. `timedOut` 优先：超时/取消时退出码可能是 `-1`，也可能残留在某一段，
  ///    但真实原因是没跑完；
  /// 2. 分段退出码逐段映射（`Cve98260UserService.kt` 的 `return 2/3/4/5/0`）；
  /// 3. 退出码 0 时再看 `ksu`：该阶段可选，失败不影响退出码，只体现在
  ///    `events` 里；
  /// 4. 有任一段 `degraded` 记降级成功。
  GhostKeyKind _classify(GhostKeyOutcomeDto dto, _StageTracker tracker) {
    if (dto.timedOut) return GhostKeyKind.timedOut;
    switch (dto.exitCode) {
      case 2:
        return GhostKeyKind.calibFailed;
      case 3:
        return GhostKeyKind.pageOffsetFailed;
      case 4:
        return GhostKeyKind.injectFailed;
      case 5:
        return GhostKeyKind.verifyFailed;
      case 0:
        if (tracker.statusOf(GhostKeyStage.ksu) == GhostKeyStageStatus.failed) {
          return GhostKeyKind.ksuFailed;
        }
        if (tracker.anyDegraded) return GhostKeyKind.degraded;
        return GhostKeyKind.succeeded;
      default:
        return GhostKeyKind.failed;
    }
  }
}

/// 五阶段状态机，逐条移植上游 `StageTracker.kt`。
///
/// 时序全部来自 `chunk.durationMs`（原生单调时钟，从受理起算），不读本地时钟：
/// 两者混用会让「阶段耗时」与「会话耗时」互相矛盾。
class _StageTracker {
  _StageTracker()
    : _states = List<GhostKeyStageStatus>.filled(
        GhostKeyStage.values.length,
        GhostKeyStageStatus.pending,
      ),
      _durations = List<int>.filled(GhostKeyStage.values.length, 0),
      _startedAt = List<int>.filled(GhostKeyStage.values.length, -1);

  /// 各阶段状态，下标对应 `GhostKeyStage.index`。
  final List<GhostKeyStageStatus> _states;

  /// 各阶段已结算耗时（毫秒）。
  final List<int> _durations;

  /// 各阶段计时起点（毫秒）；`-1` 表示未启动。
  ///
  /// **不能用 0 做哨兵**：`chunk.durationMs` 的首块可能就是 0。
  final List<int> _startedAt;

  /// 进度下限，收尾时定格，[progress] 永不低于它。
  double _progressFloor = 0;

  /// 当前状态快照。
  List<GhostKeyStageStatus> get stageStatuses =>
      List<GhostKeyStageStatus>.unmodifiable(_states);

  /// 是否有任一段降级完成。
  bool get anyDegraded => _states.contains(GhostKeyStageStatus.degraded);

  /// 指定阶段的当前状态。
  GhostKeyStageStatus statusOf(GhostKeyStage stage) => _states[stage.index];

  /// 处理一条阶段事件。
  void onEvent(({String stage, String status}) event, int now) {
    final GhostKeyStage? stage = GhostKeyStage.fromCode(event.stage);
    if (stage == null) return;
    final int i = stage.index;

    // 新阶段开始：其它仍在 running 的阶段视为已结束。
    // 上游语义：阶段是串行的，没有并行上报。
    for (int k = 0; k < _states.length; k++) {
      if (k != i && _states[k] == GhostKeyStageStatus.running) {
        _durations[k] = _elapsed(_startedAt[k], now);
        _states[k] = GhostKeyStageStatus.success;
      }
    }

    final GhostKeyStageStatus status = GhostKeyStageStatus.fromName(
      event.status,
    );
    switch (status) {
      case GhostKeyStageStatus.running:
        // 同阶段重复上报 running（如重试）不重置计时起点，
        // 耗时从首次开始累计。
        if (_states[i] != GhostKeyStageStatus.running) _startedAt[i] = now;
        _states[i] = GhostKeyStageStatus.running;
      case GhostKeyStageStatus.success:
      case GhostKeyStageStatus.degraded:
      case GhostKeyStageStatus.failed:
        if (_states[i] == GhostKeyStageStatus.running) {
          _durations[i] = _elapsed(_startedAt[i], now);
        }
        _states[i] = status;
      case GhostKeyStageStatus.skipped:
        _states[i] = GhostKeyStageStatus.skipped;
      case GhostKeyStageStatus.pending:
        break;
    }
  }

  /// 流水线结束。
  ///
  /// 仍在跑的按退出码判定，没跑到的标记「跳过」——不再刷成成功。
  void finish(int exitCode, int now) {
    _progressFloor = math.max(_progressFloor, progress(now));
    final bool ok = exitCode == 0;
    for (int i = 0; i < _states.length; i++) {
      if (_states[i] == GhostKeyStageStatus.running) {
        _durations[i] = _elapsed(_startedAt[i], now);
        _states[i] = ok
            ? GhostKeyStageStatus.success
            : GhostKeyStageStatus.failed;
      } else if (_states[i] == GhostKeyStageStatus.pending) {
        _states[i] = GhostKeyStageStatus.skipped;
      }
    }
  }

  /// 当前进度，`0`～`1`。
  ///
  /// `running` 段按指数爬升：[GhostKeyStage.expectedMs] 时约到该段权重的 63%，
  /// 再乘 `0.9` 留一点尾巴，避免阶段实际超预期时早早顶满。
  double progress(int now) {
    double sum = 0;
    for (int i = 0; i < _states.length; i++) {
      final GhostKeyStage stage = GhostKeyStage.values[i];
      switch (_states[i]) {
        case GhostKeyStageStatus.success:
        case GhostKeyStageStatus.degraded:
        case GhostKeyStageStatus.skipped:
          sum += stage.weight;
        case GhostKeyStageStatus.running:
          final int elapsed = _elapsed(_startedAt[i], now);
          final double ratio = 1 - math.exp(-elapsed / stage.expectedMs);
          sum += stage.weight * ratio * 0.9;
        case GhostKeyStageStatus.pending:
        case GhostKeyStageStatus.failed:
          break;
      }
    }
    final double total = GhostKeyStage.totalWeight;
    final double normalized = total > 0 ? sum / total : 0;
    final double clamped = normalized < 0
        ? 0
        : (normalized > 1 ? 1 : normalized);
    return math.max(clamped, _progressFloor);
  }

  /// 各阶段耗时，`running` 段按当前时刻实时算。
  List<int> liveDurations(int now) {
    final List<int> out = List<int>.of(_durations, growable: false);
    for (int i = 0; i < _states.length; i++) {
      if (_states[i] == GhostKeyStageStatus.running && _startedAt[i] >= 0) {
        out[i] = _elapsed(_startedAt[i], now);
      }
    }
    return out;
  }

  /// 从 [startedAt] 到 [now] 的毫秒差，负数归零。
  int _elapsed(int startedAt, int now) {
    if (startedAt < 0) return 0;
    final int delta = now - startedAt;
    return delta < 0 ? 0 : delta;
  }
}
