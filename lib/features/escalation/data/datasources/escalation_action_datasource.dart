import 'package:Aisupass/generated/adb_shell.g.dart' as pigeon;

/// 提权链路执行数据源：只做转调，不含任何业务判断。
class EscalationActionDatasource {
  const EscalationActionDatasource({required this._native});

  final pigeon.AdbShellNative _native;

  /// 经 ADB shell v2 通道执行一条命令，返回原始结果。
  ///
  /// `stdin` 固定传 `null`：提权命令不读标准输入，立即 EOF 比挂到超时好。
  Future<pigeon.ShellExecResult> exec(String command, int timeoutMs) =>
      _native.exec(command, timeoutMs, null);

  /// 取当前安装的原生库解压目录。
  ///
  /// 路径含安装随机后缀，每次安装/更新都会变，**不得持久化**。
  Future<String> nativeLibraryDir() => _native.nativeLibraryDir();
}
