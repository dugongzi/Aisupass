import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:Aisupass/core/storage/storage_providers.dart';
import 'package:Aisupass/features/coolapk/data/datasources/coolapk_auth_query_datasource.dart';
import 'package:Aisupass/features/coolapk/data/repositories/coolapk_auth_query_repository_impl.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_auth_state.dart';
import 'package:Aisupass/features/coolapk/domain/repositories/coolapk_auth_query_repository.dart';
import 'package:Aisupass/generated/coolapk_auth.g.dart';

part 'coolapk_auth_query_provider.g.dart';

/// 酷安登录 Cookie 的原生接口实例，与 Pigeon 通道一一对应。
@riverpod
CoolapkAuthNative coolapkAuthNative(Ref ref) => CoolapkAuthNative();

/// 酷安登录态的只读数据源。
@riverpod
CoolapkAuthQueryDatasource coolapkAuthQueryDatasource(Ref ref) =>
    CoolapkAuthQueryDatasource(
      secure: ref.watch(secureStoreProvider),
      native: ref.watch(coolapkAuthNativeProvider),
    );

/// 酷安登录态查询仓储。
@riverpod
CoolapkAuthQueryRepository coolapkAuthQueryRepository(Ref ref) =>
    CoolapkAuthQueryRepositoryImpl(
      datasource: ref.watch(coolapkAuthQueryDatasourceProvider),
    );

/// 当前登录态。
///
/// keepAlive：聊天过程中会被工具、数据源反复读取，不能因为一时没人监听
/// 就退回未登录。
@Riverpod(keepAlive: true)
Future<CoolapkAuthState> coolapkAuth(Ref ref) =>
    ref.watch(coolapkAuthQueryRepositoryProvider).load();

/// 当前登录 Cookie；未登录或仍在加载时为空串。
///
/// 数据源拼请求头时直接用它，免得到处展开 AsyncValue。
@riverpod
String coolapkAuthCookie(Ref ref) =>
    ref.watch(coolapkAuthProvider).value?.cookie ?? '';

/// 已拿到的易盾验证码票据；没有则为空串。
///
/// 数据源把它作为 `validate` Cookie 发出去，绕开详情接口的风控。
@riverpod
String coolapkCaptchaValidate(Ref ref) =>
    ref.watch(coolapkAuthProvider).value?.captchaValidate ?? '';

/// 票据保存时间（毫秒时间戳）；没有票据时为 0。
///
/// 验证卡片用它比较「保存时间是否晚于卡片出现时刻」，
/// 不能在 loading 期间用票据是否为空来判断，那样会把旧票据误认成刚验证过。
@riverpod
int coolapkCaptchaSavedAt(Ref ref) =>
    ref.watch(coolapkAuthProvider).value?.captchaSavedAt ?? 0;
