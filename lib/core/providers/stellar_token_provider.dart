import 'dart:math';

import 'package:Aisupass/core/storage/preferences_store.dart';
import 'package:Aisupass/core/storage/storage_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stellar_token_provider.g.dart';

/// 与本机 Stellar 服务共享的鉴权串。
///
/// 32 字节随机数的十六进制表示（64 个字符）。安装期一次生成后**稳定不变**：
/// 服务脱离 adbd 后可以比 App 进程活得久，App 重启后必须还能与既有服务通信，
/// 否则每次重启都要重新拉起（而拉起又依赖 ADB）。
///
/// 单独成文件是为了让依赖保持单向：服务端 Provider、执行出口、终端后端都要用它，
/// 但它自己只依赖存储层，不反过来牵动任何一侧。
@Riverpod(keepAlive: true)
Future<String> stellarServiceToken(Ref ref) async {
  final PreferencesStore store = ref.watch(preferencesStoreProvider);
  const String key = 'stellar_service_token';

  final String existing = await store.read<String>(key, defaultValue: '');
  if (_isHex64(existing)) return existing;

  final Random random = Random.secure();
  final StringBuffer buffer = StringBuffer();
  for (int i = 0; i < 32; i++) {
    buffer.write(random.nextInt(256).toRadixString(16).padLeft(2, '0'));
  }
  final String token = buffer.toString();
  await store.write<String>(key, token);
  return token;
}

/// 是否是 64 位小写十六进制串。
bool _isHex64(String value) {
  if (value.length != 64) return false;
  for (int i = 0; i < value.length; i++) {
    final int code = value.codeUnitAt(i);
    final bool digit = code >= 0x30 && code <= 0x39;
    final bool lower = code >= 0x61 && code <= 0x66;
    if (!digit && !lower) return false;
  }
  return true;
}
