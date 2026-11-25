import 'package:Aisupass/core/models/privileged_run_result.dart';
import 'package:Aisupass/core/providers/adb_shell_provider.dart';
import 'package:Aisupass/core/utils/su_shell.dart';
import 'package:Aisupass/generated/adb_shell.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'privileged_runner_provider.g.dart';

/// 以特权身份执行一条本机命令。
///
/// 特权服务自身不认识任何具体通道，只依赖这个中立签名；由本 Provider 决定
/// 当下用哪条链路执行，并把结果搬成 [PrivilegedRunResult]。
typedef PrivilegedRunner =
    Future<PrivilegedRunResult> Function(String command, int timeoutMs);

/// 特权命令的执行出口。
///
/// 这是唯一一处把「Stellar」与「无线 ADB」接在一起：服务需要一个已经具备
/// shell 身份的执行者把自己跑起来，当前可用的是无线 ADB 通道。Stellar 的
/// 状态机与 UI 都不感知这件事，只按 [PrivilegedRunResult] 分型。
@riverpod
PrivilegedRunner privilegedRunner(Ref ref) {
  final ShellExec exec = ref.watch(adbShellExecProvider);
  return (String command, int timeoutMs) async {
    final ShellExecResult result = await exec(command, timeoutMs);
    return PrivilegedRunResult(
      exitCode: result.exitCode,
      stdout: result.stdout,
      stderr: result.stderr,
    );
  };
}
