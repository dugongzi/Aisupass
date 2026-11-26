import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/ai/domain/enums/ai_builtin_login_stage.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 内置登录页顶部的说明条。
///
/// 按阶段切换主副文案：等登录时说明注册门槛，抓到令牌后说明正在读取分组，
/// 失败时显示原始原因并给出重试入口。
class AiBuiltinStatusBar extends HookWidget {
  const AiBuiltinStatusBar({
    super.key,
    required this.stage,
    required this.failure,
    required this.onRetry,
  });

  /// 当前阶段。
  final AiBuiltinLoginStage stage;

  /// 失败原因原文，非失败阶段传空串。
  final String failure;

  /// 失败后的重试动作。
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;

    final bool failed = stage == AiBuiltinLoginStage.failed;
    final String title = switch (stage) {
      AiBuiltinLoginStage.waitingLogin => l10n.aiBuiltinLoginGuideTitle,
      AiBuiltinLoginStage.loadingGroups => l10n.aiBuiltinLoginDetected,
      AiBuiltinLoginStage.creating => l10n.aiBuiltinCreating,
      AiBuiltinLoginStage.done => l10n.aiBuiltinLoginDoneTitle,
      AiBuiltinLoginStage.failed => l10n.aiBuiltinLoginFailedTitle,
    };
    final String body = switch (stage) {
      AiBuiltinLoginStage.waitingLogin => l10n.aiBuiltinLoginGuideBody,
      AiBuiltinLoginStage.loadingGroups => '',
      AiBuiltinLoginStage.creating => '',
      AiBuiltinLoginStage.done => '',
      AiBuiltinLoginStage.failed => failure,
    };

    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: failed
              ? scheme.errorContainer.withValues(alpha: 0.45)
              : scheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: failed
                ? scheme.error.withValues(alpha: 0.28)
                : scheme.primary.withValues(alpha: 0.18),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              failed
                  ? Icons.error_outline_rounded
                  : stage == AiBuiltinLoginStage.waitingLogin
                  ? Icons.info_outline_rounded
                  : Icons.sync_rounded,
              size: 16.sp,
              color: failed ? scheme.error : scheme.primary,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w600,
                      color: failed
                          ? scheme.onErrorContainer
                          : scheme.onSurface,
                    ),
                  ),
                  if (body.trim().isNotEmpty) ...<Widget>[
                    SizedBox(height: 3.h),
                    Text(
                      body,
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        height: 1.4,
                        color: failed
                            ? scheme.onErrorContainer
                            : scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (failed) ...<Widget>[
              SizedBox(width: 8.w),
              TextButton(
                onPressed: onRetry,
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size.zero,
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                ),
                child: Text(
                  l10n.aiBuiltinRetry,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
