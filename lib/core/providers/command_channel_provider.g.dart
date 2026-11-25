// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'command_channel_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 用户选择的命令通道，持久化在 [PreferencesStore] 里。
///
/// 这里只放「选了哪条」这一件事，不描述任何通道自身的状态：
/// 各通道的可用性由它自己的 Provider 负责，互不依赖。

@ProviderFor(CommandChannelController)
const commandChannelControllerProvider = CommandChannelControllerProvider._();

/// 用户选择的命令通道，持久化在 [PreferencesStore] 里。
///
/// 这里只放「选了哪条」这一件事，不描述任何通道自身的状态：
/// 各通道的可用性由它自己的 Provider 负责，互不依赖。
final class CommandChannelControllerProvider
    extends $NotifierProvider<CommandChannelController, CommandChannel> {
  /// 用户选择的命令通道，持久化在 [PreferencesStore] 里。
  ///
  /// 这里只放「选了哪条」这一件事，不描述任何通道自身的状态：
  /// 各通道的可用性由它自己的 Provider 负责，互不依赖。
  const CommandChannelControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'commandChannelControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$commandChannelControllerHash();

  @$internal
  @override
  CommandChannelController create() => CommandChannelController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CommandChannel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CommandChannel>(value),
    );
  }
}

String _$commandChannelControllerHash() =>
    r'defebdaa2cd96ea2fee4bff349238617199e9315';

/// 用户选择的命令通道，持久化在 [PreferencesStore] 里。
///
/// 这里只放「选了哪条」这一件事，不描述任何通道自身的状态：
/// 各通道的可用性由它自己的 Provider 负责，互不依赖。

abstract class _$CommandChannelController extends $Notifier<CommandChannel> {
  CommandChannel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<CommandChannel, CommandChannel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CommandChannel, CommandChannel>,
              CommandChannel,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
