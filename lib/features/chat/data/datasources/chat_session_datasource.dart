import 'dart:convert';

import 'package:Aisupass/core/storage/preferences_store.dart';
import 'package:Aisupass/features/chat/domain/models/chat_session.dart';

/// 对话会话的本地数据源。
///
/// 整表以 JSON 字符串存一个键，当前会话 id 单独存一个键；
/// 会话数量级在几十条以内，整表覆盖写足够，无需分片。
class ChatSessionDatasource {
  const ChatSessionDatasource({required PreferencesStore preferences})
    : _preferences = preferences;

  /// 会话列表的存储键，值为 JSON 数组字符串。
  static const String listKey = 'chat_sessions';

  /// 当前选中会话 id 的存储键。
  static const String currentIdKey = 'chat_current_session';

  final PreferencesStore _preferences;

  Future<List<ChatSession>> loadAll() async {
    final String raw = await _preferences.read<String>(
      listKey,
      defaultValue: '',
    );
    if (raw.trim().isEmpty) return const <ChatSession>[];

    final Object? decoded = jsonDecode(raw);
    if (decoded is! List) return const <ChatSession>[];

    final List<ChatSession> sessions = <ChatSession>[];
    for (final Object? item in decoded) {
      if (item is! Map) continue;
      final Map<String, dynamic> map = item.map(
        (Object? key, Object? value) => MapEntry(key.toString(), value),
      );
      final String id = map['id']?.toString() ?? '';
      if (id.isEmpty) continue;
      sessions.add(ChatSession.fromJson(map));
    }
    return sessions;
  }

  Future<String> readCurrentId() =>
      _preferences.read<String>(currentIdKey, defaultValue: '');

  Future<void> writeAll(List<ChatSession> sessions) {
    final String raw = jsonEncode(
      sessions.map((ChatSession item) => item.toJson()).toList(growable: false),
    );
    return _preferences.write<String>(listKey, raw);
  }

  Future<void> writeCurrentId(String id) =>
      _preferences.write<String>(currentIdKey, id);
}
