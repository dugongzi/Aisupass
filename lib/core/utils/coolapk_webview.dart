import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

/// 判断地址是否已经落在酷安页面（而非仍在登录 / 注册 / 授权流程里）。
///
/// 登录页跳转回调用它决定「可以尝试抓 Cookie 了」，停留在 `/auth/` 路径
/// 时抓取只会拿到空会话。
bool isCoolapkContentUrl(String url) {
  final Uri? uri = Uri.tryParse(url);
  if (uri == null || !uri.hasAuthority) return false;
  final String host = uri.host.toLowerCase();
  final bool isCoolapk = host == 'coolapk.com' || host.endsWith('.coolapk.com');
  if (!isCoolapk) return false;
  return !uri.path.contains('/auth/');
}

/// 读当前页 `document.cookie`；只补非 HttpOnly 的残留，读不到返回空串。
Future<String> readDocumentCookie(WebViewController controller) async {
  try {
    final Object raw = await controller.runJavaScriptReturningResult(
      'document.cookie',
    );
    return decodeJsString(raw);
  } catch (_) {
    return '';
  }
}

/// `runJavaScriptReturningResult` 在 Android 上返回 JSON 编码的字符串。
String decodeJsString(Object raw) {
  final String text = raw.toString();
  if (text.length < 2 || !text.startsWith('"') || !text.endsWith('"')) {
    return text;
  }
  try {
    final Object? decoded = jsonDecode(text);
    return decoded is String ? decoded : text;
  } on FormatException {
    return text;
  }
}
