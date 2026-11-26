import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/chat/domain/models/chat_prompt.dart';
import 'package:Aisupass/features/chat/presentation/providers/chat_prompt_provider.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 打开常用提示词弹层；选中后由调用方插入输入框。
Future<void> showChatPromptSheet(
  BuildContext context, {
  required ValueChanged<ChatPrompt> onPick,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext _) => _ChatPromptSheet(onPick: onPick),
  );
}

class _ChatPromptSheet extends HookConsumerWidget {
  const _ChatPromptSheet({required this.onPick});

  final ValueChanged<ChatPrompt> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;
    final ChatPromptsState state = ref.watch(chatPromptsProvider);
    final ChatPrompts actions = ref.read(chatPromptsProvider.notifier);

    Future<void> openEditor({ChatPrompt? prompt}) async {
      final _PromptDraft? draft = await showDialog<_PromptDraft>(
        context: context,
        builder: (BuildContext _) => _PromptEditorDialog(prompt: prompt),
      );
      if (draft == null) return;
      await actions.save(
        id: prompt?.id,
        title: draft.title,
        content: draft.content,
      );
      if (!context.mounted) return;
      ToastMessage.success(l10n.chatPromptSaved);
    }

    Future<void> confirmDelete(ChatPrompt prompt) async {
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
          title: Text(dialogContext.l10n.chatPromptDelete),
          content: Text(
            dialogContext.l10n.chatPromptDeleteConfirm(prompt.displayTitle),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(dialogContext.l10n.aiCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: dialogContext.colorScheme.error,
                foregroundColor: dialogContext.colorScheme.onError,
              ),
              child: Text(dialogContext.l10n.aiDelete),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
      await actions.remove(prompt.id);
      if (!context.mounted) return;
      ToastMessage.success(l10n.chatPromptDeleted);
    }

    void insert(ChatPrompt prompt) {
      Navigator.of(context).pop();
      onPick(prompt);
    }

    final double radius = isDesktop ? 16 : 22.r;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isDesktop ? 560 : double.infinity,
            maxHeight: MediaQuery.sizeOf(context).height * 0.8,
          ),
          child: Material(
            color: scheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 8.h),
                Container(
                  width: 36.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: scheme.onSurfaceVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 8.w, 4.h),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          l10n.chatPromptTitle,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => openEditor(),
                        tooltip: l10n.chatPromptAdd,
                        icon: Icon(Icons.add_rounded, size: 21.sp),
                        visualDensity: VisualDensity.compact,
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close_rounded, size: 20.sp),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: state.prompts.isEmpty
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 40.h),
                          child: Text(
                            state.loaded
                                ? l10n.chatPromptEmpty
                                : l10n.chatPromptLoading,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.5.sp,
                              height: 1.5,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.fromLTRB(10.w, 2.h, 10.w, 20.h),
                          itemCount: state.prompts.length,
                          itemBuilder: (BuildContext context, int index) {
                            final ChatPrompt prompt = state.prompts[index];
                            return _PromptTile(
                              prompt: prompt,
                              onInsert: () => insert(prompt),
                              onEdit: () => openEditor(prompt: prompt),
                              onDelete: () => confirmDelete(prompt),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 单条提示词：点击插入，右侧菜单处理编辑与删除。
class _PromptTile extends HookWidget {
  const _PromptTile({
    required this.prompt,
    required this.onInsert,
    required this.onEdit,
    required this.onDelete,
  });

  final ChatPrompt prompt;
  final VoidCallback onInsert;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onInsert,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.w, 9.h, 2.w, 9.h),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      prompt.displayTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isDesktop ? 13.5 : 13.5.sp,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      prompt.content.replaceAll(RegExp(r'\s+'), ' '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isDesktop ? 11.5 : 11.5.sp,
                        height: 1.4,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onInsert,
                tooltip: l10n.chatPromptInsert,
                icon: Icon(
                  Icons.keyboard_return_rounded,
                  size: 18.sp,
                  color: scheme.primary,
                ),
                visualDensity: VisualDensity.compact,
              ),
              PopupMenuButton<String>(
                tooltip: '',
                icon: Icon(
                  Icons.more_vert_rounded,
                  size: 18.sp,
                  color: scheme.onSurfaceVariant,
                ),
                onSelected: (String value) =>
                    value == 'edit' ? onEdit() : onDelete(),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Text(context.l10n.chatPromptEdit),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Text(context.l10n.chatPromptDelete),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 编辑器返回值。
class _PromptDraft {
  const _PromptDraft({required this.title, required this.content});

  final String title;
  final String content;
}

class _PromptEditorDialog extends HookWidget {
  const _PromptEditorDialog({this.prompt});

  final ChatPrompt? prompt;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final TextEditingController titleController = useTextEditingController(
      text: prompt?.title ?? '',
    );
    final TextEditingController contentController = useTextEditingController(
      text: prompt?.content ?? '',
    );
    final ValueNotifier<String?> error = useState<String?>(null);

    void submit() {
      final String content = contentController.text.trim();
      if (content.isEmpty) {
        error.value = l10n.chatPromptContentRequired;
        return;
      }
      Navigator.of(context)
          .pop(_PromptDraft(title: titleController.text, content: content));
    }

    return AlertDialog(
      scrollable: true,
      title: Text(prompt == null ? l10n.chatPromptAdd : l10n.chatPromptEdit),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: titleController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.chatPromptName,
                hintText: l10n.chatPromptNameHint,
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: contentController,
              minLines: 3,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: l10n.chatPromptContent,
                hintText: l10n.chatPromptContentHint,
                errorText: error.value,
              ),
              onChanged: (String _) {
                if (error.value != null) error.value = null;
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.aiCancel),
        ),
        FilledButton(onPressed: submit, child: Text(l10n.aiSave)),
      ],
    );
  }
}
