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

/// Stellar 通道的一次性命令出口。
///
/// 与 ADB 侧共用同一个 [ShellExec] 签名：上层只看到退出码与两路输出，
/// 不需要知道底下是 TLS 的 adb 协议还是回环的自研服务。
///
/// 服务未就绪时返回 `exitCode = -1` 与原因串，**不自动拉起服务**——
/// 拉起需要 ADB 通道，在这里发起会形成「拉起 → 执行 → 拉起」的递归。
@riverpod
ShellExec stellarShellExec(Ref ref) {
  return (String command, int timeoutMs) async {
    final String token = await ref.read(stellarServiceTokenProvider.future);
    final Uint8List commandBytes = Uint8List.fromList(utf8.encode(command));

    final StellarReply? reply = await stellarRequest(
      port: stellarServicePort,
      line: 'EXEC $token $timeoutMs ${commandBytes.length}',
      body: commandBytes,
      timeout: Duration(milliseconds: timeoutMs) + _replyMargin,
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

    final Uint8List body = reply.body;
    final int outLen = _clamp(header.outLen, body.length);
    final int errLen = _clamp(header.errLen, body.length - outLen);

    final String stdout = utf8.decode(
      Uint8List.sublistView(body, 0, outLen),
      allowMalformed: true,
    );
    String stderr = utf8.decode(
      Uint8List.sublistView(body, outLen, outLen + errLen),
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

/// 把长度夹进 `0..max`；服务端的长度字段异常时按截断处理，不越界。
int _clamp(int value, int max) {
  if (value < 0) return 0;
  return value > max ? max : value;
}
