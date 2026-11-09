import 'package:pigeon/pigeon.dart';

/// 一次 DirtyFrag 运行的入参。
class DirtyFragRequest {
  DirtyFragRequest({
    required this.managerPackage,
    required this.vrDisarm,
    required this.vrAuto,
    required this.vrOffset,
    required this.softReboot,
  });

  /// 接管方包名，写进 DE 偏好供 bootstrap 读取。
  ///
  /// 原生侧用 `PackageManager` 解出该应用的 `nativeLibraryDir`，从中取
  /// `libksud.so` 拷到 `<de>/ksud`。**Dart 层拿不到这个路径**：此时还没有
  /// root，`find` 进不去 `/data/app`，所以路径解析只发生在原生侧。
  String managerPackage;

  /// 是否启用 VR（vivo `vr.ko`）反制阶段。
  bool vrDisarm;

  /// VR 偏移是否由内核 BTF 自动解析。
  bool vrAuto;

  /// 手动偏移；[vrAuto] 为 true 时忽略。取值 1..256。
  int vrOffset;

  /// 成功后是否让管理器 soft-reboot。
  bool softReboot;
}

/// 运行会话受理结果。
class DirtyFragStartResult {
  DirtyFragStartResult({
    required this.accepted,
    required this.sessionId,
    required this.reason,
  });

  /// 是否受理。
  bool accepted;

  /// 受理后的会话标识；被拒时为空串。
  String sessionId;

  /// 被拒原因码：`alreadyArmed` / `busy` / `noIpSec` / `missingBinary` /
  /// `stagingFailed` / `badRequest`；空串表示受理。
  String reason;
}

/// 运行会话的一次快照。
///
/// 与 ADB 的 `ExecChunk` 同构：`output` 是**增量**，重复轮询不会重复拿到。
class DirtyFragChunk {
  DirtyFragChunk({
    required this.sessionId,
    required this.output,
    required this.finished,
    required this.exitCode,
    required this.timedOut,
    required this.durationMs,
    required this.resolvedVrOffset,
    required this.failure,
  });

  /// 会话标识。
  String sessionId;

  /// 自上次轮询以来新增的输出（stdout 与 stderr 合并）。
  String output;

  /// 是否已结束。结束后原生侧回收会话。
  bool finished;

  /// 退出码；仅 [finished] 为 true 时有意义。`-1` 表示没拿到。
  ///
  /// 本链路的退出码语义与常规不同：`2` 在多数成功场景下也会出现，
  /// 判定必须结合输出内容。
  int exitCode;

  /// 是否因本侧取消而强制结束了子进程。
  bool timedOut;

  /// 从开始到本次轮询的耗时（毫秒），单调时钟。
  int durationMs;

  /// `--vr-auto` 解析出的 funcs offset（十进制字符串）；未解析出为空串。
  ///
  /// 值来自 `<de>/files/vr_offset.txt`（由 ko 写入；`fail` 视为空串）。
  String resolvedVrOffset;

  /// 原生侧异常类名；空串表示无异常。
  String failure;
}

/// vr 偏移提取结果。
///
/// 成功时 [json] 是 Rust 返回的完整 JSON，[error] 为空串；
/// 失败时相反。解析在 Dart 的 `data/` 层完成，原生不解析。
class VrDeriveResult {
  VrDeriveResult({
    required this.json,
    required this.error,
  });

  /// 成功时的 JSON：`{"ok":true,"member":72,"release":"6.6.89-..."}`。
  String json;

  /// 失败原因；成功时为空串。
  String error;
}

/// 运行默认值：设置页的持久开关，也是开机链路唯一的数据来源。
///
/// 与 [DirtyFragRequest] 的区别：[DirtyFragRequest] 是**本次运行**的入参，
/// 本类是**跨运行持久**的偏好。两者字段语义相同，来源不同。
class DirtyFragRunDefaults {
  DirtyFragRunDefaults({
    required this.vrDisarm,
    required this.vrAuto,
    required this.vrOffset,
    required this.softReboot,
  });

  /// 是否启用 VR 反制。仅 vivo `vr.ko` 机型需要开。
  bool vrDisarm;

  /// 是否由内核 BTF 自动解析偏移。
  bool vrAuto;

  /// 手动偏移；[vrAuto] 为 true 时忽略。取值 1..256，0 表示未设。
  int vrOffset;

  /// 成功后是否让管理器 soft-reboot。
  ///
  /// 由 `bootstrap.c:238-241` 消费：`ksud late-load` 成功后才触发
  /// `ksud soft-reboot`，失败路径不会重启。
  bool softReboot;
}

/// DirtyFrag（CVE-2026-43284）提权的原生接口。
///
/// 契约原则：
/// 1. `start` 只负责受理与落位，真正跑起来在后台线程；
/// 2. 输出由 `poll` 增量取走，跑十来秒的链路能边跑边显示；
/// 3. `cancel` 之后仍要轮询到 `finished` 才算收尾；
/// 4. 不抛异常，失败一律走结构化返回值。
@HostApi()
abstract class DirtyFragNative {
  /// 本次开机是否已经注入过（`/dev/df` 存在）。
  @async
  bool isArmed();

  /// 专家模式开关当前是否为开。
  ///
  /// 读 DE 偏好 `shared_prefs/dfroot.xml` 的 `expert_mode` 键，
  /// 与 `bootstrap.c` 读的是同一份文件。它不控制组件态，
  /// 只决定 `DirtyFragBootReceiver` 到点后是否真的执行。
  @async
  bool isExpertModeEnabled();

  /// 切换专家模式。只写 `expert_mode` 偏好，不碰组件启用态。
  @async
  void setExpertModeEnabled(bool enabled);

  /// 开机自启开关当前是否为开。
  ///
  /// 直接读 `DirtyFragBootReceiver` 的组件启用态，不读偏好也不缓存：
  /// 开机失败会把组件自动关掉，缓存会显示错误。
  @async
  bool isBootAutostartEnabled();

  /// 切换开机自启。只改组件启用态，不落偏好。
  @async
  void setBootAutostartEnabled(bool enabled);

  /// 读运行默认值：VR 反制、自动解析、手动偏移、成功后软重启。
  ///
  /// 这四项是**设置页的持久开关**，也是开机链路唯一能拿到的来源
  /// （开机时 Flutter engine 没起，读不到 Dart 侧的任何状态）。
  @async
  DirtyFragRunDefaults getRunDefaults();

  /// 写运行默认值。设置页改开关时调用。
  ///
  /// 只写 `vr_disarm` / `vr_auto` / `vr_off` / `soft_reboot` 四个键，
  /// 不碰 `expert_mode` / `su_manager`。
  @async
  void setRunDefaults(DirtyFragRunDefaults defaults);

  /// 受理一次运行。
  @async
  DirtyFragStartResult start(DirtyFragRequest request);

  /// 取走自上次轮询以来积累的输出。
  @async
  DirtyFragChunk poll(String sessionId);

  /// 取消运行。已进入内核侧之后的阶段取消不掉，只会停止本侧读取。
  @async
  void cancel(String sessionId);

  /// 起一次离线偏移提取。
  ///
  /// [input] 是本地 `boot.img` / `payload.bin` 路径，或 `http(s)` 直链。
  /// 会下载与解包，阻塞到结束；进度用 [vrDeriveProgress] 轮询。
  @async
  VrDeriveResult deriveVrOffset(String input, bool insecure);

  /// 进度快照：`"<phase> <done> <total>"`，phase 0 = 下载字节，1 = 解包。
  @async
  String vrDeriveProgress();
}
