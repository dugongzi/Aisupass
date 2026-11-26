import 'package:Aisupass/features/escalation/data/datasources/ghost_lock_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/repositories/ghost_lock_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/domain/enums/ghost_lock_kind.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_outcome.dart';
import 'package:Aisupass/generated/ghost_lock.g.dart' as pigeon;
import 'package:flutter_test/flutter_test.dart';

/// 只替换原生四件事，判定表本身跑真实实现。
class _FakeNative extends pigeon.GhostLockNative {
  _FakeNative({
    required this.chunks,
    this.accepted = true,
    this.reason = '',
  });

  final List<pigeon.GhostLockChunk> chunks;
  final bool accepted;
  final String reason;

  int _index = 0;

  @override
  Future<pigeon.GhostLockPreflight> preflight(String managerPackage) async =>
      pigeon.GhostLockPreflight(
        adbConnected: true,
        shellUid: 2000,
        seccomp: 0,
        release: '6.6.118',
        profileRelease: '6.6.118',
        route: 'select_stack',
        binaryPresent: true,
        ksudPath: '',
        profileError: '',
      );

  @override
  Future<pigeon.GhostLockStartResult> start(
    pigeon.GhostLockRequest request,
  ) async => pigeon.GhostLockStartResult(
    accepted: accepted,
    sessionId: accepted ? 's1' : '',
    reason: reason,
  );

  @override
  Future<pigeon.GhostLockChunk> poll(String sessionId) async =>
      chunks[_index++];

  @override
  Future<void> cancel(String sessionId) async {}
}

/// 终局块：一次轮询即结束，避免测试里等 500ms 轮询间隔。
pigeon.GhostLockChunk _finalChunk(
  String log, {
  int exitCode = 0,
  bool timedOut = false,
  String failure = '',
}) => pigeon.GhostLockChunk(
  sessionId: 's1',
  output: log,
  finished: true,
  exitCode: exitCode,
  timedOut: timedOut,
  durationMs: 1,
  failure: failure,
);

Future<GhostLockOutcome> _run(
  List<pigeon.GhostLockChunk> chunks, {
  bool accepted = true,
  String reason = '',
}) => GhostLockActionRepositoryImpl(
  datasource: GhostLockActionDatasource(
    native: _FakeNative(chunks: chunks, accepted: accepted, reason: reason),
  ),
).run().last;

void main() {
  group('GhostLock 判定表', () {
    test('KernelSU ready -> 成功', () async {
      final GhostLockOutcome outcome = await _run(<pigeon.GhostLockChunk>[
        _finalChunk('... KernelSU ready\n'),
      ]);
      expect(outcome.kind, GhostLockKind.succeeded);
      expect(outcome.success, isTrue);
    });

    test('已接管不判成功', () async {
      final GhostLockOutcome outcome = await _run(<pigeon.GhostLockChunk>[
        _finalChunk('KernelSU already has root; skipping exploit\n'),
      ]);
      expect(outcome.kind, GhostLockKind.alreadyRooted);
      expect(outcome.success, isFalse);
    });

    test('脏竞争优先于其它标记', () async {
      final GhostLockOutcome outcome = await _run(<pigeon.GhostLockChunk>[
        _finalChunk('terminal dirty race: ...\nKernelSU ready\n', exitCode: 70),
      ]);
      expect(outcome.kind, GhostLockKind.dirtyRace);
    });

    test('profile 与内核不一致', () async {
      final GhostLockOutcome outcome = await _run(<pigeon.GhostLockChunk>[
        _finalChunk('profile release mismatch: expected 6.6.118\n'),
      ]);
      expect(outcome.kind, GhostLockKind.releaseMismatch);
    });

    test('W1 / W2 / W3 分别归类', () async {
      expect(
        (await _run(<pigeon.GhostLockChunk>[
          _finalChunk('Write 1 failed\n'),
        ])).kind,
        GhostLockKind.w1Failed,
      );
      expect(
        (await _run(<pigeon.GhostLockChunk>[
          _finalChunk('W2 failed after 3 attempts\n'),
        ])).kind,
        GhostLockKind.w2Failed,
      );
      expect(
        (await _run(<pigeon.GhostLockChunk>[
          _finalChunk('W3 seccomp clear failed\n'),
        ])).kind,
        GhostLockKind.w3Failed,
      );
    });

    test('KSU 加载失败', () async {
      final GhostLockOutcome outcome = await _run(<pigeon.GhostLockChunk>[
        _finalChunk('KernelSU module load failed\n'),
      ]);
      expect(outcome.kind, GhostLockKind.ksuFailed);
    });

    test('超时优先于任何输出', () async {
      final GhostLockOutcome outcome = await _run(<pigeon.GhostLockChunk>[
        _finalChunk('KernelSU ready\n', timedOut: true),
      ]);
      expect(outcome.kind, GhostLockKind.timedOut);
      expect(outcome.timedOut, isTrue);
    });

    test('无可识别标记 -> 兜底失败', () async {
      final GhostLockOutcome outcome = await _run(<pigeon.GhostLockChunk>[
        _finalChunk('something unexpected\n'),
      ]);
      expect(outcome.kind, GhostLockKind.failed);
    });

    test('未受理带原因码', () async {
      final GhostLockOutcome outcome = await _run(
        <pigeon.GhostLockChunk>[],
        accepted: false,
        reason: 'noAdb',
      );
      expect(outcome.kind, GhostLockKind.notStarted);
      expect(outcome.reason, 'noAdb');
    });

    test('原生诊断码透传到实体', () async {
      final GhostLockOutcome outcome = await _run(<pigeon.GhostLockChunk>[
        _finalChunk('', exitCode: -1, failure: 'launchFailed'),
      ]);
      expect(outcome.failure, 'launchFailed');
    });
  });
}
