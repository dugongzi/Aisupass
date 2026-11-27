/// Stellar 服务的线上协议：常量、帧编解码与行头解析。
///
/// 与 C 侧的 `stellar_proto.h` 逐项对应，改一边必须改另一边。
///
/// 本文件**只做纯函数**：字节 ↔ 结构，不碰 Socket、不判身份、不判通道可用性。
/// 网络往返见 `stellar_client.dart`，业务判定见 `stellar_service_provider.dart`。
///
/// 结构一律用记录类型：这些是协议层的技术结构，不是业务实体，
/// 因此不走 Freezed（`coding.md` §4 约束的是 Entity，不是过程值）。
library;

import 'dart:convert';
import 'dart:typed_data';

/// 协议版本；与 `PROTO_VERSION` 一致。
const int stellarProtocolVersion = 2;

/// 服务端口；与 `PROTO_PORT` 一致。
const int stellarServicePort = 39187;

/// 建立连接的上限。
const Duration stellarConnectTimeout = Duration(milliseconds: 400);

/// 短应答（`PING` / `STOP`）的等待上限。
const Duration stellarReplyTimeout = Duration(milliseconds: 800);

/// 帧头长度：`type:u8 + len:u32`。
const int stellarFrameHead = 5;

/// 帧类型：客户端 → 服务端。
const int stellarFrameStdin = 1;
const int stellarFrameResize = 2;
const int stellarFrameClose = 3;

/// 帧类型：服务端 → 客户端。
const int stellarFrameOutput = 1;
const int stellarFrameExit = 2;

/// 行头 JSON 的扁平视图：所有字段非空，缺失时填默认值。
///
/// 三种应答（`PING` / `STOP` / `EXEC`）字段不同，统一成一份扁平结构，
/// 上层按需取用；`protocol == 0` 表示这条应答没有声明协议版本（即不是本协议的应答）。
typedef StellarHeader = ({
  int protocol,
  int uid,
  int ok,
  String reason,
  int exitCode,
  int timedOut,
  int durationMs,
  int outLen,
  int errLen,
  int truncated,
});

/// 一次探活的结果。
///
/// `reachable` 为 false 表示连不上（端口无人监听）；
/// `reachable` 为 true 且 `header.protocol == 0` 表示连上了但没拿到本协议应答。
typedef StellarProbe = ({bool reachable, StellarHeader header});

/// 一次请求的应答：行头 + 可选字节体。
typedef StellarReply = ({StellarHeader header, Uint8List body});

/// pty 连接上收到的一帧。
typedef StellarFrame = ({int type, Uint8List body});

/// 没有任何字段的默认行头；用于「连上了但应答不可解析」的场景。
const StellarHeader emptyStellarHeader = (
  protocol: 0,
  uid: -1,
  ok: 0,
  reason: '',
  exitCode: -1,
  timedOut: 0,
  durationMs: 0,
  outLen: 0,
  errLen: 0,
  truncated: 0,
);

/// 把一个整数写成小端 u32。
void writeU32le(Uint8List target, int offset, int value) {
  target[offset] = value & 0xFF;
  target[offset + 1] = (value >> 8) & 0xFF;
  target[offset + 2] = (value >> 16) & 0xFF;
  target[offset + 3] = (value >> 24) & 0xFF;
}

/// 从字节里读一个小端 u32。
int readU32le(List<int> source, int offset) =>
    source[offset] |
    (source[offset + 1] << 8) |
    (source[offset + 2] << 16) |
    (source[offset + 3] << 24);

/// 把一个小端 u32 按有符号 i32 解读。
///
/// 服务端写退出码用的是 `int32`；-1 直接按无符号读会变成 4294967295。
int readI32le(List<int> source, int offset) {
  final int raw = readU32le(source, offset);
  return raw >= 0x80000000 ? raw - 0x100000000 : raw;
}

/// 组一帧：`type:u8 + len:u32 LE + body`。
Uint8List encodeStellarFrame(int type, List<int> body) {
  final Uint8List frame = Uint8List(stellarFrameHead + body.length);
  frame[0] = type & 0xFF;
  writeU32le(frame, 1, body.length);
  frame.setRange(stellarFrameHead, frame.length, body);
  return frame;
}

/// 解析一行应答头；非法 JSON 返回 [emptyStellarHeader]。
StellarHeader parseStellarHeader(String line) {
  Object? decoded;
  try {
    decoded = jsonDecode(line);
  } on FormatException {
    return emptyStellarHeader;
  }
  if (decoded is! Map) return emptyStellarHeader;
  // 提到非空局部变量：下面的闭包会捕获它，类型提升在闭包里不生效。
  final Map<Object?, Object?> map = decoded;

  int intOf(String key, int fallback) {
    final Object? value = map[key];
    return value is int ? value : fallback;
  }

  String stringOf(String key) {
    final Object? value = map[key];
    return value is String ? value : '';
  }

  return (
    protocol: intOf('protocol', 0),
    uid: intOf('uid', -1),
    ok: intOf('ok', 0),
    reason: stringOf('reason'),
    exitCode: intOf('exitCode', -1),
    timedOut: intOf('timedOut', 0),
    durationMs: intOf('durationMs', 0),
    outLen: intOf('outLen', 0),
    errLen: intOf('errLen', 0),
    truncated: intOf('truncated', 0),
  );
}
