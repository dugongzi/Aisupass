import 'dart:async';
import 'dart:convert';

import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/network/api_exception.dart';
import 'package:Aisupass/core/utils/ai_builtin_login_script.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/ai/domain/constants/builtin_ai_config.dart';
import 'package:Aisupass/features/ai/domain/enums/ai_builtin_login_stage.dart';
import 'package:Aisupass/features/ai/domain/models/ai_builtin_group.dart';
import 'package:Aisupass/features/ai/domain/models/ai_builtin_model.dart';
import 'package:Aisupass/features/ai/presentation/controllers/ai_builtin_login_controller.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_builtin_group_picker_sheet.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_builtin_login_footer.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_builtin_model_picker_sheet.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_builtin_platform_picker_sheet.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_builtin_status_bar.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 页面与注入脚本之间的 JS 通道名，必须与脚本里的一致。
const String _channelName = 'AiBuiltinBridge';

/// 单页加载超时，卡住时结束进度条。
const Duration _loadTimeout = Duration(seconds: 30);

/// 移动版 UA，避免被站点判定成不支持的浏览器。
const String _mobileUserAgent =
    'Mozilla/5.0 (Linux; Android 14; PHB110) AppleWebKit/537.36 '
    '(KHTML, like Gecko) Chrome/131.0.0.0 Mobile Safari/537.36';

/// 需要注入脚本的域名后缀。
const String _panelHostSuffix = 'muxueai.pro';

/// 内置面板的登录页。
///
/// 注册、图形验证码、邮箱验证码与二次验证都在网页里完成，应用只做两件事：
/// 从页面里读出登录令牌，然后用令牌拉分组、建密钥并写进内置配置。
class AiBuiltinLoginPage extends HookConsumerWidget {
  const AiBuiltinLoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;

    if (!isAndroidPlatform) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.aiBuiltinLoginTitle)),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.desktop_windows_rounded,
                  size: 40.sp,
                  color: context.colorScheme.onSurfaceVariant,
                ),
                SizedBox(height: 12.h),
                Text(
                  l10n.aiBuiltinLoginDesktopUnsupported,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.sp, height: 1.5),
                ),
                SizedBox(height: 16.h),
                FilledButton.icon(
                  onPressed: () => launchUrl(
                    Uri.parse(builtinAiConfigLoginUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                  icon: Icon(Icons.open_in_new_rounded, size: 16.sp),
                  label: Text(l10n.aiBuiltinOpenSite),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final AiBuiltinLoginController aiController = useMemoized(
      () => AiBuiltinLoginController(ref: ref),
      const <Object?>[],
    );

    final ValueNotifier<AiBuiltinLoginStage> stage =
        useState<AiBuiltinLoginStage>(AiBuiltinLoginStage.waitingLogin);
    final ValueNotifier<String> failure = useState<String>('');
    final ValueNotifier<String> issuedKey = useState<String>('');
    // 已拿到的登录令牌：弹层被取消或流程失败时，用它重跑而不必重新登录。
    final ValueNotifier<String> pendingToken = useState<String>('');
    final ValueNotifier<String> loadError = useState<String>('');
    final ValueNotifier<bool> busy = useState<bool>(false);
    final ValueNotifier<int> progress = useState<int>(0);
    final ValueNotifier<bool> loading = useState<bool>(true);

    late final WebViewController view;

    /// 进入失败态并记录原因。
    void fail(String message) {
      stage.value = AiBuiltinLoginStage.failed;
      failure.value = message;
    }

    /// 用登录令牌走完「拉厂商 -> 选厂商 -> 选分组 -> 选模型 -> 建密钥 -> 落库」。
    Future<void> runFlow(String token) async {
      if (busy.value) return;
      busy.value = true;
      failure.value = '';
      stage.value = AiBuiltinLoginStage.loadingGroups;
      try {
        await aiController.rememberToken(token);
        final List<AiBuiltinGroup> groups = await aiController.loadGroups(
          token: token,
        );
        if (!context.mounted) return;
        if (groups.isEmpty) {
          fail(l10n.aiBuiltinPlatformEmpty);
          return;
        }

        // 弹层覆盖页面期间，状态条退回等待态，避免显示上一个进度。
        stage.value = AiBuiltinLoginStage.waitingLogin;
        final List<AiBuiltinGroup>? vendorGroups =
            await showAiBuiltinPlatformPickerSheet(context, groups: groups);
        if (vendorGroups == null || !context.mounted) return;

        final AiBuiltinGroup? group = await showAiBuiltinGroupPickerSheet(
          context,
          groups: vendorGroups,
        );
        if (group == null || !context.mounted) return;

        final AiBuiltinModel? model = await showAiBuiltinModelPickerSheet(
          context,
          group: group,
        );
        if (model == null || !context.mounted) return;

        stage.value = AiBuiltinLoginStage.creating;
        final String key = await aiController.createKey(
          token: token,
          group: group,
        );
        await aiController.persist(
          apiKey: key,
          group: group,
          model: model,
        );
        if (!context.mounted) return;
        issuedKey.value = key;
        stage.value = AiBuiltinLoginStage.done;
      } on ApiException catch (error) {
        // 令牌失效时清掉本地副本，让用户重新登录后再试。
        if (error.isUnauthorized) await aiController.forgetToken();
        if (!context.mounted) return;
        fail(error.message);
      } catch (error) {
        if (!context.mounted) return;
        fail('$error');
      } finally {
        busy.value = false;
      }
    }

    /// 仅在 debug 构建记录页面存储键名，便于排查页面改版后的令牌位置。
    ///
    /// 键名本身不含敏感值：令牌只存在页面内存里，这里不会泄露。
    void _logProbe(Map<String, dynamic> data) {
      if (!kDebugMode) return;
      debugPrint(
        '[AiBuiltin] probe keys=${data['keys']} signedIn=${data['signedIn']}',
      );
    }

    /// 处理脚本回传：`token` 驱动主流程，`key` 兜底复制到剪贴板。
    Future<void> handleMessage(String payload) async {
      Map<String, dynamic>? data;
      try {
        final Object? decoded = jsonDecode(payload);
        if (decoded is Map) {
          data = decoded.map(
            (Object? key, Object? value) => MapEntry(key.toString(), value),
          );
        }
      } on FormatException {
        return;
      }
      if (data == null) return;

      switch (data['type']) {
        case 'token':
          final String token = (data['token'] ?? '').toString().trim();
          if (token.isEmpty || stage.value == AiBuiltinLoginStage.done) return;
          pendingToken.value = token;
          await runFlow(token);
          return;
        case 'key':
          final String key = (data['key'] ?? '').toString().trim();
          if (key.isEmpty) return;
          await Clipboard.setData(ClipboardData(text: key));
          if (!context.mounted) return;
          ToastMessage.success(l10n.aiBuiltinKeyCopied);
          return;
        case 'debug':
          _logProbe(data);
          return;
        default:
          return;
      }
    }

    /// 页面就绪后注入脚本；每次导航完成都注入，脚本自身保证幂等。
    Future<void> inject() async {
      try {
        await view.runJavaScript(
          aiBuiltinLoginScript(channelName: _channelName),
        );
      } catch (_) {
        // 注入失败不阻断人工流程：用户仍可在网页里完成注册登录。
      }
    }

    /// 重新加载登录页并复位失败态。
    Future<void> reload() async {
      loadError.value = '';
      failure.value = '';
      progress.value = 0;
      loading.value = true;
      if (stage.value == AiBuiltinLoginStage.failed) {
        stage.value = AiBuiltinLoginStage.waitingLogin;
      }
      await view.loadRequest(Uri.parse(builtinAiConfigLoginUrl));
    }

    /// 在网页里手动创建密钥：直接打开密钥页。
    Future<void> openManualCreate() async {
      await view.loadRequest(
        Uri.parse('$builtinAiConfigBaseUrl/keys'),
      );
    }

    /// 复制已生成的密钥。
    Future<void> copyKey() async {
      final String key = issuedKey.value;
      if (key.isEmpty) return;
      await Clipboard.setData(ClipboardData(text: key));
      if (!context.mounted) return;
      ToastMessage.success(l10n.aiBuiltinKeyCopied);
    }

    view = useMemoized(() {
      final WebViewController created = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setUserAgent(_mobileUserAgent)
        ..addJavaScriptChannel(
          _channelName,
          onMessageReceived: (JavaScriptMessage message) {
            unawaited(handleMessage(message.message));
          },
        )
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int value) => progress.value = value,
            onPageStarted: (String url) {
              loadError.value = '';
              loading.value = true;
            },
            onPageFinished: (String url) {
              loading.value = false;
              final Uri? uri = Uri.tryParse(url);
              final String host = uri?.host.toLowerCase() ?? '';
              if (!host.endsWith(_panelHostSuffix)) return;
              unawaited(inject());
            },
            onWebResourceError: (WebResourceError error) {
              if (error.isForMainFrame == false) return;
              loading.value = false;
              loadError.value = error.description.isEmpty
                  ? l10n.aiBuiltinLoginLoadFailed
                  : error.description;
            },
          ),
        );
      unawaited(created.loadRequest(Uri.parse(builtinAiConfigLoginUrl)));
      return created;
    }, const <Object?>[]);

    useEffect(() {
      if (!loading.value || loadError.value.isNotEmpty) return null;
      final Timer timer = Timer(_loadTimeout, () {
        if (!loading.value) return;
        loading.value = false;
        loadError.value = l10n.aiBuiltinLoginLoadTimeout;
      });
      return timer.cancel;
    }, <Object?>[loading.value, loadError.value]);

    final ColorScheme colors = context.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.aiBuiltinLoginTitle),
        actions: <Widget>[
          IconButton(
            onPressed: reload,
            icon: Icon(Icons.refresh_rounded, size: 20.sp),
            tooltip: l10n.aiBuiltinReload,
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
          AiBuiltinStatusBar(
            stage: stage.value,
            failure: failure.value,
            onRetry: () => unawaited(reload()),
          ),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                WebViewWidget(controller: view),
                if (loadError.value.isNotEmpty)
                  Positioned.fill(
                    child: ColoredBox(
                      color: colors.surface,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                loadError.value,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.5.sp,
                                  height: 1.45,
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(height: 14.h),
                              FilledButton(
                                onPressed: reload,
                                child: Text(l10n.aiBuiltinRetry),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          AiBuiltinLoginFooter(
            stage: stage.value,
            busy: busy.value,
            issuedKey: issuedKey.value,
            canContinue: pendingToken.value.isNotEmpty,
            onCancel: () => Navigator.of(context).pop(),
            onContinue: () => unawaited(runFlow(pendingToken.value)),
            onReload: () => unawaited(reload()),
            onManualCreate: () => unawaited(openManualCreate()),
            onCopyKey: () => unawaited(copyKey()),
            onFinish: () => Navigator.of(context).pop(issuedKey.value),
          ),
        ],
      ),
    );
  }
}
