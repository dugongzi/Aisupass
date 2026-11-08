import 'package:Aisupass/features/escalation/domain/models/device_identity.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:Aisupass/features/escalation/domain/models/payload_match.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';

/// 提权链路只读仓储。
abstract class EscalationQueryRepository {
  /// 读取全部载荷条目。
  Future<List<Payload>> listPayloads();

  /// 扫描设备上真实安装的 root 管理器。
  ///
  /// 判据与移交脚本一致：安装目录里带 `libksud.so` 才算，空列表表示一个
  /// 都没装。
  Future<List<RootManager>> installedRootManagers();

  /// 读取用户选定的 root 管理器。
  ///
  /// 设备上一个管理器都没装时返回 `null`；存的是已卸载的旧包名时回落到列表
  /// 第一个。
  Future<RootManager?> selectedRootManager();

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
