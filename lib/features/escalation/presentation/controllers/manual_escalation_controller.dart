import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/core/providers/adb_shell_provider.dart';
import 'package:Aisupass/core/utils/escalation_reason.dart';
import 'package:Aisupass/core/utils/escalation_result_lines.dart';
import 'package:Aisupass/features/escalation/domain/enums/dirty_frag_kind.dart';
import 'package:Aisupass/features/escalation/domain/models/device_identity.dart';
import 'package:Aisupass/features/escalation/domain/models/dirty_frag_run_defaults.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_preflight.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_run_defaults.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_preflight.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:Aisupass/features/escalation/presentation/controllers/run_log_session.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

/// 手动提权页的流程编排。
///
/// 只负责「读 Provider → 拼命令 → 写屏 → 落盘」的顺序，不持有 Context、
/// 不弹窗、不弹 Toast；这些能力由页面以回调注入。日志会话见 [RunLogSession]。
class ManualEscalationController {
  ManualEscalationController({
    required this._ref,
    required this._l10n,
    required this._writeLine,
    required this._isBusy,
    required this._setBusy,
  });

  final WidgetRef _ref;
  final AppLocalizations _l10n;
  final EscalationLineWriter _writeLine;
  final bool Function() _isBusy;
  final void Function(bool busy) _setBusy;

  /// GhostKey 一轮运行日志。
  late final RunLogSession _ghostKeyLog = RunLogSession(
    ref: _ref,
    writeLine: _writeLine,
  );

  /// GhostLock 一轮运行日志。
  late final RunLogSession _ghostLockLog = RunLogSession(
    ref: _ref,
    writeLine: _writeLine,
  );

  /// 自动匹配载荷并执行。
  Future<void> startExploit() async {
    if (_isBusy()) return;
    // 光标停在远端提示符后面，先回车，否则这行接在 `$ ` 后面。
    _writeLine('', EscalationTone.normal);
    _writeLine(_l10n.escalationExploitStarted, EscalationTone.notice);
    _ref.invalidate(shellConnectionProvider);
    // 每次都要重拼：设备状态可能变了，别吃上次的缓存。
    _ref.invalidate(runPayloadProvider);
    await _runCommand(() => _ref.read(runPayloadProvider.future));
  }

  /// 用清单里挑出来的一条提权，跳过自动匹配。
  Future<void> startPayload(Payload payload) async {
    if (_isBusy()) return;
    _writeLine('', EscalationTone.normal);
    _writeLine(
      _l10n.escalationPayloadManualStarted(payload.displayName),
      EscalationTone.notice,
    );
    _ref.invalidate(shellConnectionProvider);
    _ref.invalidate(runPayloadChoiceProvider(payload: payload));
    await _runCommand(
      () => _ref.read(runPayloadChoiceProvider(payload: payload).future),
    );
  }

  /// 把临时 root 移交给当前选定的管理器。
  ///
  /// [currentTarget] 是页面记住的上一次目标：同一目标要强制重跑，换目标只切换。
  Future<void> startHandoff({
    required RootManager? currentTarget,
    required void Function(RootManager manager) onSwitch,
    required void Function(RootManager manager) onRetry,
  }) async {
    final RootManager? manager;
    try {
      manager = await _ref.read(selectedRootManagerProvider.future);
    } catch (error) {
      _writeLine(
        '${_l10n.escalationHandoffReadManagerFailed}：$error',
        EscalationTone.error,
      );
      return;
    }
    // 一个都没装时没有可移交的对象，普通提示即可，不必走移交。
    if (manager == null) {
      _writeLine(_l10n.escalationHandoffNoManager, EscalationTone.notice);
      return;
    }
    _writeLine('', EscalationTone.normal);
    _writeLine(
      _l10n.escalationHandoffRunning(manager.displayName),
      EscalationTone.notice,
    );
    if (currentTarget == manager) {
      onRetry(manager);
    } else {
      onSwitch(manager);
    }
  }

  /// 跑一次 DirtyFrag。
  ///
  /// 前置三项都在这里拦：本次开机已注入、内核不在支持列表、没有选中管理器。
  Future<void> startDirtyFrag({
    required Future<int?> Function({
      required RootManager manager,
      required String kernelVersion,
      required bool kernelSupported,
      required DirtyFragRunDefaults defaults,
    })
    confirm,
    required void Function(RootManager manager, int? override) onStart,
  }) async {
    if (_isBusy()) return;

    final bool armed;
    try {
      armed = await _ref.read(dirtyFragArmedProvider.future);
    } catch (error) {
      _writeLine(
        '${_l10n.escalationInvokeFailed}：$error',
        EscalationTone.error,
      );
      return;
    }
    if (armed) {
      _writeLine(_l10n.escalationDirtyFragAlreadyArmed, EscalationTone.notice);
      return;
    }

    final RootManager? manager;
    final DeviceIdentity identity;
    final DirtyFragRunDefaults defaults;
    try {
      manager = await _ref.read(selectedRootManagerProvider.future);
      identity = await _ref.read(currentDeviceIdentityProvider.future);
      defaults = await _ref.read(dirtyFragRunDefaultsProvider.future);
    } catch (error) {
      _writeLine(
        '${_l10n.escalationInvokeFailed}：$error',
        EscalationTone.error,
      );
      return;
    }
    if (manager == null) {
      _writeLine(_l10n.escalationDirtyFragNoManager, EscalationTone.notice);
      return;
    }

    final bool kernelSupported = isDirtyFragKernelSupported(
      identity.kernelSeries,
    );
    if (!kernelSupported) {
      _writeLine(
        _l10n.escalationDirtyFragKernelUnsupported(
          identity.kernelVersion.isEmpty
              ? _l10n.escalationDirtyFragKernelUnknown
              : identity.kernelVersion,
        ),
        EscalationTone.error,
      );
      return;
    }

    final int? override = await confirm(
      manager: manager,
      kernelVersion: identity.kernelVersion,
      kernelSupported: kernelSupported,
      defaults: defaults,
    );
    // 弹窗返回 null 有两种含义：取消，或本次不需要手动偏移。
    // 用 defaults.needsManualOffset 区分，不能一律当成取消。
    if (override == null && defaults.needsManualOffset) return;

    _writeLine('', EscalationTone.normal);
    _writeLine(
      _l10n.escalationDirtyFragRunning(manager.displayName),
      EscalationTone.notice,
    );
    _ref.invalidate(shellConnectionProvider);
    onStart(manager, override);
  }

  /// 跑一次 GhostKey。
  ///
  /// 与 DirtyFrag 的区别：管理器可以没选（原生自己按 profile 找），不查内核版本
  /// （支持面由原生 profile 表决定），前置检查全走原生的 `preflight()`。
  Future<void> startGhostKey({
    required Future<bool?> Function({
      required RootManager? manager,
      required GhostKeyPreflight preflight,
      required GhostKeyRunDefaults defaults,
    })
    confirm,
    required void Function(RootManager? manager) onStart,
  }) async {
    if (_isBusy()) return;

    final GhostKeyPreflight preflight;
    final GhostKeyRunDefaults defaults;
    try {
      preflight = await _ref.read(ghostKeyPreflightProvider.future);
      defaults = await _ref.read(ghostKeyRunDefaultsProvider.future);
    } catch (error) {
      _writeLine(
        '${_l10n.escalationInvokeFailed}：$error',
        EscalationTone.error,
      );
      return;
    }

    // adb 不通是硬拦点：其余五项交给确认弹窗展示，用户自己判断。
    if (!preflight.adbConnected) {
      _writeLine(_l10n.escalationGhostKeyNoAdb, EscalationTone.error);
      return;
    }

    final RootManager? manager = _ref.read(selectedRootManagerProvider).value;

    final bool? confirmed = await confirm(
      manager: manager,
      preflight: preflight,
      defaults: defaults,
    );
    if (confirmed != true) return;

    _writeLine('', EscalationTone.normal);
    _writeLine(
      _l10n.escalationGhostKeyRunning(
        manager == null ? '' : ' ${manager.displayName}',
      ),
      EscalationTone.notice,
    );
    _ref.invalidate(shellConnectionProvider);
    // 必须先建好运行日志再起跑：被拒时首块立刻就到，晚一步就没有文件可写，
    // 记录会永远停在「进行中」。
    await openGhostKeyRun();
    onStart(manager);
  }

  /// 跑一次 GhostLock。
  ///
  /// 前置检查全走原生的 `preflight()`：内核表是否命中、seccomp 是否可用、
  /// 二进制是否在包里，都由原生一次取回，Dart 侧不重复读设备。
  Future<void> startGhostLock({
    required Future<bool?> Function({
      required RootManager? manager,
      required GhostLockPreflight preflight,
    })
    confirm,
    required void Function(RootManager? manager, bool safeMode) onStart,
  }) async {
    if (_isBusy()) return;

    final GhostLockPreflight preflight;
    try {
      preflight = await _ref.read(ghostLockPreflightProvider.future);
    } catch (error) {
      _writeLine(
        '${_l10n.escalationInvokeFailed}：$error',
        EscalationTone.error,
      );
      return;
    }

    if (!preflight.adbConnected) {
      _writeLine(_l10n.escalationGhostLockNoAdb, EscalationTone.error);
      return;
    }
    if (!preflight.binaryPresent) {
      _writeLine(_l10n.escalationGhostLockMissingBinary, EscalationTone.error);
      return;
    }
    if (preflight.profileError.isNotEmpty) {
      _writeLine(
        ghostLockProfileErrorText(_l10n, preflight.profileError),
        EscalationTone.error,
      );
      return;
    }
    if (!preflight.profileMatched) {
      _writeLine(
        _l10n.escalationGhostLockNoProfile(
          preflight.release.isEmpty
              ? _l10n.escalationGhostLockValueUnknown
              : preflight.release,
        ),
        EscalationTone.error,
      );
      return;
    }
    if (preflight.seccomp != 0) {
      _writeLine(
        _l10n.escalationGhostLockSeccompFiltered,
        EscalationTone.error,
      );
      return;
    }

    final RootManager? manager = _ref.read(selectedRootManagerProvider).value;

    final bool? safeMode = await confirm(
      manager: manager,
      preflight: preflight,
    );
    if (safeMode == null) return;

    _writeLine('', EscalationTone.normal);
    _writeLine(
      _l10n.escalationGhostLockRunning(
        manager == null ? '' : ' ${manager.displayName}',
      ),
      EscalationTone.notice,
    );

    _ref.invalidate(shellConnectionProvider);
    // 先建好运行日志再起跑：被拒时首块立刻就到，晚一步就没有文件可写。
    await openGhostLockRun(preflight);
    onStart(manager, safeMode);
  }

  /// 停止本侧读取；设备侧进程继续跑。
  Future<void> stopGhostKey({
    required void Function(Object error) onError,
  }) async {
    try {
      await _ref.read(ghostKeyActionsProvider).cancel();
    } catch (error) {
      onError(error);
    }
  }

  /// 停止本侧读取；设备侧进程继续跑。
  Future<void> stopGhostLock({
    required void Function(Object error) onError,
  }) async {
    try {
      await _ref.read(ghostLockActionsProvider).cancel();
    } catch (error) {
      onError(error);
    }
  }

  /// 开一轮 GhostKey 运行日志。
  Future<void> openGhostKeyRun() => _ghostKeyLog.begin(profile: '');

  /// 追加一块 GhostKey 输出。
  Future<void> persistGhostKeyChunk(GhostKeyOutcome outcome) =>
      _ghostKeyLog.append(
        output: outcome.output,
        isFinal: outcome.isFinal,
        exitCode: outcome.exitCode,
        durationMs: outcome.durationMs,
        result: outcome.logResult,
      );

  /// 开一轮 GhostLock 运行日志。
  Future<void> openGhostLockRun(GhostLockPreflight preflight) =>
      _ghostLockLog.begin(profile: preflight.release);

  /// 追加一块 GhostLock 输出。
  Future<void> persistGhostLockChunk(GhostLockOutcome outcome) =>
      _ghostLockLog.append(
        output: outcome.output,
        isFinal: outcome.isFinal,
        exitCode: outcome.exitCode,
        durationMs: outcome.durationMs,
        result: outcome.logResult,
      );

  /// 把拼出来的一行命令敲进 pty。
  ///
  /// pty 是交互式的，命令要跟一个回车才会执行；`\r` 就是回车键的字节，交给
  /// 远端行编辑处理，和手动敲进去没有区别。
  Future<void> _writeCommand(String command) async {
    await _ref
        .read(shellExecProvider.notifier)
        .writeBytes(utf8.encode('$command\r'));
  }

  /// 拼命令并敲进终端。起不来的原因在 Dart 侧写屏，不编进命令。
  Future<void> _runCommand(Future<String> Function() build) async {
    if (_isBusy()) return;
    _setBusy(true);
    try {
      await _writeCommand(await build());
    } catch (error) {
      _writeLine(
        error is PayloadLaunchException
            ? payloadLaunchFailureText(_l10n, error.code)
            : '${_l10n.escalationInvokeFailed}：$error',
        EscalationTone.error,
      );
    } finally {
      _setBusy(false);
    }
  }
}
