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

/// 一条 shell 命令的执行结果。
///
/// 刻意不提供 `success` 布尔值：原生只回证据，判定权留给上层。
class ShellExecResult {
  ShellExecResult({
    required this.exitCode,
    required this.stdout,
    required this.stderr,
    required this.durationMs,
    required this.timedOut,
  });

  /// 退出码；`-1` 表示命令没跑起来（通道未连接、流未建立等）。
  ///
  /// 被信号终止时按 `128 + 信号值` 计，这与 shell 的惯例一致。
  int exitCode;

  /// 标准输出。
  String stdout;

  /// 标准错误。
  String stderr;

  /// 耗时（毫秒），单调时钟。
  int durationMs;

  /// 是否因超时被掐断。
  bool timedOut;
}

/// 无线 ADB 配对与 shell 连接的原生接口。
///
/// 契约原则：
/// 1. 配对建链、读连接状态、在当前连接上执行单条命令；
/// 2. 不持有任何常驻进程：每条命令跑完即回收，不保留交互式会话；
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

  /// 在当前 shell 连接上执行一条命令。
  ///
  /// 走 ADB shell protocol v2，stdout 与 stderr 天然分离，退出码由协议给出。
  /// [stdin] 为命令的标准输入字节；传 null 表示立即 EOF——读 stdin 的命令
  /// 会直接拿到输入结束，而不是挂到超时。
  @async
  ShellExecResult exec(String command, int timeoutMs, Uint8List? stdin);

  /// 读取本 App 在设备上的原生库解压目录（`nativeLibraryDir`）。
  ///
  /// 打进 `jniLibs` 的 so 会被 PackageManager 解压到这里，权限为
  /// `apk_data_file` 且可执行，因此 shell（uid=2000）能直接 `LD_PRELOAD` 它，
  /// 无需再把字节写进 `/data/local/tmp`。
  ///
  /// 路径含安装随机后缀，每次安装/更新都会变，**调用方不得缓存**。
  /// 返回空串表示目录不可用——`android:extractNativeLibs=false` 时 so 留在 APK
  /// 内、不会解压，注入会失败。
  @async
  String nativeLibraryDir();
}
