import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/chat/domain/models/chat_session.dart';
import 'package:Aisupass/features/chat/presentation/providers/chat_provider.dart';
import 'package:Aisupass/features/chat/presentation/providers/chat_sessions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 会话列表：标题 + 最近更新时间，支持切换、重命名与删除。
///
/// 移动端放在抽屉里，桌面端放在左侧常驻侧栏，两处共用同一份实现。
class ChatSessionList extends HookConsumerWidget {
  const ChatSessionList({super.key, this.onSelected});

  /// 选中会话后的回调，移动端用来关闭抽屉。
  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDesktop = isDesktopPlatform;
    final ColorScheme colors = context.colorScheme;
    final ChatSessionsState sessions = ref.watch(chatSessionsProvider);
    // 只关心「哪些会话在接收流」，避免正文刷新时连带重建整个列表。
    final Set<String> running = ref.watch(
      chatJobsProvider.select((ChatJobsState jobs) => jobs.running),
    );
    final ChatController controller = ref.read(chatControllerProvider.notifier);

    Future<void> handleCreate() async {
      await controller.startNewSession();
      onSelected?.call();
    }

    Future<void> handleSelect(ChatSession session) async {
      await controller.selectSession(session.id);
      onSelected?.call();
    }

    Future<void> handleRename(ChatSession session) async {
      final TextEditingController editing = TextEditingController(
        text: session.title,
      );
      final String? value = await showDialog<String>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text(dialogContext.l10n.chatRename),
            content: TextField(
              controller: editing,
              autofocus: true,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: dialogContext.l10n.chatRenameHint,
              ),
              onSubmitted: (String text) =>
                  Navigator.of(dialogContext).pop(text),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(dialogContext.l10n.aiCancel),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(dialogContext).pop(editing.text),
                child: Text(dialogContext.l10n.aiSave),
              ),
            ],
          );
        },
      );
      editing.dispose();
      if (value == null) return;
      await controller.renameSession(session.id, value);
    }

    Future<void> handleDelete(ChatSession session) async {
      final String title = session.title.trim().isEmpty
          ? context.l10n.chatUntitled
          : session.title.trim();
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text(dialogContext.l10n.chatDeleteSession),
            content: Text(dialogContext.l10n.chatDeleteConfirm(title)),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(dialogContext.l10n.aiCancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(
                  dialogContext.l10n.aiDelete,
                  style: TextStyle(color: dialogContext.colorScheme.error),
                ),
              ),
            ],
          );
        },
      );
      if (confirmed != true) return;
      await controller.deleteSession(session.id);
    }

    Future<void> handleMenu(ChatSession session, Offset position) async {
      final RenderBox overlay =
          Overlay.of(context).context.findRenderObject()! as RenderBox;
      final String? action = await showMenu<String>(
        context: context,
        position: RelativeRect.fromRect(
          position & const Size(40, 40),
          Offset.zero & overlay.size,
        ),
        items: <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'rename',
            child: Text(context.l10n.chatRename),
          ),
          PopupMenuItem<String>(
            value: 'delete',
            child: Text(context.l10n.chatDeleteSession),
          ),
        ],
      );
      if (action == 'rename') {
        await handleRename(session);
      } else if (action == 'delete') {
        await handleDelete(session);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(
            isDesktop ? 16 : 16.w,
            isDesktop ? 6 : 6.h,
            isDesktop ? 8 : 8.w,
            isDesktop ? 6 : 6.h,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  context.l10n.chatSessions,
                  style: TextStyle(
                    fontSize: isDesktop ? 12 : 12.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
              IconButton(
                onPressed: handleCreate,
                visualDensity: VisualDensity.compact,
                iconSize: isDesktop ? 18 : 18.sp,
                color: colors.onSurfaceVariant,
                tooltip: context.l10n.chatNewSession,
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
        ),
        Expanded(
          child: sessions.sessions.isEmpty
              ? Center(
                  child: Text(
                    sessions.loaded
                        ? context.l10n.chatSessionEmpty
                        : '',
                    style: TextStyle(
                      fontSize: isDesktop ? 12.5 : 12.5.sp,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    isDesktop ? 8 : 8.w,
                    0,
                    isDesktop ? 8 : 8.w,
                    isDesktop ? 8 : 8.h,
                  ),
                  itemCount: sessions.sessions.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ChatSession session = sessions.sessions[index];
                    return _SessionTile(
                      session: session,
                      selected: session.id == sessions.currentId,
                      running: running.contains(session.id),
                      onTap: () => handleSelect(session),
                      onLongPress: (Offset position) =>
                          handleMenu(session, position),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({
    required this.session,
    required this.selected,
    required this.running,
    required this.onTap,
    required this.onLongPress,
  });

  final ChatSession session;
  final bool selected;

  /// 该会话是否正在接收流（含切走后仍在后台执行的情况）。
  final bool running;
  final VoidCallback onTap;
  final ValueChanged<Offset> onLongPress;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;
    final bool isDark = context.isDark;
    final String title = session.title.trim().isEmpty
        ? context.l10n.chatUntitled
        : session.title.trim();

    return Padding(
      padding: EdgeInsets.only(bottom: isDesktop ? 2 : 2.h),
      child: Material(
        color: selected
            ? colors.primary.withValues(alpha: isDark ? 0.16 : 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(isDesktop ? 10 : 10.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(isDesktop ? 10 : 10.r),
          onTap: onTap,
          onLongPress: () {
            final RenderBox box = context.findRenderObject()! as RenderBox;
            onLongPress(box.localToGlobal(Offset.zero));
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 10 : 10.w,
              vertical: isDesktop ? 8 : 8.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isDesktop ? 10 : 10.r),
              border: Border.all(
                color: selected
                    ? colors.primary.withValues(alpha: 0.28)
                    : Colors.transparent,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isDesktop ? 13 : 13.sp,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: selected ? colors.primary : colors.onSurface,
                  ),
                ),
                SizedBox(height: isDesktop ? 2 : 2.h),
                Row(
                  children: <Widget>[
                    if (running) ...<Widget>[
                      _StreamingDot(
                        color: colors.primary,
                        size: isDesktop ? 6 : 6.r,
                      ),
                      SizedBox(width: isDesktop ? 5 : 5.w),
                      Flexible(
                        child: Text(
                          context.l10n.chatGenerating,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isDesktop ? 10.5 : 10.5.sp,
                            fontWeight: FontWeight.w500,
                            color: colors.primary,
                          ),
                        ),
                      ),
                    ] else
                      Flexible(
                        child: Text(
                          formatSessionTime(context, session.updatedAt),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isDesktop ? 10.5 : 10.5.sp,
                            color: colors.onSurfaceVariant.withValues(
                              alpha: 0.8,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 会话正在接收流时的呼吸圆点。
class _StreamingDot extends HookWidget {
  const _StreamingDot({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final AnimationController controller = useAnimationController(
      duration: const Duration(milliseconds: 800),
    );

    useEffect(() {
      controller.repeat(reverse: true);
      return null;
    }, <Object?>[controller]);

    final CurvedAnimation curve = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    return FadeTransition(
      opacity: Tween<double>(begin: 0.28, end: 1).animate(curve),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.7, end: 1).animate(curve),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

/// 会话时间的相对描述：1 分钟内「刚刚」，7 天内按分/时/天，再久显示日期。
String formatSessionTime(BuildContext context, DateTime time) {
  final Duration diff = DateTime.now().difference(time);
  if (diff.inMinutes < 1) return context.l10n.chatJustNow;
  if (diff.inHours < 1) return context.l10n.chatMinutesAgo(diff.inMinutes);
  if (diff.inDays < 1) return context.l10n.chatHoursAgo(diff.inHours);
  if (diff.inDays < 7) return context.l10n.chatDaysAgo(diff.inDays);
  final String month = time.month.toString().padLeft(2, '0');
  final String day = time.day.toString().padLeft(2, '0');
  return '$month/$day';
}
