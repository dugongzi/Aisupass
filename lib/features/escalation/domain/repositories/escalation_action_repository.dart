import 'package:Aisupass/features/escalation/domain/models/escalation_request.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_run_record.dart';

/// 提权动作仓储，全工程唯一允许产生副作用的入口。
abstract class EscalationActionRepository {
  /// 启动一次运行。
  ///
  /// 按阶段增量推送记录，最后一帧为结束态；成功判定由实现内部的 verify 逻辑完成，
  /// 不依赖任何退出码。
  Stream<EscalationRunRecord> run(EscalationRequest request);

  /// 发起一次无线调试配对，按阶段增量推送记录。
  ///
  /// 配对码由用户在通知栏输入，地址与端口由原生 mDNS 自动发现，
  /// 因此本方法不接收任何参数。配对本身不是提权链，产出的记录不落盘。
  Stream<EscalationRunRecord> pair();

  /// 取消指定运行；已结束时为幂等空操作。
  Future<void> cancel(String runId);
}
