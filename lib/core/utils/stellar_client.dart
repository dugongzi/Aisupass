import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:Aisupass/core/utils/stellar_protocol.dart';

/// Stellar 服务的回环连接客户端。
///
/// 只做「连上去、收发字节」：不判断服务是否就绪、不认识通道概念。
/// 协议常量与编解码在 `stellar_protocol.dart`，业务判定在 Provider 层。
///
/// 为什么是裸 Socket 而不是 Pigeon：服务端是本应用 fork 出来的独立 C 进程
/// （见 `android/app/src/main/jni/stellar/`），Pigeon 的 BinaryMessenger 只能
/// 调同一进程内注册的 HostApi，物理上够不到它。

/// 连一次回环端口；失败返回 null。
Future<Socket?> _dial(int port) async {
  try {
    final Socket socket = await Socket.connect(
      InternetAddress.loopbackIPv4,
      port,
      timeout: stellarConnectTimeout,
    );
    socket.setOption(SocketOption.tcpNoDelay, true);
    return socket;
  } catch (_) {
    return null;
  }
}

/// 读完一条连接的全部字节；超时或出错返回 null。
///
/// 一次性请求（`PING` / `STOP` / `EXEC`）的应答写完服务端就会关连接，
/// 所以「读到 EOF」等价于「应答已完整」。这样不必自己处理半包。
Future<Uint8List?> _readAll(Socket socket, Duration timeout) async {
  final BytesBuilder buffer = BytesBuilder(copy: true);
  try {
    await socket.timeout(timeout).forEach(buffer.add);
  } on TimeoutException {
    return null;
  } catch (_) {
    return null;
  }
  return buffer.takeBytes();
}

/// 从已读满的字节里切出第一行（不含换行符）；没有换行返回 -1。
int _firstNewline(Uint8List raw) => raw.indexOf(0x0A);

/// 解码一段字节为字符串；非法序列用宽松模式兜住。
String _text(Uint8List raw, int start, int end) =>
    utf8.decode(Uint8List.sublistView(raw, start, end), allowMalformed: true);

/// 探活：发一行，读到 EOF，解析第一行应答头。
///
/// 区分「连不上」（端口无人监听）与「连上但没给出本协议应答」：
/// 前者 `reachable` 为 false，后者为 true 但 `header.protocol` 为 0。
Future<StellarProbe> stellarProbe({
  required int port,
  required String line,
  Duration timeout = stellarReplyTimeout,
}) async {
  final Socket? socket = await _dial(port);
  if (socket == null) {
    return (reachable: false, header: emptyStellarHeader);
  }

  try {
    socket.write('$line\n');
    await socket.flush();
    final Uint8List? raw = await _readAll(socket, timeout);
    if (raw == null) {
      return (reachable: true, header: emptyStellarHeader);
    }
    final int newline = _firstNewline(raw);
    if (newline < 0) {
      return (reachable: true, header: emptyStellarHeader);
    }
    return (reachable: true, header: parseStellarHeader(_text(raw, 0, newline)));
  } catch (_) {
    // 写到一半被对端重置：连接本身是通的，但没有可用应答。
    return (reachable: true, header: emptyStellarHeader);
  } finally {
    socket.destroy();
  }
}

/// 发一行 + 可选字节体，读到 EOF，切成「头 + 体」。
///
/// 连接失败、没有行头、读取超时一律返回 null——对调用方而言都是
/// 「这次没拿到可用应答」。
Future<StellarReply?> stellarRequest({
  required int port,
  required String line,
  required Duration timeout,
  List<int> body = const <int>[],
}) async {
  final Socket? socket = await _dial(port);
  if (socket == null) return null;

  try {
    socket.write('$line\n');
    if (body.isNotEmpty) socket.add(body);
    await socket.flush();

    final Uint8List? raw = await _readAll(socket, timeout);
    if (raw == null) return null;

    final int newline = _firstNewline(raw);
    if (newline < 0) return null;

    return (
      header: parseStellarHeader(_text(raw, 0, newline)),
      body: Uint8List.sublistView(raw, newline + 1),
    );
  } catch (_) {
    return null;
  } finally {
    socket.destroy();
  }
}

/// pty 长连接：一次 `OPEN` 一条，读帧走 [frames]，写帧走各方法。
///
/// 与一次性请求不同，这里不能「读到 EOF 再解析」：会话是长期活着的，
/// 输出持续到达，必须边收边切帧。
class StellarPtyConnection {
  StellarPtyConnection({required this.port, required this.token});

  final int port;
  final String token;

  Socket? _socket;
  final List<int> _pending = <int>[];
  final StreamController<StellarFrame> _frames =
      StreamController<StellarFrame>.broadcast();
  final Completer<StellarHeader> _head = Completer<StellarHeader>();

  bool _headDone = false;
  bool _closed = false;

  /// 服务端推来的帧；连接结束时流关闭。
  Stream<StellarFrame> get frames => _frames.stream;

  /// 开一条会话；返回是否受理。
  Future<bool> open(String command, int rows, int cols) async {
    final Socket? socket = await _dial(port);
    if (socket == null) return false;
    _socket = socket;

    socket.listen(
      _onData,
      onDone: _onDone,
      onError: (Object _) => _onDone(),
      cancelOnError: true,
    );

    final List<int> commandBytes = utf8.encode(command);
    socket.write('OPEN $token $rows $cols ${commandBytes.length}\n');
    socket.add(commandBytes);
    await socket.flush();

    final StellarHeader header;
    try {
      header = await _head.future.timeout(stellarReplyTimeout);
    } on TimeoutException {
      await close();
      return false;
    }
    if (header.ok != 1) {
      await close();
      return false;
    }

    // 首帧必须是尺寸：服务端在收到它之前按 24x80 排版。
    await resize(rows, cols);
    return true;
  }

  /// 把键盘字节原样转发给远端 pty。
  Future<bool> writeStdin(List<int> bytes) =>
      _send(encodeStellarFrame(stellarFrameStdin, bytes));

  /// 同步窗口尺寸（字符网格）。
  Future<bool> resize(int rows, int cols) {
    final Uint8List body = Uint8List(4);
    body[0] = rows & 0xFF;
    body[1] = (rows >> 8) & 0xFF;
    body[2] = cols & 0xFF;
    body[3] = (cols >> 8) & 0xFF;
    return _send(encodeStellarFrame(stellarFrameResize, body));
  }

  /// 结束会话：发 CLOSE 帧后断开。
  Future<void> close() async {
    if (_closed) return;
    _closed = true;

    final Socket? socket = _socket;
    if (socket != null) {
      try {
        socket.add(encodeStellarFrame(stellarFrameClose, const <int>[]));
        await socket.flush();
      } catch (_) {
        // 连接可能已经断了，关掉即可。
      }
      socket.destroy();
    }
    _socket = null;

    if (!_head.isCompleted) _head.complete(emptyStellarHeader);
    if (!_frames.isClosed) await _frames.close();
  }

  Future<bool> _send(Uint8List frame) async {
    final Socket? socket = _socket;
    if (socket == null || _closed) return false;
    try {
      socket.add(frame);
      await socket.flush();
      return true;
    } catch (_) {
      return false;
    }
  }

  void _onData(Uint8List data) {
    _pending.addAll(data);
    if (!_headDone) _takeHead();
    if (_headDone) _drainFrames();
  }

  /// 切出第一行（`{"ok":1,...}`），剩下的留给帧解析。
  void _takeHead() {
    final int newline = _firstNewline(Uint8List.fromList(_pending));
    if (newline < 0) return;

    final String line = utf8.decode(
      Uint8List.fromList(_pending.sublist(0, newline)),
      allowMalformed: true,
    );
    _pending.removeRange(0, newline + 1);
    _headDone = true;

    if (!_head.isCompleted) _head.complete(parseStellarHeader(line));
    _drainFrames();
  }

  /// 从累积缓冲里按 `type:u8 + len:u32 LE + body` 逐帧切出。
  void _drainFrames() {
    while (_pending.length >= stellarFrameHead) {
      final int type = _pending[0];
      final int length = readU32le(_pending, 1);
      if (length < 0 || _pending.length < stellarFrameHead + length) break;

      final Uint8List body = Uint8List.fromList(
        _pending.sublist(stellarFrameHead, stellarFrameHead + length),
      );
      _pending.removeRange(0, stellarFrameHead + length);

      if (!_frames.isClosed) {
        _frames.add((type: type, body: body));
      }
    }
  }

  void _onDone() {
    if (!_head.isCompleted) _head.complete(emptyStellarHeader);
    if (!_frames.isClosed) unawaited(_frames.close());
  }
}
