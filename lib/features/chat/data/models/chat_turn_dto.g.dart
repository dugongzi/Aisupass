// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_turn_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatTurnDto _$ChatTurnDtoFromJson(Map<String, dynamic> json) => _ChatTurnDto(
  id: json['id'] as String? ?? '',
  role: json['role'] as String? ?? '',
  text: json['text'] as String? ?? '',
  reasoning: json['reasoning'] as String? ?? '',
  toolCalls:
      (json['toolCalls'] as List<dynamic>?)
          ?.map((e) => ChatToolCallDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ChatToolCallDto>[],
  error: json['error'] as String? ?? '',
  rawError: json['rawError'] as String? ?? '',
  notice: json['notice'] as String? ?? '',
  attachments:
      (json['attachments'] as List<dynamic>?)
          ?.map((e) => ChatAttachmentDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ChatAttachmentDto>[],
  createdAt: json['createdAt'] as String? ?? '',
  durationMs: (json['durationMs'] as num?)?.toInt() ?? 0,
  usage: json['usage'] as Map<String, dynamic>? ?? const <String, dynamic>{},
);

Map<String, dynamic> _$ChatTurnDtoToJson(_ChatTurnDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'text': instance.text,
      'reasoning': instance.reasoning,
      'toolCalls': instance.toolCalls,
      'error': instance.error,
      'rawError': instance.rawError,
      'notice': instance.notice,
      'attachments': instance.attachments,
      'createdAt': instance.createdAt,
      'durationMs': instance.durationMs,
      'usage': instance.usage,
    };
