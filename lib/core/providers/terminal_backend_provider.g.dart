// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terminal_backend_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 当前通道的终端后端。
///
/// `keepAlive` 是必需的：`ShellExecController` 用 `ref.read` 取值，
/// autoDispose 会在同一帧后销毁实例，Stellar 连接会随之丢失。

@ProviderFor(terminalExecBackend)
const terminalExecBackendProvider = TerminalExecBackendProvider._();

/// 当前通道的终端后端。
///
/// `keepAlive` 是必需的：`ShellExecController` 用 `ref.read` 取值，
/// autoDispose 会在同一帧后销毁实例，Stellar 连接会随之丢失。

final class TerminalExecBackendProvider
    extends
        $FunctionalProvider<
          TerminalExecBackend,
          TerminalExecBackend,
          TerminalExecBackend
        >
    with $Provider<TerminalExecBackend> {
  /// 当前通道的终端后端。
  ///
  /// `keepAlive` 是必需的：`ShellExecController` 用 `ref.read` 取值，
  /// autoDispose 会在同一帧后销毁实例，Stellar 连接会随之丢失。
  const TerminalExecBackendProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'terminalExecBackendProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$terminalExecBackendHash();

  @$internal
  @override
  $ProviderElement<TerminalExecBackend> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TerminalExecBackend create(Ref ref) {
    return terminalExecBackend(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TerminalExecBackend value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TerminalExecBackend>(value),
    );
  }
}

String _$terminalExecBackendHash() =>
    r'8b54c2d4c25fe7815399743ade6e5728a0a0a821';
