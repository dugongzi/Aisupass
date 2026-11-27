import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:Aisupass/core/models/command_channel.dart';
import 'package:Aisupass/core/providers/command_channel_provider.dart';
import 'package:Aisupass/core/providers/stellar_token_provider.dart';
import 'package:Aisupass/core/providers/terminal_exec_backend.dart';
import 'package:Aisupass/core/utils/escalation_reason.dart';
import 'package:Aisupass/core/utils/stellar_client.dart';
import 'package:Aisupass/core/utils/stellar_protocol.dart';
import 'package:Aisupass/generated/adb_shell.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'terminal_backend_provider.g.dart';

/// 当前通道的终端后端。
///
/// `keepAlive` 是必需的：`ShellExecController` 用 `ref.read` 取值，
/// autoDispose 会在同一帧后销毁实例，Stellar 连接会随之丢失。
@Riverpod(keepAlive: true)
TerminalExecBackend terminalExecBackend(Ref ref) {
  final CommandChannel channel = ref.watch(commandChannelControllerProvider);
  final TerminalExecBackend backend = switch (channel) {
    CommandChannel.adb => _AdbTerminalBackend(),
    CommandChannel.stellar => _StellarTerminalBackend(ref),
  };
  ref.onDispose(backend.dispose);
  return backend;
}

/// 无线 ADB 后端：逐字段搬运 Pigeon 结果，不加任何判断。
///
/// 这里自行构造 [AdbShellNative] 而不读 `adbShellNativeProvider`——
/// 那个 Provider 在 `adb_shell_provider.dart` 里，反向 import 会形成循环依赖。
/// 原生侧只有一个 Impl（多实例指向同一条 Pigeon 通道），因此不产生第二套连接状态。
class _AdbTerminalBackend implements TerminalExecBackend {
  final AdbShellNative _native = AdbShellNative();

  @override
  Future<TerminalStart> start(String command, int timeoutMs) async {
    final ExecStartResult started = await _native.startExec(
      command,
      timeoutMs,
    );
    return (
      accepted: started.accepted,
      sessionId: started.sessionId,
      failure: started.reasons.isEmpty ? 'unknown' : started.reasons.first,
    );
  }

  @override
  Future<TerminalChunk> poll(String sessionId) async {
    final ExecChunk chunk = await _native.pollExec(sessionId);
    return (
      stdout: chunk.stdout,
      finished: chunk.finished,
      exitCode: chunk.exitCode,
      timedOut: chunk.timedOut,
      droppedBytes: chunk.droppedBytes,
      failure: chunk.failure,
    );
  }

  @override
  Future<bool> writeStdin(String sessionId, Uint8List data) =>
      _native.writeExecStdin(sessionId, data);

  @override
  Future<void> resize(String sessionId, int rows, int cols) =>
      _native.resizeExec(sessionId, rows, cols);

  @override
  Future<void> cancel(String sessionId) => _native.cancelExec(sessionId);

  /// ADB 后端是纯代理，自身不持有跨会话资源。
  @override
  void dispose() {}
}

/// Stellar 后端：在回环服务的 pty 上跑会话。
///
/// 与服务端的分工：服务端持有真 pty 与子进程，本端只搬运帧。
/// 帧是先到的，`poll` 是定时来取的，所以这里需要一个增量缓冲。
class _StellarTerminalBackend implements TerminalExecBackend {
  _StellarTerminalBackend(this._ref);

  final Ref _ref;

  StellarPtyConnection? _conn;
  StreamSubscription<StellarFrame>? _watch;

  final StringBuffer _pending = StringBuffer();
  bool _finished = false;
  int _exitCode = -1;
  bool _timedOut = false;
  String _failure = '';

  @override
  Future<TerminalStart> start(String command, int timeoutMs) async {
    // 同一时刻只允许一条会话；重复 start 会先收掉旧的。
    await _teardown();

    final String token;
    try {
      token = await _ref.read(stellarServiceTokenProvider.future);
    } catch (error) {
      return (accepted: false, sessionId: '', failure: '$error');
    }

    final StellarPtyConnection conn = StellarPtyConnection(
      port: stellarServicePort,
      token: token,
    );
    // 尺寸先按默认值开：调用方紧接着会用 resize 覆盖成真实视口。
    final bool opened = await conn.open(command, 24, 80);
    if (!opened) {
      await conn.close();
      // 用「通道未就绪」而不是 Stellar 自己的原因码：终端页对这个值只让顶部
      // 提示条解释，不会往屏幕里写一行红字（那时屏幕上还没有任何内容）。
      return (
        accepted: false,
        sessionId: '',
        failure: kEscalationChannelNotReady,
      );
    }

    _conn = conn;
    _finished = false;
    _exitCode = -1;
    _timedOut = false;
    _failure = '';
    _pending.clear();

    _watch = conn.frames.listen(_onFrame, onError: (Object error) {
      _failure = '$error';
      _finished = true;
    });

    return (accepted: true, sessionId: 'stellar', failure: '');
  }

  @override
  Future<TerminalChunk> poll(String sessionId) async {
    final String chunk = _pending.toString();
    _pending.clear();

    final bool finished = _finished;
    final TerminalChunk snapshot = (
      stdout: chunk,
      finished: finished,
      exitCode: _exitCode,
      timedOut: _timedOut,
      droppedBytes: 0,
      failure: _failure,
    );

    // 会话收尾时把连接一并关掉：服务端在发完退出帧后也不再需要这条连接。
    if (finished) await _teardown();
    return snapshot;
  }

  @override
  Future<bool> writeStdin(String sessionId, Uint8List data) async {
    final StellarPtyConnection? conn = _conn;
    if (conn == null) return false;
    return conn.writeStdin(data);
  }

  @override
  Future<void> resize(String sessionId, int rows, int cols) async {
    final StellarPtyConnection? conn = _conn;
    if (conn == null) return;
    await conn.resize(rows, cols);
  }

  @override
  Future<void> cancel(String sessionId) => _teardown();

  @override
  void dispose() {
    unawaited(_teardown());
  }

  Future<void> _teardown() async {
    final StreamSubscription<StellarFrame>? watch = _watch;
    _watch = null;
    if (watch != null) await watch.cancel();

    final StellarPtyConnection? conn = _conn;
    _conn = null;
    if (conn != null) await conn.close();

    _pending.clear();
  }

  void _onFrame(StellarFrame frame) {
    if (frame.type == stellarFrameOutput) {
      _pending.write(_decode(frame.body));
      return;
    }
    if (frame.type == stellarFrameExit) {
      // 退出帧 = exitCode:i32 LE || timedOut:u8
      if (frame.body.length >= 4) _exitCode = readI32le(frame.body, 0);
      if (frame.body.length >= 5) _timedOut = frame.body[4] == 1;
      _finished = true;
    }
  }

  /// pty 输出按 UTF-8 解码；半截多字节字符用宽松模式兜住，避免整段丢失。
  String _decode(Uint8List bytes) => utf8.decode(bytes, allowMalformed: true);
}
