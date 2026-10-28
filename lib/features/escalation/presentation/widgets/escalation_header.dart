import 'dart:io';

import 'package:Aisupass/common/widgets/app_data_table.dart';
import 'package:Aisupass/common/widgets/app_settings_section.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/escalation/domain/models/device_fingerprint.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 页头设备快照：设备指纹 6 行 + 宿主/平台状态提示。
///
/// 指纹来自只读探测，非 Android 或读取失败时用 `--` 占位，
/// 不让「拿不到信息」阻断页面渲染。
class EscalationHeader extends StatelessWidget {
  const EscalationHeader({
    super.key,
    required this.fingerprint,
    required this.hostAlive,
  });

  /// 当前设备的指纹快照。
  final DeviceFingerprint fingerprint;

  /// 提权宿主是否存活；M0 固定为 `false`。
  final bool hostAlive;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final bool isDesktop = isDesktopPlatform;

    final List<AppDataRow> rows = <AppDataRow>[
      AppDataRow(
        label: l10n.escalationDeviceSdk,
        value: fingerprint.androidSdk <= 0 ? '--' : '${fingerprint.androidSdk}',
      ),
      AppDataRow(label: l10n.escalationDeviceAbi, value: _orDash(fingerprint.abi)),
      AppDataRow(
        label: l10n.escalationDeviceKernel,
        value: _orDash(fingerprint.kernelVersion),
      ),
      AppDataRow(
        label: l10n.escalationDeviceSelinux,
        // 直接展示内核接口的原始取值，避免在 UI 里硬编码英文状态词。
        value: fingerprint.androidSdk <= 0
            ? '--'
            : (fingerprint.selinuxEnforcing ? '1' : '0'),
      ),
      AppDataRow(
        label: l10n.escalationDeviceManufacturer,
        value: _orDash(fingerprint.manufacturer),
      ),
      AppDataRow(
        label: l10n.escalationDeviceModel,
        value: _orDash(fingerprint.model),
      ),
    ];

    final String? warning = _resolveWarning(l10n);

    return AppSettingsSection(
      title: l10n.escalationSectionDevice,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 14 : 14.w,
            vertical: isDesktop ? 10 : 10.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (warning != null) ...<Widget>[
                _WarningLine(message: warning),
                SizedBox(height: isDesktop ? 8 : 8.h),
              ],
              AppDataTable(rows: rows),
            ],
          ),
        ),
      ],
    );
  }

  /// 平台与宿主状态只保留最需要用户知道的一条，避免页头堆叠多条提示。
  String? _resolveWarning(AppLocalizations l10n) {
    if (!Platform.isAndroid) return l10n.escalationPlatformUnsupported;
    if (!fingerprint.meetsMinSdk) return l10n.escalationReasonAndroidTooOld;
    if (!hostAlive) return l10n.escalationHostDisconnected;
    return null;
  }

  String _orDash(String value) => value.trim().isEmpty ? '--' : value;
}

/// 页头提示行：图标 + 中性警示文案。
class _WarningLine extends StatelessWidget {
  const _WarningLine({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          Icons.info_outline_rounded,
          size: isDesktop ? 15 : 15.sp,
          color: colors.tertiary,
        ),
        SizedBox(width: isDesktop ? 6 : 6.w),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              fontSize: isDesktop ? 11.5 : 11.5.sp,
              height: 1.35,
              color: colors.onSurfaceVariant.withValues(alpha: 0.85),
            ),
          ),
        ),
      ],
    );
  }
}
