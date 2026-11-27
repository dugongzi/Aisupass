// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_exec_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 当前通道的一次性命令出口。
///
/// 与 [privilegedRunner] 的分工：
/// - `privilegedRunner` 专门用于「把 Stellar 服务拉起来」，必须走 ADB——
///   服务没起来时没有别的执行者；
/// - 这里用于**业务命令**，跟随用户选择的通道。提权链路（preflight /
///   payload / `su` 包装 / 移交）走这条。
///
/// 切换通道会让依赖它的 Provider 重建，因此链路会自然切到新通道。

@ProviderFor(channelShellExec)
const channelShellExecProvider = ChannelShellExecProvider._();

/// 当前通道的一次性命令出口。
///
/// 与 [privilegedRunner] 的分工：
/// - `privilegedRunner` 专门用于「把 Stellar 服务拉起来」，必须走 ADB——
///   服务没起来时没有别的执行者；
/// - 这里用于**业务命令**，跟随用户选择的通道。提权链路（preflight /
///   payload / `su` 包装 / 移交）走这条。
///
/// 切换通道会让依赖它的 Provider 重建，因此链路会自然切到新通道。

final class ChannelShellExecProvider
    extends $FunctionalProvider<ShellExec, ShellExec, ShellExec>
    with $Provider<ShellExec> {
  /// 当前通道的一次性命令出口。
  ///
  /// 与 [privilegedRunner] 的分工：
  /// - `privilegedRunner` 专门用于「把 Stellar 服务拉起来」，必须走 ADB——
  ///   服务没起来时没有别的执行者；
  /// - 这里用于**业务命令**，跟随用户选择的通道。提权链路（preflight /
  ///   payload / `su` 包装 / 移交）走这条。
  ///
  /// 切换通道会让依赖它的 Provider 重建，因此链路会自然切到新通道。
  const ChannelShellExecProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'channelShellExecProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$channelShellExecHash();

  @$internal
  @override
  $ProviderElement<ShellExec> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ShellExec create(Ref ref) {
    return channelShellExec(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShellExec value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShellExec>(value),
    );
  }
}

String _$channelShellExecHash() => r'3dce25ef1f2cd0ae73ad05f896f8f78ad4709868';

/// 当前通道的带标准输入出口。
///
/// 与 [channelShellExec] 同一个选择逻辑；独立成一个 Provider 是因为
/// `ShellExecWithStdin` 与 `ShellExec` 是两个函数类型，混在一起要写类型判别。

@ProviderFor(channelShellExecWithStdin)
const channelShellExecWithStdinProvider = ChannelShellExecWithStdinProvider._();

/// 当前通道的带标准输入出口。
///
/// 与 [channelShellExec] 同一个选择逻辑；独立成一个 Provider 是因为
/// `ShellExecWithStdin` 与 `ShellExec` 是两个函数类型，混在一起要写类型判别。

final class ChannelShellExecWithStdinProvider
    extends
        $FunctionalProvider<
          ShellExecWithStdin,
          ShellExecWithStdin,
          ShellExecWithStdin
        >
    with $Provider<ShellExecWithStdin> {
  /// 当前通道的带标准输入出口。
  ///
  /// 与 [channelShellExec] 同一个选择逻辑；独立成一个 Provider 是因为
  /// `ShellExecWithStdin` 与 `ShellExec` 是两个函数类型，混在一起要写类型判别。
  const ChannelShellExecWithStdinProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'channelShellExecWithStdinProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$channelShellExecWithStdinHash();

  @$internal
  @override
  $ProviderElement<ShellExecWithStdin> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ShellExecWithStdin create(Ref ref) {
    return channelShellExecWithStdin(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShellExecWithStdin value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShellExecWithStdin>(value),
    );
  }
}

String _$channelShellExecWithStdinHash() =>
    r'3b29cc3ffea46b10ec76c714a8c404cf7ca6231e';

/// 把当前通道与 Stellar token 下发给原生。
///
/// GhostKey / GhostLock 的对象建在 Kotlin 侧，复用 [adbShellNativeProvider] 背后
/// 那个 `AdbShellNativeImpl` 持有的 shell 通道，不经过 [channelShellExec]。
/// 不在这里同步的话，用户切到 Stellar 之后这两个功能仍然去打无线 ADB，
/// 表现就是明明服务在跑却报 `noAdb`。
///
/// 重复下发是幂等的：原生只在 token 变化时才清 uid 缓存。

@ProviderFor(shellChannelSync)
const shellChannelSyncProvider = ShellChannelSyncProvider._();

/// 把当前通道与 Stellar token 下发给原生。
///
/// GhostKey / GhostLock 的对象建在 Kotlin 侧，复用 [adbShellNativeProvider] 背后
/// 那个 `AdbShellNativeImpl` 持有的 shell 通道，不经过 [channelShellExec]。
/// 不在这里同步的话，用户切到 Stellar 之后这两个功能仍然去打无线 ADB，
/// 表现就是明明服务在跑却报 `noAdb`。
///
/// 重复下发是幂等的：原生只在 token 变化时才清 uid 缓存。

final class ShellChannelSyncProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// 把当前通道与 Stellar token 下发给原生。
  ///
  /// GhostKey / GhostLock 的对象建在 Kotlin 侧，复用 [adbShellNativeProvider] 背后
  /// 那个 `AdbShellNativeImpl` 持有的 shell 通道，不经过 [channelShellExec]。
  /// 不在这里同步的话，用户切到 Stellar 之后这两个功能仍然去打无线 ADB，
  /// 表现就是明明服务在跑却报 `noAdb`。
  ///
  /// 重复下发是幂等的：原生只在 token 变化时才清 uid 缓存。
  const ShellChannelSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shellChannelSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shellChannelSyncHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return shellChannelSync(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$shellChannelSyncHash() => r'6f35d6038446950efcee85948e4278ab50816aa5';
