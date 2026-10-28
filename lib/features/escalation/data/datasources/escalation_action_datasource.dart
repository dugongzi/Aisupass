import 'dart:async';

import 'package:Aisupass/features/escalation/domain/enums/escalation_chain.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_reason.dart';
import 'package:Aisupass/generated/escalation.g.dart' as pigeon;

/// 提权动作数据源，**全工程唯一**允许调用 `startRun` / `pollRun` / `cancelRun` 的位置。
///
/// 轮询节奏固定 500ms，累计超过 120s 强制收尾并向原生发送取消，
/// 避免原生迟迟不返回结束态时页面无限等待。
///
/// 所有链（含演示链）一律走原生：演示链的价值就在于它是端到端的探针，
/// 一旦 Dart 侧自己模拟，管道断了也看不出来。
class EscalationActionDatasource {
  EscalationActionDatasource({required this._native});

  /// 轮询间隔。
  static const Duration pollInterval = Duration(milliseconds: 500);

  /// 单次运行的最长等待时间。
  static const Duration runTimeout = Duration(seconds: 120);

  /// 配对会话的最长等待时间。
  ///
  /// 必须明显宽于 [runTimeout]：通知栏模式下原生最多等用户输码 5 分钟，
  /// 加上 mDNS 发现与 TLS 握手，原生侧会话上限是 7 分钟。这里留出余量，
  /// 保证判超时的一定是原生而不是 Dart，否则用户还在输码就被掐断。
  static const Duration pairingTimeout = Duration(minutes: 8);

  final pigeon.EscalationNative _native;
  final Set<_RunPoller> _pollers = <_RunPoller>{};

  /// 启动一次运行。
  ///
  /// 通道异常时按「拒绝受理」返回结构化结果，不向调用方抛异常。
  Future<pigeon.StartRunResult> startRun(
    EscalationChain chain,
    Map<String, String> args,
  ) async {
    try {
      return await _native.startRun(
        _toPigeonChain(chain),
        Map<String, Object?>.from(args),
      );
    } catch (_) {
      return pigeon.StartRunResult(
        accepted: false,
        runId: '',
        reasons: <String>[EscalationReason.platformUnsupported.code],
      );
    }
  }

  /// 轮询指定运行，直到原生报告 `finished` 或触发超时。
  Stream<pigeon.RunSnapshot> watchRun(String runId, EscalationChain chain) {
    final _RunPoller poller = _RunPoller(
      runId: runId,
      chain: chain,
      fetch: _native.pollRun,
      abort: _native.cancelRun,
      timeout: runTimeout,
      onClosed: _pollers.remove,
    );
    _pollers.add(poller);
    return poller.stream;
  }

  /// 发起一次无线调试配对（通知栏输入模式）。
  ///
  /// 三个参数全部留空是刻意的：配对码由用户在**通知栏**里输入，地址与端口由
  /// mDNS 自动发现。只要让用户切回本 App 来输码，系统的「使用配对码配对设备」
  /// 对话框就会失效、配对码作废，所以这里不传任何值。
  ///
  /// 通道异常时按「拒绝受理」返回结构化结果，不向调用方抛异常。
  Future<pigeon.StartRunResult> startPairing() async {
    try {
      return await _native.startPairing('', 0, '');
    } catch (_) {
      return pigeon.StartRunResult(
        accepted: false,
        runId: '',
        reasons: <String>[EscalationReason.platformUnsupported.code],
      );
    }
  }

  /// 轮询配对会话，直到原生报告 `finished` 或触发超时。
  ///
  /// 配对没有取消接口：通知栏通知的撤销与接收器注销都由原生在收尾时完成，
  /// 这里只做只读轮询。
  Stream<pigeon.RunSnapshot> watchPairing(String sessionId) {
    final _RunPoller poller = _RunPoller(
      runId: sessionId,
      // 原生以 `payload` 标识配对会话（配对只为给该链铺出 shell）。
      chain: EscalationChain.payload,
      fetch: _native.pollPairing,
      abort: null,
      timeout: pairingTimeout,
      onClosed: _pollers.remove,
    );
    _pollers.add(poller);
    return poller.stream;
  }

  /// 取消运行并立刻停止本地轮询；对已结束的运行是幂等空操作。
  Future<void> cancelRun(String runId) async {
    for (final _RunPoller poller in _pollers.toList(growable: false)) {
      if (poller.runId == runId) poller.stop();
    }
    try {
      await _native.cancelRun(runId);
    } catch (_) {
      // 取消失败不影响本地收尾，运行记录仍按已有证据落盘。
    }
  }

  /// 释放全部轮询资源；由 Provider 销毁时调用。
  void dispose() {
    for (final _RunPoller poller in _pollers.toList(growable: false)) {
      poller.stop();
    }
    _pollers.clear();
  }

  static pigeon.EscalationChainId _toPigeonChain(EscalationChain chain) =>
      switch (chain) {
        EscalationChain.rootCheck => pigeon.EscalationChainId.rootCheck,
        EscalationChain.kernelModule => pigeon.EscalationChainId.kernelModule,
        EscalationChain.payload => pigeon.EscalationChainId.payload,
        EscalationChain.kernelExploit => pigeon.EscalationChainId.kernelExploit,
        EscalationChain.pageCache => pigeon.EscalationChainId.pageCache,
        EscalationChain.fake => pigeon.EscalationChainId.fake,
      };
}

/// 单次轮询会话，运行与配对共用。
class _RunPoller {
  _RunPoller({
    required this.runId,
    required this._chain,
    required this._fetch,
    required this._abort,
    required this._timeout,
    required this._onClosed,
  });

  final String runId;
  final EscalationChain _chain;

  /// 取一帧快照；运行走 `pollRun`，配对走 `pollPairing`。
  final Future<pigeon.RunSnapshot> Function(String id) _fetch;

  /// 超时时通知原生收尾；配对没有取消接口，故可空。
  final Future<void> Function(String id)? _abort;

  /// 本次会话的最长等待时间，运行与配对不同。
  final Duration _timeout;
  final void Function(_RunPoller poller) _onClosed;

  late final StreamController<pigeon.RunSnapshot> _controller =
      StreamController<pigeon.RunSnapshot>(
        onListen: _start,
        onCancel: () => unawaited(_finish(closeController: false)),
      );

  final int _startedAtMs = DateTime.now().millisecondsSinceEpoch;
  Timer? _timer;
  bool _busy = false;
  bool _closed = false;

  Stream<pigeon.RunSnapshot> get stream => _controller.stream;

  /// 外部主动停止（取消运行 / Provider 销毁）。
  void stop() => unawaited(_finish(closeController: true));

  void _start() {
    _timer = Timer.periodic(
      EscalationActionDatasource.pollInterval,
      (_) => unawaited(_tick()),
    );
    unawaited(_tick());
  }

  Future<void> _tick() async {
    if (_busy || _closed) return;
    _busy = true;
    try {
      final pigeon.RunSnapshot snapshot = await _fetch(runId);
      if (_closed) return;
      _controller.add(snapshot);
      if (snapshot.finished) {
        await _finish(closeController: true);
        return;
      }
      final int elapsedMs =
          DateTime.now().millisecondsSinceEpoch - _startedAtMs;
      if (elapsedMs >= _timeout.inMilliseconds) {
        try {
          await _abort?.call(runId);
        } catch (_) {
          // 超时取消失败也要继续收尾，否则页面永远停在运行态。
        }
        _controller.add(_failureSnapshot(EscalationReason.executeTimeout));
        await _finish(closeController: true);
      }
    } catch (_) {
      if (_closed) return;
      _controller.add(_failureSnapshot(EscalationReason.executeFailed));
      await _finish(closeController: true);
    } finally {
      _busy = false;
    }
  }

  Future<void> _finish({required bool closeController}) async {
    if (_closed) return;
    _closed = true;
    _timer?.cancel();
    _timer = null;
    _onClosed(this);
    if (closeController) await _controller.close();
  }

  /// 合成一帧结束态快照，用于轮询异常或超时。
  ///
  /// 证据里标记 `synthetic`，提示上层这条记录不是原生真实阶段产出。
  pigeon.RunSnapshot _failureSnapshot(EscalationReason reason) =>
      pigeon.RunSnapshot(
        runId: runId,
        chain: EscalationActionDatasource._toPigeonChain(_chain),
        phase: pigeon.EscalationStage.cleanup,
        steps: <pigeon.RunStep>[
          pigeon.RunStep(
            stage: pigeon.EscalationStage.execute,
            startedAtMs: _startedAtMs,
            durationMs: DateTime.now().millisecondsSinceEpoch - _startedAtMs,
            ok: false,
            reasons: <String>[reason.code],
            evidence: const <String, Object?>{'synthetic': 'true'},
          ),
        ],
        finished: true,
      );
}
