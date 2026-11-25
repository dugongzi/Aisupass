import 'package:Aisupass/core/models/command_channel.dart';
import 'package:Aisupass/core/storage/preferences_store.dart';
import 'package:Aisupass/core/storage/storage_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'command_channel_provider.g.dart';

/// 用户选择的命令通道，持久化在 [PreferencesStore] 里。
///
/// 这里只放「选了哪条」这一件事，不描述任何通道自身的状态：
/// 各通道的可用性由它自己的 Provider 负责，互不依赖。
@Riverpod(keepAlive: true)
class CommandChannelController extends _$CommandChannelController {
  static const String _key = 'command_channel';

  @override
  CommandChannel build() {
    Future.microtask(_load);
    return CommandChannel.adb;
  }

  PreferencesStore get _store => ref.read(preferencesStoreProvider);

  Future<void> _load() async {
    try {
      final String raw = await _store.read<String>(
        _key,
        defaultValue: CommandChannel.adb.name,
      );
      state = CommandChannel.fromName(raw);
    } catch (_) {
      // 存储不可用时保持默认：无线 ADB。
    }
  }

  /// 切换通道并落盘。
  Future<void> setChannel(CommandChannel channel) async {
    if (channel == state) return;
    state = channel;
    await _store.write<String>(_key, channel.name);
  }
}
