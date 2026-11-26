/// 注入内置登录页的脚本：把页面里的登录状态回传给应用。
///
/// 页面的登录令牌只存在内存里（登录成功后仅把用户信息写进
/// `localStorage.auth_user`），因此不能靠读存储拿令牌，只能：
/// 1. 截取登录与刷新请求响应里的 `access_token`（主路径）；
/// 2. 已登录但没截到时，用页面已有的 Cookie 会话换一次访问令牌（兜底）。
///
/// 令牌只上报一次：重复上报会让应用侧反复重建流程。
/// 全程包在 try/catch 里，站点改版导致取值失败时脚本静默退出，
/// 不影响用户正常注册登录。
///
/// [channelName] 必须与页面注册的 JS 通道名一致。
String aiBuiltinLoginScript({required String channelName}) {
  return '''
(function () {
  if (window.__aiBuiltinProbe) return;
  window.__aiBuiltinProbe = true;

  var reported = false;
  var probes = 0;
  var refreshTries = 0;
  var lastRefreshAt = 0;
  var injectedAt = 0;

  function post(payload) {
    try {
      if (window.$channelName && window.$channelName.postMessage) {
        window.$channelName.postMessage(JSON.stringify(payload));
      }
    } catch (e) {}
  }

  // 令牌只上报一次，重复上报会让应用侧反复重建流程。
  function report(token, source) {
    if (reported) return;
    var value = token ? String(token).trim() : '';
    if (!value) return;
    reported = true;
    post({ type: 'token', token: value, source: source || '' });
  }

  // 从统一响应信封里取 access_token。
  function pickToken(raw) {
    try {
      var body = typeof raw === 'string' ? JSON.parse(raw) : raw;
      if (!body) return '';
      var data = body.data ? body.data : body;
      var token = data && data.access_token ? data.access_token : '';
      return token ? String(token) : '';
    } catch (e) {
      return '';
    }
  }

  function watchable(url) {
    var u = String(url || '');
    return u.indexOf('/auth/login') >= 0 || u.indexOf('/auth/refresh') >= 0;
  }

  try {
    var xhrOpen = XMLHttpRequest.prototype.open;
    var xhrSend = XMLHttpRequest.prototype.send;
    XMLHttpRequest.prototype.open = function (method, url) {
      try { this.__aiBuiltinUrl = String(url || ''); } catch (e) {}
      return xhrOpen.apply(this, arguments);
    };
    XMLHttpRequest.prototype.send = function () {
      var xhr = this;
      try {
        xhr.addEventListener('load', function () {
          try {
            if (!watchable(xhr.__aiBuiltinUrl)) return;
            report(pickToken(xhr.responseText), 'xhr');
          } catch (e) {}
        });
      } catch (e) {}
      return xhrSend.apply(this, arguments);
    };
  } catch (e) {}

  try {
    var nativeFetch = window.fetch;
    if (nativeFetch) {
      // 留住未包装的原始实现：兜底刷新要用它，避免自己截自己的响应。
      window.__aiBuiltinNativeFetch = nativeFetch;
      window.fetch = function (input, init) {
        var url = typeof input === 'string' ? input : (input && input.url) || '';
        var promise = nativeFetch.apply(window, arguments);
        try {
          if (watchable(url)) {
            promise.then(function (response) {
              try {
                response.clone().text().then(function (text) {
                  report(pickToken(text), 'fetch');
                });
              } catch (e) {}
            });
          }
        } catch (e) {}
        return promise;
      };
    }
  } catch (e) {}

  // 兜底：登录响应没截到时，用页面已有的 Cookie 会话换一次访问令牌。
  // 刷新令牌是一次性轮转的，所以最多主动尝试三次，避免与页面自身抢票。
  function refreshOnce() {
    if (reported || refreshTries >= 3) return;
    var now = Date.now();
    // 进入页面后先让页面自己的初始化刷新跑完，我们优先截它的响应；
    // 抢在它之前刷新会让两边互相失效。
    if (now - injectedAt < 2500) return;
    if (now - lastRefreshAt < 5000) return;
    lastRefreshAt = now;
    refreshTries++;
    try {
      var request = window.__aiBuiltinNativeFetch || window.fetch;
      if (!request) return;
      request.call(window, '/api/v1/auth/refresh', {
        method: 'POST',
        credentials: 'include',
        headers: { 'Content-Type': 'application/json' },
      })
        .then(function (response) { return response.text(); })
        .then(function (text) { report(pickToken(text), 'refresh'); })
        .catch(function () {});
    } catch (e) {}
  }

  function localKeys() {
    var keys = [];
    try {
      for (var i = 0; i < window.localStorage.length; i++) {
        keys.push(window.localStorage.key(i));
      }
    } catch (e) {}
    return keys;
  }

  function probe() {
    probes++;
    if (reported) return;

    var signedIn = false;
    var storedToken = '';
    try {
      signedIn = !!window.localStorage.getItem('auth_user');
      storedToken = window.localStorage.getItem('auth_token') || '';
    } catch (e) {}

    // 兼容仍然把令牌写进存储的版本。
    if (storedToken) {
      report(storedToken, 'storage');
      return;
    }

    // 已经登录过：页面初始化那次刷新若没截到，用一个 Cookie 换票。
    if (signedIn) refreshOnce();

    // 每五次轮询回传一次存储键名，便于排查页面改版后的存储位置。
    if (probes % 5 === 0) {
      post({ type: 'debug', keys: localKeys(), signedIn: signedIn });
    }
  }

  injectedAt = Date.now();
  probe();
  setInterval(probe, 1500);
})();
''';
}
