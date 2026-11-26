/// 注入酷安验证页宿主的脚本：先把酷安首页清空，再渲染易盾组件。
///
/// 清空是必须的：酷安首页的固定顶栏、底部导航和多层 `position: fixed`
/// 容器都会盖住 `embed` 模式的验证条。清空后只剩一块白底容器，
/// 组件再不会被任何元素压住。
///
/// 回传协议：`ready` 表示组件渲染完成，`verify:<票据>` 通过，
/// `error:<内容>` 失败；[channelName] 必须与页面注册的 JS 通道一致。
String coolapkCaptchaScript({
  required String captchaId,
  required String channelName,
}) {
  final String id = captchaId.replaceAll('\\', '\\\\').replaceAll("'", "\\'");
  return '''
(function () {
  if (window.__aisupassCaptchaStarted) return;
  window.__aisupassCaptchaStarted = true;

  function post(payload) {
    try {
      if (window.$channelName && window.$channelName.postMessage) {
        window.$channelName.postMessage(payload);
      }
    } catch (e) {}
  }

  function clearPage() {
    try {
      var root = document.body || document.documentElement;
      if (root) {
        root.innerHTML = '';
        root.style.cssText = 'margin:0;padding:0;background:#ffffff;overflow:hidden;';
      }
      document.documentElement.style.cssText = 'background:#ffffff;';
    } catch (e) {}
  }

  clearPage();

  var host = document.createElement('div');
  host.id = 'aisupass-captcha-host';
  host.style.cssText = 'position:fixed;left:0;top:0;right:0;bottom:0;z-index:2147483647;' +
    'background:#ffffff;display:flex;flex-direction:column;align-items:center;' +
    'justify-content:center;padding:16px;box-sizing:border-box;';
  var box = document.createElement('div');
  box.id = 'aisupass-captcha';
  // 高度必须给出：embed 模式按容器尺寸排版，容器塌成 0 高就不会渲染。
  box.style.cssText = 'width:100%;max-width:360px;min-height:200px;' +
    'display:flex;align-items:center;justify-content:center;';
  host.appendChild(box);
  (document.body || document.documentElement).appendChild(host);

  var tries = 0;
  function boot() {
    if (typeof initNECaptcha !== 'function') {
      if (tries++ > 80) {
        post('error:captcha script not loaded');
        return;
      }
      setTimeout(boot, 200);
      return;
    }
    initNECaptcha(
      {
        captchaId: '$id',
        element: '#aisupass-captcha',
        mode: 'embed',
        // 酷安拦下的是 v2 挑战（err_request_captcha_v2），组件必须按 v2
        // 出票，否则拿到的 validate 与服务端期待的不是同一套。
        protocol: 'https',
        apiVersion: 2,
        width: '100%',
        onVerify: function (err, ret) {
          if (err) {
            var code = err && err.code ? err.code : '';
            var msg = err && err.msg ? err.msg : JSON.stringify(err || {});
            post('error:' + (code ? code + ' ' : '') + msg);
            return;
          }
          var validate = ret && ret.validate ? ret.validate : '';
          if (!validate) {
            post('error:empty validate');
            return;
          }
          post('verify:' + validate);
        }
      },
      function () {
        post('ready');
      },
      function (err) {
        post('error:' + JSON.stringify(err || {}));
      }
    );
  }

  if (typeof initNECaptcha === 'function') {
    boot();
    return;
  }
  var script = document.createElement('script');
  script.src = 'https://cstaticdun.126.net/load.min.js';
  script.onload = boot;
  script.onerror = function () { post('error:captcha script blocked'); };
  document.head.appendChild(script);
})();
''';
}
