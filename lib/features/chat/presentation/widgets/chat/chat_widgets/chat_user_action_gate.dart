import 'dart:async';

import 'package:Aisupass/features/chat/presentation/providers/chat_action_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 「等用户操作」组件的统一外壳。
///
/// 交互组件只回答 [done]（用户做完了没有）和 [onPoll]（怎么重查判定依据），
/// 挂起期间轮询、切回前台重查、完成后自动续跑、同一轮只续跑一次，
/// 全部在这里收口。新增需要挂起的组件不必再抄一遍这套逻辑。
class ChatUserActionGate extends HookConsumerWidget {
  const ChatUserActionGate({
    super.key,
    required this.turnId,
    required this.done,
    required this.onPoll,
    required this.child,
    this.pollWhileIncomplete = false,
    this.pollInterval = const Duration(seconds: 2),
  });

  /// 本组件服务的轮次 id；只有这一轮挂起时才接管续跑。
  final String turnId;

  /// 用户是否已完成操作，由交互组件按自己的状态判定。
  final bool done;

  /// 重查 [done] 依赖的状态。挂起期间定时调用，切回前台也调用。
  final VoidCallback onPoll;

  /// 未完成时是否也要轮询。
  ///
  /// 只有最新一轮的面板应为 true：历史轮次的面板不必反复查原生状态，
  /// 否则一屏多个面板会同时打到 Pigeon 通道上。
  final bool pollWhileIncomplete;

  /// 挂起期间的重查间隔。
  final Duration pollInterval;

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String awaitingTurnId = ref.watch(
      chatControllerProvider.select((ChatState state) => state.awaitingTurnId),
    );
    // 按轮次精确匹配：历史轮次里的同名组件不应被当前挂起拉起来。
    final bool awaiting = awaitingTurnId.isNotEmpty && awaitingTurnId == turnId;

    // 回调每次 build 都是新闭包，用 ref 存最新的，避免 effect 反复重建。
    final ObjectRef<VoidCallback> latestPoll = useRef<VoidCallback>(onPoll);
    latestPoll.value = onPoll;

    // 自己查：配对码在通知栏输入时用户不会离开应用，没有 onResume 可等。
    final bool shouldPoll = !done && (awaiting || pollWhileIncomplete);
    useEffect(() {
      if (!shouldPoll) return null;
      final Timer timer = Timer.periodic(
        pollInterval,
        (_) => latestPoll.value(),
      );
      return timer.cancel;
    }, <Object?>[shouldPoll, pollInterval]);

    // 用户可能跳到系统页面操作：切回前台也要重查一次。
    useEffect(() {
      final AppLifecycleListener listener = AppLifecycleListener(
        onResume: () => latestPoll.value(),
      );
      return listener.dispose;
    }, const <Object?>[]);

    // 同一轮只放行一次：模型已在内存上下文里继续，不会重发请求。
    final ObjectRef<String?> resumed = useRef<String?>(null);
    useEffect(() {
      if (!awaiting || !done || resumed.value == turnId) return null;
      resumed.value = turnId;
      // useEffect 在 build 阶段被调度，这里必须推到帧末再改 provider，
      // 否则会撞上 Riverpod 的「build 期间修改 provider」断言。
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        ref.read(chatControllerProvider.notifier).resumeAfterUserAction();
      });
      return null;
    }, <Object?>[awaiting, done, turnId]);

    return child;
  }
}
