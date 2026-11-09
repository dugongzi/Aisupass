import 'package:Aisupass/generated/adb_shell.g.dart' as pigeon;

/// 一条命令的执行出口：`(命令, 超时毫秒) → 原始结果`。
///
/// 抽掉 `stdin`：提权命令不读标准输入，固定传 `null` 立即 EOF 比挂到超时好。
typedef ShellExec =
    Future<pigeon.ShellExecResult> Function(String command, int timeoutMs);

/// 以 root 身份执行脚本的薄壳：按固定候选解析 `su` 路径后包一层。
class SuShell {
  const SuShell({required this.exec});

  final ShellExec exec;

  static const List<String> candidates = <String>[
    '/data/local/tmp/su',
    '/apex/com.android.virt/bin/su',
    '/product/bin/su',
    '/debug_ramdisk/su',
    '/system/bin/su',
    '/system/xbin/su',
    '/sbin/su',
    '/vendor/bin/su',
    '/odm/bin/su',
  ];

  /// 移交这一步的上限。比普通短命令长：管理器可能弹授权框。
  static const int handoffTimeoutMs = 120000;

  /// 把 [script] 包成 root 身份执行。
  Future<pigeon.ShellExecResult> run(
    String script, {
    required int timeoutMs,
  }) => exec(wrap(script), timeoutMs);

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
