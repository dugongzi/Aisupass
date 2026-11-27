import 'dart:typed_data';

import 'package:Aisupass/core/providers/stellar_exec_provider.dart';
import 'package:Aisupass/core/providers/stellar_token_provider.dart';
import 'package:Aisupass/generated/adb_shell.g.dart' as pigeon;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 固定的合法 token（64 个十六进制字符），避开真实存储。
const String _token =
    '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef';

void main() {
  group('Stellar 执行出口的生命周期', () {
    test('Provider 销毁后闭包仍可调用，不抛「Ref 已释放」', () async {
      final ProviderContainer container = ProviderContainer(
        overrides: [stellarServiceTokenProvider.overrideWith((ref) async => _token)],
      );

      final Future<pigeon.ShellExecResult> Function(String, int, Uint8List?)
      exec = container.read(stellarShellExecWithStdinProvider);

      // 提权链路会长期持有这个闭包，而 Provider 早已 autoDispose。
      // 修复前这里会抛 "Cannot use the Ref ... after it has been disposed"。
      container.dispose();

      final pigeon.ShellExecResult result = await exec('id', 5000, null);

      // 测试环境没有服务在监听 39187，应当是一次干净的「通道不可用」。
      expect(result.exitCode, -1);
      expect(result.stderr, 'channelUnavailable');
    });
  });
}
