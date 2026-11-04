import 'package:Aisupass/features/escalation/domain/models/device_identity.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:Aisupass/features/escalation/domain/models/payload_match.dart';

/// 提权链路只读仓储。
abstract class EscalationQueryRepository {
  /// 读取全部载荷条目。
  Future<List<Payload>> listPayloads();

  /// 采集当前设备身份。
  Future<DeviceIdentity> deviceIdentity();

  /// 为当前设备挑选载荷。
  ///
  /// [allowVendorFallback] 为 `false` 时**只**禁用同厂商兜底，
  /// 不影响 `sameKernel` 与 `similarDevice`。无任何候选时返回 `null`。
  Future<PayloadMatch?> resolve({bool allowVendorFallback = true});

  /// 取载荷在设备上的绝对路径。原生库目录不可用时返回空串。
  Future<String> payloadPath(Payload payload);
}
