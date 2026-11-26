import 'dart:developer' show log;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:Aisupass/core/storage/storage_providers.dart';
import 'package:Aisupass/core/utils/coolapk_cookie.dart';
import 'package:Aisupass/features/coolapk/data/datasources/coolapk_auth_action_datasource.dart';
import 'package:Aisupass/features/coolapk/data/repositories/coolapk_auth_action_repository_impl.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_account.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_auth_state.dart';
import 'package:Aisupass/features/coolapk/domain/repositories/coolapk_auth_action_repository.dart';
import 'package:Aisupass/features/coolapk/domain/repositories/coolapk_auth_query_repository.dart';
import 'package:Aisupass/features/coolapk/domain/repositories/coolapk_query_repository.dart';
import 'package:Aisupass/features/coolapk/presentation/providers/coolapk_auth_query_provider.dart';
import 'package:Aisupass/features/coolapk/presentation/providers/coolapk_query_provider.dart';

part 'coolapk_auth_action_provider.g.dart';

/// 酷安登录态的写入数据源。
@riverpod
CoolapkAuthActionDatasource coolapkAuthActionDatasource(Ref ref) =>
    CoolapkAuthActionDatasource(
      secure: ref.watch(secureStoreProvider),
      native: ref.watch(coolapkAuthNativeProvider),
    );

/// 酷安登录态写入仓储。
@riverpod
CoolapkAuthActionRepository coolapkAuthActionRepository(Ref ref) =>
    CoolapkAuthActionRepositoryImpl(
      datasource: ref.watch(coolapkAuthActionDatasourceProvider),
    );

/// 登录态的写操作入口。
///
/// 登录页只需要调 [captureCookie]，读取原生 Cookie、合并、向服务端确认、
/// 落盘、刷新查询 Provider 都在这里收口。
class CoolapkAuthActions {
  const CoolapkAuthActions({required this._ref});

  final Ref _ref;

  CoolapkAuthActionRepository get _repository =>
      _ref.read(coolapkAuthActionRepositoryProvider);

  CoolapkAuthQueryRepository get _authRepository =>
      _ref.read(coolapkAuthQueryRepositoryProvider);

  CoolapkQueryRepository get _queryRepository =>
      _ref.read(coolapkQueryRepositoryProvider);

  /// 抓取 WebView 会话里的 Cookie，确认是登录态后保存。
  ///
  /// [urls] 至少覆盖登录页与主站两个域名；[documentCookie] 是
  /// `document.cookie` 的补录值，只在原生读不到时起作用。
  /// [baselineSessionId] 是打开登录页时的会话 id，用于判断会话是否被换发。
  Future<CoolapkAuthState> captureCookie({
    required List<String> urls,
    String documentCookie = '',
    String baselineSessionId = '',
  }) async {
    final CoolapkAuthState live = await _authRepository.readWebViewCookie(
      urls: urls,
    );
    // 原生拿全量（含 HttpOnly），JS 只补当前页域里非 HttpOnly 的残留。
    final String merged = mergeCoolapkCookie(<String>[
      live.cookie,
      documentCookie,
    ]);

    final String sessionId = coolapkSessionIdFromCookie(merged);
    final String uid = coolapkUidFromCookie(merged);
    final bool sessionChanged =
        baselineSessionId.isNotEmpty &&
        sessionId.isNotEmpty &&
        sessionId != baselineSessionId;
    _logCapture(
      keys: coolapkCookieKeys(merged),
      uid: uid,
      sessionChanged: sessionChanged,
    );

    // 会话换了，或者 Cookie 里直接带了账号 id，都算登录生效。
    if (!sessionChanged && uid.isEmpty) {
      throw const CoolapkAuthRequiredException(
        'COOLAPK_AUTH_REQUIRED: 会话没有变化，登录未生效',
      );
    }

    final CoolapkAuthState next = CoolapkAuthState(
      cookie: merged,
      uid: uid,
      username: uid.isEmpty
          ? ''
          : await _readUsername(uid: uid, cookie: merged),
      // 换了会话，旧的验证码票据未必还认，重新过验证更稳。
      captchaValidate: '',
      captchaSavedAt: 0,
      savedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _repository.save(next);
    _ref.invalidate(coolapkAuthProvider);
    return next;
  }

  /// 保存过完人机验证拿到的票据，随后请求会自动带上 `validate` Cookie。
  ///
  /// [captchaId] 是被拦那次响应里的业务 id：酷安要求票据以
  /// `NEC:<captchaId 前 8 位>:<validate>` 的形式提交，缺了前缀服务端不认。
  /// 只有已登录才存：游客态没有正文可读，票据也无处可用。
  /// 同时记下保存时间，供验证卡片判断「这次才算过」。
  Future<void> saveCaptchaValidate({
    required String validate,
    required String captchaId,
  }) async {
    final String token = coolapkCaptchaToken(
      captchaId: captchaId,
      validate: validate,
    );
    if (token.isEmpty) return;
    final CoolapkAuthState current = await _authRepository.load();
    if (!current.isLoggedIn) return;
    await _repository.save(
      current.copyWith(
        captchaValidate: token,
        captchaSavedAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    _ref.invalidate(coolapkAuthProvider);
  }

  /// 清掉已失效的票据。
  ///
  /// 带了票据仍被风控拦下，说明这张票已经用掉或过期；留着只会让每次
  /// 请求都白带一次，所以清空并让用户重新验证一次。
  Future<void> clearCaptchaValidate() async {
    final CoolapkAuthState current = await _authRepository.load();
    if (current.captchaValidate.isEmpty) return;
    await _repository.save(
      current.copyWith(captchaValidate: '', captchaSavedAt: 0),
    );
    _ref.invalidate(coolapkAuthProvider);
  }

  /// 尽力补昵称，失败留空。
  ///
  /// 昵称只用于展示，取不到不影响登录结论。
  Future<String> _readUsername({
    required String uid,
    required String cookie,
  }) async {
    try {
      final CoolapkAccount? account = await _queryRepository.fetchProfileByUid(
        uid: uid,
        cookie: cookie,
      );
      return account?.username ?? '';
    } catch (_) {
      return '';
    }
  }

  /// 退出登录，回到游客态。
  Future<void> logout() async {
    await _repository.clear();
    _ref.invalidate(coolapkAuthProvider);
  }
}

/// 登录态写操作入口的 Provider。
///
/// 用 `keepAlive` 保住 [Ref]，避免 `ref.read` 后立即销毁导致异步落盘时失效。
@Riverpod(keepAlive: true)
CoolapkAuthActions coolapkAuthActions(Ref ref) => CoolapkAuthActions(ref: ref);

/// 仅在 debug 下输出抓取结果，release 编译后整段消失。
///
/// 只打键名、uid 与会话是否变化，不打 Cookie 值：里面是登录令牌。
void _logCapture({
  required List<String> keys,
  required String uid,
  required bool sessionChanged,
}) {
  assert(() {
    log(
      'coolapk.auth capture: keys=$keys uid=${uid.isEmpty ? '(none)' : uid} '
      'sessionChanged=$sessionChanged',
      name: 'coolapk.auth',
    );
    return true;
  }());
}
