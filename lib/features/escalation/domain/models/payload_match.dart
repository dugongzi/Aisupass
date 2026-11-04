import 'package:Aisupass/features/escalation/domain/enums/match_tier.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payload_match.freezed.dart';

/// 一次匹配的结果：命中的载荷 + 命中档位。
@freezed
abstract class PayloadMatch with _$PayloadMatch {
  const PayloadMatch._();

  const factory PayloadMatch({
    /// 命中的载荷。
    required Payload payload,

    /// 命中档位。
    required MatchTier tier,
  }) = _PayloadMatch;

  /// 是否属于「可能可用」的降级命中，UI 需要给出警告。
  bool get isDegraded =>
      tier == MatchTier.similarDevice || tier == MatchTier.vendorFallback;
}
