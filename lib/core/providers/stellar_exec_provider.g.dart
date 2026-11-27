// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stellar_exec_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stellar 通道的一次性命令出口（可带标准输入）。
///
/// 唯一的实现；[stellarShellExec] 只是把 `stdin` 固定成 null 的薄包装，
/// 避免同一套往返逻辑写两遍。
///
/// 服务未就绪时返回 `exitCode = -1` 与原因串，**不自动拉起服务**——
/// 拉起需要 ADB 通道，在这里发起会形成「拉起 → 执行 → 拉起」的递归。

@ProviderFor(stellarShellExecWithStdin)
const stellarShellExecWithStdinProvider = StellarShellExecWithStdinProvider._();

/// Stellar 通道的一次性命令出口（可带标准输入）。
///
/// 唯一的实现；[stellarShellExec] 只是把 `stdin` 固定成 null 的薄包装，
/// 避免同一套往返逻辑写两遍。
///
/// 服务未就绪时返回 `exitCode = -1` 与原因串，**不自动拉起服务**——
/// 拉起需要 ADB 通道，在这里发起会形成「拉起 → 执行 → 拉起」的递归。

final class StellarShellExecWithStdinProvider
    extends
        $FunctionalProvider<
          ShellExecWithStdin,
          ShellExecWithStdin,
          ShellExecWithStdin
        >
    with $Provider<ShellExecWithStdin> {
  /// Stellar 通道的一次性命令出口（可带标准输入）。
  ///
  /// 唯一的实现；[stellarShellExec] 只是把 `stdin` 固定成 null 的薄包装，
  /// 避免同一套往返逻辑写两遍。
  ///
  /// 服务未就绪时返回 `exitCode = -1` 与原因串，**不自动拉起服务**——
  /// 拉起需要 ADB 通道，在这里发起会形成「拉起 → 执行 → 拉起」的递归。
  const StellarShellExecWithStdinProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stellarShellExecWithStdinProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stellarShellExecWithStdinHash();

  @$internal
  @override
  $ProviderElement<ShellExecWithStdin> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ShellExecWithStdin create(Ref ref) {
    return stellarShellExecWithStdin(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShellExecWithStdin value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShellExecWithStdin>(value),
    );
  }
}

String _$stellarShellExecWithStdinHash() =>
    r'ba859521bc8532b7acd560957dbacef767394a71';

/// Stellar 通道的一次性命令出口。
///
/// 与 ADB 侧共用同一个 [ShellExec] 签名：上层只看到退出码与两路输出，
/// 不需要知道底下是 TLS 的 adb 协议还是回环的自研服务。

@ProviderFor(stellarShellExec)
const stellarShellExecProvider = StellarShellExecProvider._();

/// Stellar 通道的一次性命令出口。
///
/// 与 ADB 侧共用同一个 [ShellExec] 签名：上层只看到退出码与两路输出，
/// 不需要知道底下是 TLS 的 adb 协议还是回环的自研服务。

final class StellarShellExecProvider
    extends $FunctionalProvider<ShellExec, ShellExec, ShellExec>
    with $Provider<ShellExec> {
  /// Stellar 通道的一次性命令出口。
  ///
  /// 与 ADB 侧共用同一个 [ShellExec] 签名：上层只看到退出码与两路输出，
  /// 不需要知道底下是 TLS 的 adb 协议还是回环的自研服务。
  const StellarShellExecProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stellarShellExecProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stellarShellExecHash();

  @$internal
  @override
  $ProviderElement<ShellExec> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ShellExec create(Ref ref) {
    return stellarShellExec(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShellExec value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShellExec>(value),
    );
  }
}

String _$stellarShellExecHash() => r'6558a1487265f17b95220d0851d717c2d7e9a724';
