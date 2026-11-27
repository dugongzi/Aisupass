import 'dart:convert';
import 'dart:typed_data';

import 'package:Aisupass/core/providers/stellar_token_provider.dart';
import 'package:Aisupass/core/utils/stellar_client.dart';
import 'package:Aisupass/core/utils/stellar_protocol.dart';
import 'package:Aisupass/core/utils/su_shell.dart';
import 'package:Aisupass/generated/adb_shell.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stellar_exec_provider.g.dart';

/// 应答等待余量：命令本身可以跑很久，客户端要多等一点才能收到结果。
const Duration _replyMargin = Duration(seconds: 5);

/// 「不限时」在 Socket 上的落地值。
///
/// `Socket.timeout` 不允许无限等待，所以用一个远超任何真实命令的时长代替。
/// 这不是在替调用方设上限，只是让「不限时」这个意图能表达出来。
const Duration _unboundedWait = Duration(days: 365);

/// Stellar 通道的一次性命令出口（可带标准输入）。
///
/// 唯一的实现；[stellarShellExec] 只是把 `stdin` 固定成 null 的薄包装，
/// 避免同一套往返逻辑写两遍。
///
/// 服务未就绪时返回 `exitCode = -1` 与原因串，**不自动拉起服务**——
/// 拉起需要 ADB 通道，在这里发起会形成「拉起 → 执行 → 拉起」的递归。
///
/// 依赖必须在 build 阶段取完：返回的闭包会被提权链路长期持有（一次提权可能跑
/// 好几分钟），那时本 Provider 早已 autoDispose，闭包里再碰 `ref` 会抛
/// 「Cannot use the Ref ... after it has been disposed」。
@riverpod
ShellExecWithStdin stellarShellExecWithStdin(Ref ref) {
  // 只在这里读一次。token 本身持久化且稳定，闭包拿着这个 Future 就够用。
  final Future<String> tokenFuture = ref.read(stellarServiceTokenProvider.future);

  return (String command, int timeoutMs, Uint8List? stdin) async {
    final String token = await tokenFuture;
    final Uint8List commandBytes = Uint8List.fromList(utf8.encode(command));
    final Uint8List stdinBytes = stdin ?? Uint8List(0);

    // 请求体 = 命令字节 + 标准输入字节，顺序与 C 侧读取顺序一致。
    final Uint8List body = Uint8List(commandBytes.length + stdinBytes.length)
      ..setRange(0, commandBytes.length, commandBytes)
      ..setRange(commandBytes.length, commandBytes.length + stdinBytes.length,
          stdinBytes);

    final StellarReply? reply = await stellarRequest(
      port: stellarServicePort,
      line:
          'EXEC $token $timeoutMs ${commandBytes.length} ${stdinBytes.length}',
      body: body,
      // `<= 0` 原样发给服务端（表示不限时），本端也只等一个「实质上无上限」的时长。
      // 不在这一层把 0 改成某个默认值：命令该跑多久是调用方的决定。
      timeout: timeoutMs <= 0
          ? _unboundedWait
          : Duration(milliseconds: timeoutMs) + _replyMargin,
    );

    if (reply == null) {
      return ShellExecResult(
        exitCode: -1,
        stdout: '',
        stderr: 'channelUnavailable',
        durationMs: 0,
        timedOut: false,
      );
    }

    final StellarHeader header = reply.header;
    if (header.ok != 1) {
      return ShellExecResult(
        exitCode: -1,
        stdout: '',
        stderr: header.reason.isEmpty ? 'execRejected' : header.reason,
        durationMs: 0,
        timedOut: false,
      );
    }

    final Uint8List respBody = reply.body;
    final int outLen = _clamp(header.outLen, respBody.length);
    final int errLen = _clamp(header.errLen, respBody.length - outLen);

    final String stdout = utf8.decode(
      Uint8List.sublistView(respBody, 0, outLen),
      allowMalformed: true,
    );
    String stderr = utf8.decode(
      Uint8List.sublistView(respBody, outLen, outLen + errLen),
      allowMalformed: true,
    );
    if (header.truncated == 1) {
      stderr = stderr.isEmpty
          ? '[output truncated]'
          : '$stderr\n[output truncated]';
    }

    return ShellExecResult(
      exitCode: header.exitCode,
      stdout: stdout,
      stderr: stderr,
      durationMs: header.durationMs,
      timedOut: header.timedOut == 1,
    );
  };
}

/// Stellar 通道的一次性命令出口。
///
/// 与 ADB 侧共用同一个 [ShellExec] 签名：上层只看到退出码与两路输出，
/// 不需要知道底下是 TLS 的 adb 协议还是回环的自研服务。
@riverpod
ShellExec stellarShellExec(Ref ref) {
  final ShellExecWithStdin withStdin = ref.watch(
    stellarShellExecWithStdinProvider,
  );
  return (String command, int timeoutMs) => withStdin(command, timeoutMs, null);
}

/// 把长度夹进 `0..max`；服务端的长度字段异常时按截断处理，不越界。
int _clamp(int value, int max) {
  if (value < 0) return 0;
  return value > max ? max : value;
}
