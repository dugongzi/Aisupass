import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/core/utils/coolapk_cookie.dart';
import 'package:Aisupass/features/coolapk/domain/enums/coolapk_login_result.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_auth_state.dart';
import 'package:Aisupass/features/coolapk/presentation/providers/coolapk_auth_action_provider.dart';
import 'package:Aisupass/features/coolapk/presentation/providers/coolapk_auth_query_provider.dart';

/// 酷安登录页的流程编排。
///
/// 只做取值、比对与落盘，不接触 `BuildContext`、不弹提示，
/// 文案与页面跳转由页面根据 [CoolapkLoginResult] 处理。
class CoolapkLoginController {
  CoolapkLoginController({required this._ref});

  final WidgetRef _ref;

  /// 打开登录页时的会话 id；登录成功时服务端会换发新的 SESSID。
  String _baselineSessionId = '';

  /// 记录会话基线，只记第一次。
  Future<void> rememberBaseline({required List<String> urls}) async {
    if (_baselineSessionId.isNotEmpty) return;
    try {
      final CoolapkAuthState live = await _ref
          .read(coolapkAuthQueryRepositoryProvider)
          .readWebViewCookie(urls: urls);
      _baselineSessionId = coolapkSessionIdFromCookie(live.cookie);
    } catch (_) {
      // 读不到就留空，退化成按 Cookie 里的账号 id 判定。
    }
  }

  /// 抓取并保存当前会话。
  Future<CoolapkLoginResult> capture({
    required List<String> urls,
    required String documentCookie,
  }) async {
    try {
      await _ref
          .read(coolapkAuthActionsProvider)
          .captureCookie(
            urls: urls,
            documentCookie: documentCookie,
            baselineSessionId: _baselineSessionId,
          );
      return CoolapkLoginResult.success;
    } on CoolapkAuthRequiredException {
      return CoolapkLoginResult.notDetected;
    } catch (_) {
      return CoolapkLoginResult.failed;
    }
  }

  /// 清除登录态与 WebView 会话，并重置基线。
  Future<void> clearCookie() async {
    await _ref.read(coolapkAuthActionsProvider).logout();
    _baselineSessionId = '';
  }
}
