import 'dart:async';

import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/ai/domain/models/ai_chat_probe_event.dart';
import 'package:Aisupass/features/ai/domain/models/ai_config.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_model_query_provider.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 打开配置测试窗口。
///
/// 会真实发送一条消息给服务端，并以流式方式展示返回内容。
Future<void> showAiTestSheet(BuildContext context, AiConfig config) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext _) => _AiTestSheet(config: config),
  );
}

class _AiTestSheet extends HookConsumerWidget {
  const _AiTestSheet({required this.config});

  final AiConfig config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final bool isDesktop = isDesktopPlatform;

    final TextEditingController messageController = useTextEditingController(
      text: l10n.aiTestMessageDefault,
    );
    final ValueNotifier<bool> streaming = useState<bool>(false);
    final ValueNotifier<String> answer = useState<String>('');
    final ValueNotifier<String?> errorMessage = useState<String?>(null);
    final ValueNotifier<String> rawBody = useState<String>('');
    final ValueNotifier<int?> statusCode = useState<int?>(null);
    final ValueNotifier<Duration?> elapsed = useState<Duration?>(null);
    final ValueNotifier<int> chunks = useState<int>(0);
    final ValueNotifier<Duration?> firstDelta = useState<Duration?>(null);
    final ValueNotifier<bool> streamed = useState<bool>(true);

    final ObjectRef<StreamSubscription<AiChatProbeEvent>?> subscription =
        useRef<StreamSubscription<AiChatProbeEvent>?>(null);
    final ScrollController scrollController = useScrollController();

    // 关闭弹层时中断请求，避免后台继续收流。
    useEffect(() {
      return () {
        subscription.value?.cancel();
      };
    }, const <Object?>[]);

    // 流式输出时自动跟随到底部，避免新内容落在可视区外看起来像没动。
    useEffect(() {
      if (!streaming.value) return null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!scrollController.hasClients) return;
        final ScrollPosition position = scrollController.position;
        if (position.maxScrollExtent - position.pixels > 120) return;
        position.jumpTo(position.maxScrollExtent);
      });
      return null;
    }, <Object?>[answer.value, streaming.value]);

    void resetResult() {
      answer.value = '';
      errorMessage.value = null;
      rawBody.value = '';
      statusCode.value = null;
      elapsed.value = null;
      chunks.value = 0;
      firstDelta.value = null;
      streamed.value = true;
    }

    Future<void> send() async {
      final String message = messageController.text.trim();
      if (message.isEmpty) return;
      FocusScope.of(context).unfocus();

      await subscription.value?.cancel();
      resetResult();
      streaming.value = true;
      final Stopwatch watch = Stopwatch()..start();

      subscription.value = ref
          .read(aiModelQueryRepositoryProvider)
          .streamTestMessage(config, message)
          .listen(
            (AiChatProbeEvent event) {
              if (!context.mounted) return;
              switch (event) {
                case AiChatProbeStarted():
                  statusCode.value = event.statusCode;
                case AiChatProbeDelta():
                  if (chunks.value == 0) firstDelta.value = watch.elapsed;
                  chunks.value += 1;
                  answer.value += event.text;
                case AiChatProbeFinished():
                  statusCode.value = event.statusCode;
                  elapsed.value = event.duration;
                  streamed.value = event.streamed;
                  streaming.value = false;
                case AiChatProbeFailed():
                  statusCode.value = event.statusCode;
                  elapsed.value = event.duration;
                  errorMessage.value = event.message;
                  rawBody.value = event.rawBody;
                  streaming.value = false;
              }
            },
            onError: (Object error) {
              if (!context.mounted) return;
              errorMessage.value = error.toString();
              streaming.value = false;
            },
            onDone: () {
              if (!context.mounted) return;
              streaming.value = false;
            },
          );
    }

    Future<void> copyResult() async {
      final String text = errorMessage.value != null
          ? <String>[
              errorMessage.value!,
              if (rawBody.value.isNotEmpty) rawBody.value,
            ].join('\n\n')
          : answer.value;
      if (text.trim().isEmpty) return;
      await Clipboard.setData(ClipboardData(text: text));
      if (!context.mounted) return;
      ToastMessage.success(l10n.aiTestCopied);
    }

    final bool hasResult =
        streaming.value ||
        answer.value.isNotEmpty ||
        errorMessage.value != null ||
        statusCode.value != null;
    final double radius = isDesktop ? 16 : 22.r;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isDesktop ? 560 : double.infinity,
            maxHeight: MediaQuery.sizeOf(context).height * 0.86,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
              border: Border.all(
                color: scheme.outline.withValues(
                  alpha: context.isDark ? 0.28 : 0.14,
                ),
              ),
            ),
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
                  padding: EdgeInsets.fromLTRB(20.w, 6.h, 8.w, 0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          l10n.aiTestTitle,
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
                    controller: scrollController,
                    shrinkWrap: true,
                    padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 20.h),
                    children: <Widget>[
                      Text(
                        l10n.aiTestHint,
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          height: 1.4,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        l10n.aiTestMessageLabel,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      TextField(
                        controller: messageController,
                        minLines: 2,
                        maxLines: 4,
                        enabled: !streaming.value,
                        style: TextStyle(fontSize: 13.5.sp, height: 1.4),
                        decoration: InputDecoration(
                          hintText: l10n.aiTestMessageDefault,
                          filled: true,
                          fillColor: scheme.surfaceContainerHighest.withValues(
                            alpha: 0.4,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: streaming.value ? null : send,
                          style: FilledButton.styleFrom(
                            minimumSize: Size.fromHeight(
                              isDesktop ? 42 : 44.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          icon: streaming.value
                              ? SizedBox(
                                  width: 16.w,
                                  height: 16.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: scheme.onPrimary,
                                  ),
                                )
                              : Icon(Icons.send_rounded, size: 18.sp),
                          label: Text(l10n.aiTestSend),
                        ),
                      ),
                      if (hasResult) ...<Widget>[
                        SizedBox(height: 16.h),
                        _ProbeResultCard(
                          answer: answer.value,
                          error: errorMessage.value,
                          rawBody: rawBody.value,
                          statusCode: statusCode.value,
                          duration: elapsed.value,
                          chunks: chunks.value,
                          firstDelta: firstDelta.value,
                          streamed: streamed.value,
                          streaming: streaming.value,
                          onCopy: copyResult,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 测试结果：状态、耗时、流式文本，失败时展示错误与原始返回。
class _ProbeResultCard extends StatelessWidget {
  const _ProbeResultCard({
    required this.answer,
    required this.error,
    required this.rawBody,
    required this.statusCode,
    required this.duration,
    required this.chunks,
    required this.firstDelta,
    required this.streamed,
    required this.streaming,
    required this.onCopy,
  });

  final String answer;
  final String? error;
  final String rawBody;
  final int? statusCode;
  final Duration? duration;

  /// 收到多少个增量分片，用于判断服务端是否真的在流式返回。
  final int chunks;

  /// 首段内容到达耗时。
  final Duration? firstDelta;

  /// 服务端是否按 SSE 增量返回。
  final bool streamed;
  final bool streaming;
  final VoidCallback onCopy;

  /// 由当前结果推导状态：进行中优先，其次失败，最后按状态码判断成功。
  _ProbeState _resolveState() {
    if (streaming) return _ProbeState.streaming;
    final int? code = statusCode;
    if (error != null || (code != null && (code < 200 || code >= 300))) {
      return _ProbeState.failed;
    }
    if (code == null) return _ProbeState.unknown;
    return _ProbeState.success;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final bool failed = error != null;
    final _ProbeState state = _resolveState();
    final (String stateLabel, Color accent, IconData stateIcon) =
        switch (state) {
          _ProbeState.streaming => (
            l10n.aiTestStateStreaming,
            scheme.primary,
            Icons.autorenew_rounded,
          ),
          _ProbeState.success => (
            l10n.aiTestStateSuccess,
            const Color(0xFF2E7D32),
            Icons.check_circle_rounded,
          ),
          _ProbeState.failed => (
            l10n.aiTestStateFailed,
            scheme.error,
            Icons.error_rounded,
          ),
          _ProbeState.unknown => (
            l10n.aiTestStateUnknown,
            scheme.onSurfaceVariant,
            Icons.help_outline_rounded,
          ),
        };
    final String tagText = statusCode == null
        ? stateLabel
        : '$stateLabel · ${statusCode!}';

    final List<String> meta = <String>[
      if (duration != null)
        '${l10n.aiTestDuration} ${duration!.inMilliseconds} ms',
      if (firstDelta != null)
        '${l10n.aiTestFirstToken} ${firstDelta!.inMilliseconds} ms',
      if (chunks > 0) '$chunks ${l10n.aiTestChunks}',
      if (!failed && !streamed) l10n.aiTestNotStreamed,
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      stateIcon,
                      size: 12.sp,
                      color: accent,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      tagText,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: accent,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onCopy,
                tooltip: l10n.aiTestCopy,
                icon: Icon(Icons.copy_rounded, size: 16.sp),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          if (meta.isNotEmpty) ...<Widget>[
            SizedBox(height: 6.h),
            Text(
              meta.join(' · '),
              style: TextStyle(
                fontSize: 11.sp,
                height: 1.4,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
          if (streaming) ...<Widget>[
            SizedBox(height: 10.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(2.r),
              child: LinearProgressIndicator(
                minHeight: 2,
                backgroundColor: scheme.outline.withValues(alpha: 0.12),
              ),
            ),
          ],
          if (answer.isNotEmpty) ...<Widget>[
            SizedBox(height: 10.h),
            _Label(text: l10n.aiTestReply),
            SizedBox(height: 4.h),
            SelectableText(
              answer,
              style: TextStyle(fontSize: 13.sp, height: 1.5),
            ),
          ],
          if (failed) ...<Widget>[
            SizedBox(height: 10.h),
            _Label(text: l10n.aiTestError),
            SizedBox(height: 4.h),
            Text(
              error!,
              style: TextStyle(
                fontSize: 12.5.sp,
                height: 1.45,
                color: scheme.error,
              ),
            ),
            if (rawBody.isNotEmpty) ...<Widget>[
              SizedBox(height: 10.h),
              _Label(text: l10n.aiTestRaw),
              SizedBox(height: 4.h),
              SelectableText(
                rawBody,
                style: TextStyle(
                  fontSize: 10.5.sp,
                  height: 1.45,
                  fontFamily: 'monospace',
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

/// 测试结果卡片上展示的状态。
enum _ProbeState {
  /// 请求已发出，正在接收返回。
  streaming,

  /// 服务端返回 2xx 且解析出了回复。
  success,

  /// 网络异常、非 2xx 或解析失败。
  failed,

  /// 没有拿到状态码。
  unknown,
}

class _Label extends StatelessWidget {
  const _Label({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        color: context.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
