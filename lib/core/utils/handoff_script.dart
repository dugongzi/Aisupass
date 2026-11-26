/// 把临时 root 移交给全局选中的 root 管理器的脚本，以及它的读数解析。
///
/// 结构照上游 `RootHandoff.kt:62-66`：定位与 `late-load` 必须在同一次 shell
/// 会话里，`$KSUD` 才能传下去。拆成两条不只是多弹一次授权框，中间还有
/// TOCTOU 窗口。
///
/// **路径只有原生一个来源**：由 `RootManagerNative.resolveKsudPath` 按选中管理器
/// 解析（固定名优先、随机名靠指纹 + 实测 `late-load --help`）。脚本不再按文件名
/// `find`——那是另一套猜测逻辑，会绕过原生判定、把不可用的库当 ksud 跑。
class HandoffScript {
  const HandoffScript._();

  /// 管理器的内核驱动加载器子命令：把已存在的驱动挂进运行中的内核。
  static const String lateLoadArgument = 'late-load';

  /// 允许 shell（uid=2000）经由接管后的管理器取得 root。
  static const String allowShellFlag = '--allow-shell';

  /// 接管方的包名参数。
  static const String packageNameFlag = '--package-name';

  /// 脚本打出的定位结果行前缀，形如 `KSUD=/data/app/.../librenamed.so`。
  static const String ksudPrefix = 'KSUD=';

  /// 脚本拿不到 ksud 路径时打出的机器可读标记。
  static const String noKsudMarker = 'NO_KSUD';

  /// 脚本「没找到 ksud」时的退出码，与 [noKsudMarker] 配套。
  static const int noKsudExitCode = 3;

  /// 包名合法形态：至少两段、点分隔。包名会被拼进 shell，先校验再拼。
  static final RegExp packagePattern = RegExp(
    r'^[a-zA-Z][a-zA-Z0-9_]*(\.[a-zA-Z][a-zA-Z0-9_]*)+$',
  );

  /// ksud 路径里出现这些字符就无法安全嵌进 `su -c "..."`。
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

  /// 存进 `$KSUD` → 同一条 shell 里立即 `late-load`。
  ///
  /// [ksudPath] 必须是原生定位器给出的绝对路径。为空、或含无法安全转义的字符时
  /// 直接打 [noKsudMarker] 并以 [noKsudExitCode] 退出——不退回按文件名找，
  /// 让上层如实报「管理器里没有可用的 ksud」。
  static String build(String managerPackage, {required String ksudPath}) {
    final String path = ksudPath.trim();
    if (path.isEmpty || unsafePathChars.hasMatch(path)) {
      return 'echo "$noKsudMarker"; exit $noKsudExitCode';
    }
    return "KSUD='$path'; "
        'echo "$ksudPrefix\$KSUD"; '
        '"\$KSUD" $lateLoadArgument $allowShellFlag '
        '$packageNameFlag $managerPackage';
  }

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

  /// 输出是否表明「设备上没有 su」。
  ///
  /// `SuShell.wrap` 在所有候选路径都不可执行时会退回裸 `su`；设备上根本没有
  /// `su` 时由设备 shell 报 `sh: su: inaccessible or not found`，退出码 127。
  /// 这与「管理器装没装」无关，得单独认出来，否则会被当成授权失败误导用户。
  static bool indicatesNoSu(String output, int exitCode) {
    final String lower = output.toLowerCase();
    if (lower.contains('su: inaccessible or not found')) return true;
    if (lower.contains('su: not found')) return true;
    return exitCode == 127 && lower.contains('su');
  }

  /// 输出里是否出现已知失败关键字（大小写不敏感）。
  static bool mentionsFailure(String output) {
    final String lower = output.toLowerCase();
    return failureMarkers.any(lower.contains);
  }
}
