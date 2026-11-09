import 'package:Aisupass/core/providers/adb_shell_provider.dart';
import 'package:Aisupass/core/storage/storage_providers.dart';
import 'package:Aisupass/core/utils/payload_shell.dart';
import 'package:Aisupass/features/escalation/data/datasources/dirty_frag_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/datasources/escalation_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/repositories/dirty_frag_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/data/repositories/escalation_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/domain/models/dirty_frag_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/dirty_frag_run_defaults.dart';
import 'package:Aisupass/features/escalation/domain/models/handoff_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:Aisupass/features/escalation/domain/models/payload_match.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:Aisupass/features/escalation/domain/models/vr_derive_progress.dart';
import 'package:Aisupass/features/escalation/domain/models/vr_offset_result.dart';
import 'package:Aisupass/features/escalation/domain/repositories/dirty_frag_action_repository.dart';
import 'package:Aisupass/features/escalation/domain/repositories/escalation_action_repository.dart';
import 'package:Aisupass/features/escalation/domain/repositories/escalation_query_repository.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';
import 'package:Aisupass/generated/dirty_frag.g.dart' as pigeon;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'escalation_action_provider.g.dart';

/// 提权链路执行数据源。
@riverpod
EscalationActionDatasource escalationActionDatasource(Ref ref) =>
    EscalationActionDatasource(
      native: ref.watch(adbShellNativeProvider),
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
    return 'echo ${PayloadShell.quote('当前设备在载荷清单里没有候选')}';
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

/// 把临时 root 移交给用户选定的 [manager]。
///
/// 管理器未安装时返回 [HandoffKind.managerMissing]，不抛异常。
@riverpod
Future<HandoffOutcome> handoffRoot(Ref ref, {required RootManager manager}) =>
    ref.watch(escalationActionRepositoryProvider).handoffRoot(manager: manager);

/// 记住用户选定的 root 管理器。
///
/// 落盘后失效 [selectedRootManagerProvider]。
@riverpod
Future<void> selectRootManager(
  Ref ref, {
  required RootManager manager,
}) async {
  await ref
      .watch(escalationActionRepositoryProvider)
      .selectRootManager(manager: manager);
  ref.invalidate(selectedRootManagerProvider);
}

/// DirtyFrag 运行数据源。
@riverpod
DirtyFragActionDatasource dirtyFragActionDatasource(Ref ref) =>
    DirtyFragActionDatasource(native: pigeon.DirtyFragNative());

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

/// 写运行默认值。设置页改开关时调用。
@riverpod
Future<void> saveDirtyFragRunDefaults(
  Ref ref, {
  required DirtyFragRunDefaults defaults,
}) async {
  await ref
      .watch(dirtyFragActionRepositoryProvider)
      .saveRunDefaults(defaults: defaults);
  ref.invalidate(dirtyFragRunDefaultsProvider);
}

/// 跑一次 DirtyFrag，按块吐出证据。
@riverpod
Stream<DirtyFragOutcome> runDirtyFrag(
  Ref ref, {
  required RootManager manager,
  int? vrOffsetOverride,
}) => ref
    .watch(dirtyFragActionRepositoryProvider)
    .run(manager: manager, vrOffsetOverride: vrOffsetOverride);

/// 专家模式开关当前状态。
@riverpod
Future<bool> dirtyFragExpertMode(Ref ref) =>
    ref.watch(dirtyFragActionRepositoryProvider).isExpertModeEnabled();

/// 开机自启开关当前状态。真相是组件启用态。
@riverpod
Future<bool> dirtyFragBootAutostart(Ref ref) =>
    ref.watch(dirtyFragActionRepositoryProvider).isBootAutostartEnabled();

/// 切换专家模式。
@riverpod
Future<void> setDirtyFragExpertMode(Ref ref, {required bool enabled}) async {
  await ref
      .watch(dirtyFragActionRepositoryProvider)
      .setExpertModeEnabled(enabled: enabled);
  // 专家模式变了，开机自启那行的可用态要跟着变。
  ref.invalidate(dirtyFragExpertModeProvider);
  ref.invalidate(dirtyFragBootAutostartProvider);
}

/// 切换开机自启。
@riverpod
Future<void> setDirtyFragBootAutostart(
  Ref ref, {
  required bool enabled,
}) async {
  await ref
      .watch(dirtyFragActionRepositoryProvider)
      .setBootAutostartEnabled(enabled: enabled);
  ref.invalidate(dirtyFragBootAutostartProvider);
}

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
  while (true) {
    yield await ref
        .watch(dirtyFragActionRepositoryProvider)
        .vrDeriveProgress();
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
}
