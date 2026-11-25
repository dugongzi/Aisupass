import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/presentation/providers/chat_action_provider.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/chat_widgets/chat_tool_description.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 能力分组，顺序即手册中的展示顺序。
enum ChatManualGroup {
  device,
  adb,
  stellar,
  web,
  escalation,
  ghostKey,
  ghostLock,
  ghostLockProfile,
  dirtyFrag,
  kernel,
  ota,
  runLog,
}

/// GhostLock 提权动作只占这 4 个工具，其余 `ghost_lock_*` 都归配置档分组。
const Set<String> _ghostLockActionTools = <String>{
  'ghost_lock_preflight',
  'ghost_lock_start',
  'ghost_lock_status',
  'ghost_lock_cancel',
};

/// 按工具名归类；未匹配到任何分组时归入设备分组，保证手册不丢工具。
ChatManualGroup resolveChatManualGroup(String name) {
  if (name.startsWith('escalation_')) return ChatManualGroup.escalation;
  if (name.startsWith('ghost_key_')) return ChatManualGroup.ghostKey;
  if (_ghostLockActionTools.contains(name)) {
    return ChatManualGroup.ghostLock;
  }
  if (name.startsWith('ghost_lock_')) {
    return ChatManualGroup.ghostLockProfile;
  }
  if (name.startsWith('dirty_frag_')) return ChatManualGroup.dirtyFrag;
  if (name.startsWith('kernel_profile_')) return ChatManualGroup.kernel;
  if (name.startsWith('ota_')) return ChatManualGroup.ota;
  if (name.startsWith('run_log_')) return ChatManualGroup.runLog;
  if (name.startsWith('adb_')) return ChatManualGroup.adb;
  if (name.startsWith('stellar_')) return ChatManualGroup.stellar;
  if (name == 'open_in_browser' ||
      name == 'web_search' ||
      name == 'fetch_web_page') {
    return ChatManualGroup.web;
  }
  return ChatManualGroup.device;
}

/// 打开 AI 能力手册。
Future<void> showChatManualSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext _) => const _ChatManualSheet(),
  );
}

class _ChatManualSheet extends HookConsumerWidget {
  const _ChatManualSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;
    final List<ChatToolDefinition> tools = ref.watch(chatToolsProvider);

    // 先按分组归集，再按枚举顺序输出，保证分组顺序稳定。
    final Map<ChatManualGroup, List<ChatToolDefinition>> grouped =
        <ChatManualGroup, List<ChatToolDefinition>>{};
    for (final ChatToolDefinition tool in tools) {
      grouped
          .putIfAbsent(resolveChatManualGroup(tool.name), () => [])
          .add(tool);
    }
    final List<ChatManualGroup> groups = <ChatManualGroup>[
      for (final ChatManualGroup group in ChatManualGroup.values)
        if (grouped[group]?.isNotEmpty ?? false) group,
    ];

    final double radius = isDesktop ? 16 : 22.r;

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isDesktop ? 620 : double.infinity,
          maxHeight: MediaQuery.sizeOf(context).height * 0.86,
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
                padding: EdgeInsets.fromLTRB(20.w, 10.h, 8.w, 0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.menu_book_rounded,
                      size: 20.sp,
                      color: scheme.primary,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        l10n.chatManualTitle,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
                  children: <Widget>[
                    Text(
                      l10n.chatManualSubtitle,
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        height: 1.45,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    for (final ChatManualGroup group in groups) ...<Widget>[
                      _GroupCard(
                        group: group,
                        tools: grouped[group]!,
                      ),
                      SizedBox(height: 10.h),
                    ],
                    SizedBox(height: 2.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.verified_user_outlined,
                          size: 13.sp,
                          color: scheme.onSurfaceVariant,
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            l10n.chatManualConfirmHint,
                            style: TextStyle(
                              fontSize: 11.sp,
                              height: 1.45,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 单个能力分组：标题、说明与工具清单，默认收起。
class _GroupCard extends HookWidget {
  const _GroupCard({required this.group, required this.tools});

  final ChatManualGroup group;
  final List<ChatToolDefinition> tools;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final ValueNotifier<bool> expanded = useState<bool>(false);
    final (String title, String description, IconData icon) = _describe(
      l10n,
      group,
    );

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(
          alpha: context.isDark ? 0.24 : 0.36,
        ),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: () => expanded.value = !expanded.value,
            borderRadius: BorderRadius.circular(14.r),
            child: Padding(
              padding: EdgeInsets.fromLTRB(12.w, 10.h, 8.w, 10.h),
              child: Row(
                children: <Widget>[
                  Icon(icon, size: 17.sp, color: scheme.primary),
                  SizedBox(width: 9.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: scheme.onSurface,
                                ),
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: scheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Text(
                                '${tools.length}',
                                style: TextStyle(
                                  fontSize: 9.5.sp,
                                  fontWeight: FontWeight.w700,
                                  color: scheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            height: 1.4,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: expanded.value ? 0.5 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      Icons.expand_more_rounded,
                      size: 18.sp,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (expanded.value) ...<Widget>[
            Divider(
              height: 1,
              thickness: 1,
              color: scheme.outline.withValues(alpha: 0.12),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  for (final ChatToolDefinition tool in tools)
                    _ToolRow(tool: tool),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 分组的中文名、说明与图标。
  (String, String, IconData) _describe(
    AppLocalizations l10n,
    ChatManualGroup group,
  ) {
    return switch (group) {
      ChatManualGroup.device => (
        l10n.chatManualGroupDevice,
        l10n.chatManualGroupDeviceDesc,
        Icons.phone_android_rounded,
      ),
      ChatManualGroup.adb => (
        l10n.chatManualGroupAdb,
        l10n.chatManualGroupAdbDesc,
        Icons.terminal_rounded,
      ),
      ChatManualGroup.stellar => (
        l10n.chatManualGroupStellar,
        l10n.chatManualGroupStellarDesc,
        Icons.verified_user_outlined,
      ),
      ChatManualGroup.web => (
        l10n.chatManualGroupWeb,
        l10n.chatManualGroupWebDesc,
        Icons.public_rounded,
      ),
      ChatManualGroup.escalation => (
        l10n.chatManualGroupEscalation,
        l10n.chatManualGroupEscalationDesc,
        Icons.key_rounded,
      ),
      ChatManualGroup.ghostKey => (
        l10n.chatManualGroupGhostKey,
        l10n.chatManualGroupGhostKeyDesc,
        Icons.vpn_key_rounded,
      ),
      ChatManualGroup.ghostLock => (
        l10n.chatManualGroupGhostLock,
        l10n.chatManualGroupGhostLockDesc,
        Icons.lock_open_rounded,
      ),
      ChatManualGroup.ghostLockProfile => (
        l10n.chatManualGroupGhostLockProfile,
        l10n.chatManualGroupGhostLockProfileDesc,
        Icons.tune_rounded,
      ),
      ChatManualGroup.dirtyFrag => (
        l10n.chatManualGroupDirtyFrag,
        l10n.chatManualGroupDirtyFragDesc,
        Icons.bug_report_rounded,
      ),
      ChatManualGroup.kernel => (
        l10n.chatManualGroupKernel,
        l10n.chatManualGroupKernelDesc,
        Icons.memory_rounded,
      ),
      ChatManualGroup.ota => (
        l10n.chatManualGroupOta,
        l10n.chatManualGroupOtaDesc,
        Icons.system_update_rounded,
      ),
      ChatManualGroup.runLog => (
        l10n.chatManualGroupRunLog,
        l10n.chatManualGroupRunLogDesc,
        Icons.receipt_long_rounded,
      ),
    };
  }
}

/// 单个工具：默认两行摘要，点击展开完整说明。
class _ToolRow extends HookWidget {
  const _ToolRow({required this.tool});

  final ChatToolDefinition tool;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;
    final ValueNotifier<bool> expanded = useState<bool>(false);
    final String localized = localizedChatToolDescription(l10n, tool.name);
    final String description = localized.isEmpty
        ? tool.description
        : localized;

    return InkWell(
      onTap: () => expanded.value = !expanded.value,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 2.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Icon(
                expanded.value
                    ? Icons.expand_more_rounded
                    : Icons.chevron_right_rounded,
                size: 13.sp,
                color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    tool.name,
                    style: TextStyle(
                      fontSize: isDesktop ? 11.5 : 11.5.sp,
                      height: 1.3,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    description,
                    maxLines: expanded.value ? null : 2,
                    overflow: expanded.value
                        ? TextOverflow.clip
                        : TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      height: 1.4,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
