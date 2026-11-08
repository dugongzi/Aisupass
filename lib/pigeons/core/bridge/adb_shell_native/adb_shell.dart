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

/// 流式执行会话的受理结果。
class ExecStartResult {
  ExecStartResult({
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

/// 流式执行的一次快照：新增输出 + 当前状态。
///
/// 刻意与 `ShellExecResult` 分开：那个是「跑完之后的全量结果」，这个是「一次增量」。
/// 合并成一个类型，调用方就分不清 `stdout` 是全量还是增量了。
class ExecChunk {
  ExecChunk({
    required this.sessionId,
    required this.stdout,
    required this.stderr,
    required this.finished,
    required this.exitCode,
    required this.timedOut,
    required this.durationMs,
    required this.droppedBytes,
    required this.failure,
  });

  /// 会话标识。
  String sessionId;

  /// 自上次轮询以来新增的标准输出。
  ///
  /// 保证是完整 UTF-8 字符：帧边界按字节切，多字节字符的半个字会留到下一次轮询。
  String stdout;

  /// 自上次轮询以来新增的标准错误。
  ///
  /// pty 会话下远端已把 stderr 并进 stdout，这个字段恒为空串；保留它是因为
  /// 同一条读取链路也服务于 `raw` 会话。
  String stderr;

  /// 是否已结束。结束后原生侧会移除该会话，再轮询只会拿到 `unknownSession`。
  bool finished;

  /// 退出码；仅在 [finished] 为 true 时有意义，`-1` 表示没拿到（命令没跑起来、
  /// 流中途断开、或被取消）。
  int exitCode;

  /// 是否因超时被掐断。
  bool timedOut;

  /// 从开始到本次轮询的耗时（毫秒），单调时钟。
  int durationMs;

  /// 因上层消费不及时、缓冲溢出而被丢弃的累计字节数；`0` 表示输出完整。
  ///
  /// 有值就说明终端里看到的输出**缺了一段**，必须显式提示，不能让用户
  /// 拿缺行的日志去猜提权为什么失败。
  int droppedBytes;

  /// 读流出错时的异常类名，或 `exit frame missing`；空串表示没有异常。
  String failure;
}

/// 无线 ADB 配对与 shell 连接的原生接口。
///
/// 契约原则：
/// 1. 配对建链、读连接状态、执行命令；
/// 2. 命令分两种：`exec` 一次跑完回全量结果；`startExec` 开会话边跑边回增量，
///    供终端实时显示长命令的输出、并在跑的过程中往 stdin 喂数据；
/// 3. 会话只活到命令结束，`pollExec` 拿到 `finished` 后原生侧即回收，不跨进程留存；
/// 4. 不抛异常，失败一律走结构化返回值。
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

  /// 启动一条流式命令，立即返回会话标识。
  ///
  /// 与 [exec] 的唯一区别是**不给完整结果**：输出由 [pollExec] 增量取走。
  /// 这样 `logcat`、提权脚本这类跑几十秒的命令能边跑边显示，
  /// 而不是等进程退出才一次性吐出，用户对着空屏幕无从判断卡在哪。
  ///
  /// 流式会话一律开在 **pty** 上：远端程序认为自己面对的是终端，
  /// 于是回显、行编辑、`^C` 转 SIGINT、ANSI 控制序列、`isatty()` 都正常工作；
  /// 需要全屏重排的程序还依赖 [resizeExec] 同步窗口尺寸。
  /// 代价是 stdout 与 stderr 在远端就合并成一路，`ExecChunk.stderr` 恒为空。
  /// 一次性 [exec] 仍走 `raw`（要按分离的 stdout 文本做判定）。
  ///
  /// 「开流失败」与「命令执行失败」是两件事：前者在这里被拒（`accepted=false`），
  /// 后者表现为后续 `pollExec` 的 `exitCode != 0`。调用方不要混为一谈。
  ///
  /// [timeoutMs] 为正数时到点关流；传 **0 或负数表示不限时**，用于常驻交互
  /// shell（命令传 `sh`）：这种会话必须一直活着，超时掐断会把用户 `cd` 过去的
  /// 工作目录、`export` 的变量一起销毁，表现是「用着用着目录突然回到 `/`」。
  @async
  ExecStartResult startExec(String command, int timeoutMs);

  /// 取走自上次轮询以来积累的输出。
  ///
  /// 返回值是**增量**，不是全量；重复轮询不会拿到重复内容。
  /// 必须在拿到 `finished=true` 的那次之后停止轮询——原生侧那时已经回收会话。
  @async
  ExecChunk pollExec(String sessionId);

  /// 往正在跑的命令的 stdin 写数据。
  ///
  /// pty 会话里这就是终端输入队列：按字节原样转发，**不要做行缓冲或补 `\n`**——
  /// 回显、行编辑（退格）、`^C`/`^D` 之类的控制字符都由远端 termios 处理，
  /// 本地再加工就会出现字符双写、退格错位。
  ///
  /// 返回 `false` 表示会话已结束或 stdin 已关闭，调用方应按「命令不再接收输入」处理，
  /// 而不是重试。
  @async
  bool writeExecStdin(String sessionId, Uint8List data);

  /// 同步终端窗口尺寸给 pty。
  ///
  /// pty 的 `winsize` 决定远端如何折行、全屏程序画多大。不调用的话远端会一直按
  /// 默认 80x24 排版：`top` 只占左上角一块，长输出在 80 列处硬折。
  /// 终端首帧渲染后立刻调一次，之后视口变化时再调。
  ///
  /// [rows] / [cols] 是字符数，不是像素。像素尺寸原生侧按 0 上报——远端只需要
  /// 字符网格，传错反而会让它按错误的 DPI 算图。
  @async
  void resizeExec(String sessionId, int rows, int cols);

  /// 中断会话。
  ///
  /// pty 下这一步往 stdin 写一个 `^C`，等价于用户在终端按 Ctrl+C：内核把它翻译成
  /// 前台进程组的 SIGINT，远端程序自己收尾，**会话本身仍然存活**（`sh` 会打新提示符，
  /// `cd` 过的目录也还在）。若远端忽略 SIGINT，原生侧会在宽限期后关流强制结束。
  /// 中断不是「立刻结束」，之后仍要轮询到 `finished=true` 才算收尾。
  @async
  void cancelExec(String sessionId);

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
