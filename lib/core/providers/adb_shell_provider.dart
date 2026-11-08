import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

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
  const ShellPairingState({
    this.sessionId,
    this.stage,
    this.reason,
    this.detail,
  });

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

/// 终端会话的当前状态。
///
/// 只有三项：会话能不能用、丢了多少字节、最近一次通道故障。
/// 刻意没有「有没有命令在跑」和退出码——pty 会话是交互式的，屏幕上的提示符
/// 就是它的心跳，`ls` 跑完也不存在一个「本次执行结束」的边界可以汇报。
@immutable
class ShellTerminalState {
  const ShellTerminalState({
    this.ready = false,
    this.droppedBytes = 0,
    this.failure = '',
  });

  /// 会话是否可用。pty 会话没有「忙 / 闲」，只有「流活着 / 流断了」。
  final bool ready;

  /// 因消费不及时被丢弃的累计字节数；`0` 表示输出完整。
  final int droppedBytes;

  /// 原因码或读流出错的异常类名；空串表示没有故障。
  final String failure;
}

/// 输出的接收方：`isStderr` 为 true 时是标准错误。
///
/// 用回调而不是 `Stream`：终端只要一个「把这段字节写到屏幕上」的入口，
/// `Stream` 还要额外处理订阅时机、取消和「谁来关」。
///
/// pty 下远端已经把 stdout/stderr 合并，`isStderr` 恒为 false；保留这个参数
/// 是为了让页面仍能区分一次性 [AdbShellNative.exec] 的两路输出。
typedef TerminalExecSink = void Function(String text, bool isStderr);

/// 终端里那条常驻 shell，以及它的输出通路。
///
/// 会话开在 **pty**（`shell,v2,pty,TERM=xterm-256color:`）上：远端 `sh` 拿到了
/// 一条真正的控制终端，于是它自己回显、自己打提示符、自己处理退格与方向键，
/// `Ctrl+C` 由 line discipline 翻译成 SIGINT 送给前台进程组。所以本端**不做**
/// 任何行缓冲、本地回显或命令切分——键盘字节原样转发，屏幕字节原样写回。
///
/// 也正因为它是交互式的，「一条命令什么时候跑完」没有信号，也不需要有：
/// 页面里预置命令只是「替用户敲一行再回车」，输出和退出状态由 shell 自己表达。
///
/// 为什么要常驻：每条命令各开一个 `shell,v2,...:<cmd>`，adbd 会为它 fork 一个
/// 新进程，进程一退工作目录跟着消失，于是 `cd /data/local/tmp` 敲完毫无效果、
/// `export` 也不跨行。常驻 shell 下所有输入都进同一个 `sh`，状态一直活着。
final NotifierProvider<ShellExecController, ShellTerminalState>
shellExecProvider = NotifierProvider<ShellExecController, ShellTerminalState>(
  ShellExecController.new,
);

class ShellExecController extends Notifier<ShellTerminalState> {
  /// 轮询间隔。
  ///
  /// 原生 `pollExec` 是纯内存取增量，一次调用的成本只有 Pigeon 往返；
  /// 60ms 让回显和流式输出看起来是跟着手指走的，再密只是平白多出跨进程调用。
  static const Duration _pollInterval = Duration(milliseconds: 60);

  /// 常驻 shell 的入口命令。
  ///
  /// adbd 把这段当成 `sh -c <这段>` 执行，最后一步 `exec sh -i` 把进程换成挂在
  /// pty 上的交互式 shell：远端自己打提示符、开行编辑、接作业控制。`-i` 写明白，
  /// 不去赌「stdin 是终端就自动进交互模式」这条隐式规则。
  ///
  /// 前面那句 `PS1` 让提示符带上**当前绝对路径**：mksh 打印提示符时会做参数
  /// 展开，所以 `${PWD}` 在每次 `cd` 之后都会重新求值。默认的 `$ ` 什么都不显示，
  /// 用户 `cd` 过去就不知道自己在哪。
  ///
  /// 为什么写在命令行里而不是等提示符出来再往 stdin 灌一行：命令行参数不经过
  /// pty，不会被回显；灌进去的那条赋值会明晃晃留在首屏上。
  ///
  /// `export` 是必需的：`exec` 换掉的是进程镜像，没导出的 shell 变量不会传给
  /// 内层 shell。
  ///
  /// 注意 `,` 与 `:` 不能出现在这里：服务串是 `shell,v2,pty,TERM=...:<命令>`，
  /// 逗号分隔选项、第一个冒号之后才是命令。
  static const String _shellCommand = "PS1='\${PWD} \$ '; export PS1; exec sh -i";

  /// 常驻会话 id；为空表示还没建（或已经断了，下次写入时重建）。
  String? _sessionId;

  /// 正在建立的会话。同一时刻只允许一条 `startExec`，否则连点两下菜单就会
  /// 拿到两条会话、两块互相往同一个屏幕上写的输出。
  Future<String?>? _opening;

  Timer? _timer;

  /// 上一次轮询还没回来就不再叠新请求：增量是按顺序摘走的，
  /// 堆积只会让输出晚到，不会更快。
  bool _polling = false;

  /// 输出接收方。页面每次 build 重挂一次——回调要拿到最新的终端实例。
  TerminalExecSink? _sink;

  @override
  ShellTerminalState build() {
    ref.onDispose(close);
    return const ShellTerminalState();
  }

  /// 挂上输出通路。传 `null` 表示暂时不要输出。
  void attachSink(TerminalExecSink? sink) => _sink = sink;

  /// 建立会话，幂等。页面进来就调一次，让远端提示符立刻出现。
  Future<void> open() async {
    await _ensureSession();
  }

  /// 把键盘字节原样转发给 pty。
  ///
  /// 不做任何加工：退格、方向键、`Ctrl+C`、粘贴进来的整段文本都只是字节，
  /// 该由远端的 line discipline 与 shell 决定怎么解释。本地再消化一遍的结果
  /// 就是和远端重复回显、或者把全屏程序的按键吃掉。
  Future<bool> writeBytes(List<int> bytes) async {
    if (bytes.isEmpty) return false;
    final String? sessionId = await _ensureSession();
    if (sessionId == null) return false;
    try {
      return await ref
          .read(adbShellNativeProvider)
          .writeExecStdin(sessionId, Uint8List.fromList(bytes));
    } catch (_) {
      // 会话刚好断开时写必然失败；调用方按「这次按键丢了」处理即可。
      return false;
    }
  }

  /// 把视口的字符尺寸同步给 pty。
  ///
  /// pty 的 `winsize` 决定远端怎么折行、全屏程序画多大。不传的话远端一直按
  /// 80x24 排版：`top` 只占左上角一块，长输出在 80 列处硬折。
  Future<void> resize(int rows, int cols) async {
    final String? sessionId = _sessionId;
    if (sessionId == null || rows <= 0 || cols <= 0) return;
    try {
      await ref.read(adbShellNativeProvider).resizeExec(sessionId, rows, cols);
    } catch (_) {
      // 尺寸只影响远端排版，丢了也无害，不值得打扰用户。
    }
  }

  /// 关掉常驻 shell。页面销毁时调用，别留一条没人管的会话。
  void close() {
    final String? sessionId = _sessionId;
    _sessionId = null;
    _opening = null;
    _sink = null;
    _stopTimer();
    if (sessionId != null) _cancelQuietly(sessionId);
  }

  /// 确保有一条可用的常驻 shell，没有就建一条。
  Future<String?> _ensureSession() {
    final String? existing = _sessionId;
    if (existing != null) return Future<String?>.value(existing);
    return _opening ??= _startSession().whenComplete(() {
      _opening = null;
    });
  }

  Future<String?> _startSession() async {
    final ExecStartResult started;
    try {
      // 0 = 不限时：这条会话本来就不该因为「活得久」被掐断。
      started = await ref
          .read(adbShellNativeProvider)
          .startExec(_shellCommand, 0);
    } catch (error) {
      state = ShellTerminalState(failure: '$error');
      return null;
    }

    if (!started.accepted || started.sessionId.isEmpty) {
      state = ShellTerminalState(
        failure: started.reasons.isEmpty ? 'unknown' : started.reasons.first,
      );
      return null;
    }

    _sessionId = started.sessionId;
    state = const ShellTerminalState(ready: true);
    _stopTimer();
    _timer = Timer.periodic(_pollInterval, (_) => unawaited(_poll()));
    // 提示符可能在第一个间隔之前就到了，立刻取一次，别白等。
    unawaited(_poll());
    return started.sessionId;
  }

  Future<void> _poll() async {
    final String? sessionId = _sessionId;
    if (sessionId == null || _polling) return;
    _polling = true;

    final ExecChunk chunk;
    try {
      chunk = await ref.read(adbShellNativeProvider).pollExec(sessionId);
    } catch (error) {
      _polling = false;
      // 会话已经换人或结束：这条结果属于旧会话，丢掉。
      if (_sessionId != sessionId) return;
      _dropSession(failure: '$error');
      return;
    }
    _polling = false;

    // 会话已经换人或结束：同上。
    if (_sessionId != sessionId) return;

    // pty 下两路已在远端合并，stderr 恒为空；两条分支都留着，免得将来切回
    // raw 时这里悄悄吞掉错误输出。
    if (chunk.stderr.isNotEmpty) _sink?.call(chunk.stderr, true);
    if (chunk.stdout.isNotEmpty) _sink?.call(chunk.stdout, false);

    if (chunk.droppedBytes > state.droppedBytes) {
      state = ShellTerminalState(
        ready: state.ready,
        droppedBytes: chunk.droppedBytes,
        failure: state.failure,
      );
    }

    // 用户在终端里敲了 `exit`、设备掉线、读流异常：会话没了，通路跟着收摊。
    if (chunk.finished) _dropSession(failure: chunk.failure);
  }

  /// 会话不可再用：收掉轮询，把原因记进状态，让页面说明一句。
  void _dropSession({String failure = ''}) {
    final String? sessionId = _sessionId;
    _sessionId = null;
    _stopTimer();
    state = ShellTerminalState(droppedBytes: state.droppedBytes, failure: failure);
    if (sessionId != null) _cancelQuietly(sessionId);
  }

  /// 尽力中断；失败不影响本端状态。
  void _cancelQuietly(String sessionId) {
    try {
      unawaited(
        ref
            .read(adbShellNativeProvider)
            .cancelExec(sessionId)
            .then<void>((_) {}, onError: (Object _, StackTrace _) {}),
      );
    } catch (_) {
      // 原生未注册或容器已销毁，这里无从下手。
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
