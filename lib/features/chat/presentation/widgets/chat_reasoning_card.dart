import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 思考过程卡片。
///
/// 默认在流式思考时展开，思考结束后保留展开状态，
/// 折叠后只留一行标题与耗时，避免占用对话正文空间。
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
    final bool isDark = context.isDark;
    final bool isDesktop = isDesktopPlatform;
    final double radius = isDesktop ? 10 : 10.r;

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
        : context.l10n.chatThought;
    final String text = active ? '$reasoning▌' : reasoning;

    return Container(
      margin: EdgeInsets.only(bottom: isDesktop ? 10 : 10.h),
      decoration: BoxDecoration(
        color: colors.onSurface.withValues(alpha: isDark ? 0.04 : 0.03),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: isDark ? 0.35 : 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: () => expanded.value = !expanded.value,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                isDesktop ? 10 : 10.w,
                isDesktop ? 7 : 6.h,
                isDesktop ? 6 : 6.w,
                isDesktop ? 7 : 6.h,
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.psychology_alt_outlined,
                    size: isDesktop ? 15 : 15.sp,
                    color: colors.onSurfaceVariant,
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
                  if (!active && elapsed.value != null)
                    Padding(
                      padding: EdgeInsets.only(right: isDesktop ? 4 : 4.w),
                      child: Text(
                        _formatDuration(elapsed.value!),
                        style: TextStyle(
                          fontSize: isDesktop ? 10.5 : 10.5.sp,
                          fontFamily: 'monospace',
                          color: colors.onSurfaceVariant.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  Icon(
                    expanded.value
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    size: isDesktop ? 16 : 16.sp,
                    color: colors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          if (expanded.value)
            Padding(
              padding: EdgeInsets.fromLTRB(
                isDesktop ? 10 : 10.w,
                0,
                isDesktop ? 10 : 10.w,
                isDesktop ? 10 : 10.h,
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

String _formatDuration(Duration duration) {
  final int ms = duration.inMilliseconds;
  if (ms < 1000) return '${ms}ms';
  final double seconds = ms / 1000;
  return '${seconds.toStringAsFixed(seconds >= 10 ? 0 : 1)}s';
}
