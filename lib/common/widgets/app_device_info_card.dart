import 'package:Aisupass/common/widgets/app_setting_icon.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/providers/device_info_provider.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 设备信息卡片。
///
/// 单列展示提权方案依赖的环境参数，点击任意一行只复制该项内容，
/// 右上角按钮可复制全部；SELinux 用色标表达是否受限。
class AppDeviceInfoCard extends HookConsumerWidget {
  const AppDeviceInfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = context.colorScheme;
    final bool isDark = context.isDark;
    final bool isDesktop = isDesktopPlatform;
    final double radius = isDesktop ? 12 : 20.r;

    final AsyncValue<DeviceSnapshot> snapshot = ref.watch(
      deviceSnapshotProvider,
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: isDark ? 0.30 : 0.14),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDesktop
                  ? (isDark ? 0.18 : 0.03)
                  : (isDark ? 0.22 : 0.04),
            ),
            blurRadius: isDesktop ? 10 : 18,
            offset: Offset(0, isDesktop ? 3 : 6),
          ),
        ],
      ),
      // 透明 Material 提供水波纹层，让整行点击有反馈。
      child: Material(
        type: MaterialType.transparency,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(radius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(context, snapshot.value),
            snapshot.when(
              data: (DeviceSnapshot data) => _buildBody(context, data),
              loading: () => Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Center(
                  child: SizedBox(
                    width: 18.w,
                    height: 18.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              error: (Object error, StackTrace stack) => Padding(
                padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 18.h),
                child: Text(
                  context.l10n.deviceInfoUnavailable,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.72),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, DeviceSnapshot? data) {
    final ColorScheme colorScheme = context.colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 8.w, 4.h),
      child: Row(
        children: <Widget>[
          const AppSettingIcon(icon: Icons.smartphone_rounded),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              context.l10n.deviceInfoTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          if (data != null)
            TextButton.icon(
              onPressed: () => _copyAll(context, data),
              icon: Icon(Icons.copy_all_rounded, size: 14.sp),
              label: Text(context.l10n.deviceInfoCopy),
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textStyle: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, DeviceSnapshot data) {
    final ColorScheme colorScheme = context.colorScheme;
    // 分隔线从标签起始位置开始，与图标对齐留白。
    final double dividerIndent = 14.w + 13.sp + 8.w;

    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Column(
        children: <Widget>[
          for (int i = 0; i < data.items.length; i++) ...<Widget>[
            if (i > 0)
              Divider(
                height: 1,
                indent: dividerIndent,
                endIndent: 14.w,
                color: colorScheme.outline.withValues(alpha: 0.08),
              ),
            _InfoRow(
              item: data.items[i],
              onTap: () => _copyItem(context, data.items[i]),
            ),
          ],
        ],
      ),
    );
  }

  /// 复制单行内容，方便只把某一项参数发给 AI。
  void _copyItem(BuildContext context, DeviceInfoItem item) {
    final String text = '${_labelOf(context, item.field)}: ${item.value}';
    Clipboard.setData(ClipboardData(text: text));
    ToastMessage.success(context.l10n.deviceInfoCopied);
  }

  /// 复制全部内容。
  void _copyAll(BuildContext context, DeviceSnapshot data) {
    final String text = data.items
        .map(
          (DeviceInfoItem item) =>
              '${_labelOf(context, item.field)}: ${item.value}',
        )
        .join('\n');
    Clipboard.setData(ClipboardData(text: text));
    ToastMessage.success(context.l10n.deviceInfoCopied);
  }
}

/// 单行信息：图标 + 标签在左，取值在右。
///
/// 版本号、SOTA 这类取值可能很长，右侧取值超出可用宽度时可横向滚动，
/// 并自动来回滚动展示完整内容，不做省略号截断。
class _InfoRow extends HookWidget {
  const _InfoRow({required this.item, required this.onTap});

  final DeviceInfoItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final bool isSelinux = item.field == DeviceInfoField.selinuxStatus;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
        child: Row(
          children: <Widget>[
            Icon(
              _iconOf(item.field),
              size: 13.sp,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.62),
            ),
            SizedBox(width: 8.w),
            Text(
              _labelOf(context, item.field),
              style: TextStyle(
                fontSize: 13.sp,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.78),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: isSelinux
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: _SelinuxBadge(value: item.value),
                    )
                  : _ScrollableValue(
                      text: item.value,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface.withValues(alpha: 0.90),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 取值文本：放不下时可横向拖动，并自动来回滚动展示完整内容。
///
/// 版本号这类值必须完整可见，所以不使用省略号；
/// 宽度足够时仍保持右对齐，与其它行视觉一致。
class _ScrollableValue extends HookWidget {
  const _ScrollableValue({required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final ScrollController controller = useScrollController();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final TextPainter painter = TextPainter(
          text: TextSpan(text: text, style: style),
          textDirection: TextDirection.ltr,
          maxLines: 1,
        )..layout();
        final bool isOverflow = painter.width > constraints.maxWidth;

        if (!isOverflow) {
          return Align(
            alignment: Alignment.centerRight,
            child: Text(text, maxLines: 1, style: style),
          );
        }

        return _AutoScrollText(
          text: text,
          style: style,
          controller: controller,
        );
      },
    );
  }
}

/// 溢出文本的自动来回滚动。
class _AutoScrollText extends HookWidget {
  const _AutoScrollText({
    required this.text,
    required this.style,
    required this.controller,
  });

  final String text;
  final TextStyle style;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      bool cancelled = false;

      Future<void> loop() async {
        // 等首帧布局完成后再读取滚动范围。
        await Future<void>.delayed(const Duration(milliseconds: 800));
        while (!cancelled && controller.hasClients) {
          final double distance = controller.position.maxScrollExtent;
          if (distance <= 0) break;
          final Duration duration = Duration(
            milliseconds: (distance * 42).round(),
          );
          await controller.animateTo(
            distance,
            duration: duration,
            curve: Curves.linear,
          );
          if (cancelled) break;
          await Future<void>.delayed(const Duration(milliseconds: 1500));
          if (cancelled || !controller.hasClients) break;
          await controller.animateTo(
            0,
            duration: duration,
            curve: Curves.linear,
          );
          if (cancelled) break;
          await Future<void>.delayed(const Duration(milliseconds: 1500));
        }
      }

      loop();
      return () => cancelled = true;
    }, <Object>[controller, text]);

    return SingleChildScrollView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: Text(text, maxLines: 1, softWrap: false, style: style),
    );
  }
}

/// SELinux 状态胶囊：状态是「是否受限」而不是普通参数，用色标表达。
class _SelinuxBadge extends HookWidget {
  const _SelinuxBadge({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final Color statusColor = switch (value) {
      'Enforcing' => const Color(0xFFE0A22E),
      'Permissive' => const Color(0xFF2FA8A0),
      _ => colorScheme.onSurfaceVariant,
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(7.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
          ),
          SizedBox(width: 5.w),
          Text(
            value,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}

String _labelOf(BuildContext context, DeviceInfoField field) =>
    switch (field) {
      DeviceInfoField.osVersion => context.l10n.deviceOsVersion,
      DeviceInfoField.apiLevel => context.l10n.deviceApiLevel,
      DeviceInfoField.deviceModel => context.l10n.deviceModel,
      DeviceInfoField.cpuAbi => context.l10n.deviceCpuAbi,
      DeviceInfoField.kernelVersion => context.l10n.deviceKernelVersion,
      DeviceInfoField.securityPatch => context.l10n.deviceSecurityPatch,
      DeviceInfoField.baseband => context.l10n.deviceBaseband,
      DeviceInfoField.buildNumber => context.l10n.deviceBuildNumber,
      DeviceInfoField.sotaVersion => context.l10n.deviceSotaVersion,
      DeviceInfoField.selinuxStatus => context.l10n.deviceSelinux,
      DeviceInfoField.appVersion => context.l10n.deviceAppVersion,
    };

IconData _iconOf(DeviceInfoField field) => switch (field) {
  DeviceInfoField.osVersion => Icons.android_rounded,
  DeviceInfoField.apiLevel => Icons.layers_rounded,
  DeviceInfoField.deviceModel => Icons.phone_android_rounded,
  DeviceInfoField.cpuAbi => Icons.memory_rounded,
  DeviceInfoField.kernelVersion => Icons.terminal_rounded,
  DeviceInfoField.securityPatch => Icons.security_rounded,
  DeviceInfoField.baseband => Icons.cell_tower_rounded,
  DeviceInfoField.buildNumber => Icons.numbers_rounded,
  DeviceInfoField.sotaVersion => Icons.system_update_alt_rounded,
  DeviceInfoField.selinuxStatus => Icons.shield_outlined,
  DeviceInfoField.appVersion => Icons.tag_rounded,
};
