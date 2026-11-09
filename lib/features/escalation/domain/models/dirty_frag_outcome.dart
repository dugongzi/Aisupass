import 'package:Aisupass/features/escalation/domain/enums/dirty_frag_kind.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dirty_frag_outcome.freezed.dart';

/// 一次 DirtyFrag 运行产出的证据与结论。
///
/// 终局判定由仓储实现给出，本类只承载数据。
@freezed
abstract class DirtyFragOutcome with _$DirtyFragOutcome {
  const DirtyFragOutcome._();

  const factory DirtyFragOutcome({
    /// 终局分类；[DirtyFragKind.running] 表示还有后续块。
    required DirtyFragKind kind,

    /// 会话标识；受理失败时为空串。
    required String sessionId,

    /// 自上次块以来新增的输出（stdout 与 stderr 合并），直接写屏。
    required String output,

    /// 累积输出，只有终局块非空；判定依据就是它。
    required String log,

    /// 退出码；`-1` 表示没取到。
    ///
    /// 本链路里 `2` 在多数成功场景也会出现，不能单看退出码下结论。
    required int exitCode,

    /// 从受理到终局的耗时（毫秒）。
    required int durationMs,

    /// 是否因本侧取消而强制结束。
    required bool timedOut,

    /// `--vr-auto` 解析出的偏移（十进制字符串）；未解析出为空串。
    required String resolvedVrOffset,

    /// 受理失败原因码；受理成功时为空串。
    required String reason,
  }) = _DirtyFragOutcome;

  /// 是否全链路成功。
  bool get success => kind == DirtyFragKind.succeeded;

  /// 是否已到终局（不再有后续块）。
  bool get isFinal => kind != DirtyFragKind.running;
}
