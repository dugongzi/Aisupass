import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/features/chat/data/models/chat_attachment_dto.dart';
import 'package:Aisupass/features/chat/data/models/chat_tool_call_dto.dart';
import 'package:Aisupass/features/chat/domain/enums/chat_notice.dart';
import 'package:Aisupass/features/chat/domain/enums/chat_role.dart';
import 'package:Aisupass/features/chat/domain/models/chat_turn.dart';
import 'package:Aisupass/features/chat/domain/models/chat_usage.dart';

part 'chat_turn_dto.freezed.dart';
part 'chat_turn_dto.g.dart';

/// 对话轮次的数据传输对象，只在 data 层内流转。
@freezed
abstract class ChatTurnDto with _$ChatTurnDto {
  const ChatTurnDto._();

  const factory ChatTurnDto({
    @Default('') String id,
    @Default('') String role,
    @Default('') String text,
    @Default('') String reasoning,
    @Default(<ChatToolCallDto>[]) List<ChatToolCallDto> toolCalls,
    @Default('') String error,
    @Default('') String rawError,
    @Default('') String notice,
    @Default(<ChatAttachmentDto>[]) List<ChatAttachmentDto> attachments,
    @Default('') String createdAt,
    @Default(0) int durationMs,
    @Default(<String, dynamic>{}) Map<String, dynamic> usage,
  }) = _ChatTurnDto;

  factory ChatTurnDto.fromJson(Map<String, dynamic> json) =>
      _$ChatTurnDtoFromJson(json);

  factory ChatTurnDto.fromEntity(ChatTurn entity) => ChatTurnDto(
    id: entity.id,
    role: entity.role.name,
    text: entity.text,
    reasoning: entity.reasoning,
    toolCalls: entity.toolCalls
        .map(ChatToolCallDto.fromEntity)
        .toList(growable: false),
    error: entity.error,
    rawError: entity.rawError,
    notice: entity.notice.name,
    attachments: entity.attachments
        .map(ChatAttachmentDto.fromEntity)
        .toList(growable: false),
    createdAt: entity.hasCreatedAt
        ? entity.createdAt.toIso8601String()
        : '',
    durationMs: entity.duration.inMilliseconds,
    usage: <String, dynamic>{
      if (entity.usage.promptTokens > 0)
        'promptTokens': entity.usage.promptTokens,
      if (entity.usage.completionTokens > 0)
        'completionTokens': entity.usage.completionTokens,
    },
  );

  ChatTurn toEntity() => ChatTurn(
    id: id,
    role: ChatRole.fromName(role),
    text: text,
    reasoning: reasoning,
    toolCalls: toolCalls
        .map((ChatToolCallDto item) => item.toEntity())
        .toList(growable: false),
    streaming: false,
    error: error,
    rawError: rawError,
    notice: ChatNotice.fromName(notice),
    attachments: attachments
        .map((ChatAttachmentDto item) => item.toEntity())
        .toList(growable: false),
    createdAt: DateTime.tryParse(createdAt) ??
        DateTime.fromMillisecondsSinceEpoch(0),
    duration: Duration(milliseconds: durationMs),
    usage: ChatUsage(
      promptTokens: (usage['promptTokens'] as num?)?.toInt() ?? 0,
      completionTokens: (usage['completionTokens'] as num?)?.toInt() ?? 0,
    ),
  );
}
