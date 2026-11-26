import 'package:Aisupass/core/utils/escalation_reason.dart';
import 'package:Aisupass/core/utils/terminal_text_writer.dart';
import 'package:Aisupass/features/escalation/domain/enums/dirty_frag_kind.dart';
import 'package:Aisupass/features/escalation/domain/enums/ghost_key_kind.dart';
import 'package:Aisupass/features/escalation/domain/enums/ghost_lock_kind.dart';
import 'package:Aisupass/features/escalation/domain/enums/handoff_kind.dart';
import 'package:Aisupass/features/escalation/domain/models/dirty_frag_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/handoff_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// 写屏语义：页面据此挑前景色，渲染函数不依赖终端实现。
enum EscalationTone { normal, success, notice, error, dim }

/// 一行待写屏文本。
typedef EscalationLine = ({String text, EscalationTone tone});

/// 单行写屏回调。
typedef EscalationLineWriter = void Function(String text, EscalationTone tone);

/// 一段渲染结果：流式输出之前与之后各一批行。
///
/// 中间夹着 `writeStream(outcome.output)`，因此分两段返回。
typedef EscalationLines = ({
  List<EscalationLine> head,
  List<EscalationLine> tail,
});

/// 色调 → 终端前景色；`normal` 用默认色。
String? escalationToneColor(EscalationTone tone) => switch (tone) {
  EscalationTone.normal => null,
  EscalationTone.success => TerminalTextWriter.green,
  EscalationTone.notice => TerminalTextWriter.yellow,
  EscalationTone.error => TerminalTextWriter.red,
  EscalationTone.dim => TerminalTextWriter.dim,
};

/// 按「head → 流式输出 → tail」把渲染结果写屏。
void writeEscalationResult(
  TerminalTextWriter writer,
  EscalationLines lines, {
  String stream = '',
}) {
  for (final EscalationLine line in lines.head) {
    writer.writeLine(line.text, color: escalationToneColor(line.tone));
  }
  if (stream.isNotEmpty) writer.writeStream(stream);
  for (final EscalationLine line in lines.tail) {
    writer.writeLine(line.text, color: escalationToneColor(line.tone));
  }
}

/// 移交结果 → 待写屏行。
EscalationLines handoffResultLines(
  HandoffOutcome outcome,
  AppLocalizations l10n,
) {
  final RootManager manager = outcome.manager;
  final List<EscalationLine> head = <EscalationLine>[];
  if (!outcome.success) {
    head.add((
      text: switch (outcome.kind) {
        HandoffKind.managerMissing => l10n.escalationHandoffManagerMissing(
          manager.displayName,
          manager.packageName,
        ),
        HandoffKind.noSu => l10n.escalationHandoffNoSu,
        HandoffKind.failed =>
          outcome.exitCode < 0
              ? l10n.escalationHandoffFailedNoCode
              : l10n.escalationHandoffFailed(outcome.exitCode),
        HandoffKind.success => '',
      },
      tone: EscalationTone.error,
    ));
    // 终端会把 http(s) 识别成可点文本；未登记包名没有下载页，不打印空行。
    if (outcome.kind == HandoffKind.managerMissing &&
        manager.homeUrl.isNotEmpty) {
      head.add((text: manager.homeUrl, tone: EscalationTone.dim));
    }
  }
  if (outcome.ksudPath.isNotEmpty) {
    head.add((text: 'ksud: ${outcome.ksudPath}', tone: EscalationTone.dim));
  }
  return (
    head: head,
    tail: <EscalationLine>[
      (
        text: _exitTag(
          outcome.exitCode,
          outcome.durationMs,
          outcome.timedOut,
          l10n,
        ),
        tone: EscalationTone.dim,
      ),
    ],
  );
}

/// DirtyFrag 终局块 → 待写屏行。
EscalationLines dirtyFragResultLines(
  DirtyFragOutcome outcome,
  RootManager? manager,
  AppLocalizations l10n,
) {
  final List<EscalationLine> tail = <EscalationLine>[];
  if (outcome.resolvedVrOffset.isNotEmpty) {
    tail.add((
      text: l10n.escalationDirtyFragVrOffsetResolved(outcome.resolvedVrOffset),
      tone: EscalationTone.dim,
    ));
  }
  final String verdict = switch (outcome.kind) {
    DirtyFragKind.succeeded => l10n.escalationDirtyFragSucceeded(
      manager?.displayName ?? '',
    ),
    DirtyFragKind.notVulnerable => l10n.escalationDirtyFragNotVulnerable,
    DirtyFragKind.patchFailed => l10n.escalationDirtyFragPatchFailed,
    DirtyFragKind.vrFailed => l10n.escalationDirtyFragVrFailed,
    DirtyFragKind.bootstrapFailed => l10n.escalationDirtyFragBootstrapFailed,
    DirtyFragKind.timedOut => l10n.escalationDirtyFragTimedOut,
    DirtyFragKind.notStarted => l10n.escalationDirtyFragNotStarted(
      dirtyFragNotStartedReason(l10n, outcome.reason),
    ),
    DirtyFragKind.running ||
    DirtyFragKind.failed => l10n.escalationDirtyFragPatchFailed,
  };
  tail.add((
    text: verdict,
    tone: outcome.success ? EscalationTone.success : EscalationTone.error,
  ));
  tail.add((
    text: _exitTag(
      outcome.exitCode,
      outcome.durationMs,
      outcome.timedOut,
      l10n,
    ),
    tone: EscalationTone.dim,
  ));
  return (head: const <EscalationLine>[], tail: tail);
}

/// GhostKey 终局块 → 待写屏行。
EscalationLines ghostKeyResultLines(
  GhostKeyOutcome outcome,
  RootManager? manager,
  AppLocalizations l10n,
) {
  final String verdict = switch (outcome.kind) {
    GhostKeyKind.succeeded => l10n.escalationGhostKeySucceeded(
      manager == null ? '' : ' ${manager.displayName}',
    ),
    GhostKeyKind.degraded => l10n.escalationGhostKeyDegraded,
    GhostKeyKind.calibFailed => l10n.escalationGhostKeyCalibFailed,
    GhostKeyKind.pageOffsetFailed => l10n.escalationGhostKeyPageOffsetFailed,
    GhostKeyKind.injectFailed => l10n.escalationGhostKeyInjectFailed,
    GhostKeyKind.verifyFailed => l10n.escalationGhostKeyVerifyFailed,
    GhostKeyKind.ksuFailed => l10n.escalationGhostKeyKsuFailed,
    GhostKeyKind.timedOut => l10n.escalationGhostKeyTimedOut,
    GhostKeyKind.notStarted => l10n.escalationGhostKeyNotStarted(
      ghostKeyNotStartedReason(l10n, outcome.reason),
    ),
    GhostKeyKind.running ||
    GhostKeyKind.failed => l10n.escalationGhostKeyFailed,
  };
  return (
    head: const <EscalationLine>[],
    tail: <EscalationLine>[
      (
        text: verdict,
        tone: outcome.success ? EscalationTone.success : EscalationTone.error,
      ),
      (
        text: _exitTag(
          outcome.exitCode,
          outcome.durationMs,
          outcome.timedOut,
          l10n,
        ),
        tone: EscalationTone.dim,
      ),
    ],
  );
}

/// GhostLock 终局块 → 待写屏行。
EscalationLines ghostLockResultLines(
  GhostLockOutcome outcome,
  RootManager? manager,
  AppLocalizations l10n,
) {
  final String name = manager == null ? '' : ' ${manager.displayName}';
  final String verdict = switch (outcome.kind) {
    GhostLockKind.succeeded => l10n.escalationGhostLockSucceeded(name),
    GhostLockKind.alreadyRooted => l10n.escalationGhostLockAlreadyRooted,
    GhostLockKind.tempRootOnly => l10n.escalationGhostLockTempRootOnly,
    GhostLockKind.seccompBlocked => l10n.escalationGhostLockSeccompBlocked,
    GhostLockKind.ksuFailed => l10n.escalationGhostLockKsuFailed,
    GhostLockKind.w1Failed => l10n.escalationGhostLockW1Failed,
    GhostLockKind.w2Failed => l10n.escalationGhostLockW2Failed,
    GhostLockKind.w3Failed => l10n.escalationGhostLockW3Failed,
    GhostLockKind.releaseMismatch => l10n.escalationGhostLockReleaseMismatch,
    GhostLockKind.dirtyRace => l10n.escalationGhostLockDirtyRace,
    GhostLockKind.timedOut => l10n.escalationGhostLockTimedOut,
    GhostLockKind.notStarted => l10n.escalationGhostLockNotStarted(
      outcome.reason,
    ),
    GhostLockKind.running ||
    GhostLockKind.failed => l10n.escalationGhostLockFailed,
  };
  final List<EscalationLine> tail = <EscalationLine>[
    (
      text: verdict,
      tone: outcome.success ? EscalationTone.success : EscalationTone.error,
    ),
    (
      text: _exitTag(
        outcome.exitCode,
        outcome.durationMs,
        outcome.timedOut,
        l10n,
      ),
      tone: EscalationTone.dim,
    ),
  ];
  if (outcome.failure.isNotEmpty) {
    tail.add((
      text: ghostLockFailureText(l10n, outcome.failure),
      tone: EscalationTone.error,
    ));
  }
  return (head: const <EscalationLine>[], tail: tail);
}

/// 退出码行：`[exit N · 1234 ms]`，超时追加标记。
String _exitTag(
  int exitCode,
  int durationMs,
  bool timedOut,
  AppLocalizations l10n,
) =>
    '[${escalationExitTag(exitCode)} · $durationMs ms'
    '${timedOut ? l10n.escalationTimedOutTag : ''}]';
