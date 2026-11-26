import 'dart:async';

import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/utils/coolapk_captcha_script.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/coolapk/domain/enums/coolapk_captcha_status.dart';
import 'package:Aisupass/features/coolapk/presentation/controllers/coolapk_captcha_controller.dart';
import 'package:Aisupass/features/coolapk/presentation/widgets/coolapk_captcha_footer.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 页面与注入脚本之间的 JS 通道名，必须与脚本里的一致。
const String _channelName = 'CoolapkCaptcha';

/// 承载脚本的宿主页，用真实酷安域名，避免站点把页面判定成陌生来源。
///
/// 页面内容会在脚本注入时清空，用户看不到酷安首页。
const String _hostUrl = 'https://www.coolapk.com/';

/// 移动版 UA，避免被站点判定成不支持的浏览器。
const String _mobileUserAgent =
    'Mozilla/5.0 (Linux; Android 14; PHB110) AppleWebKit/537.36 '
    '(KHTML, like Gecko) Chrome/131.0.0.0 Mobile Safari/537.36';

/// 酷安人机验证页。
///
/// `/v6/feed/detail` 被网易易盾风控拦下时，响应里带 `captchaId`。
/// 这里加载官方易盾组件，用户划一次拿到 `validate` 票据，落盘后后续请求
/// 带上 `validate` Cookie，由酷安服务端做二次校验放行。
class CoolapkCaptchaPage extends HookConsumerWidget {
  const CoolapkCaptchaPage({super.key, required this.captchaId});

  /// 易盾业务 id，来自被风控接口的响应。
  final String captchaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme colors = context.colorScheme;

    if (!isAndroidPlatform) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.coolapkCaptchaTitle)),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Text(
              l10n.coolapkCaptchaDesktopUnsupported,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp),
            ),
          ),
        ),
      );
    }

    final CoolapkCaptchaController controller = useMemoized(
      () => CoolapkCaptchaController(ref: ref),
      const <Object?>[],
    );
    final ValueNotifier<bool> busy = useState<bool>(false);
    final ValueNotifier<bool> ready = useState<bool>(false);
    final ValueNotifier<String> failed = useState<String>('');

    late final WebViewController view;

    /// 处理脚本回传，并按结果更新界面。
    Future<void> handle(String payload) async {
      if (busy.value) return;
      busy.value = true;
      final ({CoolapkCaptchaStatus status, String detail}) outcome =
          await controller.handle(payload, captchaId: captchaId);
      busy.value = false;
      if (!context.mounted) return;
      switch (outcome.status) {
        case CoolapkCaptchaStatus.ready:
          ready.value = true;
          failed.value = '';
        case CoolapkCaptchaStatus.saved:
          ToastMessage.success(l10n.coolapkCaptchaSucceeded);
          Navigator.of(context).pop(true);
        case CoolapkCaptchaStatus.failed:
          ready.value = true;
          failed.value = outcome.detail.isEmpty
              ? l10n.coolapkCaptchaSaveFailed
              : outcome.detail;
        case CoolapkCaptchaStatus.ignored:
          break;
      }
    }

    /// 页面就绪后注入验证组件。
    ///
    /// 每次页面加载完成都要注入：酷安首页可能重定向一次，新页面的 DOM
    /// 会退回酷安首页内容，只有重新清空并注入，验证条才不会又被压住。
    /// 同一页面内的重复注入由脚本自己的 `__aisupassCaptchaStarted` 拦住。
    Future<void> inject() async {
      try {
        await view.runJavaScript(
          coolapkCaptchaScript(captchaId: captchaId, channelName: _channelName),
        );
      } catch (error) {
        ready.value = true;
        failed.value = '$error';
      }
    }

    view = useMemoized(() {
      final WebViewController created = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setUserAgent(_mobileUserAgent)
        // 让酷安首页走移动版布局，脚本注入前不至于铺开成桌面版。
        ..setBackgroundColor(const Color(0xFFFFFFFF))
        ..addJavaScriptChannel(
          _channelName,
          onMessageReceived: (JavaScriptMessage message) {
            unawaited(handle(message.message));
          },
        )
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (String url) {
              final Uri? uri = Uri.tryParse(url);
              final String host = uri?.host.toLowerCase() ?? '';
              if (!host.endsWith('coolapk.com')) return;
              unawaited(inject());
            },
            onWebResourceError: (WebResourceError error) {
              if (error.isForMainFrame == false) return;
              ready.value = true;
              failed.value = error.description;
            },
          ),
        );
      unawaited(created.loadRequest(Uri.parse(_hostUrl)));
      return created;
    }, <Object?>[captchaId]);

    /// 重新加载宿主页并重新注入，用于验证失败后重试。
    Future<void> reload() async {
      failed.value = '';
      ready.value = false;
      await view.loadRequest(Uri.parse(_hostUrl));
    }

    /// 复制当前错误原文，方便直接粘贴反馈。
    Future<void> copyError() async {
      final String text = failed.value.trim();
      if (text.isEmpty) return;
      await Clipboard.setData(ClipboardData(text: text));
      if (!context.mounted) return;
      ToastMessage.success(l10n.coolapkCaptchaErrorCopied);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.coolapkCaptchaTitle),
        actions: <Widget>[
          IconButton(
            onPressed: reload,
            icon: Icon(Icons.refresh_rounded, size: 20.sp),
            tooltip: l10n.coolapkCaptchaRetry,
          ),
          SizedBox(width: 4.w),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: ready.value
              ? SizedBox(height: 3, child: ColoredBox(color: colors.surface))
              : LinearProgressIndicator(
                  minHeight: 3,
                  backgroundColor: colors.surfaceContainerHigh,
                ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                // WebView 是原生平台视图，尺寸为 0 时 Flutter 会直接断言崩溃
                // （`!size.isEmpty`）。路由切换的首帧约束可能为空，这里先占位。
                if (constraints.maxWidth <= 0 || constraints.maxHeight <= 0) {
                  return ColoredBox(color: colors.surface);
                }
                return WebViewWidget(controller: view);
              },
            ),
          ),
          CoolapkCaptchaFooter(
            ready: ready.value,
            busy: busy.value,
            failed: failed.value,
            onRetry: reload,
            onCopyError: copyError,
          ),
        ],
      ),
    );
  }
}
