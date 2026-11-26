/// 把 `k=v; k2=v2` 解析成键值对；空项与无等号的片段直接丢弃。
Map<String, String> parseCoolapkCookie(String raw) {
  final Map<String, String> jar = <String, String>{};
  for (final String segment in raw.split(';')) {
    final String part = segment.trim();
    if (part.isEmpty) continue;
    final int index = part.indexOf('=');
    if (index <= 0) continue;
    final String key = part.substring(0, index).trim();
    final String value = part.substring(index + 1).trim();
    if (key.isEmpty || value.isEmpty) continue;
    jar[key] = value;
  }
  return jar;
}

/// 取出会话 id（`SESSID`）。
///
/// 登录成功时服务端会换发新的 SESSID，因此「前后两次不同」本身就是
/// 登录生效的证据，不依赖具体账号字段叫什么名字。
String coolapkSessionIdFromCookie(String raw) =>
    (parseCoolapkCookie(raw)['SESSID'] ?? '').trim();

/// 从 Cookie 里解析登录账号 id。
///
/// 只是补充信息：字段名各端不统一，取不到不代表没登录，
/// 是否登录由 [coolapkSessionIdFromCookie] 的前后对比来定。
String coolapkUidFromCookie(String raw) {
  final Map<String, String> jar = parseCoolapkCookie(raw);
  for (final String key in const <String>['uid', 'user_id', 'userId']) {
    final String value = (jar[key] ?? '').trim();
    if (value.isNotEmpty && _isNumeric(value)) return value;
  }
  return '';
}

/// 纯数字判定：uid 必须全是数字，避免把 `uid=deleted` 之类的脏值当真。
bool _isNumeric(String text) {
  if (text.isEmpty) return false;
  for (final int code in text.codeUnits) {
    if (code < 0x30 || code > 0x39) return false;
  }
  return true;
}

/// 拼出 `validate` Cookie 的值。
///
/// 酷安要的不是易盾原始的 validate，而是 `NEC:<captchaId 前 8 位>:<validate>`。
/// 缺了这段前缀，服务端认不出这张票属于哪个挑战，会把同一个 captchaId
/// 再发回来，表现成「验证过了却还是被拦」。
String coolapkCaptchaToken({
  required String captchaId,
  required String validate,
}) {
  final String token = validate.trim();
  final String id = captchaId.trim();
  // 少了任何一段都拼不出服务端认的票，宁可返回空让上层报失败。
  if (token.isEmpty || id.isEmpty) return '';
  final String prefix = id.length <= 8 ? id : id.substring(0, 8);
  return 'NEC:$prefix:$token';
}

/// 列出 Cookie 的键名，用于诊断日志（不含值，避免泄漏令牌）。
List<String> coolapkCookieKeys(String raw) =>
    parseCoolapkCookie(raw).keys.toList(growable: false);

/// 合并多段 Cookie 串，先到的键优先。
///
/// 原生通道拿到的是全量（含 HttpOnly），`document.cookie` 只补当前页域里
/// 非 HttpOnly 的残留，所以调用方把原生结果放前面。
String mergeCoolapkCookie(List<String> sources) {
  final Map<String, String> merged = <String, String>{};
  for (final String source in sources) {
    final Map<String, String> jar = parseCoolapkCookie(source);
    for (final MapEntry<String, String> entry in jar.entries) {
      merged.putIfAbsent(entry.key, () => entry.value);
    }
  }
  return merged.entries
      .map((MapEntry<String, String> entry) => '${entry.key}=${entry.value}')
      .join('; ');
}
