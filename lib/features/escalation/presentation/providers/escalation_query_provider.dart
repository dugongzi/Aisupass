import 'package:Aisupass/core/providers/asset_bundle_provider.dart';
import 'package:Aisupass/core/providers/device_identity_provider.dart';
import 'package:Aisupass/core/providers/root_manager_provider.dart';
import 'package:Aisupass/core/storage/storage_providers.dart';
import 'package:Aisupass/features/escalation/data/datasources/escalation_query_datasource.dart';
import 'package:Aisupass/features/escalation/data/repositories/escalation_query_repository_impl.dart';
import 'package:Aisupass/features/escalation/domain/models/device_identity.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:Aisupass/features/escalation/domain/repositories/escalation_query_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'escalation_query_provider.g.dart';

/// 提权链路只读数据源。
@riverpod
EscalationQueryDatasource escalationQueryDatasource(Ref ref) =>
    EscalationQueryDatasource(
      bundle: ref.watch(assetBundleProvider),
      native: ref.watch(deviceIdentityNativeProvider),
      managers: ref.watch(rootManagerNativeProvider),
      storage: ref.watch(preferencesStoreProvider),
    );

/// 提权链路只读仓储。
@riverpod
EscalationQueryRepository escalationQueryRepository(Ref ref) =>
    EscalationQueryRepositoryImpl(
      datasource: ref.watch(escalationQueryDatasourceProvider),
    );

/// 全部载荷条目。
@riverpod
Future<List<Payload>> payloads(Ref ref) =>
    ref.watch(escalationQueryRepositoryProvider).listPayloads();

/// 设备上真实安装的 root 管理器。
@riverpod
Future<List<RootManager>> installedRootManagers(Ref ref) =>
    ref.watch(escalationQueryRepositoryProvider).installedRootManagers();

/// 当前设备身份。
@riverpod
Future<DeviceIdentity> currentDeviceIdentity(Ref ref) =>
    ref.watch(escalationQueryRepositoryProvider).deviceIdentity();

/// 用户上次选定的 root 管理器；设备上一个都没装时为 `null`。
@riverpod
Future<RootManager?> selectedRootManager(Ref ref) =>
    ref.watch(escalationQueryRepositoryProvider).selectedRootManager();
