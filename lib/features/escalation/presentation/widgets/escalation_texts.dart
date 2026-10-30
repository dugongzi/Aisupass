import 'package:Aisupass/features/escalation/domain/enums/escalation_chain.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_outcome.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_reason.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_stage.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// 提权相关的枚举到文案的统一映射。
///
/// 全部用 `switch` 表达式穷举，枚举新增成员时编译期即报错，
/// 不会出现「某个原因码在界面上没有文案」的静默缺漏。
String escalationChainName(AppLocalizations l10n, EscalationChain chain) =>
    switch (chain) {
      EscalationChain.shellChannel => l10n.escalationChainShellChannelName,
      EscalationChain.kernelModule => l10n.escalationChainKernelModuleName,
      EscalationChain.payload => l10n.escalationChainPayloadName,
      EscalationChain.kernelExploit => l10n.escalationChainKernelExploitName,
      EscalationChain.pageCache => l10n.escalationChainPageCacheName,
    };

/// 链的一句话说明。
String escalationChainDesc(AppLocalizations l10n, EscalationChain chain) =>
    switch (chain) {
      EscalationChain.shellChannel => l10n.escalationChainShellChannelDesc,
      EscalationChain.kernelModule => l10n.escalationChainKernelModuleDesc,
      EscalationChain.payload => l10n.escalationChainPayloadDesc,
      EscalationChain.kernelExploit => l10n.escalationChainKernelExploitDesc,
      EscalationChain.pageCache => l10n.escalationChainPageCacheDesc,
    };

/// 危险等级文案：0 低、1 中、2 高。
String escalationDangerText(AppLocalizations l10n, int dangerLevel) =>
    switch (dangerLevel) {
      <= 0 => l10n.escalationDangerLow,
      1 => l10n.escalationDangerMedium,
      _ => l10n.escalationDangerHigh,
    };

/// 阶段名。
String escalationStageText(AppLocalizations l10n, EscalationStage stage) =>
    switch (stage) {
      EscalationStage.probe => l10n.escalationStageProbe,
      EscalationStage.prepare => l10n.escalationStagePrepare,
      EscalationStage.execute => l10n.escalationStageExecute,
      EscalationStage.verify => l10n.escalationStageVerify,
      EscalationStage.cleanup => l10n.escalationStageCleanup,
    };

/// 结论名。
String escalationOutcomeText(
  AppLocalizations l10n,
  EscalationOutcome outcome,
) => switch (outcome) {
  EscalationOutcome.success => l10n.escalationOutcomeSuccess,
  EscalationOutcome.partial => l10n.escalationOutcomePartial,
  EscalationOutcome.failed => l10n.escalationOutcomeFailed,
  EscalationOutcome.unsafe => l10n.escalationOutcomeUnsafe,
  EscalationOutcome.unsupported => l10n.escalationOutcomeUnsupported,
  EscalationOutcome.notStarted => l10n.escalationOutcomeNotStarted,
};

/// 原因码文案。
String escalationReasonText(
  AppLocalizations l10n,
  EscalationReason reason,
) => switch (reason) {
  EscalationReason.platformUnsupported =>
    l10n.escalationReasonPlatformUnsupported,
  EscalationReason.androidTooOld => l10n.escalationReasonAndroidTooOld,
  EscalationReason.deviceNotSupported => l10n.escalationReasonDeviceNotSupported,
  EscalationReason.probeTimeout => l10n.escalationReasonProbeTimeout,
  EscalationReason.probeFailed => l10n.escalationReasonProbeFailed,
  EscalationReason.noRootBinary => l10n.escalationReasonNoRootBinary,
  EscalationReason.noSelinuxContext => l10n.escalationReasonNoSelinuxContext,
  EscalationReason.selinuxEnforcing => l10n.escalationReasonSelinuxEnforcing,
  EscalationReason.shellUnavailable => l10n.escalationReasonShellUnavailable,
  EscalationReason.shellDenied => l10n.escalationReasonShellDenied,
  EscalationReason.shellTimeout => l10n.escalationReasonShellTimeout,
  EscalationReason.payloadMissing => l10n.escalationReasonPayloadMissing,
  EscalationReason.payloadMismatch => l10n.escalationReasonPayloadMismatch,
  EscalationReason.catalogCorrupted => l10n.escalationReasonCatalogCorrupted,
  EscalationReason.kernelNotSupported => l10n.escalationReasonKernelNotSupported,
  EscalationReason.kernelModuleLoadFailed =>
    l10n.escalationReasonKernelModuleLoadFailed,
  EscalationReason.kernelVersionMismatch =>
    l10n.escalationReasonKernelVersionMismatch,
  EscalationReason.executeTimeout => l10n.escalationReasonExecuteTimeout,
  EscalationReason.executeFailed => l10n.escalationReasonExecuteFailed,
  EscalationReason.verifyFailedAtExternal =>
    l10n.escalationReasonVerifyFailedAtExternal,
  EscalationReason.verifyTimeout => l10n.escalationReasonVerifyTimeout,
  EscalationReason.cleanupFailed => l10n.escalationReasonCleanupFailed,
  EscalationReason.enforceRestoreFailed =>
    l10n.escalationReasonEnforceRestoreFailed,
  EscalationReason.residualLeft => l10n.escalationReasonResidualLeft,
  EscalationReason.hostDisconnected => l10n.escalationReasonHostDisconnected,
  EscalationReason.hostAuthFailed => l10n.escalationReasonHostAuthFailed,
  EscalationReason.hostPairingFailed => l10n.escalationReasonHostPairingFailed,
  EscalationReason.unknown => l10n.escalationReasonUnknown,
};
