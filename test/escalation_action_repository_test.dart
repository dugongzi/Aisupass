import 'dart:typed_data';

import 'package:Aisupass/core/storage/json_codec.dart';
import 'package:Aisupass/core/storage/key_value_store.dart';
import 'package:Aisupass/features/escalation/data/datasources/escalation_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/repositories/escalation_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/domain/enums/root_manager.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_run_result.dart';
import 'package:Aisupass/features/escalation/domain/models/handoff_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:Aisupass/generated/adb_shell.g.dart' as pigeon;
import 'package:flutter_test/flutter_test.dart';

/// 安装后的原生库目录。带 `~~` 和 `==`，用来验证命令里的引号没漏。
const String _directory =
    '/data/app/~~abc==/org.supass.ai_su_pass-xyz==/lib/arm64';

/// 轮询间隔拉到和停滞阈值一样大，让停滞在一轮内就能触发。
///
/// 生产是 2 秒一轮，这里把间隔拉大、等待注入成空实现，判定路径一样但
/// 不用真的等 180 秒。
const Duration _fastPoll = Duration(seconds: 180);

Payload _payload({bool standalone = false}) => Payload(
  id: 'vivo_iqoo13_6657_a',
  library: 'libksu_vivo_iqoo13_6657_a.so',
  vendor: 'vivo',
  displayName: 'iQOO 13（6.6.57）',
  models: const <String>['iqoo13'],
  kernelUnknown: false,
  kernelVersion: '6.6.57',
  kernelCommits: const <String>[],
  buildId: '',
  size: 1,
  sha256: '',
  command: 'LD_PRELOAD=<payload> /system/bin/id',
  standalone: standalone,
  source: '',
);

pigeon.ShellExecResult _ok(String stdout) => pigeon.ShellExecResult(
  exitCode: 0,
  stdout: stdout,
  stderr: '',
  durationMs: 1,
  timedOut: false,
);

pigeon.ShellExecResult _fail(int exitCode, {String stderr = ''}) =>
    pigeon.ShellExecResult(
      exitCode: exitCode,
      stdout: '',
      stderr: stderr,
      durationMs: 1,
      timedOut: false,
    );

bool _isLaunch(String command) => command.contains('env EXPLOIT_ATTEMPTS');
bool _isProbe(String command) => command.contains('state=');
bool _isTerminate(String command) => command.contains('kill -TERM');
bool _isCollect(String command) => command.contains('helper output');
bool _isRootCheck(String command) => command.contains('-c "id"');
bool _isBootId(String command) =>
    command.contains('/proc/sys/kernel/random/boot_id');
bool _isLogTail(String command) => command.contains('tail -c +');

/// 内存版键值存储。兜底值与生产实现保持一致，才能复现
/// 「`read<int>` 对缺失键返回 -1 而不是 null」这个坑。
class _FakeStore implements KeyValueStore {
  final Map<String, Object?> values = <String, Object?>{};

  @override
  Future<T> read<T>(
    String key, {
    T? defaultValue,
    JsonDecoder<T>? fromJson,
  }) async {
    final Object? raw = values[key];
    if (raw is T) return raw;
    if (defaultValue != null) return defaultValue;
    if (T == String) return '' as T;
    if (T == bool) return false as T;
    if (T == int) return -1 as T;
    if (T == double) return -1.0 as T;
    if (T == List<String>) return const <String>[] as T;
    throw StateError('缺少 defaultValue：$key');
  }

  @override
  Future<void> write<T>(String key, T value) async {
    values[key] = value;
  }

  @override
  Future<bool> containsKey(String key) async => values.containsKey(key);

  @override
  Future<Set<String>> keys() async => values.keys.toSet();

  @override
  Future<void> remove(String key) async {
    values.remove(key);
  }

  @override
  Future<void> clear() async {
    values.clear();
  }
}

/// 假的原生桥：按命令内容分流，同时记录真正下发的命令。
///
/// 数据源用真的，命令拼装照样被这些断言覆盖；仓储只拿到返回值去判定。
/// `boot_id` 读取与日志增量读属于基础设施命令，由这里直接应答，不进
/// [commands]，免得把业务断言里的命令条数搅乱。
class _FakeNative extends pigeon.AdbShellNative {
  _FakeNative(
    this.handler, {
    this.directory = _directory,
    this.bootToken = 'boot-session-1',
    this.logTail = '',
  });

  final pigeon.ShellExecResult Function(String command) handler;
  final String directory;

  /// `boot_id` 的读数；置空表示读不到。
  final String bootToken;

  /// 增量读日志时返回的新增内容。
  final String logTail;

  final List<String> commands = <String>[];
  final List<String> logTails = <String>[];

  int get probes => commands.where(_isProbe).length;
  int get terminations => commands.where(_isTerminate).length;

  @override
  Future<pigeon.ShellExecResult> exec(
    String command,
    int timeoutMs,
    Uint8List? stdin,
  ) async {
    if (_isBootId(command)) {
      return bootToken.isEmpty ? _fail(1) : _ok('$bootToken\n');
    }
    if (_isLogTail(command)) {
      logTails.add(command);
      return _ok(logTail);
    }
    commands.add(command);
    return handler(command);
  }

  @override
  Future<String> nativeLibraryDir() async => directory;
}

EscalationActionRepositoryImpl _repository(
  _FakeNative native, {
  Duration pollInterval = _fastPoll,
  KeyValueStore? storage,
}) => EscalationActionRepositoryImpl(
  datasource: EscalationActionDatasource(
    native: native,
    storage: storage ?? _FakeStore(),
    delay: (Duration _) async {},
    pollInterval: pollInterval,
  ),
);

void main() {
  group('启动阶段', () {
    test('命令里带 helper 与载荷两道存在性闸门', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (_isLaunch(command)) return _ok('4242\n');
        if (_isProbe(command)) return _ok('state=gone size=1');
        if (_isCollect(command)) {
          return _ok('exploit completed\ndone=1 root=1\nexitCode=0\n');
        }
        if (_isRootCheck(command)) return _ok('uid=0(root) gid=0(root)');
        fail('不该走到这里: $command');
      });

      await _repository(fake).runPayload(_payload());

      final String launch = fake.commands.first;
      expect(_isLaunch(launch), isTrue);
      expect(launch, contains('[ -x '));
      expect(launch, contains('exit 2'));
      expect(launch, contains('[ -e '));
      expect(launch, contains('exit 3'));
      // 后台起：进程号必须记进文件，且标准输入要接到 /dev/null，
      // 否则 shell 退出后载荷读 stdin 会拿到 EIO。
      expect(launch, contains('</dev/null &'));
      // 记下的必须是**助手本身**的号：先 `env ... &` 拿到 `$!`，再写文件，
      // 再由外层子 shell `wait` 回收退出码。写 `$!` 之外的东西（比如包一层
      // 子 shell 的号）会让终止只杀掉壳、留下孤儿载荷。
      expect(launch, contains('assist=\$!;'));
      expect(launch, contains('echo \$assist > '));
      expect(launch, contains('wait \$assist;'));
      expect(launch, contains('echo \$? > '));
      // 重试参数要显式传给助手，不能指望环境里已经有。
      expect(launch, contains('EXPLOIT_ATTEMPTS=24'));
      expect(launch, contains('P0_ATTEMPT_TIMEOUT_SEC=45'));
      expect(launch, contains('EXPLOIT_ATTEMPT_TIMEOUT_SEC=120'));
      // 路径必须被单引号包住，否则 `~~` 和 `==` 会被 shell 解释。
      expect(launch, contains("'$_directory/libcve43499root.so'"));
      expect(launch, contains("'$_directory/libksu_vivo_iqoo13_6657_a.so'"));
    });

    test('载荷缺失的退出码原样透传，且按打包缺失说明，不再轮询', () async {
      final _FakeNative fake = _FakeNative(
        (String command) => _fail(3, stderr: 'payload missing: /x/y.so'),
      );

      final EscalationRunResult result = await _repository(fake)
          .runPayload(_payload());

      expect(result.success, isFalse);
      expect(result.exitCode, 3);
      // 退出码 3 = 这份 so 没进安装包。文案必须说成打包缺失，
      // 否则用户会以为是自己设备 / 内核的问题，白白去折腾系统。
      expect(result.stderr, contains('没有打进安装包'));
      expect(result.stderr, contains('打包缺失'));
      expect(fake.commands, hasLength(1));
      expect(fake.probes, 0);
    });

    test('原生库目录为空直接失败，不发命令', () async {
      final _FakeNative fake = _FakeNative(
        (String command) => fail('不该发命令: $command'),
        directory: '',
      );

      final EscalationRunResult result = await _repository(fake)
          .runPayload(_payload());

      expect(result.success, isFalse);
      expect(fake.commands, isEmpty);
    });

    test('standalone 载荷不自动执行', () async {
      final _FakeNative fake = _FakeNative(
        (String command) => fail('不该发命令: $command'),
      );

      final EscalationRunResult result = await _repository(fake)
          .runPayload(_payload(standalone: true));

      expect(result.success, isFalse);
      expect(result.stderr, contains('暂不支持自动执行'));
      expect(fake.commands, isEmpty);
    });
  });

  group('轮询阶段', () {
    test('探测到两条标记即判成功，且不去 kill', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (_isLaunch(command)) return _ok('4242\n');
        if (_isProbe(command)) return _ok('state=gone size=987');
        if (_isCollect(command)) {
          return _ok('[*] done\nexploit completed\ndone=1 root=1\nexitCode=0\n');
        }
        if (_isRootCheck(command)) return _ok('uid=0(root) gid=0(root)');
        fail('不该走到这里: $command');
      });

      final EscalationRunResult result = await _repository(fake)
          .runPayload(_payload());

      expect(result.success, isTrue);
      expect(result.exitCode, 0);
      expect(result.stderr, isEmpty);
      expect(result.timedOut, isFalse);
      expect(result.stdout, contains('done=1 root=1'));
      expect(result.stdout, contains('uid=0(root)'));
      expect(fake.commands.where(_isRootCheck), hasLength(1));
      expect(fake.probes, 1);
      // 进程自己退了，进程号已经不在，kill 是多余动作。
      expect(fake.terminations, 0);
    });

    test('载荷报告成功但 su 未确认 uid=0 时判失败', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (_isLaunch(command)) return _ok('4242\n');
        if (_isProbe(command)) return _ok('state=gone size=987');
        if (_isCollect(command)) {
          return _ok('exploit completed\ndone=1 root=1\nexitCode=0\n');
        }
        if (_isRootCheck(command)) {
          return _ok('uid=2000(shell) gid=2000(shell)');
        }
        fail('不该走到这里: $command');
      });

      final EscalationRunResult result = await _repository(fake)
          .runPayload(_payload());

      expect(result.success, isFalse);
      expect(result.exitCode, -1);
      expect(result.stderr, contains('uid=2000'));
    });

    test('进程退出但标记不全判失败，且不算超时', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (_isLaunch(command)) return _ok('4242\n');
        if (_isProbe(command)) return _ok('state=gone size=64');
        if (_isCollect(command)) {
          return _ok('[-] open /dev/kmsg failed\nexitCode=0\n');
        }
        if (_isRootCheck(command)) fail('载荷未报告成功时不应复核 root');
        fail('不该走到这里: $command');
      });

      final EscalationRunResult result = await _repository(fake)
          .runPayload(_payload());

      expect(result.success, isFalse);
      // 退出码是 0，失败原因只能落在「标记不全」上，不能是空串。
      expect(result.exitCode, 0);
      expect(result.stderr, contains('没有成功标记'));
      expect(result.timedOut, isFalse);
      expect(result.stdout, contains('/dev/kmsg'));
    });

    test('退出码取最后一行，不被载荷自己输出里的 exitCode= 带偏', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (_isLaunch(command)) return _ok('4242\n');
        if (_isProbe(command)) return _ok('state=gone size=120');
        if (_isCollect(command)) {
          // 载荷自己打了一行 exitCode=1（例如上一轮子进程的残留），
          // 收日志脚本追加的真实退出码在最后一行。
          return _ok(
            'exitCode=1\nexploit completed\ndone=1 root=1\nexitCode=0\n',
          );
        }
        if (_isRootCheck(command)) return _ok('uid=0(root) gid=0(root)');
        fail('不该走到这里: $command');
      });

      final EscalationRunResult result = await _repository(fake)
          .runPayload(_payload());

      expect(result.success, isTrue);
      expect(result.exitCode, 0);
    });

    test('行内的 exitCode= 字样不参与退出码判定', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (_isLaunch(command)) return _ok('4242\n');
        if (_isProbe(command)) return _ok('state=gone size=120');
        if (_isCollect(command)) {
          // 只在行中出现，不是收尾脚本写的整行，不能当成退出码。
          return _ok(
            '[*] child exitCode=9 ignored\n'
            'exploit completed\ndone=1 root=1\nexitCode=0\n',
          );
        }
        if (_isRootCheck(command)) return _ok('uid=0(root) gid=0(root)');
        fail('不该走到这里: $command');
      });

      final EscalationRunResult result = await _repository(fake)
          .runPayload(_payload());

      expect(result.success, isTrue);
      expect(result.exitCode, 0);
    });

    test('日志 180 秒不增长即判停滞，并显式终止', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (_isLaunch(command)) return _ok('4242\n');
        // 进程活着，但体积一直停在 100 字节：正是卡死的特征。
        if (_isProbe(command)) return _ok('state=running size=100');
        if (_isTerminate(command)) return _ok('');
        if (_isCollect(command)) return _ok('[*] spraying...\n');
        fail('不该走到这里: $command');
      });

      final EscalationRunResult result = await _repository(fake)
          .runPayload(_payload());

      expect(result.success, isFalse);
      expect(result.timedOut, isTrue);
      expect(result.stderr, contains('180 秒'));
      // 第一次探测把体积从「未知」变成 100，第二次还停在 100 就判停滞。
      expect(fake.probes, 2);
      expect(fake.terminations, 1);
    });

    test('日志持续增长时不判停滞', () async {
      int size = 0;
      final _FakeNative fake = _FakeNative((String command) {
        if (_isLaunch(command)) return _ok('4242\n');
        if (_isProbe(command)) {
          size += 100;
          // 前几轮都还在长，最后一轮退出。
          return _ok(
            size >= 400 ? 'state=gone size=$size' : 'state=running size=$size',
          );
        }
        if (_isCollect(command)) {
          return _ok('exploit completed\ndone=1 root=1\nexitCode=0\n');
        }
        if (_isRootCheck(command)) return _ok('uid=0(root) gid=0(root)');
        fail('不该走到这里: $command');
      });

      final EscalationRunResult result = await _repository(fake)
          .runPayload(_payload());

      expect(result.success, isTrue);
      expect(fake.probes, 4);
      expect(fake.terminations, 0);
    });

    test('探测本身连续失败三次即判通道中断', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (_isLaunch(command)) return _ok('4242\n');
        if (_isProbe(command)) return _fail(-1);
        if (_isTerminate(command)) return _ok('');
        if (_isCollect(command)) {
          return _ok('exploit completed\ndone=1 root=1\n');
        }
        fail('不该走到这里: $command');
      });

      final EscalationRunResult result = await _repository(fake)
          .runPayload(_payload());

      expect(result.stderr, contains('探测通道中断'));
      expect(fake.probes, 3);
      // 通道断了也得尝试收尸，否则载荷会在设备上继续跑。
      expect(fake.terminations, 1);
    });

    test('探测读不懂时宁可提前收尾，不能当成还在跑', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (_isLaunch(command)) return _ok('4242\n');
        if (_isProbe(command)) return _ok('garbage');
        if (_isCollect(command)) {
          return _ok('exploit completed\ndone=1 root=1\nexitCode=0\n');
        }
        if (_isRootCheck(command)) return _ok('uid=0(root) gid=0(root)');
        fail('不该走到这里: $command');
      });

      final EscalationRunResult result = await _repository(fake)
          .runPayload(_payload());

      expect(fake.probes, 1);
      expect(result.success, isTrue);
    });
  });

  group('KASLR 偏移缓存', () {
    /// 合法 slide：不超过 0x1f0000，且按 0x10000 对齐。
    const String slideLine = 'slide-kaslr-ok slide=00000000001a0000\n';

    _FakeNative payloadRun({String logTail = '', String bootToken = 'boot-session-1'}) {
      int size = 0;
      return _FakeNative(
        (String command) {
          if (_isLaunch(command)) return _ok('4242\n');
          if (_isProbe(command)) {
            size += 100;
            return _ok(
              size >= 200 ? 'state=gone size=$size' : 'state=running size=$size',
            );
          }
          if (_isCollect(command)) {
            return _ok('exploit completed\ndone=1 root=1\nexitCode=0\n');
          }
          if (_isRootCheck(command)) return _ok('uid=0(root) gid=0(root)');
          fail('不该走到这里: $command');
        },
        bootToken: bootToken,
        logTail: logTail,
      );
    }

    test('日志里抓到 slide 就写盘，键是 boot_id 与偏移', () async {
      final _FakeStore store = _FakeStore();
      final _FakeNative fake = payloadRun(logTail: slideLine);

      final EscalationRunResult result = await _repository(
        fake,
        storage: store,
      ).runPayload(_payload());

      expect(result.success, isTrue);
      expect(store.values['p0_cache.offset'], 0x1a0000);
      expect(store.values['p0_cache.boot_id'], 'boot-session-1');
      // 增量读日志：只读新增的那一段，不是每轮把整份日志搬一遍。
      expect(fake.logTails, isNotEmpty);
      expect(fake.logTails.first, contains('tail -c +1 '));
    });

    test('同一次开机内第二次运行直接带 SLIDE_P0_OFFSET 起载荷', () async {
      final _FakeStore store = _FakeStore();
      await store.write<String>('p0_cache.boot_id', 'boot-session-1');
      await store.write<int>('p0_cache.offset', 0x1a0000);

      final _FakeNative fake = payloadRun();
      await _repository(fake, storage: store).runPayload(_payload());

      expect(fake.commands.first, contains('SLIDE_P0_OFFSET=0x1a0000'));
    });

    test('boot 会话变了就不复用上一次的偏移', () async {
      final _FakeStore store = _FakeStore();
      await store.write<String>('p0_cache.boot_id', '上一次开机');
      await store.write<int>('p0_cache.offset', 0x1a0000);

      final _FakeNative fake = payloadRun();
      await _repository(fake, storage: store).runPayload(_payload());

      expect(fake.commands.first, isNot(contains('SLIDE_P0_OFFSET')));
    });

    test('偏移越界时不写盘，宁可下一轮重做 P0', () async {
      final _FakeStore store = _FakeStore();

      // 0x20000 超过上限 0x1f0000；0x1f8000 没按 0x10000 对齐。
      for (final String slide in <String>[
        '0000000000200000',
        '00000000001f8000',
      ]) {
        await _repository(
          payloadRun(logTail: 'slide-kaslr-ok slide=$slide\n'),
          storage: store,
        ).runPayload(_payload());
        expect(store.values['p0_cache.offset'], isNull, reason: slide);
      }
    });

    test('读不到 boot_id 时既不读缓存也不写缓存', () async {
      final _FakeStore store = _FakeStore();
      final _FakeNative fake = payloadRun(logTail: slideLine, bootToken: '');

      final EscalationRunResult result = await _repository(
        fake,
        storage: store,
      ).runPayload(_payload());

      expect(result.success, isTrue);
      expect(fake.commands.first, isNot(contains('SLIDE_P0_OFFSET')));
      expect(store.values, isEmpty);
    });
  });

  group('移交阶段', () {
    /// 管理器安装目录里的 ksud，形如 `find` 会打出来的真实路径。
    const String ksudPath =
        '/data/app/~~abc==/me.weishu.kernelsu-xyz==/lib/arm64/libksud.so';

    /// 定位 + `late-load` 合成的那一条命令：两者必须在同一个 shell 会话里。
    bool isHandoff(String command) =>
        command.contains('find /data/app') && command.contains('late-load');

    /// 只在「没有 root」之后才跑的 su 候选诊断命令。
    bool isDiagnose(String command) => command.contains('probe=');

    test('先探 root，再用同一条 su 完成定位与 late-load', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (_isRootCheck(command)) return _ok('uid=0(root) gid=0(root)');
        if (isHandoff(command)) return _ok('KSUD=$ksudPath\nlate load ok\n');
        fail('不该走到这里: $command');
      });

      final HandoffOutcome result = await _repository(
        fake,
      ).handoffRoot(manager: RootManager.kernelsu);

      expect(result.kind, HandoffKind.success);
      expect(result.exitCode, 0);
      expect(result.ksudPath, ksudPath);
      // 两次 su：定位与 late-load 必须活在同一次 shell 会话里，`$KSUD` 才传得
      // 下去。拆成两条不只是多弹一次授权框，中间还有 TOCTOU 窗口。
      expect(fake.commands, hasLength(2));

      final String handoff = fake.commands[1];
      expect(handoff, contains(r'KSUD=\$(find /data/app -name libksud.so'));
      expect(handoff, contains('| grep -F me.weishu.kernelsu | head -n 1'));
      expect(handoff, contains(r'if [ -z \"\$KSUD\" ]'));
      expect(handoff, contains(r'echo \"NO_KSUD\"; exit 3'));
      expect(handoff, contains(r'echo \"KSUD=\$KSUD\"'));
      expect(handoff, contains(r'\"\$KSUD\" late-load --allow-shell'));
      expect(handoff, contains('--package-name me.weishu.kernelsu'));
    });

    test('没有 root 时只提示并附候选诊断，不发移交命令', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (_isRootCheck(command)) {
          return _ok('uid=2000(shell) gid=2000(shell)');
        }
        if (isDiagnose(command)) {
          return _ok(
            'probe=/apex/com.android.virt/bin/su exit=1 out=permission denied',
          );
        }
        fail('没 root 不该继续: $command');
      });

      final HandoffOutcome result = await _repository(
        fake,
      ).handoffRoot(manager: RootManager.kernelsu);

      expect(result.kind, HandoffKind.noRoot);
      expect(result.success, isFalse);
      // 进不去 /data/app 的 find 只会返回空，别把「没 root」说成「没装管理器」。
      expect(fake.commands, hasLength(2));
      expect(isHandoff(fake.commands[1]), isFalse);
      // 诊断只在已经失败之后才跑，把每条候选的实际情况摊进输出：
      // 路径不存在 / 被管理器拒绝 / 授权框超时，三种原因的处置完全不同。
      expect(result.output, contains('--- su 候选诊断 ---'));
      expect(result.output, contains('probe=/apex/com.android.virt/bin/su'));
    });

    test('su 走候选路径解析，不赌 PATH', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (_isRootCheck(command)) return _ok('uid=0(root) gid=0(root)');
        if (isHandoff(command)) return _ok('KSUD=$ksudPath\nok\n');
        fail('不该走到这里: $command');
      });

      await _repository(fake).handoffRoot(manager: RootManager.kernelsu);

      // 探身份与移交都借 root shell；诊断命令不在这里跑（它要逐条试候选本身）。
      expect(fake.commands, hasLength(2));
      for (final String command in fake.commands) {
        // 载荷把 su 落在 /apex/com.android.virt/bin，该目录不在默认 PATH。
        expect(
          command,
          contains('for c in /apex/com.android.virt/bin/su /product/bin/su'),
        );
        expect(command, contains('[ -x "\$c" ]'));
        expect(command, contains('if [ -z "\$SU" ]; then SU=su; fi'));
        expect(command, contains('"\$SU" -c "'));
      }
    });

    test('找不到 libksud.so 时归为「管理器没装」而不是笼统失败', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (_isRootCheck(command)) return _ok('uid=0(root) gid=0(root)');
        if (isHandoff(command)) return _fail(3, stderr: 'NO_KSUD\n');
        fail('不该走到这里: $command');
      });

      final HandoffOutcome result = await _repository(
        fake,
      ).handoffRoot(manager: RootManager.sukisu);

      // 这是最常见的一种失败，必须单独分型：用户唯一能自救的动作是去装管理器。
      expect(result.kind, HandoffKind.managerMissing);
      expect(result.exitCode, 3);
      expect(result.manager, RootManager.sukisu);
      expect(fake.commands, hasLength(2));
      expect(fake.commands[1], contains('grep -F com.sukisu.ultra'));
    });

    test('只有退出码 3、没有 NO_KSUD 字样时仍按未安装处理', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (_isRootCheck(command)) return _ok('uid=0(root) gid=0(root)');
        if (isHandoff(command)) return _fail(3);
        fail('不该走到这里: $command');
      });

      final HandoffOutcome result = await _repository(
        fake,
      ).handoffRoot(manager: RootManager.kernelsu);

      // 脚本提前挂掉时可能只留下退出码，标记未必打得出来。
      expect(result.kind, HandoffKind.managerMissing);
    });

    test('ksud 路径含无法转义的字符时拒绝转述', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (_isRootCheck(command)) return _ok('uid=0(root) gid=0(root)');
        if (isHandoff(command)) return _ok('KSUD=/data/app/x/libksud.so"\n');
        fail('不该走到这里: $command');
      });

      final HandoffOutcome result = await _repository(
        fake,
      ).handoffRoot(manager: RootManager.kernelsu);

      expect(result.kind, HandoffKind.failed);
      expect(result.output, contains('无法安全转义'));
      expect(fake.commands, hasLength(2));
    });

    test('late-load 退出码非 0 即失败，退出码原样透传', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (_isRootCheck(command)) return _ok('uid=0(root) gid=0(root)');
        if (isHandoff(command)) return _fail(7, stderr: 'no kernel module');
        fail('不该走到这里: $command');
      });

      final HandoffOutcome result = await _repository(
        fake,
      ).handoffRoot(manager: RootManager.kernelsu);

      expect(result.kind, HandoffKind.failed);
      expect(result.exitCode, 7);
      expect(result.output, contains('no kernel module'));
    });

    test('退 0 但输出含失败关键字时不给假成功', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (_isRootCheck(command)) return _ok('uid=0(root) gid=0(root)');
        if (isHandoff(command)) {
          return _ok('KSUD=$ksudPath\nlate-load: permission denied\n');
        }
        fail('不该走到这里: $command');
      });

      final HandoffOutcome result = await _repository(
        fake,
      ).handoffRoot(manager: RootManager.kernelsu);

      expect(result.kind, HandoffKind.failed);
      expect(result.exitCode, 0);
      expect(result.output, contains('denied'));
      // 路径已经定位到了，失败发生在 late-load 那一步——两件事的处置不同。
      expect(result.ksudPath, ksudPath);
    });

    test('退 0 但输出含 failure 也判失败', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (_isRootCheck(command)) return _ok('uid=0(root) gid=0(root)');
        if (isHandoff(command)) {
          return _ok('KSUD=$ksudPath\nlate-load: module failure\n');
        }
        fail('不该走到这里: $command');
      });

      final HandoffOutcome result = await _repository(
        fake,
      ).handoffRoot(manager: RootManager.kernelsu);

      expect(result.kind, HandoffKind.failed);
      expect(result.output, contains('failure'));
    });

    test('非 0 且没有任何输出时仍按失败处理，退出码不丢', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (_isRootCheck(command)) return _ok('uid=0(root) gid=0(root)');
        if (isHandoff(command)) return _fail(1);
        fail('不该走到这里: $command');
      });

      final HandoffOutcome result = await _repository(
        fake,
      ).handoffRoot(manager: RootManager.kernelsu);

      // 兜底原因交给 UI 按 kind 出文案，这里只保证退出码与分型不丢。
      expect(result.kind, HandoffKind.failed);
      expect(result.exitCode, 1);
      expect(result.output, isEmpty);
    });

    test('退 0 且无输出仍按退出码判成功', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (_isRootCheck(command)) return _ok('uid=0(root) gid=0(root)');
        if (isHandoff(command)) return _ok('');
        fail('不该走到这里: $command');
      });

      final HandoffOutcome result = await _repository(
        fake,
      ).handoffRoot(manager: RootManager.kernelsu);

      expect(result.kind, HandoffKind.success);
      expect(result.ksudPath, isEmpty);
      expect(result.output, isEmpty);
    });

    test('移交不动载荷的进程号与日志，只发探 root 与移交两条', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (_isRootCheck(command)) return _ok('uid=0(root) gid=0(root)');
        if (isHandoff(command)) return _ok('KSUD=$ksudPath\nok\n');
        fail('不该走到这里: $command');
      });

      await _repository(fake).handoffRoot(manager: RootManager.kernelsu);

      expect(fake.commands, hasLength(2));
      expect(fake.probes, 0);
      expect(fake.terminations, 0);
      expect(fake.logTails, isEmpty);
    });
  });
}
