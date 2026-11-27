import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/features/chat/domain/enums/chat_notice.dart';
import 'package:Aisupass/features/chat/domain/enums/chat_role.dart';
import 'package:Aisupass/features/chat/domain/models/chat_attachment.dart';
import 'package:Aisupass/features/chat/domain/models/chat_tool_call.dart';
import 'package:Aisupass/features/chat/domain/models/chat_usage.dart';

part 'chat_turn.freezed.dart';

/// 一条对话消息。assistant 消息由正文、思考过程与工具调用组成。
@freezed
abstract class ChatTurn with _$ChatTurn {
  const ChatTurn._();

  const factory ChatTurn({
    required String id,
    required ChatRole role,
    required String text,
    required String reasoning,
    required List<ChatToolCall> toolCalls,
    required bool streaming,
    required String error,
    required ChatNotice notice,

    /// 失败时服务端返回的原始响应正文。
    ///
    /// 界面上原样展开给用户看，避免只给一句概括让用户猜原因。
    @Default('') String rawError,

    /// 用户消息附带的图片或文本文件，assistant 轮次恒为空。
    @Default(<ChatAttachment>[]) List<ChatAttachment> attachments,

    /// 轮次创建时间；`0` 表示未记录。
    required DateTime createdAt,

    /// 本轮模型调用的总耗时；`Duration.zero` 表示未记录。
    required Duration duration,

    /// 本轮模型调用的 token 用量。
    required ChatUsage usage,
  }) = _ChatTurn;

  /// 是否为用户消息。
  bool get isUser => role == ChatRole.user;

  /// 是否包含可发送给模型的有效内容。
  bool get hasPayload =>
      text.trim().isNotEmpty || toolCalls.isNotEmpty || attachments.isNotEmpty;

  /// 是否有失败原因。
  bool get hasError => error.isNotEmpty;

  /// 是否记录了创建时间。
  bool get hasCreatedAt => createdAt.millisecondsSinceEpoch > 0;

  /// 是否记录了耗时。
  bool get hasDuration => duration > Duration.zero;

  /// 是否有非错误提示。
  bool get hasNotice => notice != ChatNotice.none;
}
