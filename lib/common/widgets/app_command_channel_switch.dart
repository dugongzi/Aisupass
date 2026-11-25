import 'package:Aisupass/common/widgets/app_setting_icon.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/models/command_channel.dart';
import 'package:Aisupass/core/providers/command_channel_provider.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 命令通道设置项：选择 AI 工具执行命令时走哪条链路。
///
/// 两条通道的能力不同（Stellar 不提供 pty 终端），所以选择权交给用户，
/// 不按机型或安装情况做硬判断。
///
/// 窄屏时段段按钮会挤占标题与说明的宽度，因此宽度不足时把控件换到
/// 标题下方一行，但仍贴右对齐，保持与其它行右侧控件的视觉对齐。
class AppCommandChannelSwitch extends HookConsumerWidget {
  const AppCommandChannelSwitch({super.key});

  /// 行内可用宽度低于该值时把控件换到标题下方。
  static const double _stackedBreakpoint = 400;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 两条通道都只存在于 Android，其他平台整行不渲染。
    if (!isAndroidPlatform) return const SizedBox.shrink();

    final AppLocalizations l10n = context.l10n;
    final ColorScheme colors = context.colorScheme;
    final CommandChannel channel = ref.watch(commandChannelControllerProvider);

    void select(String value) {
      ref
          .read(commandChannelControllerProvider.notifier)
          .setChannel(CommandChannel.fromName(value));
    }

    final Widget info = Row(
      children: <Widget>[
        const AppSettingIcon(icon: Icons.alt_route_rounded),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                l10n.settingsCommandChannelTitle,
                style: context.textTheme.titleSmall?.copyWith(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                l10n.settingsCommandChannelDesc,
                style: TextStyle(
                  fontSize: 11.sp,
                  height: 1.3,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    final Widget control = SegmentedButton<String>(
      segments: <ButtonSegment<String>>[
        ButtonSegment<String>(
          value: CommandChannel.adb.name,
          label: Text(l10n.commandChannelAdb),
        ),
        ButtonSegment<String>(
          value: CommandChannel.stellar.name,
          label: Text(l10n.commandChannelStellar),
        ),
      ],
      selected: <String>{channel.name},
      showSelectedIcon: false,
      style: SegmentedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        textStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
      ),
      onSelectionChanged: (Set<String> selection) => select(selection.first),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < _stackedBreakpoint) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                info,
                SizedBox(height: 10.h),
                // 空间不足时控件另起一行，但仍靠右对齐。
                Align(alignment: Alignment.centerRight, child: control),
              ],
            );
          }
          return Row(
            children: <Widget>[
              Expanded(child: info),
              SizedBox(width: 8.w),
              control,
            ],
          );
        },
      ),
    );
  }
}
