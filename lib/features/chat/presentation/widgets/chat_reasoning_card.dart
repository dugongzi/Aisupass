import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 思考过程。
///
/// 与工具步骤同款单行样式：图标 + 摘要 + 展开箭头，
/// 不填充、不描边，避免抢占对话正文的视觉重心。
class ChatReasoningCard extends HookWidget {
  const ChatReasoningCard({
    super.key,
    required this.reasoning,
    this.active = false,
  });

  final String reasoning;

  /// 模型仍处于思考阶段（尚未输出正文）。
  final bool active;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;
    final Color muted = colors.onSurfaceVariant.withValues(alpha: 0.6);

    final ValueNotifier<bool> expanded = useState(active);
    final ObjectRef<Stopwatch?> stopwatch = useRef<Stopwatch?>(null);
    final ValueNotifier<Duration?> elapsed = useState<Duration?>(null);

    // 本地计时：首次进入思考阶段开始，结束思考时冻结。
    useEffect(() {
      if (active) {
        stopwatch.value ??= Stopwatch()..start();
        return null;
      }
      final Stopwatch? watch = stopwatch.value;
      if (watch != null && watch.isRunning) {
        watch.stop();
        elapsed.value = watch.elapsed;
      }
      return null;
    }, <Object?>[active]);

    final String title = active
        ? context.l10n.chatThinking
        : (elapsed.value == null
              ? context.l10n.chatThought
              : context.l10n.chatThoughtFor(
                  _formatSeconds(elapsed.value!),
                ));
    final String text = active ? '$reasoning▌' : reasoning;

    return Padding(
      padding: EdgeInsets.only(bottom: isDesktop ? 2 : 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InkWell(
            onTap: () => expanded.value = !expanded.value,
            borderRadius: BorderRadius.circular(isDesktop ? 6 : 6.r),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: isDesktop ? 5 : 5.h,
                horizontal: isDesktop ? 2 : 2.w,
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: isDesktop ? 16 : 16.w,
                    height: isDesktop ? 16 : 16.w,
                    child: Center(
                      child: active
                          ? SizedBox(
                              width: isDesktop ? 12 : 12.w,
                              height: isDesktop ? 12 : 12.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.6,
                                color: colors.onSurfaceVariant,
                              ),
                            )
                          : Icon(
                              Icons.psychology_alt_outlined,
                              size: isDesktop ? 15 : 15.sp,
                              color: colors.onSurfaceVariant,
                            ),
                    ),
                  ),
                  SizedBox(width: isDesktop ? 8 : 8.w),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isDesktop ? 12.5 : 12.5.sp,
                        height: 1.3,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  SizedBox(width: isDesktop ? 4 : 4.w),
                  SizedBox(
                    width: isDesktop ? 15 : 15.w,
                    height: isDesktop ? 15 : 15.w,
                    child: Icon(
                      expanded.value
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      size: isDesktop ? 15 : 15.sp,
                      color: muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (expanded.value)
            Container(
              margin: EdgeInsets.only(
                left: isDesktop ? 8 : 8.w,
                bottom: isDesktop ? 4 : 4.h,
              ),
              padding: EdgeInsets.only(
                left: isDesktop ? 10 : 10.w,
                top: isDesktop ? 2 : 2.h,
                bottom: isDesktop ? 2 : 2.h,
              ),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: colors.outlineVariant.withValues(alpha: 0.6),
                  ),
                ),
              ),
              child: SelectableText(
                text,
                style: TextStyle(
                  fontSize: isDesktop ? 12.5 : 12.5.sp,
                  height: 1.55,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 只保留秒数部分，交给 l10n 拼接单位。
String _formatSeconds(Duration duration) {
  final int ms = duration.inMilliseconds;
  if (ms < 1000) return (ms / 1000).toStringAsFixed(1);
  final double seconds = ms / 1000;
  return seconds.toStringAsFixed(seconds >= 10 ? 0 : 1);
}
