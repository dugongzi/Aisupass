import 'package:Aisupass/features/escalation/domain/enums/escalation_chain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'escalation_request.freezed.dart';

/// 一次提权运行的启动请求。
///
/// M0 只承载链名与扁平参数，资产选择（载荷版本、内核配置、模块包）属于后续里程碑。
@freezed
abstract class EscalationRequest with _$EscalationRequest {
  const EscalationRequest._();

  const factory EscalationRequest({
    required EscalationChain chain,
    required Map<String, String> args,
  }) = _EscalationRequest;
}
