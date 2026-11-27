import 'dart:async';

import 'package:Aisupass/core/models/command_channel.dart';
import 'package:Aisupass/core/providers/adb_shell_provider.dart';
import 'package:Aisupass/core/providers/command_channel_provider.dart';
import 'package:Aisupass/core/providers/stellar_exec_provider.dart';
import 'package:Aisupass/core/providers/stellar_token_provider.dart';
import 'package:Aisupass/core/utils/su_shell.dart';
import 'package:Aisupass/generated/adb_shell.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'channel_exec_provider.g.dart';

/// 当前通道的一次性命令出口。
///
/// 与 [privilegedRunner] 的分工：
/// - `privilegedRunner` 专门用于「把 Stellar 服务拉起来」，必须走 ADB——
///   服务没起来时没有别的执行者；
/// - 这里用于**业务命令**，跟随用户选择的通道。提权链路（preflight /
///   payload / `su` 包装 / 移交）走这条。
///
/// 切换通道会让依赖它的 Provider 重建，因此链路会自然切到新通道。
@riverpod
ShellExec channelShellExec(Ref ref) {
  return switch (ref.watch(commandChannelControllerProvider)) {
    CommandChannel.adb => ref.watch(adbShellExecProvider),
    CommandChannel.stellar => ref.watch(stellarShellExecProvider),
  };
}

/// 当前通道的带标准输入出口。
///
/// 与 [channelShellExec] 同一个选择逻辑；独立成一个 Provider 是因为
/// `ShellExecWithStdin` 与 `ShellExec` 是两个函数类型，混在一起要写类型判别。
@riverpod
ShellExecWithStdin channelShellExecWithStdin(Ref ref) {
  return switch (ref.watch(commandChannelControllerProvider)) {
    CommandChannel.adb => ref.watch(adbShellExecWithStdinProvider),
    CommandChannel.stellar => ref.watch(stellarShellExecWithStdinProvider),
  };
}

/// 把当前通道与 Stellar token 下发给原生。
///
/// GhostKey / GhostLock 的对象建在 Kotlin 侧，复用 [adbShellNativeProvider] 背后
/// 那个 `AdbShellNativeImpl` 持有的 shell 通道，不经过 [channelShellExec]。
/// 不在这里同步的话，用户切到 Stellar 之后这两个功能仍然去打无线 ADB，
/// 表现就是明明服务在跑却报 `noAdb`。
///
/// 重复下发是幂等的：原生只在 token 变化时才清 uid 缓存。
@Riverpod(keepAlive: true)
void shellChannelSync(Ref ref) {
  final AdbShellNative native = ref.watch(adbShellNativeProvider);
  final CommandChannel channel = ref.watch(commandChannelControllerProvider);
  // 同步阶段就把 future 取出来：await 之后再用 ref 会命中已销毁的 Ref。
  // ADB 模式不读 token，避免在只用 ADB 的设备上白生成一份凭据。
  final Future<String>? tokenFuture = channel == CommandChannel.stellar
      ? ref.read(stellarServiceTokenProvider.future)
      : null;
  unawaited(_pushShellChannel(native, channel, tokenFuture));
}

Future<void> _pushShellChannel(
  AdbShellNative native,
  CommandChannel channel,
  Future<String>? tokenFuture,
) async {
  try {
    final String token = tokenFuture == null ? '' : await tokenFuture;
    await native.configureShellChannel(channel.name, token);
  } catch (_) {
    // 桌面端或原生未注册时没有通道可下发；不影响 Dart 侧的执行出口选择。
  }
}
