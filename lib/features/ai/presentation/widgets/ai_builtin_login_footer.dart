import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/ai/domain/enums/ai_builtin_login_stage.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 内置登录页的底部操作区。
///
/// 按阶段切换按钮组合：等待登录时只给取消，读取中给出进度文案，
/// 失败时给「在网页创建」与「重试」，完成后给密钥掩码、复制与完成。
class AiBuiltinLoginFooter extends StatelessWidget {
  const AiBuiltinLoginFooter({
    super.key,
    required this.stage,
    required this.busy,
    required this.issuedKey,
    required this.canContinue,
    required this.onCancel,
    required this.onContinue,
    required this.onReload,
    required this.onManualCreate,
    required this.onCopyKey,
    required this.onFinish,
  });

  /// 当前阶段。
  final AiBuiltinLoginStage stage;

  /// 是否正在处理，处理中禁用按钮。
  final bool busy;

  /// 已生成的密钥，仅在完成阶段非空。
  final String issuedKey;

  /// 是否已持有登录令牌，可以继续而未必要重新登录。
  final bool canContinue;

  /// 关闭页面。
  final VoidCallback onCancel;

  /// 用已持有的令牌重跑一次流程。
  final VoidCallback onContinue;

  /// 重新加载登录页。
  final VoidCallback onReload;

  /// 打开网页里的密钥页，由用户自己创建。
  final VoidCallback onManualCreate;

  /// 复制已生成的密钥。
  final VoidCallback onCopyKey;

  /// 关闭页面并把密钥带回上一页。
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
        child: switch (stage) {
          AiBuiltinLoginStage.done => _DoneActions(
            issuedKey: issuedKey,
            onCopyKey: onCopyKey,
            onFinish: onFinish,
          ),
          AiBuiltinLoginStage.failed => Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: busy ? null : onManualCreate,
                  child: Text(l10n.aiBuiltinCreateInWeb),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: FilledButton(
                  onPressed: busy ? null : onReload,
                  child: Text(l10n.aiBuiltinRetry),
                ),
              ),
            ],
          ),
          AiBuiltinLoginStage.loadingGroups ||
          AiBuiltinLoginStage.creating => SizedBox(
            height: 42.h,
            child: Center(
              child: Text(
                stage == AiBuiltinLoginStage.creating
                    ? l10n.aiBuiltinCreating
                    : l10n.aiBuiltinLoginDetected,
                style: TextStyle(
                  fontSize: 12.5.sp,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          AiBuiltinLoginStage.waitingLogin => canContinue
              ? Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onCancel,
                        child: Text(l10n.aiBuiltinCancel),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: FilledButton(
                        onPressed: onContinue,
                        child: Text(l10n.aiBuiltinContinue),
                      ),
                    ),
                  ],
                )
              : SizedBox(
                  width: double.infinity,
                  height: 42.h,
                  child: OutlinedButton(
                    onPressed: onCancel,
                    child: Text(l10n.aiBuiltinCancel),
                  ),
                ),
        },
      ),
    );
  }
}

/// 完成阶段的操作区：密钥掩码 + 复制 + 完成。
class _DoneActions extends StatelessWidget {
  const _DoneActions({
    required this.issuedKey,
    required this.onCopyKey,
    required this.onFinish,
  });

  final String issuedKey;
  final VoidCallback onCopyKey;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: SelectableText(
            maskAiBuiltinKey(issuedKey),
            style: TextStyle(
              fontSize: 12.sp,
              fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
              color: scheme.onSurface,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: <Widget>[
            Expanded(
              child: OutlinedButton(
                onPressed: onCopyKey,
                child: Text(l10n.aiBuiltinCopyKey),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: FilledButton(
                onPressed: onFinish,
                child: Text(l10n.aiBuiltinFinish),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 密钥掩码：只露首尾，避免整串留在屏幕上。
String maskAiBuiltinKey(String key) {
  if (key.length <= 12) return key;
  return '${key.substring(0, 6)}••••${key.substring(key.length - 4)}';
}
