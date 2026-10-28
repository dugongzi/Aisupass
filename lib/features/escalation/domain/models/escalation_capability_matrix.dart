import 'package:Aisupass/features/escalation/domain/models/device_fingerprint.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_capability.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'escalation_capability_matrix.freezed.dart';

/// 一次只读探测的完整结论。
@freezed
abstract class EscalationCapabilityMatrix with _$EscalationCapabilityMatrix {
  const EscalationCapabilityMatrix._();

  const factory EscalationCapabilityMatrix({
    required DeviceFingerprint fingerprint,
    required List<EscalationCapability> capabilities,
    required int probedAtMs,
  }) = _EscalationCapabilityMatrix;

  /// 按破坏性优先级排序后的能力列表。
  List<EscalationCapability> get orderedCapabilities =>
      capabilities.toList(growable: false)
        ..sort((a, b) => a.chain.priority.compareTo(b.chain.priority));

  /// 首个可用链；全部不可用时返回 `null`。
  EscalationCapability? get firstAvailable {
    for (final EscalationCapability capability in orderedCapabilities) {
      if (capability.available) return capability;
    }
    return null;
  }

  /// 是否至少有一条链可用。
  bool get hasAvailable => firstAvailable != null;

  /// 查询指定链的能力结论；不存在时返回 `null`。
  EscalationCapability? capabilityOf(String chainName) {
    for (final EscalationCapability capability in capabilities) {
      if (capability.chain.name == chainName) return capability;
    }
    return null;
  }
}
