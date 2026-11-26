import 'dart:async';

import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/coolapk_webview.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/coolapk/domain/enums/coolapk_login_result.dart';
import 'package:Aisupass/features/coolapk/presentation/controllers/coolapk_login_controller.dart';
import 'package:Aisupass/features/coolapk/presentation/widgets/coolapk_login_footer.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 登录入口。`type=mobile` 走手机版，页面更轻。
const String _loginUrl = 'https://account.coolapk.com/auth/login?type=mobile';

/// 需要读 Cookie 的域名。
///
/// Cookie 按域隔离，登录页在 `account.coolapk.com`、主站在 `www.coolapk.com`，
/// 只读一个域名会漏掉另一半。
const List<String> _cookieOrigins = <String>[
  'https://account.coolapk.com',
  'https://www.coolapk.com',
];

/// 单页加载超时，卡住时结束进度条。
const Duration _loadTimeout = Duration(seconds: 30);

/// 用移动版 UA，避免被站点判定成不支持的浏览器。
const String _mobileUserAgent =
    'Mozilla/5.0 (Linux; Android 14; PHB110) AppleWebKit/537.36 '
    '(KHTML, like Gecko) Chrome/131.0.0.0 Mobile Safari/537.36';

/// 酷安登录页：在 WebView 里完成登录，随后读取 Cookie 交给后续请求复用。
class CoolapkLoginPage extends HookConsumerWidget {
  const CoolapkLoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;

    if (!isAndroidPlatform) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.coolapkLoginTitle)),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Text(
              l10n.coolapkLoginDesktopUnsupported,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp),
            ),
          ),
        ),
      );
    }

    final CoolapkLoginController loginController = useMemoized(
      () => CoolapkLoginController(ref: ref),
      const <Object?>[],
    );

    final ValueNotifier<String> currentUrl = useState<String>(_loginUrl);
    final ValueNotifier<int> progress = useState<int>(0);
    final ValueNotifier<bool> loading = useState<bool>(true);
    final ValueNotifier<bool> capturing = useState<bool>(false);
    // 自动抓取只尝试一次，避免每次页面跳转都打一遍原生通道。
    final ValueNotifier<bool> autoTried = useState<bool>(false);

    // 先声明后赋值：抓取流程要用 controller，而 controller 的导航回调又要用
    // 抓取流程。
    late final WebViewController controller;

    /// 读取并保存令牌。[silent] 为 true 时失败不弹提示（自动流程用）。
    Future<bool> capture({required bool silent}) async {
      if (capturing.value) return false;
      capturing.value = true;
      try {
        final String jsCookie = await readDocumentCookie(controller);
        final CoolapkLoginResult result = await loginController.capture(
          urls: _cookieOrigins,
          documentCookie: jsCookie,
        );
        if (!context.mounted) return false;
        switch (result) {
          case CoolapkLoginResult.success:
            ToastMessage.success(l10n.coolapkLoginSucceeded);
            Navigator.of(context).pop();
            return true;
          case CoolapkLoginResult.notDetected:
            if (!silent) ToastMessage.error(l10n.coolapkLoginNotDetected);
            return false;
          case CoolapkLoginResult.failed:
            if (!silent) ToastMessage.error(l10n.coolapkLoginCaptureFailed);
            return false;
        }
      } finally {
        capturing.value = false;
      }
    }

    /// 清除本地登录态与 WebView 会话，并重新打开登录页。
    Future<void> clearCookie() async {
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
          title: Text(l10n.coolapkLoginClearCookie),
          content: Text(l10n.coolapkLoginClearCookieConfirm),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.aiCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.aiDelete),
            ),
          ],
        ),
      );
      if (confirmed != true) return;

      await loginController.clearCookie();
      await controller.clearCache();
      await controller.clearLocalStorage();
      autoTried.value = false;
      if (!context.mounted) return;
      ToastMessage.success(l10n.coolapkLoginCookieCleared);
      await controller.loadRequest(Uri.parse(_loginUrl));
    }

    /// 跳到酷安页面时试抓一次，是否真的登录成功由会话比对决定。
    void onUrlChanged(String url) {
      currentUrl.value = url;
      if (autoTried.value) return;
      if (!isCoolapkContentUrl(url)) return;
      autoTried.value = true;
      unawaited(
        Future<void>.delayed(
          const Duration(milliseconds: 400),
          () => capture(silent: true),
        ),
      );
    }

    controller = useMemoized(() {
      final WebViewController view = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted);
      view.setUserAgent(_mobileUserAgent);
      view.setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int value) => progress.value = value,
          onPageStarted: (String url) {
            currentUrl.value = url;
            loading.value = true;
          },
          onPageFinished: (String url) {
            currentUrl.value = url;
            loading.value = false;
            // 页面就绪后记下当前会话，供后续判断是否被换发。
            unawaited(loginController.rememberBaseline(urls: _cookieOrigins));
          },
          onUrlChange: (UrlChange change) {
            final String? url = change.url;
            if (url != null && url.isNotEmpty) onUrlChanged(url);
          },
          onWebResourceError: (WebResourceError error) {
            if (error.isForMainFrame == false) return;
            loading.value = false;
          },
        ),
      );
      view.loadRequest(Uri.parse(_loginUrl));
      return view;
    }, const <Object?>[]);

    useEffect(() {
      if (!loading.value) return null;
      final Timer timer = Timer(_loadTimeout, () => loading.value = false);
      return timer.cancel;
    }, <Object?>[loading.value]);

    final ColorScheme colors = context.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.coolapkLoginTitle),
        actions: <Widget>[
          IconButton(
            onPressed: clearCookie,
            icon: Icon(Icons.cookie_outlined, size: 20.sp),
            tooltip: l10n.coolapkLoginClearCookie,
          ),
          SizedBox(width: 4.w),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: loading.value
              ? LinearProgressIndicator(
                  value: progress.value <= 0 ? null : progress.value / 100,
                  minHeight: 3,
                  backgroundColor: colors.surfaceContainerHigh,
                )
              : SizedBox(height: 3, child: ColoredBox(color: colors.surface)),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: WebViewWidget(controller: controller)),
          CoolapkLoginFooter(
            capturing: capturing.value,
            onCapture: () => capture(silent: false),
          ),
        ],
      ),
    );
  }
}
