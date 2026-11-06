import 'package:Aisupass/features/escalation/domain/enums/root_manager.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_run_result.dart';
import 'package:Aisupass/features/escalation/domain/models/handoff_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';

/// 提权链路执行仓储。
///
/// 只负责「把给定的载荷跑起来并判定结果」与「把拿到的 root 移交给管理器」，
/// 选哪份载荷由查询仓储决定，两者的装配在 Provider 层完成。
abstract class EscalationActionRepository {
  /// 执行指定载荷。载荷本身或运行环境不可用时返回失败结果，不抛异常。
  Future<EscalationRunResult> runPayload(Payload payload);

  /// 把临时 root 移交给设备上已安装的 [manager]。
  ///
  /// 从该管理器的安装包里 `find` 出 `libksud.so`，再以 root 身份执行
  /// `late-load --allow-shell --package-name <包名>`；两步合并在同一次
  /// `su` 会话里完成，定位结果不跨调用传递。
  ///
  /// 返回 [HandoffOutcome] 而不是 [EscalationRunResult]：移交给的是四种
  /// 形态（成功 / 管理器没装 / 没有 root / 命令失败），每种对应完全不同的
  /// 用户动作，压成一个「失败 + 一段 stderr」就丢掉了这些出路。
  /// 管理器没装、没有 root 都返回结果而不是抛异常——它们是要给用户看的
  /// 信息，不是代码缺陷。
  Future<HandoffOutcome> handoffRoot({required RootManager manager});
}
