import 'dart:async';

import 'package:Aisupass/core/storage/key_value_store.dart';
import 'package:Aisupass/core/utils/handoff_script.dart';
import 'package:Aisupass/core/utils/payload_shell.dart';
import 'package:Aisupass/core/utils/slide_offset_cache.dart';
import 'package:Aisupass/core/utils/su_shell.dart';
import 'package:Aisupass/features/escalation/domain/enums/root_manager.dart';
import 'package:Aisupass/features/escalation/domain/models/handoff_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:Aisupass/generated/adb_shell.g.dart' as pigeon;

/// 两次 `su` 之间的等待。抽成回调是为了让测试不必真的睡。
typedef EscalationDelay = Future<void> Function(Duration duration);

Future<void> _sleep(Duration duration) => Future<void>.delayed(duration);

/// 提权链路执行数据源。
///
/// 对外只有 [runPayload] / [observeOutput] / [handoffRoot]。
class EscalationActionDatasource {
  EscalationActionDatasource({
    required this._native,
    required this._storage,
    this._delay = _sleep,
  });

  final pigeon.AdbShellNative _native;

  final KeyValueStore _storage;

  final EscalationDelay _delay;

  /// `stdin` 固定传 `null`：这里的命令都不读标准输入，立即 EOF 比挂到超时好。
  Future<pigeon.ShellExecResult> _exec(String command, int timeoutMs) =>
      _native.exec(command, timeoutMs, null);

  late final SuShell _su = SuShell(exec: _exec, wait: _delay);

  late final SlideOffsetCache _slideCache = SlideOffsetCache(
    exec: _exec,
    storage: _storage,
  );

  /// 本次运行的 boot token。载荷在终端里跑，输出陆续到达，要跨这段时间挂住
  /// 这个凭据，才能把偏移写进属于同一次开机的缓存。
  String? _bootToken;

  /// 拼出「在常驻 pty 里跑这份载荷」的那一行。
  ///
  /// 返回的永远是可以原样敲进终端的一行：跑不起来的原因（目录不可用、参数
  /// 补不齐）也编成一句 `echo`，屏幕上看得见。
  Future<String> runPayload(Payload payload) async {
    final String directory = await _native.nativeLibraryDir();
    if (directory.isEmpty) {
      return _echo('原生库目录不可用：so 没有解压到 nativeLibraryDir');
    }

    final String payloadPath = '$directory/${payload.library}';

    if (payload.standalone) {
      // 独立载荷没有注入 slide 的位置，这份缓存对它没意义。
      _bootToken = null;
      // catalog 里 `command` 的尾部是该载荷的参数，含占位符的要按设备实际内核
      // 补齐；补不齐就只说一句，猜参数只会跑一次什么都没做的尝试。
      String kernelVersion = payload.kernelVersion;
      if (payload.command.contains(PayloadShell.kernelTailPlaceholder)) {
        final pigeon.ShellExecResult kernel = await _exec(
          PayloadShell.buildKernelReleaseCommand(),
          PayloadShell.shortTimeoutMs,
        );
        kernelVersion = kernel.exitCode == 0 ? kernel.stdout : '';
      }
      final String? arguments = PayloadShell.standaloneArguments(
        payload.command,
        kernelVersion,
      );
      if (arguments == null) {
        return _echo(
          '${payload.library} 的参数无法在设备上补齐：${payload.command}',
        );
      }
      return PayloadShell.buildStandaloneLaunchCommand(
        payloadPath: payloadPath,
        arguments: arguments,
      );
    }

    // 同一次开机内 slide 固定，读得到就塞进环境变量，省掉最贵的 P0 阶段。
    final String? bootToken = await _slideCache.bootToken();
    final String? cachedSlide = bootToken == null
        ? null
        : await _slideCache.read(bootToken);
    _bootToken = bootToken;

    return PayloadShell.buildLaunchCommand(
      helperPath: '$directory/${PayloadShell.helperLibrary}',
      payloadPath: payloadPath,
      slideOffset: cachedSlide,
    );
  }

  /// 终端上来一段输出就喂一次，把 KASLR slide 从字节流里捞出来存盘。
  ///
  /// 只有读得到 boot token 的运行才需要：没有凭据就不知道这份偏移属于哪次
  /// 开机，存了也不敢复用。
  void observeOutput(String text) {
    final String? token = _bootToken;
    if (token == null || text.isEmpty) return;
    unawaited(_slideCache.observe(text, token));
  }

  /// 把一句说明编成终端里的一行。单引号包住，中文与空格都不会被 shell 拆开。
  static String _echo(String message) => 'echo ${PayloadShell.quote(message)}';

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
