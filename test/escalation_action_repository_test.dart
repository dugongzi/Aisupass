import 'dart:typed_data';

import 'package:Aisupass/core/storage/json_codec.dart';
import 'package:Aisupass/core/storage/key_value_store.dart';
import 'package:Aisupass/core/utils/handoff_script.dart';
import 'package:Aisupass/features/escalation/data/datasources/escalation_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/repositories/escalation_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/domain/enums/handoff_kind.dart';
import 'package:Aisupass/features/escalation/domain/models/handoff_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:Aisupass/generated/adb_shell.g.dart' as pigeon;
import 'package:flutter_test/flutter_test.dart';

/// 安装后的原生库目录。带 `~~` 和 `==`，用来验证命令里的引号没漏。
const String _directory =
    '/data/app/~~abc==/org.supass.ai_su_pass-xyz==/lib/arm64';

/// 移交只吃包名与名字，图标给空字节即可。
final RootManager _kernelsu = RootManager(
  packageName: 'me.weishu.kernelsu',
  displayName: 'KernelSU',
  icon: Uint8List(0),
);
final RootManager _sukisu = RootManager(
  packageName: 'com.sukisu.ultra',
  displayName: 'SukiSU Ultra',
  icon: Uint8List(0),
);

Payload _payload({
  bool standalone = false,
  String command = 'LD_PRELOAD=<payload> /system/bin/id',
}) => Payload(
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
  command: command,
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

bool _isLaunch(String command) => command.contains('EXPLOIT_ATTEMPTS=24');
bool _isStandaloneLaunch(String command) =>
    command.contains('</dev/null') && !command.contains('--run-payload');
bool _isKernelRelease(String command) => command.contains('uname -r');
bool _isBootId(String command) =>
    command.contains('/proc/sys/kernel/random/boot_id');
bool _isFileTest(String command) => command.startsWith('test ');

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
/// 数据源现在只**拼**命令，不执行它；真正被下发的只有 `boot_id`（读缓存凭据）
/// 与独立载荷的 `uname -r`（补参数）。前者由这里直接应答、不进 [commands]，
/// 免得把业务断言里的命令条数搅乱。
class _FakeNative extends pigeon.AdbShellNative {
  _FakeNative(
    this.handler, {
    this.directory = _directory,
    this.bootToken = 'boot-session-1',
  });

  final pigeon.ShellExecResult Function(String command) handler;
  final String directory;

  /// `boot_id` 的读数；置空表示读不到。
  final String bootToken;

  final List<String> commands = <String>[];

  @override
  Future<pigeon.ShellExecResult> exec(
    String command,
    int timeoutMs,
    Uint8List? stdin,
  ) async {
    if (_isBootId(command)) {
      return bootToken.isEmpty ? _fail(1) : _ok('$bootToken\n');
    }
    commands.add(command);
    return handler(command);
  }

  @override
  Future<String> nativeLibraryDir() async => directory;
}

/// 装配仓储。
///
/// 数据源现在收「执行出口」而不是「原生桥」：`native` 只留着读
/// `nativeLibraryDir`，命令一律走 `exec`。测试里把两条都指向同一个
/// [_FakeNative]，保持「按命令内容分流」的既有断言不变。
EscalationActionRepositoryImpl _repository(
  _FakeNative native, {
  KeyValueStore? storage,
}) => EscalationActionRepositoryImpl(
  datasource: EscalationActionDatasource(
    native: native,
    exec: (String command, int timeoutMs) =>
        native.exec(command, timeoutMs, null),
    storage: storage ?? _FakeStore(),
  ),
);

void main() {
  group('拼命令阶段', () {
    test('命令里只拼执行体，文件存在性由设备侧 test 前置检查', () async {
      final _FakeNative fake = _FakeNative(
        (String command) => _isFileTest(command)
            ? _ok('')
            : fail('拼命令阶段不该真的执行载荷: $command'),
      );

      final String launch = await _repository(fake).runPayload(_payload());

      expect(_isLaunch(launch), isTrue);
      // 提示改由 Dart 侧写屏，命令行里不再夹 echo 兜底。
      expect(launch, isNot(contains('echo ')));
      // 绝不用 `exit`：那会关掉整条终端会话，用户还得重连。
      expect(launch, isNot(contains('exit ')));
      // 环境变量直接做命令前缀，不能借 `env`：目录里的 `==` 会被 `env` 当成
      // 变量赋值吞掉，助手路径消失，设备上只剩 `env: exec --run-payload: ...`。
      expect(launch, isNot(contains('env ')));
      expect(launch, contains('EXPLOIT_ATTEMPTS=24'));
      expect(launch, contains('P0_ATTEMPT_TIMEOUT_SEC=45'));
      expect(launch, contains('EXPLOIT_ATTEMPT_TIMEOUT_SEC=120'));
      // 路径必须被单引号包住，否则 `~~` 和 `==` 会被 shell 解释。
      expect(
        launch,
        contains(
          "'$_directory/libcve43499root.so' --run-payload "
          "'$_directory/libksu_vivo_iqoo13_6657_a.so' "
          "'$_directory/libcve43499root.so' /dev/stdout",
        ),
      );
      // 载荷不该等键盘；这不妨碍 Ctrl+C（SIGINT 按前台进程组投递）。
      expect(launch, contains('</dev/null'));
      // 助手与载荷各查一次，且都是不上屏的一次性通道。
      final List<String> tests = fake.commands.where(_isFileTest).toList();
      expect(tests, hasLength(2));
      expect(tests.first, startsWith('test -x '));
      expect(tests.last, startsWith('test -e '));
    });

    test('原生库目录为空时抛异常，不拼助手命令', () async {
      final _FakeNative fake = _FakeNative(
        (String command) => fail('不该发命令: $command'),
        directory: '',
      );

      expect(
        () => _repository(fake).runPayload(_payload()),
        throwsA(
          isA<PayloadLaunchException>().having(
            (PayloadLaunchException e) => e.code,
            'code',
            'libraryDirUnavailable',
          ),
        ),
      );
      expect(fake.commands, isEmpty);
    });

    test('standalone 载荷直接跑本体，参数按设备内核补齐', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (_isKernelRelease(command)) return _ok('6.6.89-android15-8-gabcd\n');
        if (_isFileTest(command)) return _ok('');
        fail('不该走到这里: $command');
      });

      final String launch = await _repository(fake).runPayload(
        _payload(
          standalone: true,
          command: '/data/local/tmp/mi_mt6895_43499 --target <内核版本的后三位>',
        ),
      );

      expect(_isStandaloneLaunch(launch), isTrue);
      // 执行的是本 App 目录下那份，不是 catalog 文案里的落点。
      expect(
        launch,
        contains("'$_directory/libksu_vivo_iqoo13_6657_a.so' --target 89"),
      );
      // 不过助手：没有 --run-payload，也没有助手的环境变量。
      expect(launch, isNot(contains('--run-payload')));
      expect(launch, isNot(contains('EXPLOIT_ATTEMPTS')));
      expect(launch, isNot(contains('echo ')));
      // 本体也必须可执行，检查走设备侧 test，不上屏。
      expect(fake.commands.where(_isFileTest), hasLength(1));
      expect(launch, contains('</dev/null'));
      // 补参数要靠设备真实内核版本，所以确实读了 `uname -r`。
      expect(fake.commands.where(_isKernelRelease), hasLength(1));
    });

    test('standalone 占位符补不齐时抛异常，不拼启动命令', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (_isKernelRelease(command)) return _fail(1);
        fail('不该走到这里: $command');
      });

      expect(
        () => _repository(fake).runPayload(
          _payload(
            standalone: true,
            command: '/data/local/tmp/mi_mt6895_43499 --target <内核版本的后三位>',
          ),
        ),
        throwsA(
          isA<PayloadLaunchException>().having(
            (PayloadLaunchException e) => e.code,
            'code',
            'argumentsUnresolved',
          ),
        ),
      );
      expect(fake.commands.where(_isFileTest), isEmpty);
    });
  });

  group('KASLR 偏移缓存', () {
    /// 合法 slide：不超过 0x1f0000，且按 0x10000 对齐。
    const String slideLine = 'slide-kaslr-ok slide=00000000001a0000\n';

    _FakeNative planner({String bootToken = 'boot-session-1'}) => _FakeNative(
      (String command) => _isFileTest(command)
          ? _ok('')
          : fail('拼命令阶段不该真的执行载荷: $command'),
      bootToken: bootToken,
    );

    test('屏幕上出现 slide 就写盘，键是 boot_id 与偏移', () async {
      final _FakeStore store = _FakeStore();
      final EscalationActionRepositoryImpl repository = _repository(
        planner(),
        storage: store,
      );

      // 先拼一次，让数据源挂住本次运行的 boot token。
      await repository.runPayload(_payload());
      repository.observeOutput(slideLine);
      await pumpEventQueue();

      expect(store.values['p0_cache.offset'], 0x1a0000);
      expect(store.values['p0_cache.boot_id'], 'boot-session-1');
    });

    test('被切开的记录跨两次输出也能拼回来', () async {
      final _FakeStore store = _FakeStore();
      final EscalationActionRepositoryImpl repository = _repository(
        planner(),
        storage: store,
      );

      await repository.runPayload(_payload());
      repository.observeOutput('[*] slide-kaslr-ok slide=00000000001a');
      await pumpEventQueue();
      repository.observeOutput('0000\n');
      await pumpEventQueue();

      expect(store.values['p0_cache.offset'], 0x1a0000);
    });

    test('同一次开机内第二次运行直接带 SLIDE_P0_OFFSET 起载荷', () async {
      final _FakeStore store = _FakeStore();
      await store.write<String>('p0_cache.boot_id', 'boot-session-1');
      await store.write<int>('p0_cache.offset', 0x1a0000);

      final String launch = await _repository(
        planner(),
        storage: store,
      ).runPayload(_payload());

      expect(launch, contains('SLIDE_P0_OFFSET=0x1a0000'));
    });

    test('boot 会话变了就不复用上一次的偏移', () async {
      final _FakeStore store = _FakeStore();
      await store.write<String>('p0_cache.boot_id', '上一次开机');
      await store.write<int>('p0_cache.offset', 0x1a0000);

      final String launch = await _repository(
        planner(),
        storage: store,
      ).runPayload(_payload());

      expect(launch, isNot(contains('SLIDE_P0_OFFSET')));
    });

    test('偏移越界时不写盘，宁可下一轮重做 P0', () async {
      final _FakeStore store = _FakeStore();
      final EscalationActionRepositoryImpl repository = _repository(
        planner(),
        storage: store,
      );

      await repository.runPayload(_payload());

      // 0x20000 超过上限 0x1f0000；0x1f8000 没按 0x10000 对齐。
      for (final String slide in <String>[
        '0000000000200000',
        '00000000001f8000',
      ]) {
        repository.observeOutput('slide-kaslr-ok slide=$slide\n');
        await pumpEventQueue();
        expect(store.values['p0_cache.offset'], isNull, reason: slide);
      }
    });

    test('读不到 boot_id 时既不读缓存也不写缓存', () async {
      final _FakeStore store = _FakeStore();
      final EscalationActionRepositoryImpl repository = _repository(
        planner(bootToken: ''),
        storage: store,
      );

      final String launch = await repository.runPayload(_payload());
      repository.observeOutput(slideLine);
      await pumpEventQueue();

      expect(launch, isNot(contains('SLIDE_P0_OFFSET')));
      expect(store.values, isEmpty);
    });
  });

  group('移交阶段', () {
    /// 管理器安装目录里的 ksud，形如原生定位器给出的真实路径。
    const String ksudPath =
        '/data/app/~~abc==/me.weishu.kernelsu-xyz==/lib/arm64/libksud.so';

    /// 接管 + `late-load` 合成的那一条命令：两者必须在同一个 shell 会话里。
    bool isHandoff(String command) => command.contains('late-load');

    test('用同一条 su 完成接管与 late-load，不做 root 预检', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (isHandoff(command)) return _ok('KSUD=$ksudPath\nlate load ok\n');
        fail('不该走到这里: $command');
      });

      final HandoffOutcome result = await _repository(fake)
          .handoffRoot(manager: _kernelsu, ksudPath: ksudPath);

      expect(result.kind, HandoffKind.success);
      expect(result.exitCode, 0);
      expect(result.ksudPath, ksudPath);
      // 只发一条：接管与 late-load 必须活在同一次 shell 会话里，`$KSUD` 才传得
      // 下去。拆成两条不只是多弹一次授权框，中间还有 TOCTOU 窗口。
      expect(fake.commands, hasLength(1));

      final String handoff = fake.commands[0];
      // 路径原样来自原生定位器，单引号包住直接用，脚本不再自己找。
      expect(handoff, contains("KSUD='$ksudPath';"));
      expect(handoff, isNot(contains('find /data/app')));
      expect(handoff, contains(r'echo \"KSUD=\$KSUD\"'));
      expect(handoff, contains(r'\"\$KSUD\" late-load --allow-shell'));
      expect(handoff, contains('--package-name me.weishu.kernelsu'));
    });

    test('su 走候选路径解析，不赌 PATH', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (isHandoff(command)) return _ok('KSUD=$ksudPath\nok\n');
        fail('不该走到这里: $command');
      });

      await _repository(fake).handoffRoot(manager: _kernelsu, ksudPath: ksudPath);

      expect(fake.commands, hasLength(1));
      for (final String command in fake.commands) {
        // 载荷把 su 落在 /data/local/tmp，该目录不在默认 PATH。
        expect(
          command,
          contains('for c in /data/local/tmp/su /apex/com.android.virt/bin/su'),
        );
        expect(command, contains('[ -x "\$c" ]'));
        expect(command, contains('if [ -z "\$SU" ]; then SU=su; fi'));
        expect(command, contains('"\$SU" -c "'));
      }
    });

    test('原生没给出 ksud 路径时归为「管理器没装」而不是笼统失败', () async {
      final _FakeNative fake = _FakeNative((String command) {
        // 空路径时脚本只打标记就退，不会尝试 late-load。
        expect(command, contains('NO_KSUD'));
        return _fail(3, stderr: 'NO_KSUD\n');
      });

      final HandoffOutcome result = await _repository(fake)
          .handoffRoot(manager: _sukisu, ksudPath: '');

      // 这是最常见的一种失败，必须单独分型：用户唯一能自救的动作是去装管理器。
      expect(result.kind, HandoffKind.managerMissing);
      expect(result.exitCode, 3);
      expect(result.manager.packageName, 'com.sukisu.ultra');
      expect(fake.commands, hasLength(1));
    });

    test('只有退出码 3、没有 NO_KSUD 字样时仍按未安装处理', () async {
      final _FakeNative fake = _FakeNative((String command) => _fail(3));

      final HandoffOutcome result = await _repository(fake)
          .handoffRoot(manager: _kernelsu, ksudPath: ksudPath);

      // 脚本提前挂掉时可能只留下退出码，标记未必打得出来。
      expect(result.kind, HandoffKind.managerMissing);
    });

    test('设备没有 su 时单独分型，不并入一般失败', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (isHandoff(command)) {
          return _fail(
            127,
            stderr: '/system/bin/sh: su: inaccessible or not found\n',
          );
        }
        fail('不该走到这里: $command');
      });

      final HandoffOutcome result = await _repository(fake)
          .handoffRoot(manager: _kernelsu, ksudPath: ksudPath);

      expect(result.kind, HandoffKind.noSu);
      expect(result.exitCode, 127);
    });

    test('late-load 退出码非 0 即失败，退出码原样透传', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (isHandoff(command)) return _fail(7, stderr: 'no kernel module');
        fail('不该走到这里: $command');
      });

      final HandoffOutcome result = await _repository(fake)
          .handoffRoot(manager: _kernelsu, ksudPath: ksudPath);

      expect(result.kind, HandoffKind.failed);
      expect(result.exitCode, 7);
      expect(result.output, contains('no kernel module'));
    });

    test('退 0 但输出含失败关键字时不给假成功', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (isHandoff(command)) {
          return _ok('KSUD=$ksudPath\nlate-load: permission denied\n');
        }
        fail('不该走到这里: $command');
      });

      final HandoffOutcome result = await _repository(fake)
          .handoffRoot(manager: _kernelsu, ksudPath: ksudPath);

      expect(result.kind, HandoffKind.failed);
      expect(result.exitCode, 0);
      expect(result.output, contains('denied'));
      // 路径已经定位到了，失败发生在 late-load 那一步——两件事的处置不同。
      expect(result.ksudPath, ksudPath);
    });

    test('退 0 但输出含 failure 也判失败', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (isHandoff(command)) {
          return _ok('KSUD=$ksudPath\nlate-load: module failure\n');
        }
        fail('不该走到这里: $command');
      });

      final HandoffOutcome result = await _repository(fake)
          .handoffRoot(manager: _kernelsu, ksudPath: ksudPath);

      expect(result.kind, HandoffKind.failed);
      expect(result.output, contains('failure'));
    });

    test('非 0 且没有任何输出时仍按失败处理，退出码不丢', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (isHandoff(command)) return _fail(1);
        fail('不该走到这里: $command');
      });

      final HandoffOutcome result = await _repository(fake)
          .handoffRoot(manager: _kernelsu, ksudPath: ksudPath);

      // 兜底原因交给 UI 按 kind 出文案，这里只保证退出码与分型不丢。
      expect(result.kind, HandoffKind.failed);
      expect(result.exitCode, 1);
      expect(result.output, isEmpty);
    });

    test('退 0 且无输出仍按退出码判成功', () async {
      final _FakeNative fake = _FakeNative((String command) {
        if (isHandoff(command)) return _ok('');
        fail('不该走到这里: $command');
      });

      final HandoffOutcome result = await _repository(fake)
          .handoffRoot(manager: _kernelsu, ksudPath: ksudPath);

      expect(result.kind, HandoffKind.success);
      expect(result.ksudPath, isEmpty);
      expect(result.output, isEmpty);
    });

    test('原生已解析出 ksud 路径时直接用该路径', () async {
      const String resolved =
          '/data/app/~~abc==/com.sukisu.ultra-xyz==/lib/arm64/librenamed.so';
      final _FakeNative fake = _FakeNative((String command) {
        if (isHandoff(command)) return _ok('KSUD=$resolved\nok\n');
        fail('不该走到这里: $command');
      });

      final HandoffOutcome result = await _repository(fake)
          .handoffRoot(manager: _sukisu, ksudPath: resolved);

      expect(result.kind, HandoffKind.success);
      expect(result.ksudPath, resolved);
      final String handoff = fake.commands.single;
      expect(handoff, contains("KSUD='$resolved';"));
      // 改了名的管理器拿不到固定文件名，只能靠原生给的全路径。
      expect(handoff, isNot(contains('find /data/app')));
      expect(handoff, contains('--package-name com.sukisu.ultra'));
    });

    test('原生给的路径含无法安全转义的字符时直接判没找到', () {
      // 不退回按文件名找：路径已经不可信，只能如实报「没有可用的 ksud」。
      final String handoff = HandoffScript.build(
        'me.weishu.kernelsu',
        ksudPath: '/data/app/x/libksud.so"',
      );

      expect(handoff, contains('NO_KSUD'));
      expect(handoff, contains('exit 3'));
      expect(handoff, isNot(contains('find')));
      expect(handoff, isNot(contains('late-load')));
    });
  });
}
