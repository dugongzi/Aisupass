import 'package:Aisupass/generated/adb_shell.g.dart' as pigeon;

/// 一条命令的执行出口：`(命令, 超时毫秒) → 原始结果`。
///
/// 抽掉 `stdin`：提权命令不读标准输入，固定传 `null` 立即 EOF 比挂到超时好。
typedef ShellExec =
    Future<pigeon.ShellExecResult> Function(String command, int timeoutMs);

/// 以 root 身份执行脚本的薄壳：包 `su`、把 `id` 读数判成是不是 root、
/// 失败后逐条摊开 `su` 候选。
class SuShell {
  const SuShell({required this.exec});

  final ShellExec exec;

  /// `su` 候选路径，绝对路径优先。
  ///
  /// 本工程载荷提权后把 `su` 落在 `/apex/com.android.virt/bin/su`（实测确认），
  /// 该目录不在默认 `PATH` 里；KernelSU / SukiSU 常见落点是 `/product/bin/su`，
  /// Magisk 是 `/debug_ramdisk/su`。逐条试，取第一个可执行的，都没有才交给
  /// `PATH` 里的裸 `su`。
  static const List<String> candidates = <String>[
    '/apex/com.android.virt/bin/su',
    '/product/bin/su',
    '/debug_ramdisk/su',
    '/system/bin/su',
    '/system/xbin/su',
    '/sbin/su',
  ];

  /// 探测 root 身份的单次上限。比普通短命令长：管理器可能弹授权框。
  static const int rootProbeTimeoutMs = 20000;

  /// 移交这一步的上限。理由同上。
  static const int handoffTimeoutMs = 120000;

  /// `id` 输出里的 root 字段。认 `uid=0` 与 `uid=0(root)`，且必须是完整字段
  /// —— 直接 `contains('uid=0')` 会被 `uid=10000` 骗过去。
  static final RegExp _rootUidPattern = RegExp(
    r'(?:^|\s)uid=0(?:\(root\))?(?:\s|$)',
  );

  /// 借 root shell 读一次身份。
  Future<pigeon.ShellExecResult> checkRoot() =>
      run('id', timeoutMs: rootProbeTimeoutMs);

  /// 把 [script] 包成 root 身份执行。
  Future<pigeon.ShellExecResult> run(
    String script, {
    required int timeoutMs,
  }) => exec(wrap(script), timeoutMs);

  /// `id` 的读数是否说明当前就是 root。
  bool indicatesRoot(pigeon.ShellExecResult result) =>
      result.exitCode == 0 && _rootUidPattern.hasMatch(result.stdout);

  /// 逐条试 `su` 候选并记下每次的结果，供「没有 root」时定位原因。
  ///
  /// 快速路径把候选循环放在设备端，一次 IPC 拿结果但中间过程全丢。排查要的
  /// 正是那些中间过程：路径不存在 / 被管理器拒绝 / 授权框超时，处置完全不同。
  ///
  /// 这条命令**不能**再过 [wrap]：它自己要逐条试候选本身。
  Future<String> diagnoseCandidates() async {
    final String script = candidates
        .map(
          (String candidate) =>
              'if [ -x $candidate ]; then '
              'out=\$($candidate -c id 2>&1); rc=\$?; '
              'echo "probe=$candidate exit=\$rc out=\${out:-<empty>}"; '
              'else echo "probe=$candidate missing"; fi',
        )
        .join('; ');
    final pigeon.ShellExecResult result = await exec(script, handoffTimeoutMs);
    final String detail = '${result.stdout}${result.stderr}'.trim();
    return detail.isEmpty ? '' : '--- su 候选诊断 ---\n$detail';
  }

  /// 把一段脚本包成「以 root 身份执行」的一条命令。
  ///
  /// 先按 [candidates] 挑第一个可执行的绝对路径，都没有才退回裸 `su`。
  ///
  /// 外层用双引号是因为脚本里已经用了单引号包裹路径，再套一层单引号会互相
  /// 截断。
  static String wrap(String script) {
    final String joined = candidates.join(' ');
    final String escaped = escapeInDoubleQuotes(script);
    return "SU=''; for c in $joined; do "
        '[ -x "\$c" ] && { SU="\$c"; break; }; done; '
        'if [ -z "\$SU" ]; then SU=su; fi; '
        '"\$SU" -c "$escaped"';
  }

  /// 转义双引号串里的四个特殊字符，避免外层 shell 提前解释。
  static String escapeInDoubleQuotes(String value) => value
      .replaceAll('\\', '\\\\')
      .replaceAll('"', r'\"')
      .replaceAll(r'$', r'\$')
      .replaceAll('`', r'\`');
}
