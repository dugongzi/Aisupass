// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privileged_runner_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 特权命令的执行出口。
///
/// 这是唯一一处把「Stellar」与「无线 ADB」接在一起：服务需要一个已经具备
/// shell 身份的执行者把自己跑起来，当前可用的是无线 ADB 通道。Stellar 的
/// 状态机与 UI 都不感知这件事，只按 [PrivilegedRunResult] 分型。
///
/// 执行前先自己把通道连上：调用方要的是「跑这条命令」，不是「先手动去连一次
/// ADB 再回来点按钮」，所以没连接时由这里发起配对，而不是把「请先连接」退回
/// 给调用方去提示用户。配对码输入位置这一设置由通道自己遵守，这里只搬原因码。

@ProviderFor(privilegedRunner)
const privilegedRunnerProvider = PrivilegedRunnerProvider._();

/// 特权命令的执行出口。
///
/// 这是唯一一处把「Stellar」与「无线 ADB」接在一起：服务需要一个已经具备
/// shell 身份的执行者把自己跑起来，当前可用的是无线 ADB 通道。Stellar 的
/// 状态机与 UI 都不感知这件事，只按 [PrivilegedRunResult] 分型。
///
/// 执行前先自己把通道连上：调用方要的是「跑这条命令」，不是「先手动去连一次
/// ADB 再回来点按钮」，所以没连接时由这里发起配对，而不是把「请先连接」退回
/// 给调用方去提示用户。配对码输入位置这一设置由通道自己遵守，这里只搬原因码。

final class PrivilegedRunnerProvider
    extends
        $FunctionalProvider<
          PrivilegedRunner,
          PrivilegedRunner,
          PrivilegedRunner
        >
    with $Provider<PrivilegedRunner> {
  /// 特权命令的执行出口。
  ///
  /// 这是唯一一处把「Stellar」与「无线 ADB」接在一起：服务需要一个已经具备
  /// shell 身份的执行者把自己跑起来，当前可用的是无线 ADB 通道。Stellar 的
  /// 状态机与 UI 都不感知这件事，只按 [PrivilegedRunResult] 分型。
  ///
  /// 执行前先自己把通道连上：调用方要的是「跑这条命令」，不是「先手动去连一次
  /// ADB 再回来点按钮」，所以没连接时由这里发起配对，而不是把「请先连接」退回
  /// 给调用方去提示用户。配对码输入位置这一设置由通道自己遵守，这里只搬原因码。
  const PrivilegedRunnerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'privilegedRunnerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$privilegedRunnerHash();

  @$internal
  @override
  $ProviderElement<PrivilegedRunner> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PrivilegedRunner create(Ref ref) {
    return privilegedRunner(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrivilegedRunner value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrivilegedRunner>(value),
    );
  }
}

String _$privilegedRunnerHash() => r'450a8cd648228c7d2f328108d88aed1580708b8e';
