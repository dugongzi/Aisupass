import 'package:Aisupass/features/escalation/domain/models/device_fingerprint.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_capability_matrix.dart';

/// 提权只读查询仓储。
///
/// **零副作用**：实现内不得出现 prepare / execute / startRun 之类动作。
abstract class EscalationQueryRepository {
  /// 读取判定所需的设备指纹。非 Android 平台返回降级值而非抛异常。
  Future<DeviceFingerprint> readFingerprint();

  /// 探测全部链的能力，不做任何写入。
  Future<EscalationCapabilityMatrix> probeCapabilities();
}
