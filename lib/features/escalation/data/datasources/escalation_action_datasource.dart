import 'dart:async';

import 'package:Aisupass/core/constants/storage_keys.dart';
import 'package:Aisupass/core/storage/key_value_store.dart';
import 'package:Aisupass/core/utils/handoff_script.dart';
import 'package:Aisupass/core/utils/payload_shell.dart';
import 'package:Aisupass/core/utils/slide_offset_cache.dart';
import 'package:Aisupass/core/utils/su_shell.dart';
import 'package:Aisupass/features/escalation/data/models/handoff_outcome_dto.dart';
import 'package:Aisupass/features/escalation/domain/enums/handoff_kind.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:Aisupass/generated/adb_shell.g.dart' as pigeon;

/// 提权链路执行数据源。
class EscalationActionDatasource {
  EscalationActionDatasource({required this._native, required this._storage});

  final pigeon.AdbShellNative _native;

  final KeyValueStore _storage;

  /// `stdin` 固定传 `null`：这里的命令都不读标准输入，立即 EOF 比挂到超时好。
  Future<pigeon.ShellExecResult> _exec(String command, int timeoutMs) =>
      _native.exec(command, timeoutMs, null);

  late final SuShell _su = SuShell(exec: _exec);

  late final SlideOffsetCache _slideCache = SlideOffsetCache(
    exec: _exec,
    storage: _storage,
  );

  /// 本次运行的 boot token。载荷在终端里跑，输出陆续到达，要跨这段时间挂住
  /// 这个凭据，才能把偏移写进属于同一次开机的缓存。
  String? _bootToken;

  /// 拼出「在常驻 pty 里跑这份载荷」的那一行。
  ///
  /// 只返回可以原样敲进终端的一行；起不来的原因抛
  /// [PayloadLaunchException]，由展示层写屏，命令行里不夹 `echo`。
  Future<String> runPayload(Payload payload) async {
    final String directory = await _native.nativeLibraryDir();
    // 自定义载荷的 library 是绝对路径（导入时推到 /data/local/tmp），
    // 包内载荷才是 `nativeLibraryDir` 下的文件名。
    final bool absolutePath = payload.library.startsWith('/');
    if (!absolutePath && directory.isEmpty) {
      throw const PayloadLaunchException('libraryDirUnavailable');
    }

    final String payloadPath = absolutePath
        ? payload.library
        : '$directory/${payload.library}';

    if (payload.standalone) {
      // 独立载荷没有注入 slide 的位置，这份缓存对它没意义。
      _bootToken = null;
      // catalog 里 `command` 的尾部是该载荷的参数，含占位符的要按设备实际内核
      // 补齐；补不齐就直说，猜参数只会跑一次什么都没做的尝试。
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
        throw const PayloadLaunchException('argumentsUnresolved');
      }
      if (!await _test('-x', payloadPath)) {
        throw const PayloadLaunchException('payloadMissing');
      }
      return PayloadShell.buildStandaloneLaunchCommand(
        payloadPath: payloadPath,
        arguments: arguments,
      );
    }

    final String helperPath = '$directory/${PayloadShell.helperLibrary}';
    if (!await _test('-x', helperPath)) {
      throw const PayloadLaunchException('helperMissing');
    }
    if (!await _test('-e', payloadPath)) {
      throw const PayloadLaunchException('payloadMissing');
    }

    // 同一次开机内 slide 固定，读得到就塞进环境变量，省掉最贵的 P0 阶段。
    final String? bootToken = await _slideCache.bootToken();
    final String? cachedSlide = bootToken == null
        ? null
        : await _slideCache.read(bootToken);
    _bootToken = bootToken;

    return PayloadShell.buildLaunchCommand(
      helperPath: helperPath,
      payloadPath: payloadPath,
      slideOffset: cachedSlide,
    );
  }

  /// 设备侧文件检查。走一次性通道，不上终端屏幕，也不产生回显。
  Future<bool> _test(String flag, String path) async {
    final pigeon.ShellExecResult result = await _exec(
      'test $flag ${PayloadShell.quote(path)}',
      PayloadShell.shortTimeoutMs,
    );
    return result.exitCode == 0;
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

  /// 记住用户选定的 root 管理器包名。
  Future<void> writeSelectedRootManagerPackage(String packageName) => _storage
      .write<String>(StorageKeys.escalationSelectedRootManager, packageName);

  /// 把临时 root 交给设备上的 KernelSU 系管理器。
  ///
  /// 一条命令：「定位 `libksud.so` + `late-load`」合成执行。这里不做 root
  /// 预检：载荷刚移交完时 `su` 未必就绪，预检会把已成功的接管误判成没有
  /// root。没 root 时这条命令自己会失败，退出码与输出就是真实原因。
  Future<HandoffOutcomeDto> handoffRoot({required RootManager manager}) async {
    final String managerPackage = manager.packageName;
    if (!HandoffScript.packagePattern.hasMatch(managerPackage)) {
      return _outcome(
        kind: HandoffKind.failed,
        manager: manager,
        output: '管理器包名非法：$managerPackage',
      );
    }

    final DateTime startedAt = DateTime.now();

    final pigeon.ShellExecResult handoff = await _su.run(
      HandoffScript.build(managerPackage),
      timeoutMs: SuShell.handoffTimeoutMs,
    );

    final String output = '${handoff.stdout}${handoff.stderr}';
    final int durationMs = DateTime.now().difference(startedAt).inMilliseconds;

    // 脚本自己退出并打标记，这是「管理器没装」的机器可读信号。
    if (HandoffScript.indicatesManagerMissing(output, handoff.exitCode)) {
      return _outcome(
        kind: HandoffKind.managerMissing,
        manager: manager,
        exitCode: handoff.exitCode,
        output: output,
        durationMs: durationMs,
        timedOut: handoff.timedOut,
      );
    }

    // 候选路径全 miss 后退回裸 `su`，设备上也没有 —— 提权这一步还没完成。
    if (HandoffScript.indicatesNoSu(output, handoff.exitCode)) {
      return _outcome(
        kind: HandoffKind.noSu,
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
      return _outcome(
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

    return _outcome(
      kind: handedOff ? HandoffKind.success : HandoffKind.failed,
      manager: manager,
      ksudPath: ksudPath,
      exitCode: handoff.exitCode,
      output: output,
      durationMs: durationMs,
      timedOut: handoff.timedOut,
    );
  }

  /// 按管理器与命令结果组装一份移交 DTO。
  static HandoffOutcomeDto _outcome({
    required HandoffKind kind,
    required RootManager manager,
    String ksudPath = '',
    int exitCode = -1,
    String output = '',
    int durationMs = 0,
    bool timedOut = false,
  }) => HandoffOutcomeDto(
    kind: kind,
    managerPackage: manager.packageName,
    managerDisplayName: manager.displayName,
    managerIcon: manager.icon,
    ksudPath: ksudPath,
    exitCode: exitCode,
    output: output,
    durationMs: durationMs,
    timedOut: timedOut,
  );
}
