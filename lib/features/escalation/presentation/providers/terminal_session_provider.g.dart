// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terminal_session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 全局唯一的终端会话。
///
/// 手动提权页与终端页共用同一份终端缓冲与同一条 pty：切页不丢历史，停在提权页
/// 时发起的提权命令，其输出也继续累积进来，进终端页能看到完整过程。
///
/// 刻意 `keepAlive`：切页会把实例连同屏幕历史一起丢掉。

@ProviderFor(terminalSession)
const terminalSessionProvider = TerminalSessionProvider._();

/// 全局唯一的终端会话。
///
/// 手动提权页与终端页共用同一份终端缓冲与同一条 pty：切页不丢历史，停在提权页
/// 时发起的提权命令，其输出也继续累积进来，进终端页能看到完整过程。
///
/// 刻意 `keepAlive`：切页会把实例连同屏幕历史一起丢掉。

final class TerminalSessionProvider
    extends
        $FunctionalProvider<TerminalSession, TerminalSession, TerminalSession>
    with $Provider<TerminalSession> {
  /// 全局唯一的终端会话。
  ///
  /// 手动提权页与终端页共用同一份终端缓冲与同一条 pty：切页不丢历史，停在提权页
  /// 时发起的提权命令，其输出也继续累积进来，进终端页能看到完整过程。
  ///
  /// 刻意 `keepAlive`：切页会把实例连同屏幕历史一起丢掉。
  const TerminalSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'terminalSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$terminalSessionHash();

  @$internal
  @override
  $ProviderElement<TerminalSession> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TerminalSession create(Ref ref) {
    return terminalSession(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TerminalSession value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TerminalSession>(value),
    );
  }
}

String _$terminalSessionHash() => r'f710613356124aaa5f0d92aa51dc6146f70db96a';
