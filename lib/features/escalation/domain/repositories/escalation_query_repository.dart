import 'package:Aisupass/features/escalation/domain/enums/root_manager.dart';
import 'package:Aisupass/features/escalation/domain/models/device_identity.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:Aisupass/features/escalation/domain/models/payload_match.dart';

/// 提权链路只读仓储。
abstract class EscalationQueryRepository {
  /// 读取全部载荷条目。
  Future<List<Payload>> listPayloads();

  /// 读取用户上次选定的 root 管理器。
  ///
  /// 从未选过时返回 [RootManager.kernelsu]。
  Future<RootManager> selectedRootManager();

  /// 采集当前设备身份。
  Future<DeviceIdentity> deviceIdentity();

  /// 为当前设备挑选载荷。
  ///
  /// [allowVendorFallback] 为 `false`（默认）时不走同厂商兜底，
  /// 不影响 `exact` / `sameKernel` / `similarDevice`。无任何候选时返回
  /// `null`。
  ///
  /// 默认关闭：兜底载荷机型不同，拿去自动执行必然失败。
  Future<PayloadMatch?> resolve({bool allowVendorFallback = false});
}
