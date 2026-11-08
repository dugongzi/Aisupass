/// 载荷侧的 shell 协议：命令拼装与路径约定。
///
/// 路径与字段名是与助手 `libcve43499root.so` 的约定，两边必须一致。
class PayloadShell {
  const PayloadShell._();

  /// 随包执行助手的库名。名字是 `.so`，实际是 PIE 可执行文件。
  static const String helperLibrary = 'libcve43499root.so';

  /// 执行助手的子命令：加载并运行指定载荷。
  static const String runPayloadArgument = '--run-payload';

  /// 助手的最后一个参数是载荷输出的落点。前台跑时给 `/dev/stdout`，输出直接
  /// 进 pty，屏幕上实时可见。
  static const String stdoutPath = '/dev/stdout';

  /// 单次提权的重试轮数，传给助手的 `EXPLOIT_ATTEMPTS`。
  static const String exploitAttempts = '24';

  /// 单轮 P0（KASLR 泄露）阶段超时，单位秒。
  static const String p0AttemptTimeoutSec = '45';

  /// 单轮完整利用超时，单位秒。
  static const String exploitAttemptTimeoutSec = '120';

  /// KASLR P0 偏移的环境变量名，同一 boot 会话内 slide 固定。
  static const String slideP0OffsetEnv = 'SLIDE_P0_OFFSET';

  /// 一次性短命令（读内核版本、读 boot_id）的单次上限。长任务不经这条路。
  static const int shortTimeoutMs = 15000;

  /// 单引号包裹。`nativeLibraryDir` 含 `~` `=`，不加引号会被 shell 吃掉。
  static String quote(String value) => "'$value'";

  /// 助手链的一行命令。
  ///
  /// 两道闸门用 `||` 打印、再拿 `&&` 串起真正的执行：缺文件时屏幕上多一行说明，
  /// 载荷不会跑，`$?` 非 0。**不用 `exit`**——那会把整个终端会话关掉，用户还得
  /// 重新连一条。
  ///
  /// 环境变量用 `NAME=VALUE` 前缀直接贴给助手，**不能借 `env`**：
  /// `nativeLibraryDir` 形如 `/data/app/~~abc==/pkg-xyz==/lib/arm64`，路径里带
  /// `=`；`env` 只要看到参数含 `=` 就当成变量赋值吞掉，助手路径被吃掉后它
  /// exec 的就成了 `--run-payload`，设备上只得到
  /// `env: exec --run-payload: No such file or directory`。
  ///
  /// 标准输入接 `/dev/null`：载荷不该等键盘。这不妨碍 `Ctrl+C`——SIGINT 由内核
  /// 按前台进程组投递，与 stdin 指向哪里无关。
  static String buildLaunchCommand({
    required String helperPath,
    required String payloadPath,
    String? slideOffset,
  }) {
    final String helper = quote(helperPath);
    final String payload = quote(payloadPath);
    final String slideEnv = slideOffset != null
        ? '$slideP0OffsetEnv=$slideOffset '
        : '';
    return '[ -x $helper ] || '
        'echo "helper not executable: $helper"; '
        '[ -e $payload ] || '
        'echo "payload missing: $payload"; '
        '{ [ -x $helper ] && [ -e $payload ]; } && '
        'EXPLOIT_ATTEMPTS=$exploitAttempts '
        'P0_ATTEMPT_TIMEOUT_SEC=$p0AttemptTimeoutSec '
        'EXPLOIT_ATTEMPT_TIMEOUT_SEC=$exploitAttemptTimeoutSec '
        '$slideEnv'
        '$helper $runPayloadArgument $payload $helper $stdoutPath '
        '</dev/null';
  }

  /// 启动命令（独立可执行载荷）：直接执行载荷本身，不走助手。
  ///
  /// 载荷的 stdout 就是终端，不需要再指定输出落点。
  static String buildStandaloneLaunchCommand({
    required String payloadPath,
    required String arguments,
  }) {
    final String payload = quote(payloadPath);
    final String args = arguments.isEmpty ? '' : ' $arguments';
    return '[ -x $payload ] || '
        'echo "payload not executable: $payload"; '
        '[ -x $payload ] && $payload$args </dev/null';
  }

  /// 读设备内核版本，供需要内核版本参数的独立载荷填空。
  static String buildKernelReleaseCommand() => 'uname -r 2>/dev/null';

  /// catalog 里「内核版本末段」的占位符。
  static const String kernelTailPlaceholder = '<内核版本的后三位>';

  /// 把 catalog 的命令文案转成直接执行载荷的参数串。
  ///
  /// 文案的第一个 token 是载荷在设备上的落点（如 `/data/local/tmp/preload.so`），
  /// 与本 App 的 `nativeLibraryDir` 不同，不采用；只取它后面的参数。
  /// 占位符补不齐时返回 `null`，由调用方把原因打到屏幕上 —— 猜参数只会得到
  /// 一次看起来跑了、实际什么都没做的尝试。
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

  /// 读当前 boot 会话 token。`boot_id` 对 shell 可读，不必过 `su`。
  static String buildBootIdCommand() =>
      'cat /proc/sys/kernel/random/boot_id 2>/dev/null';
}
