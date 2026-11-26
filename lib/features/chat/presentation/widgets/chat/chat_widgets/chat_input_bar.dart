import 'dart:io';

import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/chat/data/datasources/chat_attachment_store.dart';
import 'package:Aisupass/features/chat/domain/models/chat_attachment.dart';
import 'package:Aisupass/features/chat/domain/models/chat_prompt.dart';
import 'package:Aisupass/features/chat/presentation/providers/chat_action_provider.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/chat_widgets/chat_prompt_sheet.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 对话输入栏：多行输入 + 提示词库 + 附件 + 发送/停止。
///
/// 桌面端支持 Enter 发送、Shift + Enter 换行。
class ChatInputBar extends HookConsumerWidget {
  const ChatInputBar({
    super.key,
    required this.streaming,
    required this.onSend,
    required this.onStop,
  });

  final bool streaming;
  final void Function(String text, List<ChatAttachment> attachments) onSend;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme colors = context.colorScheme;
    final bool isDark = context.isDark;
    final bool isDesktop = isDesktopPlatform;
    final TextEditingController controller = useTextEditingController();
    final TextEditingValue value = useValueListenable(controller);
    final ValueNotifier<List<ChatAttachment>> attachments =
        useState<List<ChatAttachment>>(const <ChatAttachment>[]);
    final ValueNotifier<bool> picking = useState<bool>(false);
    final bool canSend =
        value.text.trim().isNotEmpty || attachments.value.isNotEmpty;

    void submit() {
      if (streaming || !canSend) return;
      final String text = controller.text.trim();
      final List<ChatAttachment> files = List<ChatAttachment>.unmodifiable(
        attachments.value,
      );
      controller.clear();
      attachments.value = const <ChatAttachment>[];
      onSend(text, files);
    }

    /// 把提示词插入到光标位置，保留已输入的内容。
    void insertPrompt(ChatPrompt prompt) {
      final String current = controller.text;
      final String next = current.trim().isEmpty
          ? prompt.content
          : '${current.trimRight()}\n${prompt.content}';
      controller.value = TextEditingValue(
        text: next,
        selection: TextSelection.collapsed(offset: next.length),
      );
    }

    Future<ChatAttachmentKind?> pickKind() {
      return showModalBottomSheet<ChatAttachmentKind>(
        context: context,
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        builder: (BuildContext sheetContext) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.image_outlined),
                title: Text(sheetContext.l10n.chatAttachImage),
                onTap: () =>
                    Navigator.of(sheetContext).pop(ChatAttachmentKind.image),
              ),
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: Text(sheetContext.l10n.chatAttachText),
                onTap: () =>
                    Navigator.of(sheetContext).pop(ChatAttachmentKind.text),
              ),
              ListTile(
                leading: const Icon(Icons.inventory_2_outlined),
                title: Text(sheetContext.l10n.chatAttachBinary),
                onTap: () =>
                    Navigator.of(sheetContext).pop(ChatAttachmentKind.binary),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      );
    }

    Future<void> handleAttach() async {
      if (streaming || picking.value) return;
      final ChatAttachmentKind? kind = await pickKind();
      if (kind == null || !context.mounted) return;

      picking.value = true;
      try {
        final FilePickerResult? picked = await FilePicker.pickFiles(
          type: switch (kind) {
            ChatAttachmentKind.image => FileType.image,
            ChatAttachmentKind.text => FileType.custom,
            ChatAttachmentKind.binary => FileType.custom,
          },
          allowedExtensions: switch (kind) {
            ChatAttachmentKind.image => null,
            ChatAttachmentKind.text => chatTextExtensions.toList(
              growable: false,
            ),
            ChatAttachmentKind.binary => chatBinaryExtensions.toList(
              growable: false,
            ),
          },
          allowMultiple: true,
          withData: false,
        );
        if (picked == null || !context.mounted) return;

        final ChatAttachmentStore store = ref.read(chatAttachmentStoreProvider);
        final List<ChatAttachment> added = <ChatAttachment>[];
        for (final PlatformFile file in picked.files) {
          if (!context.mounted) return;
          if (kind == ChatAttachmentKind.text &&
              !hasChatTextExtension(file.name)) {
            ToastMessage.error(l10n.chatAttachUnsupported);
            continue;
          }
          if (kind == ChatAttachmentKind.binary &&
              !hasChatBinaryExtension(file.name)) {
            ToastMessage.error(l10n.chatAttachUnsupported);
            continue;
          }
          // 只传路径的附件不读内容，体积不受上下文限制。
          if (kind != ChatAttachmentKind.binary) {
            final int limit = kind == ChatAttachmentKind.image
                ? maxChatImageBytes
                : maxChatTextBytes;
            if (file.size <= 0 || file.size > limit) {
              ToastMessage.error(l10n.chatAttachTooLarge(file.name));
              continue;
            }
          }
          final ChatAttachment? item = await store.save(file, kind);
          if (item == null) {
            ToastMessage.error(
              kind == ChatAttachmentKind.binary
                  ? l10n.chatAttachNoPath(file.name)
                  : l10n.chatAttachFailed,
            );
            continue;
          }
          added.add(item);
        }
        if (added.isEmpty || !context.mounted) return;

        final int remain = maxChatAttachments - attachments.value.length;
        if (remain <= 0) {
          ToastMessage.show(l10n.chatAttachLimit(maxChatAttachments));
          return;
        }
        if (added.length > remain) {
          ToastMessage.show(l10n.chatAttachLimit(maxChatAttachments));
        }
        attachments.value = <ChatAttachment>[
          ...attachments.value,
          ...added.take(remain),
        ];
      } catch (_) {
        if (context.mounted) ToastMessage.error(l10n.chatAttachFailed);
      } finally {
        if (context.mounted) picking.value = false;
      }
    }

    final double radius = isDesktop ? 22 : 22.r;

    Widget field = TextField(
      controller: controller,
      minLines: 1,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      style: TextStyle(
        fontSize: isDesktop ? 14 : 14.sp,
        height: 1.45,
        color: colors.onSurface,
      ),
      decoration: InputDecoration(
        hintText: l10n.chatInputHint,
        hintStyle: TextStyle(
          fontSize: isDesktop ? 13.5 : 13.5.sp,
          color: colors.onSurfaceVariant.withValues(alpha: 0.8),
        ),
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(
          isDesktop ? 14 : 14.w,
          isDesktop ? 12 : 12.h,
          isDesktop ? 14 : 14.w,
          0,
        ),
      ),
    );

    if (isDesktop) {
      field = Shortcuts(
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.enter): _SendIntent(),
          SingleActivator(LogicalKeyboardKey.numpadEnter): _SendIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            _SendIntent: CallbackAction<_SendIntent>(
              onInvoke: (_) {
                submit();
                return null;
              },
            ),
          },
          child: field,
        ),
      );
    }

    /// 输入框与右下角的按钮同处一个圆角容器，视觉上是一整块输入区。
    final Widget composer = Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(
          alpha: isDark ? 0.35 : 0.5,
        ),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: colors.outline.withValues(alpha: isDark ? 0.26 : 0.14),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          field,
          Padding(
            padding: EdgeInsets.fromLTRB(
              isDesktop ? 6 : 6.w,
              0,
              isDesktop ? 6 : 6.w,
              isDesktop ? 6 : 6.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _BarIconButton(
                  icon: Icons.tips_and_updates_outlined,
                  tooltip: l10n.chatPromptTitle,
                  onTap: streaming
                      ? null
                      : () =>
                            showChatPromptSheet(context, onPick: insertPrompt),
                ),
                SizedBox(width: isDesktop ? 2 : 2.w),
                _BarIconButton(
                  icon: Icons.attach_file_rounded,
                  tooltip: l10n.chatAttachTitle,
                  loading: picking.value,
                  onTap: streaming ? null : handleAttach,
                ),
                SizedBox(width: isDesktop ? 6 : 6.w),
                _SendButton(
                  streaming: streaming,
                  enabled: canSend,
                  onSend: submit,
                  onStop: onStop,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (attachments.value.isNotEmpty) ...<Widget>[
          SizedBox(
            height: isDesktop ? 68 : 64.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 4 : 4.w),
              itemCount: attachments.value.length,
              separatorBuilder: (BuildContext _, int _) =>
                  SizedBox(width: isDesktop ? 8 : 8.w),
              itemBuilder: (BuildContext context, int index) {
                final ChatAttachment attachment = attachments.value[index];
                return _AttachmentPreview(
                  attachment: attachment,
                  onRemove: () => attachments.value = <ChatAttachment>[
                    for (final ChatAttachment item in attachments.value)
                      if (item.id != attachment.id) item,
                  ],
                );
              },
            ),
          ),
          SizedBox(height: isDesktop ? 8 : 8.h),
        ],
        composer,
      ],
    );

    return Container(
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 24 : 12.w,
        isDesktop ? 10 : 10.h,
        isDesktop ? 24 : 12.w,
        isDesktop ? 14 : 10.h,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(
            color: colors.outline.withValues(alpha: isDark ? 0.22 : 0.12),
          ),
        ),
      ),
      child: isDesktop
          ? Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: content,
              ),
            )
          : content,
    );
  }
}

class _SendIntent extends Intent {
  const _SendIntent();
}

/// 输入框右下角的图标按钮。
class _BarIconButton extends HookWidget {
  const _BarIconButton({
    required this.icon,
    required this.tooltip,
    this.onTap,
    this.loading = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;
    final bool disabled = onTap == null;

    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: isDesktop ? 32 : 32.w,
        height: isDesktop ? 32 : 32.h,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(isDesktop ? 10 : 10.r),
          child: Center(
            child: loading
                ? SizedBox(
                    width: 14.w,
                    height: 14.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.primary,
                    ),
                  )
                : Icon(
                    icon,
                    size: isDesktop ? 18 : 18.sp,
                    color: disabled
                        ? colors.onSurfaceVariant.withValues(alpha: 0.45)
                        : colors.onSurfaceVariant,
                  ),
          ),
        ),
      ),
    );
  }
}

/// 输入框上方的附件预览，右上角带移除按钮。
class _AttachmentPreview extends HookWidget {
  const _AttachmentPreview({required this.attachment, required this.onRemove});

  final ChatAttachment attachment;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;
    final double height = isDesktop ? 56 : 52.h;

    final Widget body = attachment.isImage
        ? Image.file(
            File(attachment.path),
            width: height,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object error, StackTrace? _) =>
                Container(
                  width: height,
                  height: height,
                  alignment: Alignment.center,
                  color: colors.surfaceContainerHighest,
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 18.sp,
                    color: colors.onSurfaceVariant,
                  ),
                ),
          )
        : Container(
            width: isDesktop ? 150 : 130.w,
            height: height,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            alignment: Alignment.centerLeft,
            color: colors.surfaceContainerHighest.withValues(alpha: 0.6),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.description_outlined,
                  size: 15.sp,
                  color: colors.onSurfaceVariant,
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    attachment.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      height: 1.3,
                      color: colors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          );

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(isDesktop ? 10 : 10.r),
          child: body,
        ),
        Positioned(
          top: 3,
          right: 3,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: colors.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Icon(
                Icons.close_rounded,
                size: 12,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.streaming,
    required this.enabled,
    required this.onSend,
    required this.onStop,
  });

  final bool streaming;
  final bool enabled;
  final VoidCallback onSend;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;
    final bool active = streaming || enabled;

    return Tooltip(
      message: streaming ? context.l10n.chatStop : context.l10n.chatSend,
      child: SizedBox(
        width: isDesktop ? 34 : 34.w,
        height: isDesktop ? 34 : 34.h,
        child: Material(
          color: active
              ? colors.primary
              : colors.onSurface.withValues(alpha: 0.08),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: streaming ? onStop : (enabled ? onSend : null),
            child: Icon(
              streaming ? Icons.stop_rounded : Icons.arrow_upward_rounded,
              size: isDesktop ? 18 : 18.sp,
              color: active
                  ? colors.onPrimary
                  : colors.onSurfaceVariant.withValues(alpha: 0.55),
            ),
          ),
        ),
      ),
    );
  }
}
