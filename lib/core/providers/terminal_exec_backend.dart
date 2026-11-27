import 'dart:typed_data';

/// 启动会话的受理结果。
///
/// 用记录类型而非实体：这是同进程内的过程值，不属于任何 feature 的业务模型。
typedef TerminalStart = ({bool accepted, String sessionId, String failure});

/// 一次增量快照。
typedef TerminalChunk = ({
  String stdout,
  bool finished,
  int exitCode,
  bool timedOut,
  int droppedBytes,
  String failure,
});

/// 终端后端：一组「开流 / 取增量 / 写 stdin / 改尺寸 / 中断」的契约。
///
/// 存在的理由只有一个：终端页与提权链路只认识这组方法，不关心底下是
/// 无线 ADB 的 shell 协议还是本应用自己的回环服务。
///
/// 与具体实现的装配在 `terminal_backend_provider.dart`；
/// 单独成文件是为了让调用方（如 `adb_shell_provider.dart`）只依赖契约，
/// 不连带上两个实现及其各自的依赖。
abstract class TerminalExecBackend {
  /// 开一条会话；[timeoutMs] 为 0 或负数表示不限时。
  Future<TerminalStart> start(String command, int timeoutMs);

  /// 取走自上次轮询以来的增量；`finished` 之后原生侧即回收会话。
  Future<TerminalChunk> poll(String sessionId);

  /// 往 stdin 写字节；返回 false 表示会话已不可写。
  Future<bool> writeStdin(String sessionId, Uint8List data);

  /// 同步窗口尺寸（字符网格）。
  Future<void> resize(String sessionId, int rows, int cols);

  /// 结束会话并释放资源。
  ///
  /// 注意这不是「Ctrl+C」：终端里按中断键走的是 [writeStdin] 写 `0x03`，
  /// 由远端 line discipline 翻译成 SIGINT，会话本身仍存活。
  Future<void> cancel(String sessionId);

  /// 释放后端自身持有的资源；切换通道或容器销毁时调用。
  void dispose() {}
}
