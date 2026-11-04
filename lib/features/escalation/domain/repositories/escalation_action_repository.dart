import 'package:Aisupass/features/escalation/domain/models/escalation_run_result.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';

/// 提权链路执行仓储。
abstract class EscalationActionRepository {
  /// 自动匹配一份载荷并执行。匹配不到时返回失败结果，不抛异常。
  Future<EscalationRunResult> runResolvedPayload();

  /// 执行指定载荷。
  Future<EscalationRunResult> runPayload(Payload payload);

  /// 按候选顺序探测可用的 `su`，返回绝对路径；全部不可用时返回空串。
  Future<String> probeSu();
}
