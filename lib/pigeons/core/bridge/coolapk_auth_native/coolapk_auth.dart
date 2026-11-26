import 'package:pigeon/pigeon.dart';

/// WebView 登录 Cookie 快照。
///
/// 平台侧把多个域名下可见的 Cookie 合并成一条 `k=v; k2=v2` 串，
/// 令牌解析在 Dart 侧完成。
class CoolapkCookie {
  CoolapkCookie({required this.cookie});

  /// 合并后的 Cookie 串，形如 `SESSID=abc; uid=123`；读不到为空串。
  String cookie;
}

/// 酷安登录 Cookie 原生接口。
///
/// 登录令牌通常是 HttpOnly，`document.cookie` 读不到，
/// 需要走 `android.webkit.CookieManager`。
@HostApi()
abstract class CoolapkAuthNative {
  /// 读取 [urls] 下可见的 Cookie 并合并。
  ///
  /// Cookie 按域名隔离，登录页在 `account.coolapk.com`、主站在
  /// `www.coolapk.com`，调用方要把两个域名都传进来。
  @async
  CoolapkCookie readCookie(List<String> urls);

  /// 清空 WebView 的全部 Cookie。
  @async
  void clearCookie();
}
