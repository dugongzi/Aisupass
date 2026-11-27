import 'dart:async';

import 'package:Aisupass/core/providers/adb_shell_provider.dart';
import 'package:Aisupass/core/providers/channel_exec_provider.dart';
import 'package:Aisupass/core/providers/escalation_native_provider.dart';
import 'package:Aisupass/core/storage/storage_providers.dart';
import 'package:Aisupass/features/escalation/data/datasources/dirty_frag_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/datasources/escalation_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/datasources/escalation_query_datasource.dart';
import 'package:Aisupass/features/escalation/data/datasources/ghost_key_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/datasources/ghost_lock_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/datasources/ghost_lock_profile_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/datasources/ghost_lock_profile_edit_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/repositories/dirty_frag_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/data/repositories/escalation_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/data/repositories/ghost_key_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/data/repositories/ghost_lock_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/data/repositories/ghost_lock_profile_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/data/repositories/ghost_lock_profile_edit_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/domain/models/dirty_frag_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/dirty_frag_run_defaults.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_preflight.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_run_defaults.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_import_result.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_preflight.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_probe.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_probe_progress.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_config.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_user_profile.dart';
import 'package:Aisupass/features/escalation/domain/models/handoff_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:Aisupass/features/escalation/domain/models/payload_match.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:Aisupass/features/escalation/domain/models/vr_derive_progress.dart';
import 'package:Aisupass/features/escalation/domain/models/vr_offset_result.dart';
import 'package:Aisupass/features/escalation/domain/repositories/dirty_frag_action_repository.dart';
import 'package:Aisupass/features/escalation/domain/repositories/escalation_action_repository.dart';
import 'package:Aisupass/features/escalation/domain/repositories/escalation_query_repository.dart';
import 'package:Aisupass/features/escalation/domain/repositories/ghost_key_action_repository.dart';
import 'package:Aisupass/features/escalation/domain/repositories/ghost_lock_action_repository.dart';
import 'package:Aisupass/features/escalation/domain/repositories/ghost_lock_profile_action_repository.dart';
import 'package:Aisupass/features/escalation/domain/repositories/ghost_lock_profile_edit_action_repository.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'escalation_action_provider.g.dart';

/// 提权链路执行数据源。
@riverpod
EscalationActionDatasource escalationActionDatasource(Ref ref) =>
    EscalationActionDatasource(
      native: ref.watch(adbShellNativeProvider),
      exec: ref.watch(channelShellExecProvider),
      storage: ref.watch(preferencesStoreProvider),
    );

/// 提权链路执行仓储。
@riverpod
EscalationActionRepository escalationActionRepository(Ref ref) =>
    EscalationActionRepositoryImpl(
      datasource: ref.watch(escalationActionDatasourceProvider),
    );

/// 自动匹配并拼出执行载荷的那一行命令。
///
/// 「选哪份」归查询仓储，「拼命令」归执行仓储，两者的装配只在这里发生。
/// 没有候选时抛 [PayloadLaunchException]，文案由展示层写屏。
@riverpod
Future<String> runPayload(Ref ref) async {
  final EscalationQueryRepository query = ref.watch(
    escalationQueryRepositoryProvider,
  );
  final EscalationActionRepository action = ref.watch(
    escalationActionRepositoryProvider,
  );

  final PayloadMatch? match = await query.resolve();
  if (match == null) {
    throw const PayloadLaunchException('noCandidate');
  }
  return action.runPayload(match.payload);
}

/// 用指定载荷拼出执行命令，跳过自动匹配。
///
/// 与 [runPayload] 共用执行仓储，区别只在「哪一条」是调用方给的，还是查出来的。
/// 用户在载荷清单里手动指定时走这里。
@riverpod
Future<String> runPayloadChoice(Ref ref, {required Payload payload}) =>
    ref.watch(escalationActionRepositoryProvider).runPayload(payload);

/// 提权链路的写操作。
///
/// 无参 `keepAlive` 类持有 [Ref]，参数走方法入参。
@Riverpod(keepAlive: true)
EscalationActions escalationActions(Ref ref) => EscalationActions(ref);

/// 见 [escalationActions]。
class EscalationActions {
  EscalationActions(this._ref);

  final Ref _ref;

  /// 终端上来一段输出就喂一次，供滑动缓存提取 KASLR 偏移。
  Future<void> observePayloadOutput(String text) async =>
      _ref.read(escalationActionRepositoryProvider).observeOutput(text);
}

/// 把临时 root 移交给用户选定的 [manager]，成功后把该管理器拉到前台。
///
/// 先由原生按该管理器解析 ksud 路径（支持改了名的管理器），再拼脚本；
/// 管理器未安装时返回 [HandoffKind.managerMissing]，不抛异常。
@riverpod
Future<HandoffOutcome> handoffRoot(Ref ref, {required RootManager manager}) async {
  final EscalationQueryDatasource query = ref.watch(
    escalationQueryDatasourceProvider,
  );
  final String ksudPath = await query.resolveKsudPath(manager.packageName);
  final HandoffOutcome outcome = await ref
      .watch(escalationActionRepositoryProvider)
      .handoffRoot(manager: manager, ksudPath: ksudPath);
  // 移交成功后主动把管理器拉到前台。
  //
  // 这一步原先只有官方 KernelSU 才「有」：它的 ksud 在 `late-load` 收尾自己跑
  // `am force-stop` + `am start -n <包名>/me.weishu.kernelsu.ui.MainActivity`。
  // 第三方分支要么没这段，要么组件名对不上，用户就会觉得移交没生效。
  if (outcome.success) {
    unawaited(_launchManagerAfterHandoff(query, manager.packageName));
  }
  return outcome;
}

/// 移交成功后拉起管理器的延迟。
///
/// `ksud late-load` 进来第一件事就是 daemonize：shell 命令退 0 时模块其实还在后台
/// 加载，官方 ksud 的收尾（`am force-stop` + `am start`）也在那之后。立刻拉起会被
/// 它顺手杀掉，所以等它把这一轮跑完再拉。
const Duration _managerLaunchDelay = Duration(milliseconds: 1500);

/// 延迟拉起目标管理器；拉起失败不影响移交结果，只留在原生日志里。
Future<void> _launchManagerAfterHandoff(
  EscalationQueryDatasource query,
  String packageName,
) async {
  await Future<void>.delayed(_managerLaunchDelay);
  await query.launchRootManager(packageName);
}

/// root 管理器的写操作。
///
/// 形态同 `aiConfigActions`：无参 `keepAlive` 类持有 [Ref]，参数走方法入参。
/// 带参族函数会按参数缓存，同样的参数第二次调用不再执行方法体。
@Riverpod(keepAlive: true)
RootManagerActions rootManagerActions(Ref ref) => RootManagerActions(ref);

/// 见 [rootManagerActions]。
class RootManagerActions {
  RootManagerActions(this._ref);

  final Ref _ref;

  /// 记住用户选定的管理器，落盘后失效 [selectedRootManagerProvider]。
  Future<void> select(RootManager manager) async {
    await _ref
        .read(escalationActionRepositoryProvider)
        .selectRootManager(manager: manager);
    _ref.invalidate(selectedRootManagerProvider);
  }
}

/// DirtyFrag 运行数据源。
@riverpod
DirtyFragActionDatasource dirtyFragActionDatasource(Ref ref) =>
    DirtyFragActionDatasource(native: ref.watch(dirtyFragNativeProvider));

/// DirtyFrag 运行仓储。
@riverpod
DirtyFragActionRepository dirtyFragActionRepository(Ref ref) =>
    DirtyFragActionRepositoryImpl(
      datasource: ref.watch(dirtyFragActionDatasourceProvider),
    );

/// 本次开机是否已经注入过。
@riverpod
Future<bool> dirtyFragArmed(Ref ref) =>
    ref.watch(dirtyFragActionRepositoryProvider).isArmed();

/// 运行默认值（设置页四个开关的当前值）。
@riverpod
Future<DirtyFragRunDefaults> dirtyFragRunDefaults(Ref ref) =>
    ref.watch(dirtyFragActionRepositoryProvider).runDefaults();

/// DirtyFrag 设置页的写操作。
///
/// 同 [rootManagerActions]：无参类，参数走方法入参。
@Riverpod(keepAlive: true)
DirtyFragActions dirtyFragActions(Ref ref) => DirtyFragActions(ref);

/// 见 [dirtyFragActions]。
class DirtyFragActions {
  DirtyFragActions(this._ref);

  final Ref _ref;

  /// 写运行默认值。四个字段整体覆盖。
  Future<void> saveRunDefaults(DirtyFragRunDefaults defaults) async {
    await _ref
        .read(dirtyFragActionRepositoryProvider)
        .saveRunDefaults(defaults: defaults);
    _ref.invalidate(dirtyFragRunDefaultsProvider);
  }

  /// 切换专家模式。
  Future<void> setExpertMode({required bool enabled}) async {
    await _ref
        .read(dirtyFragActionRepositoryProvider)
        .setExpertModeEnabled(enabled: enabled);
    _ref.invalidate(dirtyFragExpertModeProvider);
    _ref.invalidate(dirtyFragBootAutostartProvider);
  }

  /// 切换开机自启。
  Future<void> setBootAutostart({required bool enabled}) async {
    await _ref
        .read(dirtyFragActionRepositoryProvider)
        .setBootAutostartEnabled(enabled: enabled);
    _ref.invalidate(dirtyFragBootAutostartProvider);
  }

  /// 停止本侧读取；设备侧进程继续跑。
  Future<void> cancel() =>
      _ref.read(dirtyFragActionRepositoryProvider).cancel();

  /// 跑一次 DirtyFrag，按块吐出证据。
  Stream<DirtyFragOutcome> run({
    required RootManager manager,
    int? vrOffsetOverride,
  }) => _ref
      .read(dirtyFragActionRepositoryProvider)
      .run(manager: manager, vrOffsetOverride: vrOffsetOverride);
}

/// 跑一次 DirtyFrag，按块吐出证据。
@riverpod
Stream<DirtyFragOutcome> runDirtyFrag(
  Ref ref, {
  required RootManager manager,
  int? vrOffsetOverride,
}) => ref
    .watch(dirtyFragActionsProvider)
    .run(manager: manager, vrOffsetOverride: vrOffsetOverride);

/// 专家模式开关当前状态。
@riverpod
Future<bool> dirtyFragExpertMode(Ref ref) =>
    ref.watch(dirtyFragActionRepositoryProvider).isExpertModeEnabled();

/// 开机自启开关当前状态。真相是组件启用态。
@riverpod
Future<bool> dirtyFragBootAutostart(Ref ref) =>
    ref.watch(dirtyFragActionRepositoryProvider).isBootAutostartEnabled();

/// 从镜像或 OTA 直链算一次 vr 偏移。
@riverpod
Future<VrOffsetResult> deriveVrOffset(
  Ref ref, {
  required String input,
  bool insecure = false,
}) => ref
    .watch(dirtyFragActionRepositoryProvider)
    .deriveVrOffset(input: input, insecure: insecure);

/// 提取进度。只在被监听期间轮询，弹窗关掉就停。
@riverpod
Stream<VrDeriveProgress> vrDeriveProgress(Ref ref) async* {
  final DirtyFragActionRepository repository = ref.watch(
    dirtyFragActionRepositoryProvider,
  );
  while (ref.mounted) {
    yield await repository.vrDeriveProgress();
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
}

/// 提取进度的单次快照，供一次性查询使用。
@riverpod
Future<VrDeriveProgress> vrDeriveProgressSnapshot(Ref ref) =>
    ref.watch(dirtyFragActionRepositoryProvider).vrDeriveProgress();

/// GhostKey 运行数据源。
@riverpod
GhostKeyActionDatasource ghostKeyActionDatasource(Ref ref) =>
    GhostKeyActionDatasource(
      native: ref.watch(cve98260NativeProvider),
      storage: ref.watch(preferencesStoreProvider),
    );

/// GhostKey 运行仓储。
@riverpod
GhostKeyActionRepository ghostKeyActionRepository(Ref ref) =>
    GhostKeyActionRepositoryImpl(
      datasource: ref.watch(ghostKeyActionDatasourceProvider),
    );

/// GhostKey 起跑前的六项就绪检查。
@riverpod
Future<GhostKeyPreflight> ghostKeyPreflight(Ref ref) =>
    ref.watch(ghostKeyActionRepositoryProvider).preflight();

/// 运行偏好（设置页两个开关的当前值）。
@riverpod
Future<GhostKeyRunDefaults> ghostKeyRunDefaults(Ref ref) =>
    ref.watch(ghostKeyActionRepositoryProvider).runDefaults();

/// GhostKey 设置页的写操作。
///
/// 同 [rootManagerActions]：无参类，参数走方法入参。
@Riverpod(keepAlive: true)
GhostKeyActions ghostKeyActions(Ref ref) => GhostKeyActions(ref);

/// 见 [ghostKeyActions]。
class GhostKeyActions {
  GhostKeyActions(this._ref);

  final Ref _ref;

  /// 写运行偏好。两个字段整体覆盖。
  Future<void> saveRunDefaults(GhostKeyRunDefaults defaults) async {
    await _ref
        .read(ghostKeyActionRepositoryProvider)
        .saveRunDefaults(defaults: defaults);
    _ref.invalidate(ghostKeyRunDefaultsProvider);
  }

  /// 停止本侧读取；设备侧进程继续跑。
  Future<void> cancel() =>
      _ref.read(ghostKeyActionRepositoryProvider).cancel();

  /// 跑一次 GhostKey，按块吐出证据。
  Stream<GhostKeyOutcome> run({RootManager? manager}) =>
      _ref.read(ghostKeyActionRepositoryProvider).run(manager: manager);
}

/// 跑一次 GhostKey，按块吐出证据。
@riverpod
Stream<GhostKeyOutcome> runGhostKey(Ref ref, {RootManager? manager}) =>
    ref.watch(ghostKeyActionsProvider).run(manager: manager);

/// GhostLock 运行数据源。
@riverpod
GhostLockActionDatasource ghostLockActionDatasource(Ref ref) =>
    GhostLockActionDatasource(native: ref.watch(ghostLockNativeProvider));

/// GhostLock 运行仓储。
@riverpod
GhostLockActionRepository ghostLockActionRepository(Ref ref) =>
    GhostLockActionRepositoryImpl(
      datasource: ref.watch(ghostLockActionDatasourceProvider),
    );

/// 运行前自检。
@riverpod
Future<GhostLockPreflight> ghostLockPreflight(Ref ref) {
  // 自检里的 ksudPath 要与实际执行一致，所以带上全局选中的管理器。
  // 读不到（还在加载或报错）时先按包内自带兜底，读出来后自动重算。
  final RootManager? manager = ref.watch(selectedRootManagerProvider).value;
  return ref
      .watch(ghostLockActionRepositoryProvider)
      .preflight(manager: manager);
}

/// GhostLock 运行期的写操作。
///
/// 无参 `keepAlive` 类持有 [Ref]，参数走方法入参。
@Riverpod(keepAlive: true)
GhostLockActions ghostLockActions(Ref ref) => GhostLockActions(ref);

/// 见 [ghostLockActions]。
class GhostLockActions {
  GhostLockActions(this._ref);

  final Ref _ref;

  /// 停止本侧读取；设备侧进程继续跑。
  Future<void> cancel() =>
      _ref.read(ghostLockActionRepositoryProvider).cancel();

  /// 跑一次 GhostLock，按块吐出证据。
  Stream<GhostLockOutcome> run({
    RootManager? manager,
    bool safeMode = false,
  }) => _ref
      .read(ghostLockActionRepositoryProvider)
      .run(manager: manager, safeMode: safeMode);
}

/// 跑一次 GhostLock，按块吐出证据。
@riverpod
Stream<GhostLockOutcome> runGhostLock(
  Ref ref, {
  RootManager? manager,
  bool safeMode = false,
}) => ref
    .watch(ghostLockActionsProvider)
    .run(manager: manager, safeMode: safeMode);

/// GhostLock profile 导入数据源。
@riverpod
GhostLockProfileActionDatasource ghostLockProfileActionDatasource(Ref ref) =>
    GhostLockProfileActionDatasource(
      native: ref.watch(ghostLockProfileNativeProvider),
    );

/// GhostLock profile 导入仓储。
@riverpod
GhostLockProfileActionRepository ghostLockProfileActionRepository(Ref ref) =>
    GhostLockProfileActionRepositoryImpl(
      datasource: ref.watch(ghostLockProfileActionDatasourceProvider),
    );

/// 用户导入的 profile 列表。
@riverpod
Future<List<GhostLockUserProfile>> ghostLockImportedProfiles(Ref ref) =>
    ref.watch(ghostLockProfileActionRepositoryProvider).listImportedProfiles();

/// 内置 GhostLock 内核表的全部 release，按与设备内核的相近度排序。
///
/// 设备 release 尚未就绪（自检未跑完）时退回原生顺序，不阻塞列表。
@riverpod
Future<List<String>> ghostLockBuiltinReleases(Ref ref) async {
  // 依赖必须在第一个 await 之前读完：await 之后再用 ref 会命中已销毁的 Ref。
  final GhostLockProfileActionRepository repository = ref.watch(
    ghostLockProfileActionRepositoryProvider,
  );
  final String device =
      ref.watch(ghostLockPreflightProvider).value?.release ?? '';

  final List<String> releases = await repository.listBuiltinReleases();
  if (device.isEmpty) return releases;
  return _sortByKernelSimilarity(device, releases);
}

/// 按 major/minor/fix/android 的绝对差排序，差值小的在前。
List<String> _sortByKernelSimilarity(
  String deviceRelease,
  List<String> releases,
) {
  final List<int> device = _kernelVersionKey(deviceRelease);
  return releases.toList()..sort((a, b) {
    final List<int> left = _similarityKey(device, _kernelVersionKey(a));
    final List<int> right = _similarityKey(device, _kernelVersionKey(b));
    final int length = left.length > right.length ? left.length : right.length;
    for (int i = 0; i < length; i++) {
      final int l = i < left.length ? left[i] : 0;
      final int r = i < right.length ? right[i] : 0;
      if (l != r) return l.compareTo(r);
    }
    return 0;
  });
}

List<int> _kernelVersionKey(String release) {
  final List<int> version = release
      .split('-')
      .first
      .split('.')
      .map(int.tryParse)
      .whereType<int>()
      .toList();
  final RegExpMatch? android = RegExp(r'-android(\d+)').firstMatch(release);
  final int? androidVersion = android == null
      ? null
      : int.tryParse(android.group(1)!);
  return androidVersion == null ? version : <int>[...version, androidVersion];
}

List<int> _similarityKey(List<int> device, List<int> candidate) {
  final int length = device.length > candidate.length
      ? device.length
      : candidate.length;
  return List<int>.generate(length, (int index) {
    final int d = index < device.length ? device[index] : 0;
    final int c = index < candidate.length ? candidate[index] : 0;
    return (d - c).abs();
  });
}

/// 某 release 的生效 GhostLock 配置。
@riverpod
Future<GhostLockProfileConfig> ghostLockProfileConfig(
  Ref ref, {
  required String release,
}) => ref
    .watch(ghostLockProfileEditActionRepositoryProvider)
    .load(release: release);

/// 上一次提取留在缓存里的镜像路径。
@riverpod
Future<List<String>> ghostLockExtractedImages(Ref ref) =>
    ref.watch(ghostLockProfileActionsProvider).listExtractedImages();

/// kernel 表解析进度快照，供一次性查询使用。
@riverpod
Future<GhostLockProbeProgress> ghostLockProbeProgressSnapshot(Ref ref) => ref
    .watch(ghostLockProfileActionRepositoryProvider)
    .profileProgress();

/// 单份用户 profile 的原始 HOCON 文本；不存在返回空串。
@riverpod
Future<String> ghostLockImportedProfileContent(
  Ref ref, {
  required String name,
}) => ref
    .watch(ghostLockProfileActionRepositoryProvider)
    .readImportedProfile(name: name);

/// GhostLock 解析进度。只在被监听期间轮询，面板收起就停。
@riverpod
Stream<GhostLockProbeProgress> ghostLockProbeProgress(Ref ref) async* {
  final GhostLockProfileActionRepository repository = ref.watch(
    ghostLockProfileActionRepositoryProvider,
  );
  while (ref.mounted) {
    yield await repository.profileProgress();
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
}

/// GhostLock profile 编辑数据源。
@riverpod
GhostLockProfileEditActionDatasource ghostLockProfileEditActionDatasource(
  Ref ref,
) => GhostLockProfileEditActionDatasource(
  native: ref.watch(ghostLockProfileEditNativeProvider),
);

/// GhostLock profile 编辑仓储。
@riverpod
GhostLockProfileEditActionRepository ghostLockProfileEditActionRepository(
  Ref ref,
) => GhostLockProfileEditActionRepositoryImpl(
  datasource: ref.watch(ghostLockProfileEditActionDatasourceProvider),
);

/// GhostLock profile 导入与编辑的写操作。
///
/// 同 [ghostKeyActions]：无参类，参数走方法入参。
@Riverpod(keepAlive: true)
GhostLockProfileActions ghostLockProfileActions(Ref ref) =>
    GhostLockProfileActions(ref);

/// 见 [ghostLockProfileActions]。
class GhostLockProfileActions {
  GhostLockProfileActions(this._ref);

  final Ref _ref;

  /// 解析内核表但不落盘；结果由调用方暂存，选定落点后再调 [saveProfile]。
  Future<GhostLockProbe> probeProfile({
    required String input,
    bool insecure = false,
    String xblPath = '',
    String uefiPath = '',
    String vendorBootPath = '',
    String phys = '',
    String kallsymsPath = '',
    String iomemPath = '',
    String route = '',
    bool allowMissing = false,
    bool noDisasm = false,
  }) => _ref
      .read(ghostLockProfileActionRepositoryProvider)
      .probeProfile(
        input: input,
        insecure: insecure,
        xblPath: xblPath,
        uefiPath: uefiPath,
        vendorBootPath: vendorBootPath,
        phys: phys,
        kallsymsPath: kallsymsPath,
        iomemPath: iomemPath,
        route: route,
        allowMissing: allowMissing,
        noDisasm: noDisasm,
      );

  /// 把 [probeProfile] 返回的文本落盘。
  Future<GhostLockImportResult> saveProfile({
    required String release,
    required String conf,
    bool overwrite = false,
  }) async {
    final GhostLockImportResult result = await _ref
        .read(ghostLockProfileActionRepositoryProvider)
        .saveProfile(release: release, conf: conf, overwrite: overwrite);
    _ref.invalidate(ghostLockImportedProfilesProvider);
    _ref.invalidate(ghostLockPreflightProvider);
    return result;
  }

  /// 删除一份用户 profile。
  Future<bool> removeImportedProfile({required String name}) async {
    final bool removed = await _ref
        .read(ghostLockProfileActionRepositoryProvider)
        .removeImportedProfile(name: name);
    _ref.invalidate(ghostLockImportedProfilesProvider);
    _ref.invalidate(ghostLockActiveSourceProvider);
    _ref.invalidate(ghostLockPreflightProvider);
    return removed;
  }

  /// 导入现成的 profile 文本（HOCON 或 JSON）。
  Future<GhostLockImportResult> importProfileText({
    required String text,
    required String fileName,
    bool overwrite = false,
  }) async {
    final GhostLockImportResult result = await _ref
        .read(ghostLockProfileActionRepositoryProvider)
        .importProfileText(
          text: text,
          fileName: fileName,
          overwrite: overwrite,
        );
    if (result.ok) {
      _ref.invalidate(ghostLockImportedProfilesProvider);
      _ref.invalidate(ghostLockPreflightProvider);
    }
    return result;
  }

  /// 重命名用户文档；返回新文件名，失败为空串。
  Future<String> renameImportedProfile({
    required String name,
    required String newName,
  }) async {
    final String renamed = await _ref
        .read(ghostLockProfileActionRepositoryProvider)
        .renameImportedProfile(name: name, newName: newName);
    if (renamed.isNotEmpty) {
      _ref.invalidate(ghostLockImportedProfilesProvider);
      _ref.invalidate(ghostLockActiveSourceProvider);
      _ref.invalidate(ghostLockPreflightProvider);
    }
    return renamed;
  }

  /// 导出用户文档为 HOCON 文本。
  Future<String> exportImportedProfile({required String name}) => _ref
      .read(ghostLockProfileActionRepositoryProvider)
      .exportImportedProfile(name: name);

  /// 把旧格式文档转换为当前布局。
  Future<GhostLockImportResult> convertImportedProfile({
    required String name,
  }) async {
    final GhostLockImportResult result = await _ref
        .read(ghostLockProfileActionRepositoryProvider)
        .convertImportedProfile(name: name);
    if (result.ok) {
      _ref.invalidate(ghostLockImportedProfilesProvider);
      _ref.invalidate(ghostLockPreflightProvider);
    }
    return result;
  }

  /// 把缓存里的镜像另存到手机「下载」目录；返回落点显示名，失败为空串。
  Future<String> exportLocalFile({
    required String sourcePath,
    required String fileName,
  }) => _ref
      .read(ghostLockProfileActionRepositoryProvider)
      .exportLocalFile(sourcePath: sourcePath, fileName: fileName);

  /// 上一次提取留在缓存里的镜像路径。
  Future<List<String>> listExtractedImages() => _ref
      .read(ghostLockProfileActionRepositoryProvider)
      .listExtractedImages();

  /// 写通用参数。
  Future<GhostLockProfileConfig> updateGeneral({
    required String release,
    required Map<String, int> values,
  }) => _apply(
    release,
    (repo) => repo.updateGeneral(release: release, values: values),
  );

  /// 写高级字段。
  Future<GhostLockProfileConfig> updateAdvanced({
    required String release,
    required Map<String, int> values,
  }) => _apply(
    release,
    (repo) => repo.updateAdvanced(release: release, values: values),
  );

  /// 设置 route；空串恢复为 profile 声明。
  Future<GhostLockProfileConfig> updateRoute({
    required String release,
    required String route,
  }) => _apply(
    release,
    (repo) => repo.updateRoute(release: release, route: route),
  );

  /// 设置 fallback。
  Future<GhostLockProfileConfig> updateFallback({
    required String release,
    required String fallbackTo,
  }) => _apply(
    release,
    (repo) => repo.updateFallback(release: release, fallbackTo: fallbackTo),
  );

  /// 只重置通用参数的 override。
  Future<GhostLockProfileConfig> resetGeneral({required String release}) =>
      _apply(release, (repo) => repo.resetGeneral(release: release));

  /// 只重置路由与高级字段的 override。
  Future<GhostLockProfileConfig> resetAdvanced({required String release}) =>
      _apply(release, (repo) => repo.resetAdvanced(release: release));

  /// 清掉该 release 的全部 override。
  Future<GhostLockProfileConfig> resetProfile({required String release}) =>
      _apply(release, (repo) => repo.reset(release: release));

  /// 把当前生效配置另存为一份用户文档。
  Future<bool> saveModified({required String release}) => _ref
      .read(ghostLockProfileEditActionRepositoryProvider)
      .saveModified(release: release);

  /// 把当前生效配置写回用户文档 [name]。
  Future<bool> overwriteProfile({
    required String release,
    required String name,
  }) async {
    final bool saved = await _ref
        .read(ghostLockProfileEditActionRepositoryProvider)
        .overwriteProfile(release: release, name: name);
    if (saved) {
      _ref.invalidate(ghostLockImportedProfilesProvider);
      _ref.invalidate(ghostLockPreflightProvider);
    }
    return saved;
  }

  /// 指定生效的内置表；空串回到设备自身 release。
  Future<GhostLockProfileConfig> selectBuiltin({
    required String release,
    required String profileRelease,
  }) => _apply(
    release,
    (repo) =>
        repo.selectBuiltin(release: release, profileRelease: profileRelease),
  );

  /// 指定生效的用户文档；空串不使用导入层。
  Future<GhostLockProfileConfig> selectUserProfile({
    required String release,
    required String name,
  }) => _apply(
    release,
    (repo) => repo.selectUserProfile(release: release, name: name),
  );

  /// 导出当前生效配置到本地文件。
  Future<bool> exportProfile({required String release, required String path}) =>
      _ref
          .read(ghostLockProfileEditActionRepositoryProvider)
          .export(release: release, path: path);

  /// 把当前生效配置渲染为 HOCON 文本；无法解析时返回空串。
  Future<String> renderProfile({required String release}) => _ref
      .read(ghostLockProfileEditActionRepositoryProvider)
      .render(release: release);

  /// 打开编辑会话；[name] 为空串表示内置/设备态。
  Future<GhostLockProfileConfig> beginEditSession({
    required String name,
    required String deviceRelease,
  }) => _ref
      .read(ghostLockProfileEditActionRepositoryProvider)
      .beginEditSession(name: name, deviceRelease: deviceRelease);

  /// 丢弃未保存改动，按当前会话目标重新解析。
  Future<GhostLockProfileConfig> reloadEditSession() => _ref
      .read(ghostLockProfileEditActionRepositoryProvider)
      .reloadEditSession();

  /// 会话是否编辑当前生效配置。
  Future<bool> editSessionIsLive() => _ref
      .read(ghostLockProfileEditActionRepositoryProvider)
      .editSessionIsLive();

  /// 会话目标的文档名；内置/设备态返回空串。
  Future<String> editSessionTarget() => _ref
      .read(ghostLockProfileEditActionRepositoryProvider)
      .editSessionTarget();

  /// 会话实际使用的 release。
  Future<String> editSessionRelease() => _ref
      .read(ghostLockProfileEditActionRepositoryProvider)
      .editSessionRelease();

  /// 把会话 override 写入 live override。
  Future<bool> commitEditSession() async {
    final bool committed = await _ref
        .read(ghostLockProfileEditActionRepositoryProvider)
        .commitEditSession();
    if (committed) {
      _ref.invalidate(ghostLockPreflightProvider);
    }
    return committed;
  }

  /// 用会话结果整篇覆盖目标文档。
  Future<bool> saveEditSessionInPlace() async {
    final bool saved = await _ref
        .read(ghostLockProfileEditActionRepositoryProvider)
        .saveEditSessionInPlace();
    if (saved) {
      _ref.invalidate(ghostLockImportedProfilesProvider);
      _ref.invalidate(ghostLockPreflightProvider);
    }
    return saved;
  }

  /// 会话结果另存为新文档；失败返回空串。
  Future<String> saveEditSessionAsNew() async {
    final String name = await _ref
        .read(ghostLockProfileEditActionRepositoryProvider)
        .saveEditSessionAsNew();
    if (name.isNotEmpty) {
      _ref.invalidate(ghostLockImportedProfilesProvider);
    }
    return name;
  }

  /// 会话结果导出到 [path]。
  Future<bool> exportEditSession({required String path}) => _ref
      .read(ghostLockProfileEditActionRepositoryProvider)
      .exportEditSession(path: path);

  /// 关闭会话。
  Future<void> endEditSession() =>
      _ref.read(ghostLockProfileEditActionRepositoryProvider).endEditSession();

  /// 写操作共用：落盘后失效生效来源与运行前自检。
  Future<GhostLockProfileConfig> _apply(
    String release,
    Future<GhostLockProfileConfig> Function(
      GhostLockProfileEditActionRepository repo,
    )
    action,
  ) async {
    final GhostLockProfileConfig config = await action(
      _ref.read(ghostLockProfileEditActionRepositoryProvider),
    );
    _ref.invalidate(ghostLockActiveSourceProvider);
    _ref.invalidate(ghostLockPreflightProvider);
    return config;
  }
}
