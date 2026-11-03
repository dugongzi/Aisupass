import 'package:pigeon/pigeon.dart';

/// 无线 ADB 的 shell 连接状态。
///
/// 只描述「连上了没有、当前是什么身份」。
class ShellConnection {
  ShellConnection({required this.connected, required this.uid});

  /// ADB 连接是否活着。
  bool connected;

  /// 当前身份 uid：`2000` = shell，`-1` = 未知或不可用。
  int uid;
}

/// 配对受理结果。
class PairingStartResult {
  PairingStartResult({
    required this.accepted,
    required this.sessionId,
    required this.reasons,
  });

  /// 是否受理。
  bool accepted;

  /// 受理后的会话标识；被拒时为空串。
  String sessionId;

  /// 被拒原因码。
  List<String> reasons;
}

/// 配对阶段。
enum PairingStage {
  /// 通知栏已弹出输入框，等用户输入 6 位配对码。
  waitingCode,

  /// 正在用配对码交换凭据。
  pairing,

  /// 配对码已通过，正在发现连接端点并建立调试连接。
  connecting,

  /// 会话已结束（无论成败）。
  done,
}

/// 配对会话快照，供 Dart 侧轮询。
class PairingSnapshot {
  PairingSnapshot({
    required this.sessionId,
    required this.stage,
    required this.reason,
    required this.detail,
    required this.finished,
  });

  /// 会话标识。
  String sessionId;

  /// 当前阶段。
  PairingStage stage;

  /// 失败原因码；空串表示尚未失败。
  String reason;

  /// 失败详情（异常类名等原始信息）；无失败时为空串。
  String detail;

  /// 是否已结束。
  bool finished;
}

/// 无线 ADB 配对与 shell 连接的原生接口。
///
/// 契约原则：
/// 1. 只做两件事：配对建链、读连接状态；
/// 2. 不提供任意命令执行能力，也不持有任何常驻进程；
/// 3. 不抛异常，失败一律走结构化返回值。
@HostApi()
abstract class AdbShellNative {
  /// 读当前 shell 连接状态，零副作用。
  @async
  ShellConnection connection();

  /// 发起配对。
  ///
  /// 三个参数全为空 = 通知栏模式：配对码在通知里输入，地址与端口由 mDNS 发现。
  @async
  PairingStartResult startPairing(String host, int port, String code);

  /// 轮询配对进度。
  @async
  PairingSnapshot pollPairing(String sessionId);

  /// 取消配对会话。
  @async
  void cancelPairing(String sessionId);
}
