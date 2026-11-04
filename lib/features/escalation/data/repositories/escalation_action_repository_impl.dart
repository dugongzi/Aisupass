import 'package:Aisupass/features/escalation/data/datasources/escalation_action_datasource.dart';
import 'package:Aisupass/features/escalation/domain/models/device_identity.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_run_result.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:Aisupass/features/escalation/domain/models/payload_match.dart';
import 'package:Aisupass/features/escalation/domain/repositories/escalation_action_repository.dart';
import 'package:Aisupass/features/escalation/domain/repositories/escalation_query_repository.dart';
import 'package:Aisupass/generated/adb_shell.g.dart' as pigeon;

/// 提权链路执行仓储实现：命令拼装与成功判定都在这一层。
///
/// 原生侧只回证据（退出码、stdout、stderr），判定权在这里，
/// 不把「是否成功」的逻辑下沉到 Kotlin。
class EscalationActionRepositoryImpl implements EscalationActionRepository {
  const EscalationActionRepositoryImpl({
    required this._datasource,
    required this._query,
  });

  final EscalationActionDatasource _datasource;
  final EscalationQueryRepository _query;

  /// 成功标记一：载荷/helper 打完的收尾日志。
  static const String _markerCompleted = 'exploit completed';

  /// 成功标记二：root 状态行。两个标记缺一不算成功。
  static const String _markerRoot = 'done=1 root=1';

  /// su 探测判据。
  static const String _rootUidMarker = 'uid=0';

  /// 命令模板占位符。
  static const String _payloadToken = '<payload>';
  static const String _suToken = '<su>';
  static const String _kernelTailToken = '<内核版本的后三位>';

  /// 自包含 runner 的命令都以这个前缀开头。
  static const String _runnerPrefix = '/data/local/tmp/';

  /// su 探测顺序。`/apex/com.android.virt/bin/su` 是本载荷提权后的落点，置首位。
  static const List<String> _suCandidates = <String>[
    '/apex/com.android.virt/bin/su',
    '/product/bin/su',
    '/debug_ramdisk/su',
    '/system/bin/su',
    '/system/xbin/su',
    '/sbin/su',
    'su',
  ];

  /// 执行超时。载荷要跑内存布局与内核利用，给足时间。
  static const int _runTimeoutMs = 90000;

  /// su 探测超时。超时通常意味着 su 管理器在等用户点「授权」。
  static const int _probeTimeoutMs = 8000;

  @override
  Future<EscalationRunResult> runResolvedPayload() async {
    final PayloadMatch? match = await _query.resolve();
    if (match == null) {
      return _failure('当前设备在载荷清单里没有候选');
    }
    return runPayload(match.payload);
  }

  @override
  Future<EscalationRunResult> runPayload(Payload payload) async {
    final String directory = await _datasource.nativeLibraryDir();
    if (directory.isEmpty) {
      return _failure('原生库目录不可用：so 没有解压到 nativeLibraryDir');
    }

    // 需要 su 的形态先把 su 探出来，探不到就不必发命令了。
    final bool needsSu = payload.command.contains(_suToken);
    final String suPath = needsSu ? await probeSu() : '';
    if (needsSu && suPath.isEmpty) {
      return _failure('没有探测到可用的 su，su 服务端形态无法加载');
    }

    final String kernelTail = payload.command.contains(_kernelTailToken)
        ? await _kernelVersionTail()
        : '';

    final String command = _buildCommand(
      payload: payload,
      payloadPath: '$directory/${payload.library}',
      suPath: suPath,
      kernelTail: kernelTail,
    );

    final pigeon.ShellExecResult result = await _datasource.exec(
      command,
      _runTimeoutMs,
    );
    return EscalationRunResult(
      success: _isSuccess(result),
      exitCode: result.exitCode,
      stdout: result.stdout,
      stderr: result.stderr,
      durationMs: result.durationMs,
      timedOut: result.timedOut,
    );
  }

  @override
  Future<String> probeSu() async {
    for (final String candidate in _suCandidates) {
      final pigeon.ShellExecResult result = await _datasource.exec(
        '${_quote(candidate)} -c id',
        _probeTimeoutMs,
      );
      // 超时不换下一条：那通常是在等用户手动授权，换一条只会把等待乘 7。
      if (result.timedOut) return '';
      if (result.stdout.contains(_rootUidMarker)) return candidate;
    }
    return '';
  }

  /// 拼装最终命令。
  ///
  /// `catalog` 的 `command` 有 5 种形态，必须按条目分流，不能当成随便一条
  /// shell 命令执行：只有 124 条是 `LD_PRELOAD` 形态。
  String _buildCommand({
    required Payload payload,
    required String payloadPath,
    required String suPath,
    required String kernelTail,
  }) {
    final String quotedPath = _quote(payloadPath);
    String command = payload.command;

    if (command.contains(_payloadToken)) {
      command = command.replaceAll(_payloadToken, quotedPath);
    } else if (command.startsWith(_runnerPrefix)) {
      // 自包含 runner 是 `ET_EXEC`，不能 LD_PRELOAD。命令里的路径是上游
      // 文件名，这里替换成本机 so 的绝对路径，原地执行。
      // `/data/app` 是否 noexec 由真机验证；不能执行时再做 staging。
      final int spaceIndex = command.indexOf(' ');
      final String args = spaceIndex < 0 ? '' : command.substring(spaceIndex);
      command = '$quotedPath$args';
    }

    if (command.contains(_suToken)) {
      command = command.replaceAll(_suToken, _quote(suPath));
    }
    if (command.contains(_kernelTailToken)) {
      command = command.replaceAll(_kernelTailToken, kernelTail);
    }
    return command;
  }

  /// 内核版本最后一段，如 `6.6.104` → `104`。
  Future<String> _kernelVersionTail() async {
    final DeviceIdentity device = await _query.deviceIdentity();
    final List<String> parts = device.kernelVersion.split('.');
    return parts.isEmpty ? '' : parts.last;
  }

  /// 单引号包裹。`nativeLibraryDir` 含 `~` `=`，不加引号会被 shell 吃掉。
  String _quote(String value) => "'$value'";

  /// 成功判据：退出码为 0 且两条日志标记同时出现，缺一不算。
  bool _isSuccess(pigeon.ShellExecResult result) =>
      result.exitCode == 0 &&
      result.stdout.contains(_markerCompleted) &&
      result.stdout.contains(_markerRoot);

  /// 没跑起来时的结果，走结构化返回值，不抛异常。
  EscalationRunResult _failure(String message) => EscalationRunResult(
    success: false,
    exitCode: -1,
    stdout: '',
    stderr: message,
    durationMs: 0,
    timedOut: false,
  );
}
