import 'package:Aisupass/features/escalation/data/datasources/escalation_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/models/escalation_run_dto.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_chain.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_outcome.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_reason.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_request.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_run_record.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_step_record.dart';
import 'package:Aisupass/features/escalation/domain/repositories/escalation_action_repository.dart';
import 'package:Aisupass/features/escalation/domain/repositories/escalation_record_repository.dart';
import 'package:Aisupass/generated/escalation.g.dart' as pigeon;

/// 提权动作仓储实现：把原生快照转成运行记录，并在 Dart 侧完成最终判定。
///
/// 判定规则（与领域层约定一致）：
/// 1. 成功只看外部状态：`verify` 阶段证据里 `targetAchieved == '1'` 才算达成，
///    `ok` 标志与任何退出码都不参与判定；
/// 2. 破坏性原语失败不原地重试，直接以失败收尾；
/// 3. `cleanup` 失败降级为 [EscalationOutcome.partial] 且标记 `residual`；
/// 4. `enforce` 恢复失败直接判 [EscalationOutcome.unsafe]。
class EscalationActionRepositoryImpl implements EscalationActionRepository {
  const EscalationActionRepositoryImpl({
    required this._datasource,
    required this._recordRepository,
  });

  /// verify 阶段用于表达「外部状态已达成」的证据键，由原生回填。
  static const String targetAchievedKey = 'targetAchieved';

  final EscalationActionDatasource _datasource;
  final EscalationRecordRepository _recordRepository;

  @override
  Stream<EscalationRunRecord> run(EscalationRequest request) async* {
    final int startedAtMs = DateTime.now().millisecondsSinceEpoch;
    final pigeon.StartRunResult started = await _datasource.startRun(
      request.chain,
      request.args,
    );

    if (!started.accepted) {
      yield EscalationRunRecord(
        runId: started.runId,
        chain: request.chain,
        outcome: _outcomeForRejection(started.reasons),
        steps: const <EscalationStepRecord>[],
        startedAtMs: startedAtMs,
        finishedAtMs: DateTime.now().millisecondsSinceEpoch,
        residual: false,
      );
      return;
    }

    await for (final pigeon.RunSnapshot snapshot in _datasource.watchRun(
      started.runId,
      request.chain,
    )) {
      final bool finished = snapshot.finished;
      final _Judgement judgement = _judge(snapshot);
      final EscalationRunRecord? record = EscalationRunDto.fromPigeon(
        snapshot,
        outcome: judgement.outcome,
        startedAtMs: startedAtMs,
        finishedAtMs: finished
            ? DateTime.now().millisecondsSinceEpoch
            : 0,
        residual: judgement.residual,
      ).toEntity();
      if (record == null) continue;

      yield record;
      if (finished) await _recordRepository.save(record);
    }
  }

  @override
  Stream<EscalationRunRecord> pair() async* {
    final int startedAtMs = DateTime.now().millisecondsSinceEpoch;
    final pigeon.StartRunResult started = await _datasource.startPairing();

    if (!started.accepted) {
      yield EscalationRunRecord(
        runId: started.runId,
        // 原生以 `shellChannel` 标识配对会话，与 datasource 的轮询保持一致。
        chain: EscalationChain.shellChannel,
        outcome: _outcomeForRejection(started.reasons),
        steps: const <EscalationStepRecord>[],
        startedAtMs: startedAtMs,
        finishedAtMs: DateTime.now().millisecondsSinceEpoch,
        residual: false,
      );
      return;
    }

    await for (final pigeon.RunSnapshot snapshot in _datasource.watchPairing(
      started.runId,
    )) {
      final EscalationRunRecord? record = EscalationRunDto.fromPigeon(
        snapshot,
        outcome: _judgePairing(snapshot),
        startedAtMs: startedAtMs,
        finishedAtMs: snapshot.finished
            ? DateTime.now().millisecondsSinceEpoch
            : 0,
        residual: false,
      ).toEntity();
      if (record == null) continue;

      // 配对不入历史：它只为 `payload` 链铺出 shell，不是一次提权运行，
      // 混进记录列表会让「上次结果」这类展示失真。
      yield record;
    }
  }

  @override
  Future<void> cancel(String runId) => _datasource.cancelRun(runId);

  /// 依据外部证据与恢复情况给出最终结论。
  _Judgement _judge(pigeon.RunSnapshot snapshot) {
    final List<pigeon.RunStep> steps = snapshot.steps;
    if (steps.isEmpty) {
      return const _Judgement(
        outcome: EscalationOutcome.notStarted,
        residual: false,
      );
    }

    // SELinux 未能恢复或已留下残留，属于危险状态，优先级最高。
    if (_hasReason(steps, EscalationReason.enforceRestoreFailed) ||
        _hasReason(steps, EscalationReason.residualLeft)) {
      return const _Judgement(
        outcome: EscalationOutcome.unsafe,
        residual: true,
      );
    }

    final bool cleanupFailed = _hasReason(
      steps,
      EscalationReason.cleanupFailed,
    );
    if (cleanupFailed) {
      return const _Judgement(
        outcome: EscalationOutcome.partial,
        residual: true,
      );
    }

    return _targetAchieved(steps)
        ? const _Judgement(outcome: EscalationOutcome.success, residual: false)
        : const _Judgement(outcome: EscalationOutcome.failed, residual: false);
  }

  /// 配对会话的结论。
  ///
  /// 只认一个事实：`PREPARE` 阶段建链成功（系统配对 + `adb-tls-connect` 通了，
  /// 拿到了 uid=2000 的 shell）。**点火不在这个会话里**——常驻特权进程起没起
  /// 是另一件事，由页面在配对成功后单独调用 `warmUpHost` 触发并单独展示。
  ///
  /// 之前把点火也算进配对结论，会导致配对明明成功、只是点火失败，页面却报
  /// 「配对失败」；同时同步等点火还会让页面卡在「等待输入配对码」十几秒。
  EscalationOutcome _judgePairing(pigeon.RunSnapshot snapshot) {
    if (snapshot.steps.isEmpty) return EscalationOutcome.notStarted;

    for (final pigeon.RunStep step in snapshot.steps) {
      if (step.stage != pigeon.EscalationStage.prepare) continue;
      return step.ok ? EscalationOutcome.success : EscalationOutcome.failed;
    }
    return EscalationOutcome.failed;
  }

  /// 任一阶段带出指定原因码即视为命中。
  bool _hasReason(List<pigeon.RunStep> steps, EscalationReason reason) =>
      steps.any(
        (pigeon.RunStep step) => step.reasons.contains(reason.code),
      );

  /// 只看 `verify` 阶段回填的外部状态证据。
  bool _targetAchieved(List<pigeon.RunStep> steps) {
    for (final pigeon.RunStep step in steps) {
      if (step.stage != pigeon.EscalationStage.verify) continue;
      if (step.evidence[targetAchievedKey]?.toString() == '1') return true;
    }
    return false;
  }

  /// 原生拒绝受理时的结论：
  /// 环境/能力缺失归为 `unsupported`，其余情况归为 `failed`。
  EscalationOutcome _outcomeForRejection(List<String> reasons) {
    const List<EscalationReason> unsupportedReasons = <EscalationReason>[
      EscalationReason.platformUnsupported,
      EscalationReason.androidTooOld,
      EscalationReason.deviceNotSupported,
      EscalationReason.noRootBinary,
      EscalationReason.kernelNotSupported,
      EscalationReason.payloadMissing,
      EscalationReason.catalogCorrupted,
    ];
    for (final String reason in reasons) {
      if (unsupportedReasons.contains(EscalationReason.fromCode(reason))) {
        return EscalationOutcome.unsupported;
      }
    }
    return EscalationOutcome.failed;
  }
}

/// 判定结果：结论 + 是否遗留残留。
class _Judgement {
  const _Judgement({required this.outcome, required this.residual});

  final EscalationOutcome outcome;
  final bool residual;
}
