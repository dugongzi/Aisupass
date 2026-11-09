import 'dart:convert';

import 'package:Aisupass/features/escalation/data/datasources/dirty_frag_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/models/dirty_frag_outcome_dto.dart';
import 'package:Aisupass/features/escalation/data/models/dirty_frag_run_defaults_dto.dart';
import 'package:Aisupass/features/escalation/data/models/vr_derive_progress_dto.dart';
import 'package:Aisupass/features/escalation/data/models/vr_offset_result_dto.dart';
import 'package:Aisupass/features/escalation/domain/enums/dirty_frag_kind.dart';
import 'package:Aisupass/features/escalation/domain/models/dirty_frag_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/dirty_frag_run_defaults.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:Aisupass/features/escalation/domain/models/vr_derive_progress.dart';
import 'package:Aisupass/features/escalation/domain/models/vr_offset_result.dart';
import 'package:Aisupass/features/escalation/domain/repositories/dirty_frag_action_repository.dart';
import 'package:Aisupass/generated/dirty_frag.g.dart' as pigeon;

/// DirtyFrag 运行仓储实现：DTO -> Entity 的唯一转换点，同时承载轮询循环与判定表。
class DirtyFragActionRepositoryImpl implements DirtyFragActionRepository {
  DirtyFragActionRepositoryImpl({required this._datasource});

  final DirtyFragActionDatasource _datasource;

  /// 两次轮询之间的间隔。
  ///
  /// 原生侧 `exp.c:624` 用 10 ms 的粒度轮询，整条链路上限 10 s（D10 已定
  /// 按源码）。本侧取 100 ms 是为了让一屏输出不至于碎成上百段；
  /// 10 s ÷ 100 ms = 最多 100 块，不会拖慢终局判定。
  static const Duration _pollInterval = Duration(milliseconds: 100);

  /// 当前会话；没有运行在跑时为空串。
  String _sessionId = '';

  @override
  Future<bool> isArmed() => _datasource.isArmed();

  @override
  Future<DirtyFragRunDefaults> runDefaults() async =>
      DirtyFragRunDefaultsDto.fromNative(
        await _datasource.getRunDefaults(),
      ).toEntity();

  @override
  Future<void> saveRunDefaults({required DirtyFragRunDefaults defaults}) =>
      _datasource.setRunDefaults(
        defaults: DirtyFragRunDefaultsDto(
          vrDisarm: defaults.vrDisarm,
          vrAuto: defaults.vrAuto,
          vrOffset: defaults.vrOffset,
          softReboot: defaults.softReboot,
        ).toNative(),
      );

  @override
  Stream<DirtyFragOutcome> run({
    required RootManager manager,
    int? vrOffsetOverride,
  }) async* {
    // 本次参数全部来自设置页，只有手动偏移允许调用方临时覆盖。
    final DirtyFragRunDefaults defaults = await runDefaults();
    final int offset = vrOffsetOverride ?? defaults.vrOffset;

    final pigeon.DirtyFragStartResult accepted = await _datasource.start(
      request: pigeon.DirtyFragRequest(
        managerPackage: manager.packageName,
        vrDisarm: defaults.vrDisarm,
        vrAuto: defaults.vrAuto,
        vrOffset: offset,
        softReboot: defaults.softReboot,
      ),
    );

    if (!accepted.accepted) {
      // 被拒也要走一次 DTO -> Entity：Entity 只能由 DTO 转出来，不在别处 new。
      yield DirtyFragOutcomeDto(
        sessionId: accepted.sessionId,
        kind: DirtyFragKind.notStarted,
        reason: accepted.reason,
      ).toEntity();
      return;
    }

    _sessionId = accepted.sessionId;
    final StringBuffer accumulated = StringBuffer();

    try {
      while (true) {
        final pigeon.DirtyFragChunk chunk = await _datasource.poll(
          sessionId: accepted.sessionId,
        );
        final DirtyFragOutcomeDto dto = DirtyFragOutcomeDto.fromNative(chunk);
        accumulated.write(chunk.output);

        if (chunk.finished) {
          // 判定结果先落进 DTO，再走无参 toEntity()。
          yield dto
              .copyWith(
                kind: _classify(accumulated.toString(), chunk),
                log: accumulated.toString(),
              )
              .toEntity();
          return;
        }

        // 中间块的 kind 取 DTO 的默认值 DirtyFragKind.running。
        yield dto.toEntity();
        await Future<void>.delayed(_pollInterval);
      }
    } finally {
      _sessionId = '';
    }
  }

  @override
  Future<void> cancel() async {
    final String sessionId = _sessionId;
    if (sessionId.isEmpty) return;
    await _datasource.cancel(sessionId: sessionId);
  }

  @override
  Future<bool> isExpertModeEnabled() => _datasource.isExpertModeEnabled();

  @override
  Future<void> setExpertModeEnabled({required bool enabled}) =>
      _datasource.setExpertModeEnabled(enabled: enabled);

  @override
  Future<bool> isBootAutostartEnabled() =>
      _datasource.isBootAutostartEnabled();

  @override
  Future<void> setBootAutostartEnabled({required bool enabled}) =>
      _datasource.setBootAutostartEnabled(enabled: enabled);

  /// 判定表。只有这里掌握「成功/失败」的解释权。
  ///
  /// 判定顺序不可调换：先看不可逆的失败证据，再看成功标记，最后才兜底。
  /// 所有字符串都来自 `exp.c` 的 `printf` 与 `markers[]`，逐字对齐，不凭印象。
  DirtyFragKind _classify(String log, pigeon.DirtyFragChunk chunk) {
    if (chunk.timedOut) return DirtyFragKind.timedOut;

    // 1) 不可逆失败：内核没有这个洞（exp.c:363）
    if (log.contains('patch: DEVICE NOT VULNERABLE')) {
      return DirtyFragKind.notVulnerable;
    }

    // 2) VR 反制失败：markers[] 的 rc=4 两条（exp.c:607 / :609）
    if (log.contains('vr: ERROR - disarm failed') ||
        log.contains('vr: ERROR - auto-resolve failed')) {
      return DirtyFragKind.vrFailed;
    }

    // 3) 打补丁阶段失败：rc=3 的收尾行（exp.c:636）
    if (log.contains('patch: ERROR - failed to patch files')) {
      return DirtyFragKind.patchFailed;
    }

    // 4) 成功：markers[] 里唯一 rc=0 的一条（exp.c:619）
    if (log.contains('ksud start: SUCCESS')) return DirtyFragKind.succeeded;

    // 5) 超时：10 s 窗口里没有任何终局 marker（exp.c:634）
    if (log.contains('timeout: ERROR')) return DirtyFragKind.timedOut;

    // 6) bootstrap 或 ksud 阶段失败：markers[] 的 rc=1 三条（exp.c:611 / :617 / :620）
    if (log.contains('bootstrap: ERROR') ||
        log.contains('ksud start: ERROR')) {
      return DirtyFragKind.bootstrapFailed;
    }

    // 7) 有输出但没有可识别结论：不猜。
    return DirtyFragKind.failed;
  }

  @override
  Future<VrOffsetResult> deriveVrOffset({
    required String input,
    bool insecure = false,
  }) async {
    final pigeon.VrDeriveResult raw = await _datasource.deriveVrOffset(
      input: input,
      insecure: insecure,
    );
    final VrOffsetResultDto dto =
        raw.error.isNotEmpty
        ? VrOffsetResultDto(error: _squash(raw.error))
        : _parseVrOffset(raw.json);
    return dto.toEntity();
  }

  @override
  Future<VrDeriveProgress> vrDeriveProgress() async {
    final String raw = await _datasource.vrDeriveProgress();
    return VrDeriveProgressDto.fromNative(raw).toEntity();
  }

  /// 把 Rust 的 JSON 落成 DTO。解析失败按「提取失败」处理，不抛给 UI。
  VrOffsetResultDto _parseVrOffset(String json) {
    try {
      final Object? decoded = jsonDecode(json);
      if (decoded is! Map<String, dynamic>) {
        return const VrOffsetResultDto(error: 'malformedResult');
      }
      return VrOffsetResultDto.fromJson(decoded);
    } on FormatException {
      return const VrOffsetResultDto(error: 'malformedResult');
    }
  }

  /// `VrDeriveResult.error` 里可能整段包着 Rust 的 JSON，只留可读的一行。
  String _squash(String raw) {
    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        final String error = decoded['error'] as String? ?? '';
        if (error.isNotEmpty) return error;
      }
    } on FormatException {
      // 不是 JSON 就按原文返回：至少让用户看到原始报错。
    }
    return raw;
  }
}
