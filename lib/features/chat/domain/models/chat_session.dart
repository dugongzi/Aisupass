import 'package:meta/meta.dart';

import 'chat_turn.dart';

/// 一个独立的多轮对话会话，整体序列化后落盘。
@immutable
class ChatSession {
  const ChatSession({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.turns = const <ChatTurn>[],
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ChatTurn> turns;

  bool get isEmpty => turns.isEmpty;

  ChatSession copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ChatTurn>? turns,
  }) {
    return ChatSession(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      turns: turns ?? this.turns,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'turns': turns.map((ChatTurn turn) => turn.toJson()).toList(),
    };
  }

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    final DateTime now = DateTime.now();
    final List<dynamic> rawTurns =
        json['turns'] as List<dynamic>? ?? const <dynamic>[];
    return ChatSession(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ?? now,
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? now,
      turns: rawTurns
          .whereType<Map<dynamic, dynamic>>()
          .map((Map<dynamic, dynamic> item) =>
              ChatTurn.fromJson(Map<String, dynamic>.from(item)))
          .toList(growable: false),
    );
  }
}
