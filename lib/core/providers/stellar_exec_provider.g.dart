// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stellar_exec_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stellar 通道的一次性命令出口。
///
/// 与 ADB 侧共用同一个 [ShellExec] 签名：上层只看到退出码与两路输出，
/// 不需要知道底下是 TLS 的 adb 协议还是回环的自研服务。
///
/// 服务未就绪时返回 `exitCode = -1` 与原因串，**不自动拉起服务**——
/// 拉起需要 ADB 通道，在这里发起会形成「拉起 → 执行 → 拉起」的递归。

@ProviderFor(stellarShellExec)
const stellarShellExecProvider = StellarShellExecProvider._();

/// Stellar 通道的一次性命令出口。
///
/// 与 ADB 侧共用同一个 [ShellExec] 签名：上层只看到退出码与两路输出，
/// 不需要知道底下是 TLS 的 adb 协议还是回环的自研服务。
///
/// 服务未就绪时返回 `exitCode = -1` 与原因串，**不自动拉起服务**——
/// 拉起需要 ADB 通道，在这里发起会形成「拉起 → 执行 → 拉起」的递归。

final class StellarShellExecProvider
    extends $FunctionalProvider<ShellExec, ShellExec, ShellExec>
    with $Provider<ShellExec> {
  /// Stellar 通道的一次性命令出口。
  ///
  /// 与 ADB 侧共用同一个 [ShellExec] 签名：上层只看到退出码与两路输出，
  /// 不需要知道底下是 TLS 的 adb 协议还是回环的自研服务。
  ///
  /// 服务未就绪时返回 `exitCode = -1` 与原因串，**不自动拉起服务**——
  /// 拉起需要 ADB 通道，在这里发起会形成「拉起 → 执行 → 拉起」的递归。
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

String _$stellarShellExecHash() => r'30bdbbaa214d4180c523d9452f6f2a0685e0d4b3';
