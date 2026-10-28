import 'package:pigeon/pigeon.dart';

/// 提权链标识。
///
/// 顺序即破坏性优先级：越靠前越安全，链选择时取第一个可用的链。
enum EscalationChainId {
  /// 检测设备当前是否已具备 Root 权限，零破坏。
  rootCheck,

  /// 通过加载内核模块提权。
  kernelModule,

  /// 使用本地载荷完成提权。
  payload,

  /// 利用内核漏洞获得临时提权。
  kernelExploit,

  /// 通过 PageCache 写入提权。
  pageCache,

  /// 纯演示链，不改变任何系统状态。
  fake,
}

/// 运行阶段。
///
/// 前五个与 Dart 侧领域模型一一对应；`done` 为原生侧收尾哨兵，
/// Dart 侧映射时归入「全部阶段完成」，不做 index 互转。
enum EscalationStage { probe, prepare, execute, verify, cleanup, done }

/// 单条链的探测结论。
///
/// 原生只回证据，不判定「能否提权」——判定权在 Dart。
class ChainProbe {
  ChainProbe({
    required this.chain,
    required this.available,
    required this.reasons,
    required this.evidence,
  });

  /// 所属链。
  EscalationChainId chain;

  /// 该链在当前设备上是否具备执行前提。
  bool available;

  /// 不可用的原因码字符串，由 Dart 侧映射为枚举。
  List<String> reasons;

  /// 原始证据，原样透传给 Dart，便于展示与排障。
  Map<String, Object?> evidence;
}

/// 启动一次运行的受理结果。
class StartRunResult {
  StartRunResult({
    required this.accepted,
    required this.runId,
    required this.reasons,
  });

  /// 是否受理。
  bool accepted;

  /// 受理后的运行标识；被拒时为空串。
  String runId;

  /// 被拒原因码。
  List<String> reasons;
}

/// 单个阶段的执行记录。
class RunStep {
  RunStep({
    required this.stage,
    required this.startedAtMs,
    required this.durationMs,
    required this.ok,
    required this.reasons,
    required this.evidence,
  });

  /// 阶段。
  EscalationStage stage;

  /// 阶段开始时间（Unix 毫秒）。
  int startedAtMs;

  /// 阶段耗时（毫秒）。
  int durationMs;

  /// 该阶段自身是否未抛异常；不代表提权成败。
  bool ok;

  /// 阶段原因码。
  List<String> reasons;

  /// 阶段证据（含退出码等原始信息，仅作参考，不参与判定）。
  Map<String, Object?> evidence;
}

/// 一次运行的快照，供 Dart 侧轮询。
class RunSnapshot {
  RunSnapshot({
    required this.runId,
    required this.chain,
    required this.phase,
    required this.steps,
    required this.finished,
  });

  /// 运行标识。
  String runId;

  /// 所属链。
  EscalationChainId chain;

  /// 当前阶段。
  EscalationStage phase;

  /// 已完成阶段序列。
  List<RunStep> steps;

  /// 是否已结束（无论成败）。
  bool finished;
}

/// 提权宿主连接状态。
class HostStatus {
  HostStatus({
    required this.alive,
    required this.uid,
    required this.reconnectAttempts,
  });

  /// 宿主是否存活。
  bool alive;

  /// 宿主动作进程的 uid，用于判活；0 表示未知。
  int uid;

  /// 已尝试重连次数。
  int reconnectAttempts;
}

/// 提权原生接口。
///
/// 契约原则：
/// 1. 只回证据与原因码，**不返回成败结论**，判定权在 Dart；
/// 2. 不提供 `execShell(String)` 这类任意命令执行能力；
/// 3. 所有方法内部不得抛异常，失败一律走结构化返回值。
@HostApi()
abstract class EscalationNative {
  /// 只读探测全部链，零副作用。
  @async
  List<ChainProbe> probeAll();

  /// 启动一次运行。
  @async
  StartRunResult startRun(
    EscalationChainId chain,
    Map<String, Object?> args,
  );

  /// 轮询运行快照。
  @async
  RunSnapshot pollRun(String runId);

  /// 取消运行。
  @async
  void cancelRun(String runId);

  /// 查询宿主连接状态。
  @async
  HostStatus hostStatus();

  /// 预热宿主进程。
  @async
  bool warmUpHost();

  /// 发起宿主配对。
  @async
  StartRunResult startPairing(String host, int port, String code);

  /// 轮询配对进度。
  @async
  RunSnapshot pollPairing(String sessionId);
}
