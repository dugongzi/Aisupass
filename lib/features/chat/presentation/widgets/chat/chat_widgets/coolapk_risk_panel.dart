import 'dart:convert';

import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/routes/app_route.dart';
import 'package:Aisupass/core/themes/app_colors.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/chat/domain/enums/chat_tool_status.dart';
import 'package:Aisupass/features/chat/domain/models/chat_tool_call.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/chat_widgets/chat_user_action_gate.dart';
import 'package:Aisupass/features/coolapk/presentation/providers/coolapk_auth_query_provider.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 酷安人机验证卡片。
///
/// 出现时机：工具因 `err_request_captcha_v2` 被拦下时返回 `awaitsUser=true`，
/// Run loop 随之原地挂起。这里给用户一个直接过验证的入口，通过后
/// 票据落盘、Gate 检测到变化即自动续跑，模型会拿同样的参数重调工具。
///
/// 挂起/续跑复用 [ChatUserActionGate]，与无线调试配对面板同一套机制。
class CoolapkRiskPanel extends HookConsumerWidget {
  const CoolapkRiskPanel({
    super.key,
    required this.turnId,
    required this.isLastTurn,
    required this.captchaId,
  });

  /// 所属轮次，挂起判定按轮次精确匹配。
  final String turnId;

  /// 是否为最新一轮；只有最新一轮在未完成时持续轮询。
  final bool isLastTurn;

  /// 易盾业务 id；为空表示拿不到 id，此时入口不可用。
  final String captchaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int savedAt = ref.watch(coolapkCaptchaSavedAtProvider);
    // 卡片出现时刻。只有保存时间晚于它，才算用户这次真的过了验证。
    // 用时间戳而不是「票据是否为空」：auth 是异步 provider，invalidate 后
    // 会短暂回到 loading，那时读票据只会得到空串，一加载完就误判成已完成。
    final ObjectRef<int> appearedAt = useRef<int>(
      DateTime.now().millisecondsSinceEpoch,
    );
    final bool done = savedAt > appearedAt.value;

    return ChatUserActionGate(
      turnId: turnId,
      done: done,
      pollWhileIncomplete: isLastTurn,
      onPoll: () => ref.invalidate(coolapkAuthProvider),
      child: _CoolapkRiskCard(captchaId: captchaId, done: done),
    );
  }
}

/// 验证卡片的展示部分：只按 [done] 渲染，不含挂起逻辑。
class _CoolapkRiskCard extends StatelessWidget {
  const _CoolapkRiskCard({required this.captchaId, required this.done});

  /// 易盾业务 id，验证入口据此拉起验证页。
  final String captchaId;

  /// 用户是否已经通过本轮验证。
  final bool done;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDesktopPlatform;
    final ColorScheme colors = context.colorScheme;
    final AppLocalizations l10n = context.l10n;
    final bool canVerify = !isDesktop && captchaId.isNotEmpty && !done;

    final IconData icon = done
        ? Icons.verified_user_rounded
        : Icons.verified_user_outlined;
    final String title = done
        ? l10n.chatCoolapkCaptchaPassedTitle
        : l10n.chatCoolapkCaptchaTitle;
    final String hint = done
        ? l10n.chatCoolapkCaptchaPassedHint
        : l10n.chatCoolapkCaptchaHint;

    return Container(
      margin: EdgeInsets.only(
        left: isDesktop ? 8 : 8.w,
        bottom: isDesktop ? 8 : 8.h,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 12 : 12.w,
        vertical: isDesktop ? 10 : 10.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.coolapk.withValues(
          alpha: context.isDark ? 0.14 : 0.07,
        ),
        borderRadius: BorderRadius.circular(isDesktop ? 10 : 10.r),
        border: Border.all(color: AppColors.coolapk.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                icon,
                size: isDesktop ? 15 : 15.sp,
                color: AppColors.coolapk,
              ),
              SizedBox(width: isDesktop ? 6 : 6.w),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isDesktop ? 12 : 12.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isDesktop ? 6 : 6.h),
          Text(
            hint,
            style: TextStyle(
              fontSize: isDesktop ? 11.5 : 11.5.sp,
              height: 1.45,
              color: colors.onSurfaceVariant,
            ),
          ),
          SizedBox(height: isDesktop ? 10 : 10.h),
          SizedBox(
            height: isDesktop ? 36 : 36.h,
            child: FilledButton.icon(
              // 桌面端没有 WebView，拉起验证页也没有意义。
              onPressed: canVerify
                  ? () => context.push(AppRoute.coolapkCaptchaPath(captchaId))
                  : null,
              icon: Icon(
                canVerify ? Icons.shield_outlined : Icons.check_rounded,
                size: isDesktop ? 15 : 15.sp,
              ),
              label: Text(
                done
                    ? l10n.chatCoolapkCaptchaPassedAction
                    : l10n.chatCoolapkCaptchaAction,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isDesktop ? 12.5 : 12.5.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.coolapk,
                foregroundColor: AppColors.onCoolapk,
                disabledBackgroundColor: AppColors.coolapk.withValues(
                  alpha: 0.4,
                ),
                disabledForegroundColor: AppColors.onCoolapk.withValues(
                  alpha: 0.7,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 判断这次工具结果是否需要人机验证，是则返回待渲染的验证卡片。
///
/// 风控被 `_awaitOnRisk` 转成了 `awaitsUser` 结果，因此这里看成功结果里的
/// `riskControl` 标记；旧的「失败 + marker」分支保留，兼容历史轮次。
Widget? coolapkRiskPanelFor({
  required String turnId,
  required bool isLastTurn,
  required ChatToolCall call,
}) {
  final String? captchaId = _captchaIdOf(call);
  if (captchaId == null) return null;
  return CoolapkRiskPanel(
    turnId: turnId,
    isLastTurn: isLastTurn,
    captchaId: captchaId,
  );
}

/// 从工具调用里取出 `captchaId`；不是风控场景返回 null。
String? _captchaIdOf(ChatToolCall call) {
  if (call.status == ChatToolStatus.succeeded) {
    final Map<String, dynamic> result = _decode(call.result);
    if (result['riskControl'] != true) return null;
    return (result['captchaId'] ?? '').toString().trim();
  }
  // 历史轮次里风控曾以失败形式记录，错误串带 `captchaId=xxx`。
  if (call.status == ChatToolStatus.failed) {
    final RegExpMatch? match = _legacyCaptchaPattern.firstMatch(call.error);
    if (match == null) return null;
    return match.group(1) ?? '';
  }
  return null;
}

/// 旧版错误串里的 `captchaId=`，仅用于兼容已有会话记录。
final RegExp _legacyCaptchaPattern = RegExp(r'captchaId=([A-Za-z0-9]+)');

/// 工具结果与参数都是 JSON 文本，非法或为空时按空对象处理。
Map<String, dynamic> _decode(String raw) {
  final String text = raw.trim();
  if (text.isEmpty) return const <String, dynamic>{};
  try {
    final Object? decoded = jsonDecode(text);
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
  } on FormatException {
    return const <String, dynamic>{};
  }
  return const <String, dynamic>{};
}
