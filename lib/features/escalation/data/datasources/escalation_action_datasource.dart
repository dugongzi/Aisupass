import 'package:Aisupass/core/storage/key_value_store.dart';
import 'package:Aisupass/core/utils/handoff_script.dart';
import 'package:Aisupass/core/utils/payload_shell.dart';
import 'package:Aisupass/core/utils/slide_offset_cache.dart';
import 'package:Aisupass/core/utils/su_shell.dart';
import 'package:Aisupass/features/escalation/domain/enums/root_manager.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_run_result.dart';
import 'package:Aisupass/features/escalation/domain/models/handoff_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:Aisupass/generated/adb_shell.g.dart' as pigeon;

/// 两次探测之间的等待。抽成回调是为了让测试不必真的睡。
typedef EscalationDelay = Future<void> Function(Duration duration);

Future<void> _sleep(Duration duration) => Future<void>.delayed(duration);

/// 提权链路执行数据源。对外只有 [runPayload]、[handoffRoot]。
///
/// 例外（已批准，2026-11）：成功与否在本层判定，与 §5「只做转发」不同，
/// 登记见 `coding.md` §8.2。
class EscalationActionDatasource {
  EscalationActionDatasource({
    required this._native,
    required this._storage,
    this._delay = _sleep,
    this._pollInterval = const Duration(seconds: 2),
  });

  final pigeon.AdbShellNative _native;

  final KeyValueStore _storage;

  final EscalationDelay _delay;

  /// 两次探测的间隔，总轮数与停滞轮数由它推出。
  final Duration _pollInterval;

  /// `stdin` 固定传 `null`：提权命令不读标准输入，立即 EOF 比挂到超时好。
  Future<pigeon.ShellExecResult> _exec(String command, int timeoutMs) =>
      _native.exec(command, timeoutMs, null);

  late final SuShell _su = SuShell(exec: _exec);

  late final SlideOffsetCache _slideCache = SlideOffsetCache(
    exec: _exec,
    storage: _storage,
  );

  /// 执行载荷：启动 → 轮询 → 终止 → 收日志 → 复核 root。
  ///
  /// 拿到的 root 是**一次性**的，cred 属于那个已退出的载荷子进程。要留下来
  /// 必须走 [handoffRoot]。失败返回结果，不抛异常。
  Future<EscalationRunResult> runPayload(Payload payload) async {
    if (payload.standalone) {
      return EscalationRunResult.failure(
        '${payload.library} 是独立可执行载荷，参数按机型而定，暂不支持自动执行',
      );
    }

    final String directory = await _native.nativeLibraryDir();
    if (directory.isEmpty) {
      return EscalationRunResult.failure('原生库目录不可用：so 没有解压到 nativeLibraryDir');
    }

    final DateTime startedAt = DateTime.now();

    // 读取 boot token 和 KASLR P0 偏移缓存
    final String? bootToken = await _slideCache.bootToken();
    final String? cachedSlide = bootToken != null
        ? await _slideCache.read(bootToken)
        : null;

    final pigeon.ShellExecResult launch = await _exec(
      PayloadShell.buildLaunchCommand(
        helperPath: '$directory/${PayloadShell.helperLibrary}',
        payloadPath: '$directory/${payload.library}',
        slideOffset: cachedSlide,
      ),
      PayloadShell.shortTimeoutMs,
    );

    // 启动脚本自带两道闸门：helper 不可执行退 2、载荷缺失退 3。其余非 0
    // 说明命令没在设备上跑起来，轮询下去没意义。
    if (launch.exitCode != 0) {
      return EscalationRunResult(
        success: false,
        exitCode: launch.exitCode,
        stdout: launch.stdout,
        stderr: launch.exitCode == PayloadShell.payloadMissingExitCode
            ? '${payload.library} 没有打进安装包：原生库目录下找不到这份 so。'
                  '属于打包缺失，不是设备问题'
            : launch.stderr.isEmpty
            ? '启动载荷失败，退出码 ${launch.exitCode}'
            : launch.stderr,
        durationMs: launch.durationMs,
        timedOut: launch.timedOut,
      );
    }

    // 日志每长一段就抓一次 slide，同一次开机内后续尝试可跳过 P0。
    Future<void> Function(String window)? onLogWindow;
    if (bootToken != null) {
      final String token = bootToken;
      onLogWindow = (String window) => _slideCache.cacheFromLog(window, token);
    }

    final PollOutcome outcome = await PayloadPoller(
      exec: _exec,
      delay: _delay,
      pollInterval: _pollInterval,
      onLogWindow: onLogWindow,
    ).poll();

    // 只有被掐断时才需要 kill，自然退出的进程号已经不在了。
    if (outcome != PollOutcome.finished) {
      await _exec(
        PayloadShell.buildTerminateCommand(),
        PayloadShell.shortTimeoutMs,
      );
    }
    final String log = (await _exec(
      PayloadShell.buildCollectCommand(),
      PayloadShell.shortTimeoutMs,
    )).stdout;

    // 轮询里没抓到的（比如只出现在最后一行）靠这次兜住。
    if (bootToken != null) {
      await _slideCache.cacheFromLog(log, bootToken);
    }

    final int exitCode = PayloadShell.exitCodeFrom(log);

    // 两条日志标记加退出码，三者都满足才算成功。
    final bool payloadReportedSuccess =
        log.contains(PayloadShell.markerCompleted) &&
        log.contains(PayloadShell.markerRoot);
    if (!payloadReportedSuccess ||
        exitCode != 0 ||
        outcome != PollOutcome.finished) {
      final String reason = switch (outcome) {
        PollOutcome.finished when exitCode > 0 => '载荷退出码 $exitCode',
        PollOutcome.finished when exitCode == 0 && !payloadReportedSuccess =>
          '载荷正常退出，但日志里没有成功标记'
              '（${PayloadShell.markerCompleted} / ${PayloadShell.markerRoot}）',
        PollOutcome.finished when exitCode <= 0 =>
          '载荷已退出，但没有读到退出码（${PayloadShell.rcPath} 缺失）',
        PollOutcome.finished => '',
        PollOutcome.stalled => '载荷 180 秒没有任何输出，已终止',
        PollOutcome.timedOut => '提权超过 15 分钟，已终止',
        PollOutcome.lost => '探测通道中断，无法确认载荷状态',
      };
      return EscalationRunResult(
        success: false,
        exitCode: exitCode,
        stdout: log,
        stderr: reason,
        durationMs: DateTime.now().difference(startedAt).inMilliseconds,
        timedOut:
            outcome == PollOutcome.stalled || outcome == PollOutcome.timedOut,
      );
    }

    final pigeon.ShellExecResult rootCheck = await _su.checkRoot();
    final bool rootVerified = _su.indicatesRoot(rootCheck);

    return EscalationRunResult(
      success: rootVerified,
      exitCode: rootVerified ? 0 : -1,
      stdout:
          '$log\n--- root verification ---\n${rootCheck.stdout}${rootCheck.stderr}',
      stderr: rootVerified
          ? ''
          : rootCheck.stderr.isNotEmpty
          ? rootCheck.stderr
          : rootCheck.stdout,
      durationMs: DateTime.now().difference(startedAt).inMilliseconds,
      timedOut:
          outcome == PollOutcome.stalled || outcome == PollOutcome.timedOut,
    );
  }

  /// 把临时 root 交给设备上的 KernelSU 系管理器。
  ///
  /// 两次 `su`：先探身份，再把「定位 `libksud.so` + `late-load`」合成一条跑。
  /// 没有 root 时 `find` 只会因为进不去 `/data/app` 返回空，`late-load` 也
  /// 必被拒，跑下去只是把「没 root」伪装成「管理器没装」。
  ///
  /// 判据只有退出码与已知失败关键字，接管后是否持久生效这里不猜。
  /// 没装、没 root 都返回失败结果而不是抛异常。
  Future<HandoffOutcome> handoffRoot({required RootManager manager}) async {
    final String managerPackage = manager.packageName;
    if (!HandoffScript.packagePattern.hasMatch(managerPackage)) {
      return HandoffOutcome(
        kind: HandoffKind.failed,
        manager: manager,
        output: '管理器包名非法：$managerPackage',
      );
    }

    final DateTime startedAt = DateTime.now();

    final pigeon.ShellExecResult rootCheck = await _su.checkRoot();
    if (!_su.indicatesRoot(rootCheck)) {
      // 正常路径一次 IPC 就够，失败才逐条摊开 su 候选说明原因。
      final String diagnostic = await _su.diagnoseCandidates();
      final String output = <String>[
        rootCheck.stderr.isNotEmpty ? rootCheck.stderr : rootCheck.stdout,
        diagnostic,
      ].where((String part) => part.trim().isNotEmpty).join('\n');
      return HandoffOutcome(
        kind: HandoffKind.noRoot,
        manager: manager,
        exitCode: rootCheck.exitCode,
        output: output,
        durationMs: DateTime.now().difference(startedAt).inMilliseconds,
        timedOut: rootCheck.timedOut,
      );
    }

    final pigeon.ShellExecResult handoff = await _su.run(
      HandoffScript.build(managerPackage),
      timeoutMs: SuShell.handoffTimeoutMs,
    );

    final String output = '${handoff.stdout}${handoff.stderr}';
    final int durationMs = DateTime.now().difference(startedAt).inMilliseconds;

    // 脚本自己退出并打标记，这是「管理器没装」的机器可读信号。
    if (HandoffScript.indicatesManagerMissing(output, handoff.exitCode)) {
      return HandoffOutcome(
        kind: HandoffKind.managerMissing,
        manager: manager,
        exitCode: handoff.exitCode,
        output: output,
        durationMs: durationMs,
        timedOut: handoff.timedOut,
      );
    }

    final String ksudPath = HandoffScript.ksudPathFrom(handoff.stdout);
    // 路径来自设备输出，含引号 / 反引号 / `$` 时原样回显可被复制去拼命令。
    if (ksudPath.isNotEmpty &&
        HandoffScript.unsafePathChars.hasMatch(ksudPath)) {
      return HandoffOutcome(
        kind: HandoffKind.failed,
        manager: manager,
        exitCode: handoff.exitCode,
        output: '${HandoffScript.ksudLibrary} 路径含无法安全转义的字符：$ksudPath\n$output',
        durationMs: durationMs,
        timedOut: handoff.timedOut,
      );
    }

    // 退出码是硬判据；关键字表只用来挡掉「退 0 但打印了 denied」的假成功。
    final bool handedOff =
        handoff.exitCode == 0 && !HandoffScript.mentionsFailure(output);

    return HandoffOutcome(
      kind: handedOff ? HandoffKind.success : HandoffKind.failed,
      manager: manager,
      ksudPath: ksudPath,
      exitCode: handoff.exitCode,
      output: output,
      durationMs: durationMs,
      timedOut: handoff.timedOut,
    );
  }
}
