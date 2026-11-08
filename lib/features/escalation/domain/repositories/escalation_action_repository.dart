import 'package:Aisupass/features/escalation/domain/models/handoff_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';

/// 提权链路执行仓储。
///
/// 只负责「把给定的载荷变成要执行的命令行」与「把拿到的 root 移交给管理器」，
/// 选哪份载荷由查询仓储决定，两者的装配在 Provider 层完成。
abstract class EscalationActionRepository {
  /// 拼出执行指定载荷的那一行命令。
  ///
  /// 跑不起来的原因（so 没打进包、参数补不齐）也编在命令里，由终端打印，
  /// 不抛异常。
  Future<String> runPayload(Payload payload);

  /// 终端上来一段载荷输出就喂一次，供实现从中提取并缓存 KASLR 偏移。
  void observeOutput(String text);

  /// 把临时 root 移交给设备上已安装的 [manager]。
  ///
  /// 从该管理器的安装包里 `find` 出 `libksud.so`，再以 root 身份执行
  /// `late-load --allow-shell --package-name <包名>`；两步合并在同一次
  /// `su` 会话里完成，定位结果不跨调用传递。
  ///
  /// 返回 [HandoffOutcome] 而不是抛异常：移交给的是四种形态（成功 / 管理器
  /// 没装 / 没有 root / 命令失败），每种对应完全不同的用户动作，压成一个
  /// 「失败 + 一段 stderr」就丢掉了这些出路。管理器没装、没有 root 都是要给
  /// 用户看的信息，不是代码缺陷。
  Future<HandoffOutcome> handoffRoot({required RootManager manager});

  /// 记住用户选定的 root 管理器，供下次启动与本页移交复用。
  Future<void> selectRootManager({required RootManager manager});
}

