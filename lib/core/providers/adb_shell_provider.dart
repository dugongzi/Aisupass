import 'dart:async';
import 'dart:io';

import 'package:Aisupass/generated/adb_shell.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 原生接口实例，与 Pigeon 通道一一对应。
final Provider<AdbShellNative> adbShellNativeProvider =
    Provider<AdbShellNative>((ref) => AdbShellNative());

/// 当前是否已经有一条 adb shell 连接，以及它是以谁的 uid 跑起来的。
///
/// 桌面端没有无线调试，固定返回未连接。
final FutureProvider<ShellConnection> shellConnectionProvider =
    FutureProvider<ShellConnection>((ref) async {
      ShellConnection disconnected() =>
          ShellConnection(connected: false, uid: -1);
      if (!Platform.isAndroid) return disconnected();

      final AdbShellNative native = ref.watch(adbShellNativeProvider);
      try {
        return await native.connection();
      } catch (_) {
        // 原生未注册或调用失败时按未连接处理。
        return disconnected();
      }
    });

/// 配对会话的当前快照，面板据此决定显示哪一行字、给哪个按钮。
@immutable
class ShellPairingState {
  const ShellPairingState({this.sessionId, this.stage, this.reason, this.detail});

  /// 原生侧会话 id；为空表示当前没有会话。
  final String? sessionId;

  /// 会话阶段，[PairingStage.done] 表示已经收尾。
  final PairingStage? stage;

  /// 失败原因码；成功收尾时为空。
  final String? reason;

  /// 原生回传的原始细节，可能带 stderr，允许用户复制。
  final String? detail;

  /// 会话是否还在推进。
  bool get active => sessionId != null && stage != PairingStage.done;

  /// 会话是否以失败收尾。
  bool get failed => stage == PairingStage.done && reason != null;
}

/// 无线调试配对：配对码在通知栏里输，调试端口由 mDNS 自动发现。
final NotifierProvider<ShellPairingController, ShellPairingState>
shellPairingProvider =
    NotifierProvider<ShellPairingController, ShellPairingState>(
      ShellPairingController.new,
    );

class ShellPairingController extends Notifier<ShellPairingState> {
  /// 轮询间隔：原生快照是纯内存读取，400ms 足够跟上阶段变化。
  static const Duration _pollInterval = Duration(milliseconds: 400);

  /// 原生只有 `hostPairingFailed` 这一个笼统码可用于「调用本身失败」。
  static const String _hostPairingFailed = 'hostPairingFailed';

  Timer? _timer;

  /// 上一次轮询还没回来就不再叠新请求，避免 Pigeon 后台线程被堆满。
  bool _polling = false;

  @override
  ShellPairingState build() {
    ref.onDispose(_stop);
    return const ShellPairingState();
  }

  /// 发起一次配对。
  Future<void> start() async {
    if (state.active) return;
    final AdbShellNative native = ref.read(adbShellNativeProvider);

    final PairingStartResult result;
    try {
      // 三个参数留空 = 通知栏模式：地址与端口由原生侧 mDNS 发现。
      result = await native.startPairing('', 0, '');
    } catch (error) {
      state = ShellPairingState(
        stage: PairingStage.done,
        reason: _hostPairingFailed,
        detail: '$error',
      );
      return;
    }

    if (!result.accepted) {
      state = ShellPairingState(
        stage: PairingStage.done,
        reason: result.reasons.isEmpty
            ? _hostPairingFailed
            : result.reasons.first,
      );
      return;
    }

    state = ShellPairingState(
      sessionId: result.sessionId,
      stage: PairingStage.waitingCode,
    );
    _startPolling(result.sessionId);
  }

  /// 取消当前会话，界面立刻回到「未连接」。
  Future<void> cancel() async {
    final String? sessionId = state.sessionId;
    _stop();
    state = const ShellPairingState();
    if (sessionId == null || sessionId.isEmpty) return;
    try {
      await ref.read(adbShellNativeProvider).cancelPairing(sessionId);
    } catch (_) {
      // 取消失败不影响界面：原生会话到点也会自己超时收尾。
    }
  }

  void _startPolling(String sessionId) {
    _stop();
    _timer = Timer.periodic(_pollInterval, (_) => _poll(sessionId));
  }

  Future<void> _poll(String sessionId) async {
    if (_polling) return;
    _polling = true;

    final PairingSnapshot snapshot;
    try {
      snapshot = await ref.read(adbShellNativeProvider).pollPairing(sessionId);
    } catch (error) {
      _polling = false;
      // 会话已被取消或替换：这条结果属于旧会话，丢掉。
      if (state.sessionId != sessionId) return;
      _stop();
      state = ShellPairingState(
        sessionId: sessionId,
        stage: PairingStage.done,
        reason: _hostPairingFailed,
        detail: '$error',
      );
      return;
    }
    _polling = false;

    if (state.sessionId != sessionId) return;

    state = ShellPairingState(
      sessionId: sessionId,
      stage: snapshot.stage,
      reason: snapshot.reason.isEmpty ? null : snapshot.reason,
      detail: snapshot.detail.isEmpty ? null : snapshot.detail,
    );

    if (snapshot.finished) {
      _stop();
      // 配对收尾后连接可能已经建立，让状态行去问一次原生。
      ref.invalidate(shellConnectionProvider);
    }
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }
}
