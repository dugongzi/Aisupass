// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stellar_token_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 与本机 Stellar 服务共享的鉴权串。
///
/// 32 字节随机数的十六进制表示（64 个字符）。安装期一次生成后**稳定不变**：
/// 服务脱离 adbd 后可以比 App 进程活得久，App 重启后必须还能与既有服务通信，
/// 否则每次重启都要重新拉起（而拉起又依赖 ADB）。
///
/// 单独成文件是为了让依赖保持单向：服务端 Provider、执行出口、终端后端都要用它，
/// 但它自己只依赖存储层，不反过来牵动任何一侧。

@ProviderFor(stellarServiceToken)
const stellarServiceTokenProvider = StellarServiceTokenProvider._();

/// 与本机 Stellar 服务共享的鉴权串。
///
/// 32 字节随机数的十六进制表示（64 个字符）。安装期一次生成后**稳定不变**：
/// 服务脱离 adbd 后可以比 App 进程活得久，App 重启后必须还能与既有服务通信，
/// 否则每次重启都要重新拉起（而拉起又依赖 ADB）。
///
/// 单独成文件是为了让依赖保持单向：服务端 Provider、执行出口、终端后端都要用它，
/// 但它自己只依赖存储层，不反过来牵动任何一侧。

final class StellarServiceTokenProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// 与本机 Stellar 服务共享的鉴权串。
  ///
  /// 32 字节随机数的十六进制表示（64 个字符）。安装期一次生成后**稳定不变**：
  /// 服务脱离 adbd 后可以比 App 进程活得久，App 重启后必须还能与既有服务通信，
  /// 否则每次重启都要重新拉起（而拉起又依赖 ADB）。
  ///
  /// 单独成文件是为了让依赖保持单向：服务端 Provider、执行出口、终端后端都要用它，
  /// 但它自己只依赖存储层，不反过来牵动任何一侧。
  const StellarServiceTokenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stellarServiceTokenProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stellarServiceTokenHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return stellarServiceToken(ref);
  }
}

String _$stellarServiceTokenHash() =>
    r'79fd4e4886f2bdf17acd36e1e6a4e64b17aa3949';
