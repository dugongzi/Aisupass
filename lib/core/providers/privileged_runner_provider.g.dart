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

@ProviderFor(privilegedRunner)
const privilegedRunnerProvider = PrivilegedRunnerProvider._();

/// 特权命令的执行出口。
///
/// 这是唯一一处把「Stellar」与「无线 ADB」接在一起：服务需要一个已经具备
/// shell 身份的执行者把自己跑起来，当前可用的是无线 ADB 通道。Stellar 的
/// 状态机与 UI 都不感知这件事，只按 [PrivilegedRunResult] 分型。
final class PrivilegedRunnerProvider
    extends
        $FunctionalProvider<PrivilegedRunner, PrivilegedRunner, PrivilegedRunner>
    with $Provider<PrivilegedRunner> {
  /// 特权命令的执行出口。
  ///
  /// 这是唯一一处把「Stellar」与「无线 ADB」接在一起：服务需要一个已经具备
  /// shell 身份的执行者把自己跑起来，当前可用的是无线 ADB 通道。Stellar 的
  /// 状态机与 UI 都不感知这件事，只按 [PrivilegedRunResult] 分型。
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

String _$privilegedRunnerHash() =>
    r'9a4c7e12d5b83f60c1e9a7d2f4b85c30e6d1a9b7';
