import 'dart:async';

import 'package:Aisupass/features/escalation/data/datasources/escalation_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/repositories/escalation_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_chain.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_outcome.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_reason.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_request.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_run_record.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_step_record.dart';
import 'package:Aisupass/features/escalation/domain/repositories/escalation_action_repository.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_record_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'escalation_action_provider.g.dart';

/// 提权运行阶段，仅用于驱动页面按钮与时间线的显隐。
enum EscalationRunPhase {
  /// 未发起，或运行已被用户取消。
  idle,

  /// 正在运行。
  running,

  /// 已结束，[EscalationRunState.outcome] 一定有值。
  finished,
}

/// 页面上的单次提权运行状态。
///
/// 由 `EscalationRunController` 依据仓储推送的记录逐帧更新，
/// 只承载展示所需字段，不含任何业务判定逻辑。
@immutable
class EscalationRunState {
  const EscalationRunState({
    required this.phase,
    required this.runId,
    required this.chain,
    required this.steps,
    required this.outcome,
    required this.reasons,
    this.pairing = false,
  });

  /// 空闲态：无运行、无结论。
  const EscalationRunState.idle()
    : phase = EscalationRunPhase.idle,
      runId = '',
      chain = null,
      steps = const <EscalationStepRecord>[],
      outcome = null,
      reasons = const <EscalationReason>[],
      pairing = false;

  final EscalationRunPhase phase;

  /// 原生分配的运行 id；尚未受理时为空串。
  final String runId;

  /// 本次运行使用的链；空闲时为空。
  final EscalationChain? chain;

  /// 已到达的阶段记录，按原生推送顺序追加。
  final List<EscalationStepRecord> steps;

  /// 运行结束后的结论；运行中与空闲时为空。
  final EscalationOutcome? outcome;

  /// 各阶段带出的原因码去重合集，供结果卡展示。
  final List<EscalationReason> reasons;

  /// 本次是否为无线调试配对会话（而非提权运行）。
  ///
  /// 配对码在通知栏输入，页面上的主按钮此时不提供取消——取消只会在 UI 侧
  /// 断开订阅，原生线程仍会等满用户输码窗口，给出可点击的取消反而是误导。
  final bool pairing;

  /// 是否正在运行。
  bool get isRunning => phase == EscalationRunPhase.running;

  /// 是否已结束且拿到结论。
  bool get isFinished =>
      phase == EscalationRunPhase.finished && outcome != null;
}

/// 提权动作数据源。
///
/// 轮询器挂在数据源内部，必须活到运行结束，因此用 `keepAlive`，
/// 由容器销毁时统一释放计时器，避免运行中途被回收导致收不到结束帧。
@Riverpod(keepAlive: true)
EscalationActionDatasource escalationActionDatasource(Ref ref) {
  final EscalationActionDatasource datasource = EscalationActionDatasource(
    native: ref.watch(escalationNativeProvider),
  );
  ref.onDispose(datasource.dispose);
  return datasource;
}

/// 提权动作仓储。
@Riverpod(keepAlive: true)
EscalationActionRepository escalationActionRepository(Ref ref) {
  return EscalationActionRepositoryImpl(
    datasource: ref.watch(escalationActionDatasourceProvider),
    recordRepository: ref.watch(escalationRecordRepositoryProvider),
  );
}

/// 提权运行控制器：页面唯一的写入口。
///
/// 单 running 锁由 [start] 内部保证；结束时主动失效记录与遗留状态，
/// 让页面横幅与快捷面板红点立即反映最新结果。
@Riverpod(keepAlive: true)
class EscalationRunController extends _$EscalationRunController {
  StreamSubscription<EscalationRunRecord>? _subscription;

  @override
  EscalationRunState build() {
    ref.onDispose(() => unawaited(_subscription?.cancel()));
    return const EscalationRunState.idle();
  }

  /// 启动一次提权运行。
  ///
  /// 已在运行时直接返回，避免重复点击造成两次 `startRun`。
  Future<void> start(EscalationChain chain) async {
    if (state.isRunning) return;

    await _subscription?.cancel();
    _subscription = null;
    state = EscalationRunState(
      phase: EscalationRunPhase.running,
      runId: '',
      chain: chain,
      steps: const <EscalationStepRecord>[],
      outcome: null,
      reasons: const <EscalationReason>[],
    );

    final EscalationActionRepository repository = ref.read(
      escalationActionRepositoryProvider,
    );
    _subscription = repository
        .run(EscalationRequest(chain: chain, args: const <String, String>{}))
        .listen(
          _onRecord,
          onError: (Object error, StackTrace stackTrace) => _onStreamError(),
          onDone: _onStreamDone,
          cancelOnError: true,
        );
  }

  /// 发起一次无线调试配对。
  ///
  /// 配对码在**通知栏**里输入，地址与端口由原生 mDNS 自动发现，所以这里不接受
  /// 任何参数，也不打开任何对话框：一旦把本 App 切到前台，系统「使用配对码
  /// 配对设备」的弹窗就会失效、配对码作废。
  ///
  /// 与 [start] 共用同一个 running 锁与订阅，页面不会同时跑两件写操作。
  Future<void> startPairing() async {
    if (state.isRunning) return;

    await _subscription?.cancel();
    _subscription = null;
    state = EscalationRunState(
      phase: EscalationRunPhase.running,
      runId: '',
      // 配对不是提权链；原生以 `payload` 标识该会话，页面不展示此字段。
      chain: EscalationChain.payload,
      steps: const <EscalationStepRecord>[],
      outcome: null,
      reasons: const <EscalationReason>[],
      pairing: true,
    );

    _subscription = ref
        .read(escalationActionRepositoryProvider)
        .pair()
        .listen(
          _onRecord,
          onError: (Object error, StackTrace stackTrace) => _onStreamError(),
          onDone: _onStreamDone,
          cancelOnError: true,
        );
  }

  /// 取消当前运行并回到空闲态。
  ///
  /// 取消不产生结论：原生可能已经写入一半状态，这里不臆断成功或失败，
  /// 只把页面退回可重新开始的形态，遗留与否交由下一次探测和记录判定。
  Future<void> cancel() async {
    if (!state.isRunning) return;

    final String runId = state.runId;
    await _subscription?.cancel();
    _subscription = null;
    if (runId.isNotEmpty) {
      await ref.read(escalationActionRepositoryProvider).cancel(runId);
    }
    state = const EscalationRunState.idle();
    ref.invalidate(escalationRecordsProvider);
  }

  /// 逐帧接收运行记录：未结束只更新阶段，结束帧写结论并落盘。
  void _onRecord(EscalationRunRecord record) {
    if (record.isRunning) {
      state = EscalationRunState(
        phase: EscalationRunPhase.running,
        runId: record.runId,
        chain: record.chain,
        steps: record.steps,
        outcome: null,
        reasons: const <EscalationReason>[],
        pairing: state.pairing,
      );
      return;
    }

    state = EscalationRunState(
      phase: EscalationRunPhase.finished,
      runId: record.runId,
      chain: record.chain,
      steps: record.steps,
      outcome: record.outcome,
      reasons: _collectReasons(record.steps),
      // 结束帧必须把配对标记归零：否则主按钮永远停在「等待通知栏输入配对码」
      // 且保持禁用，用户看到的结局就是「输完码没下文」。
      pairing: false,
    );
  }

  /// 流正常结束；此时仓储已把记录落盘，可以安全刷新读取侧。
  void _onStreamDone() {
    _subscription = null;
    if (state.isRunning) _finishAsFailed();
    _invalidateRecords();
  }

  /// 流异常：原生通道在运行中断开，按执行失败收尾，页面不留运行态。
  void _onStreamError() {
    _subscription = null;
    _finishAsFailed();
    _invalidateRecords();
  }

  void _finishAsFailed() {
    state = EscalationRunState(
      phase: EscalationRunPhase.finished,
      runId: state.runId,
      chain: state.chain,
      steps: state.steps,
      outcome: EscalationOutcome.failed,
      reasons: const <EscalationReason>[EscalationReason.executeFailed],
      // 同上：异常收尾也要退出配对态，页面才能重新发起。
      pairing: false,
    );
  }

  void _invalidateRecords() {
    ref.invalidate(escalationRecordsProvider);
    ref.invalidate(escalationResidualProvider);
  }

  /// 汇总各阶段原因码并去重，顺序保持首次出现的位置。
  List<EscalationReason> _collectReasons(List<EscalationStepRecord> steps) {
    final List<EscalationReason> reasons = <EscalationReason>[];
    for (final EscalationStepRecord step in steps) {
      for (final EscalationReason reason in step.reasons) {
        if (!reasons.contains(reason)) reasons.add(reason);
      }
    }
    return List<EscalationReason>.unmodifiable(reasons);
  }
}
