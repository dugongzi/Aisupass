/// 把临时 root 移交给 KernelSU 系管理器的脚本，以及它的读数解析。
///
/// 结构照上游 `RootHandoff.kt:62-66`：定位与 `late-load` 必须在同一次 shell
/// 会话里，`$KSUD` 才能传下去。拆成两条不只是多弹一次授权框，中间还有
/// TOCTOU 窗口。
class HandoffScript {
  const HandoffScript._();

  /// 管理器的内核驱动加载器。装了 KernelSU 系管理器就一定有这一份。
  static const String ksudLibrary = 'libksud.so';

  /// 管理器的内核驱动加载器子命令：把已存在的驱动挂进运行中的内核。
  static const String lateLoadArgument = 'late-load';

  /// 允许 shell（uid=2000）经由接管后的管理器取得 root。
  static const String allowShellFlag = '--allow-shell';

  /// 接管方的包名参数。
  static const String packageNameFlag = '--package-name';

  /// 脚本打出的定位结果行前缀，形如 `KSUD=/data/app/.../libksud.so`。
  static const String ksudPrefix = 'KSUD=';

  /// 脚本找不到 `libksud.so` 时打出的机器可读标记：`find` 的空输出也可能是
  /// 命令根本没跑起来，不能靠它判。
  static const String noKsudMarker = 'NO_KSUD';

  /// 脚本「没找到管理器」时的退出码，与 [noKsudMarker] 配套。
  static const int noKsudExitCode = 3;

  /// 包名合法形态：至少两段、点分隔。包名会被拼进 shell，先校验再拼。
  static final RegExp packagePattern = RegExp(
    r'^[a-zA-Z][a-zA-Z0-9_]*(\.[a-zA-Z][a-zA-Z0-9_]*)+$',
  );

  /// `libksud.so` 的路径里出现这些字符就无法安全嵌进 `su -c "..."`。
  static final RegExp unsafePathChars = RegExp(r'''["'$`\\]''');

  /// 失败关键字，口径来自上游 `RootHandoff`。只看退出码和这张表，命中即失败。
  static const List<String> failureMarkers = <String>[
    'error',
    'failed',
    'failure',
    'denied',
    'not found',
    'invalid',
    'cannot',
    'not permitted',
    'permission',
    'unable',
    'refused',
    'mismatch',
  ];

  /// 定位 `libksud.so` → 存进 `$KSUD` → 同一条 shell 里立即 `late-load`。
  ///
  /// 安装目录形如 `/data/app/~~<hash>==/<包名>-<hash>==/lib/arm64/libksud.so`，
  /// 包名只出现在中间那段，所以按整条路径过滤。
  ///
  /// `2>/dev/null` 压在 `find` 上：某个子目录进不去不该算整体失败。
  /// `head -n 1` 保证只留一个路径：管理器升级后可能残留旧目录，取首条既定了
  /// 唯一解，也让 `"$KSUD"` 不会被当成多行命令。
  static String build(String managerPackage) =>
      'KSUD=\$(find /data/app -name $ksudLibrary 2>/dev/null '
      '| grep -F $managerPackage | head -n 1); '
      'if [ -z "\$KSUD" ]; then echo "$noKsudMarker"; exit $noKsudExitCode; fi; '
      'echo "$ksudPrefix\$KSUD"; '
      '"\$KSUD" $lateLoadArgument $allowShellFlag '
      '$packageNameFlag $managerPackage';

  /// 从输出里取出 `KSUD=<路径>` 那一行。只认行首：`late-load` 自己的输出
  /// 可能也提到路径，带 `KSUD=` 前缀的只有脚本自己打的那一行。
  static String ksudPathFrom(String output) {
    for (final String line in output.split('\n')) {
      final String trimmed = line.trim();
      if (!trimmed.startsWith(ksudPrefix)) continue;
      final String path = trimmed.substring(ksudPrefix.length).trim();
      if (path.isNotEmpty) return path;
    }
    return '';
  }

  /// 输出是否表明「管理器没装」。标记与退出码任一命中即可：标记是脚本自己
  /// 打的，退出码是兜底 —— 脚本提前挂掉时可能只留下 3。
  static bool indicatesManagerMissing(String output, int exitCode) =>
      output.contains(noKsudMarker) || exitCode == noKsudExitCode;

  /// 输出里是否出现已知失败关键字（大小写不敏感）。
  static bool mentionsFailure(String output) {
    final String lower = output.toLowerCase();
    return failureMarkers.any(lower.contains);
  }
}
