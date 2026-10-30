import 'package:Aisupass/common/widgets/app_settings_section.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 连接段：宿主状态 + **唯一**动作。
///
/// 这一段只回答一个问题：「和特权宿主的连接现在是什么状态，下一步只该点哪里」。
/// 动作由页面算好后传进来，组件本身不做任何判定，因此三种状态
/// （配对 / 重试点火 / 断开）永远只会出现一个按钮，
/// 不会出现「一个按钮背五种动作」那种点了才知道自己点了什么的情况。
class EscalationConnectionPanel extends StatelessWidget {
  const EscalationConnectionPanel({
    super.key,
    required this.connected,
    required this.statusText,
    required this.actionLabel,
    required this.actionIcon,
    this.onAction,
    this.detail,
    this.hint,
  });

  /// 宿主是否已就绪；只影响状态行的配色与图标。
  final bool connected;

  /// 状态行文案。
  final String statusText;

  /// 唯一动作按钮上的文案。
  final String actionLabel;

  /// 唯一动作按钮的图标。
  final IconData actionIcon;

  /// 点按钮要做的事；为 `null` 时按钮禁用（进行中或平台不支持）。
  final VoidCallback? onAction;

  /// 动作失败时的原始原因；有值时给出可复制的全文。
  final String? detail;

  /// 按钮下方的说明（配对须知 / 断开后果）。
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;
    final String? failureDetail = detail;

    return AppSettingsSection(
      title: l10n.escalationSectionConnection,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 14 : 14.w,
            vertical: isDesktop ? 12 : 12.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    connected
                        ? Icons.link_rounded
                        : Icons.link_off_rounded,
                    size: isDesktop ? 16 : 16.sp,
                    color: connected
                        ? colors.primary
                        : colors.onSurfaceVariant,
                  ),
                  SizedBox(width: isDesktop ? 8 : 8.w),
                  Expanded(
                    child: SelectableText(
                      statusText,
                      style: TextStyle(
                        fontSize: isDesktop ? 12.5 : 12.5.sp,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                        color: connected
                            ? colors.primary
                            : colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  if (failureDetail != null)
                    IconButton(
                      onPressed: () => _copy(context, failureDetail),
                      icon: Icon(
                        Icons.copy_rounded,
                        size: isDesktop ? 16 : 16.sp,
                      ),
                      color: colors.onSurfaceVariant,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: l10n.escalationCopy,
                    ),
                ],
              ),
              SizedBox(height: isDesktop ? 10 : 10.h),
              SizedBox(
                height: isDesktop ? 40 : 40.h,
                child: OutlinedButton.icon(
                  onPressed: onAction,
                  icon: Icon(actionIcon, size: isDesktop ? 16 : 16.sp),
                  label: Text(
                    actionLabel,
                    style: TextStyle(
                      fontSize: isDesktop ? 13 : 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: connected ? colors.error : colors.primary,
                    side: BorderSide(
                      color: (connected ? colors.error : colors.primary)
                          .withValues(alpha: 0.45),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isDesktop ? 10 : 12.r),
                    ),
                  ),
                ),
              ),
              if (hint != null) ...<Widget>[
                SizedBox(height: isDesktop ? 6 : 6.h),
                Text(
                  hint!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isDesktop ? 11 : 11.sp,
                    height: 1.3,
                    color: colors.onSurfaceVariant.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// 复制原始失败原因：这行常带原生 stderr，用户要能直接贴出来。
  void _copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(content: Text(context.l10n.escalationCopied)),
    );
  }
}
