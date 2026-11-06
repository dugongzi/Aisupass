import 'package:Aisupass/core/utils/su_shell.dart';
import 'package:Aisupass/generated/adb_shell.g.dart' as pigeon;

/// 载荷侧的 shell 协议：落点文件、环境变量、命令拼装、读数解析。
///
/// 路径与字段名是与助手 `libcve43499root.so` 的约定，两边必须一致。
class PayloadShell {
  const PayloadShell._();

  /// 随包执行助手的库名。名字是 `.so`，实际是 PIE 可执行文件。
  static const String helperLibrary = 'libcve43499root.so';

  /// 执行助手的子命令：加载并运行指定载荷。
  static const String runPayloadArgument = '--run-payload';

  /// 载荷日志落点。助手把载荷输出写这里，不写 stdout。
  static const String logPath = '/data/local/tmp/exploit.log';

  /// 助手自己的 stdout/stderr 落点。后台模式下读不到进程的流，只能靠文件：
  /// 载荷在创建日志之前就挂了（典型的 `CANNOT LINK`）时错误只在这里。
  static const String outputPath = '/data/local/tmp/exploit.out';

  /// 后台进程号落点。终止与存活性探测都读它。
  static const String pidPath = '/data/local/tmp/exploit.pid';

  /// 退出码落点。助手执行完毕后把退出码写这里。
  static const String rcPath = '/data/local/tmp/exploit.rc';

  /// 单次提权的重试轮数，传给助手的 `EXPLOIT_ATTEMPTS`。
  static const String exploitAttempts = '24';

  /// 单轮 P0（KASLR 泄露）阶段超时，单位秒。
  static const String p0AttemptTimeoutSec = '45';

  /// 单轮完整利用超时，单位秒。
  static const String exploitAttemptTimeoutSec = '120';

  /// KASLR P0 偏移的环境变量名，同一 boot 会话内 slide 固定。
  static const String slideP0OffsetEnv = 'SLIDE_P0_OFFSET';

  /// 启动脚本的闸门一：随包助手不可执行。
  static const int helperMissingExitCode = 2;

  /// 启动脚本的闸门二：`jniLibs` 里没有这份载荷，属打包缺失，与设备无关。
  static const int payloadMissingExitCode = 3;

  /// 启动 / 探测 / 终止 / 收日志这类短命令的单次上限。
  static const int shortTimeoutMs = 15000;

  /// 停滞判据：这么久日志一个字节都没长就判卡死。判的是日志长度，不是 stdout。
  static const int stallTimeoutMs = 180000;

  /// 整次提权的时长上限。单轮 120 秒、共 24 轮，得给重试留够。
  static const int runTimeoutMs = 900000;

  /// 连续这么多次探测本身失败，就认为通道已经不可用。
  static const int maxProbeFailures = 3;

  /// 增量读取时保留的重叠字符数：一条记录可能被两次 `tail` 切开。
  static const int windowChars = 512;

  /// 成功标记一：载荷打完的收尾日志。
  static const String markerCompleted = 'exploit completed';

  /// 成功标记二：root 状态行。两个标记缺一不算成功。
  static const String markerRoot = 'done=1 root=1';

  /// 退出码行：收日志脚本以整行 `exitCode=<rc>` 追加在 stdout 末尾。限定行首
  /// 行尾，是为了不被载荷自己打印的 `retry exitCode=1` 这类行内字样命中。
  static final RegExp exitCodePattern = RegExp(
    r'^exitCode=(\d+)\s*$',
    multiLine: true,
  );

  /// 单引号包裹。`nativeLibraryDir` 含 `~` `=`，不加引号会被 shell 吃掉。
  static String quote(String value) => "'$value'";

  /// 启动脚本：两道闸门 + 后台起助手 + 记录进程号。
  ///
  /// 进程号必须取助手本身：`env ... &` 的 `$!` 就是助手（`env` setenv 后
  /// exec，pid 不变）；写成 `{ env ...; } &` 拿到的是外层子 shell，杀掉它
  /// 只会留下孤儿载荷。`wait` 只能等自己的子进程，所以外面再套一层子 shell
  /// 负责 fork、记 pid、wait 完写 rc。代价是 pid 文件异步写出，要等一小会。
  static String buildLaunchCommand({
    required String helperPath,
    required String payloadPath,
    String? slideOffset,
  }) {
    final String helper = quote(helperPath);
    final String payload = quote(payloadPath);
    final String log = quote(logPath);
    final String output = quote(outputPath);
    final String pid = quote(pidPath);
    final String rc = quote(rcPath);
    final String slideEnv = slideOffset != null
        ? '$slideP0OffsetEnv=$slideOffset '
        : '';
    return '[ -x $helper ] || { '
        'echo "helper not executable: $helper"; exit $helperMissingExitCode; }; '
        '[ -e $payload ] || { '
        'echo "payload missing: $payload"; exit $payloadMissingExitCode; }; '
        'rm -f $log $output $pid $rc; '
        ': > $log; '
        '( env EXPLOIT_ATTEMPTS=$exploitAttempts '
        'P0_ATTEMPT_TIMEOUT_SEC=$p0AttemptTimeoutSec '
        'EXPLOIT_ATTEMPT_TIMEOUT_SEC=$exploitAttemptTimeoutSec '
        '$slideEnv'
        '$helper $runPayloadArgument $payload $helper $log '
        '>$output 2>&1 </dev/null & '
        'assist=\$!; '
        'echo \$assist > $pid; '
        'wait \$assist; '
        'echo \$? > $rc ) & '
        'i=0; '
        'while [ ! -s $pid ] && [ \$i -lt 50 ]; do '
        'sleep 0.1; i=\$((i+1)); done; '
        'cat $pid';
  }

  /// 启动脚本（独立可执行载荷）：直接执行载荷本身，不走助手。
  ///
  /// 输出仍写 [logPath]：探测脚本按日志体积判停滞，落点必须与助手链一致，
  /// 否则日志恒为 0 字节，进程活着也会被判成停滞。
  static String buildStandaloneLaunchCommand({
    required String payloadPath,
    required String arguments,
  }) {
    final String payload = quote(payloadPath);
    final String log = quote(logPath);
    final String output = quote(outputPath);
    final String pid = quote(pidPath);
    final String rc = quote(rcPath);
    final String args = arguments.isEmpty ? '' : ' $arguments';
    return '[ -x $payload ] || { '
        'echo "payload not executable: $payload"; exit $payloadMissingExitCode; }; '
        'rm -f $log $output $pid $rc; '
        ': > $log; '
        '( $payload$args >$log 2>&1 </dev/null & '
        'assist=\$!; '
        'echo \$assist > $pid; '
        'wait \$assist; '
        'echo \$? > $rc ) & '
        'i=0; '
        'while [ ! -s $pid ] && [ \$i -lt 50 ]; do '
        'sleep 0.1; i=\$((i+1)); done; '
        'cat $pid';
  }

  /// 读设备内核版本，供需要内核版本参数的独立载荷填空。
  static String buildKernelReleaseCommand() => 'uname -r 2>/dev/null';

  /// catalog 里「内核版本末段」的占位符。
  static const String kernelTailPlaceholder = '<内核版本的后三位>';

  /// 把 catalog 的命令文案转成直接执行载荷的参数串。
  ///
  /// 文案的第一个 token 是载荷在设备上的落点（如 `/data/local/tmp/preload.so`），
  /// 与本 App 的 `nativeLibraryDir` 不同，不采用；只取它后面的参数。
  /// 占位符补不齐时返回 `null`，由调用方拒绝执行 —— 猜参数只会得到一次
  /// 看起来跑了、实际什么都没做的尝试。
  static String? standaloneArguments(String command, String kernelVersion) {
    final String trimmed = command.trim();
    if (trimmed.isEmpty) return null;
    final int space = trimmed.indexOf(' ');
    String resolved = space < 0 ? '' : trimmed.substring(space + 1).trim();
    if (resolved.contains(kernelTailPlaceholder)) {
      final String tail = kernelTail(kernelVersion);
      if (tail.isEmpty) return null;
      resolved = resolved.replaceAll(kernelTailPlaceholder, tail);
    }
    if (resolved.contains('<') || resolved.contains('>')) return null;
    return resolved;
  }

  /// 内核版本末段：`6.6.89` → `89`。
  ///
  /// 末段带厂商后缀（`6.6.89-android15-8-gabcd`）时只取开头的数字。
  static String kernelTail(String kernelVersion) {
    final List<String> parts = kernelVersion.trim().split('.');
    if (parts.length < 3) return '';
    final RegExpMatch? digits = RegExp(r'^\d+').firstMatch(parts.last);
    return digits?.group(0) ?? '';
  }

  /// 探测脚本：一行 `state=running|gone size=<字节数>`。
  ///
  /// `kill -0` 只查进程存不存在，不投递信号。进程号文件缺失或已被回收都算
  /// `gone`，交给调用方去判标记。
  static String buildProbeCommand() {
    final String pid = quote(pidPath);
    final String log = quote(logPath);
    return 'if [ -f $pid ] && kill -0 "\$(cat $pid)" 2>/dev/null; then '
        'st=running; else st=gone; fi; '
        'sz=\$(wc -c < $log 2>/dev/null | tr -d " \\n"); '
        'echo "state=\$st size=\${sz:-0}"';
  }

  /// 终止脚本：先 TERM 给载荷机会自己收尾，一秒后还在就直接 KILL。
  static String buildTerminateCommand() {
    final String pid = quote(pidPath);
    return 'if [ -f $pid ]; then '
        'k=\$(cat $pid); '
        'kill -TERM "\$k" 2>/dev/null; '
        'sleep 1; '
        'kill -KILL "\$k" 2>/dev/null; '
        'fi';
  }

  /// 收日志脚本：载荷日志在前，助手输出非空时附在后面，退出码在最后。
  static String buildCollectCommand() {
    final String log = quote(logPath);
    final String output = quote(outputPath);
    final String rc = quote(rcPath);
    return 'cat $log 2>/dev/null; '
        'if [ -s $output ]; then echo; '
        'echo "--- helper output ---"; cat $output; fi; '
        'if [ -f $rc ]; then echo; '
        'echo "exitCode=\$(cat $rc)"; fi';
  }

  /// 从日志的第 [fromByte] 个字节起读到末尾（`fromByte` 从 1 起）。
  ///
  /// 用 `tail -c` 而不是 `cat`：日志涨到几十 KB 后每 2 秒整份搬一遍是 O(n²)。
  static String buildReadTailCommand(int fromByte) =>
      'tail -c +$fromByte ${quote(logPath)} 2>/dev/null';

  /// 读当前 boot 会话 token。`boot_id` 对 shell 可读，不必过 `su`。
  static String buildBootIdCommand() =>
      'cat /proc/sys/kernel/random/boot_id 2>/dev/null';

  /// 从收日志输出里取退出码；取不到返回 `-1`。
  ///
  /// 只认整行匹配并取最后一处，避免被载荷自己输出里的 `exitCode=` 字样带偏。
  static int exitCodeFrom(String log) {
    final RegExpMatch? match = exitCodePattern.allMatches(log).lastOrNull;
    if (match == null) return -1;
    return int.tryParse(match.group(1) ?? '') ?? -1;
  }
}

/// 轮询的终止条件。
enum PollOutcome {
  /// 后台进程自己退出了。成功与否看日志标记。
  finished,

  /// 日志长时间不增长，已判停滞。
  stalled,

  /// 触到总时长上限。
  timedOut,

  /// 探测命令连续失败，状态不可知。
  lost,
}

/// 一次探测的读数。
class PayloadProbe {
  const PayloadProbe({required this.running, required this.size});

  /// 后台进程是否还活着。
  final bool running;

  /// 日志当前字节数。
  final int size;

  static final RegExp _pattern = RegExp(r'state=(\w+)\s+size=(\d*)');

  /// 解析 `state=... size=...`。解析不出来按 `running: false`：宁可提前收尾
  /// 去读日志判标记，也不能把「看不懂」当成「还在跑」。
  static PayloadProbe parse(String stdout) {
    final RegExpMatch? match = _pattern.firstMatch(stdout);
    if (match == null) return const PayloadProbe(running: false, size: 0);
    return PayloadProbe(
      running: match.group(1) == 'running',
      size: int.tryParse(match.group(2) ?? '') ?? 0,
    );
  }
}

/// 轮询载荷进程，直到退出、卡死或超时。
///
/// 按轮数计数，阈值由 [pollInterval] 与两个时长常量算出，不受系统时间跳变影响。
class PayloadPoller {
  const PayloadPoller({
    required this.exec,
    required this.delay,
    required this.pollInterval,
    this.onLogWindow,
  });

  final ShellExec exec;

  /// 轮询的等待实现；测试注入成立即返回。
  final Future<void> Function(Duration duration) delay;

  /// 两次探测的间隔。总轮数与停滞轮数都由它和两个时长常量推出来。
  final Duration pollInterval;

  /// 日志每长一段就回调一次，入参是「上一轮尾部 + 本轮新增」的窗口。
  final Future<void> Function(String window)? onLogWindow;

  Future<PollOutcome> poll() async {
    final int intervalMs = pollInterval.inMilliseconds <= 0
        ? 1
        : pollInterval.inMilliseconds;
    final int stallPolls = (PayloadShell.stallTimeoutMs / intervalMs).ceil();
    final int totalPolls = (PayloadShell.runTimeoutMs / intervalMs).ceil();

    int lastSize = -1;
    int pollsSinceGrowth = 0;
    int polls = 0;
    int probeFailures = 0;

    // 增量扫描游标：日志只在末尾追加，所以每轮只读新增的那一段。
    int readBytes = 0;
    String carry = '';

    while (true) {
      await delay(pollInterval);
      polls++;

      final pigeon.ShellExecResult probe = await exec(
        PayloadShell.buildProbeCommand(),
        PayloadShell.shortTimeoutMs,
      );

      if (probe.exitCode != 0) {
        // 探测命令自己失败：通道断了。连续几次都这样必须收手，否则会把
        // 「看不了」当成「还在跑」，一直耗到总时长上限。
        if (++probeFailures >= PayloadShell.maxProbeFailures) {
          return PollOutcome.lost;
        }
      } else {
        probeFailures = 0;
        final PayloadProbe parsed = PayloadProbe.parse(probe.stdout);
        if (!parsed.running) return PollOutcome.finished;
        if (parsed.size != lastSize) {
          lastSize = parsed.size;
          pollsSinceGrowth = 0;

          final Future<void> Function(String window)? onWindow = onLogWindow;
          if (onWindow != null) {
            final pigeon.ShellExecResult tail = await exec(
              PayloadShell.buildReadTailCommand(readBytes + 1),
              PayloadShell.shortTimeoutMs,
            );
            // 读失败就不推进游标，下一轮重读整份日志，属于自愈。
            if (tail.exitCode == 0) {
              readBytes = parsed.size;
              if (tail.stdout.isNotEmpty) {
                final String window = carry + tail.stdout;
                await onWindow(window);
                carry = window.length > PayloadShell.windowChars
                    ? window.substring(window.length - PayloadShell.windowChars)
                    : window;
              }
            }
          }
        } else if (++pollsSinceGrowth >= stallPolls) {
          return PollOutcome.stalled;
        }
      }

      if (polls >= totalPolls) return PollOutcome.timedOut;
    }
  }
}
