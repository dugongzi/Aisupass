import 'package:Aisupass/common/widgets/loading.dart';
import 'package:Aisupass/common/widgets/ref_error.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/providers/adb_shell_provider.dart';
import 'package:Aisupass/features/escalation/domain/enums/root_manager.dart';
import 'package:Aisupass/features/escalation/domain/models/device_identity.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_run_result.dart';
import 'package:Aisupass/features/escalation/domain/models/handoff_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:Aisupass/features/escalation/domain/models/payload_match.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';
import 'package:Aisupass/generated/adb_shell.g.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// 手动提权页。
///
/// 上半部分是命令执行面板：把一条命令交给已连接的 shell（uid=2000）执行，
/// 并把退出码、stdout、stderr 原样展示，用于验证注入链路本身。
///
/// 下半部分是提权入口：不再由页面拼命令，而是把「匹配 + 执行 + 判据」整条
/// 交给 `runPayloadProvider`，页面只负责触发和渲染结果。
///
/// payload 走 `jniLibs`：so 由 PackageManager 解压到 `nativeLibraryDir`，
/// shell 身份可直接 `LD_PRELOAD`，因此不需要把字节经 stdin 搬进
/// `/data/local/tmp`。代价是不能热更新，加 payload 必须重新出包。
class ManualEscalationPage extends HookConsumerWidget {
  const ManualEscalationPage({super.key});

  /// 命令模板里的原生库目录占位符。
  static const String _libToken = '{lib}';

  /// 面板默认上限，与 `ShellConsoleController` 的默认值一致。
  static const Duration _quickTimeout = Duration(seconds: 20);

  /// 预置命令模板：覆盖注入链路验证的各个判据，省得每次手敲。
  ///
  /// `{lib}` 在执行前换成设备上真实的 `nativeLibraryDir`——该路径带安装随机
  /// 后缀，每次安装都变，写死必然失效，所以只能运行时拼。
  ///
  /// 文案随语言切换，因此每次 build 重新组装，不做成 `static const`。
  static List<({String label, String template, Duration timeout})> _presets(
    AppLocalizations l10n,
  ) => [
    (label: 'id -u', template: 'id -u', timeout: _quickTimeout),
    (label: 'id -Z', template: 'id -Z', timeout: _quickTimeout),
    (
      label: l10n.escalationPresetLibDir,
      template: 'ls -lZ $_libToken',
      timeout: _quickTimeout,
    ),
    (
      label: l10n.escalationPresetInject,
      template: 'LD_PRELOAD=$_libToken/libaisup_probe.so /system/bin/id -u',
      timeout: _quickTimeout,
    ),
    (
      label: l10n.escalationPresetChecksum,
      template: 'sha256sum $_libToken/libaisup_probe.so',
      timeout: _quickTimeout,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final TextEditingController input = useTextEditingController(text: 'id -u');
    final ShellConsoleState state = ref.watch(shellConsoleProvider);
    final ShellConnection? link = ref.watch(shellConnectionProvider).value;
    final String libDir = ref.watch(nativeLibraryDirProvider).value ?? '';

    // 提权是有副作用的操作，不能在 build 里自动触发：先记「用户点过了」，
    // 之后才开始 watch 那个 FutureProvider。
    final ValueNotifier<bool> exploitRequested = useState<bool>(false);
    final AsyncValue<EscalationRunResult>? exploit = exploitRequested.value
        ? ref.watch(runPayloadProvider)
        : null;

    final bool connected = link?.connected ?? false;
    final int uid = link?.uid ?? -1;
    final bool exploitRunning = exploit?.isLoading ?? false;
    final List<({String label, String template, Duration timeout})> presets =
        _presets(l10n);

    void run(String template, {Duration? timeout}) {
      if (state.running || template.trim().isEmpty) return;
      // 目录拿不到时注定跑不通，就地给出原因：放它下去只会拿到一条
      // 「library not found」，看起来像 so 缺失，实际是没解压。
      if (template.contains(_libToken) && libDir.isEmpty) {
        ref
            .read(shellConsoleProvider.notifier)
            .fail(l10n.escalationNativeDirUnavailable);
        return;
      }
      // 执行前把状态行刷新一次，避免面板显示的是配对前的旧身份。
      ref.invalidate(shellConnectionProvider);
      ref
          .read(shellConsoleProvider.notifier)
          .run(template.replaceAll(_libToken, libDir), timeout: timeout);
    }

    void runExploit() {
      if (exploitRunning) return;
      ref.invalidate(shellConnectionProvider);
      if (exploitRequested.value) {
        ref.invalidate(runPayloadProvider);
      } else {
        exploitRequested.value = true;
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.escalationTitle)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
        children: [
          _LinkBanner(connected: connected, uid: uid),
          SizedBox(height: 16.h),
          TextField(
            controller: input,
            maxLines: 3,
            minLines: 1,
            style: TextStyle(fontFamily: 'monospace', fontSize: 13.sp),
            decoration: InputDecoration(
              labelText: l10n.escalationCommandLabel,
              hintText: 'id -u',
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            onSubmitted: run,
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: state.running ? null : () => run(input.text),
                  icon: state.running
                      ? SizedBox.square(
                          dimension: 16.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(Icons.play_arrow_rounded, size: 20.r),
                  label: Text(
                    state.running
                        ? l10n.escalationRunningButton
                        : l10n.escalationRunButton,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              OutlinedButton(
                onPressed: state.running
                    ? null
                    : ref.read(shellConsoleProvider.notifier).clear,
                child: Text(l10n.escalationClearButton),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 4.h,
            children: [
              for (final ({String label, String template, Duration timeout})
                  preset
                  in presets)
                ActionChip(
                  label: Text(preset.label),
                  onPressed: state.running
                      ? null
                      : () {
                          // 输入框里放解析后的真实命令，方便对照结果自查。
                          input.text = preset.template.replaceAll(
                            _libToken,
                            libDir,
                          );
                          run(preset.template, timeout: preset.timeout);
                        },
                ),
            ],
          ),
          SizedBox(height: 20.h),
          _ResultView(state: state),
          SizedBox(height: 24.h),
          Divider(height: 1.h),
          SizedBox(height: 16.h),
          Text(
            l10n.escalationDesc,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: 12.h),
          const _MatchSummary(),
          SizedBox(height: 12.h),
          FilledButton.icon(
            onPressed: exploitRunning ? null : runExploit,
            icon: exploitRunning
                ? SizedBox.square(
                    dimension: 16.r,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(Icons.security_rounded, size: 20.r),
            label: Text(
              exploitRunning
                  ? l10n.escalationRunningButton
                  : l10n.escalationExploitButton,
            ),
          ),
          if (exploit != null) ...[
            SizedBox(height: 16.h),
            _ExploitView(
              state: exploit,
              onRetry: () => ref.invalidate(runPayloadProvider),
            ),
          ],
          SizedBox(height: 24.h),
          Divider(height: 1.h),
          SizedBox(height: 16.h),
          const _HandoffSection(),
        ],
      ),
    );
  }
}

/// 移交区：把刚拿到的临时 root 交给设备上已安装的管理器。
///
/// 与提权分开是刻意的——提权只负责「拿到 root」，「谁接管」是另一件事。
/// 结果按 [HandoffKind] 分四型渲染：「管理器没装」时给出下载页，
/// 「没有 root」时把人引回上面的提权按钮，而不是笼统一句失败。
class _HandoffSection extends HookConsumerWidget {
  const _HandoffSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ThemeData theme = Theme.of(context);
    final ValueNotifier<RootManager> manager = useState<RootManager>(
      RootManager.kernelsu,
    );
    // 记「哪个管理器被点过」而不是「点没点过」：换人选时不能自动开跑，
    // 移交有副作用，只能由按钮触发。
    final ValueNotifier<RootManager?> requested = useState<RootManager?>(null);
    final RootManager? target = requested.value;
    final AsyncValue<HandoffOutcome>? handoff = target == null
        ? null
        : ref.watch(handoffRootProvider(manager: target));
    final bool running = handoff?.isLoading ?? false;

    void handOff() {
      if (running) return;
      final RootManager selected = manager.value;
      if (target == selected) {
        ref.invalidate(handoffRootProvider(manager: selected));
      } else {
        requested.value = selected;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(l10n.escalationHandoffSection, style: theme.textTheme.titleSmall),
        SizedBox(height: 6.h),
        Text(l10n.escalationHandoffDesc, style: theme.textTheme.bodySmall),
        SizedBox(height: 12.h),
        SegmentedButton<RootManager>(
          segments: <ButtonSegment<RootManager>>[
            ButtonSegment<RootManager>(
              value: RootManager.kernelsu,
              label: Text(l10n.escalationHandoffManagerKernelsu),
            ),
            ButtonSegment<RootManager>(
              value: RootManager.sukisu,
              label: Text(l10n.escalationHandoffManagerSukisu),
            ),
          ],
          selected: <RootManager>{manager.value},
          onSelectionChanged: running
              ? null
              : (Set<RootManager> selection) => manager.value = selection.first,
        ),
        SizedBox(height: 12.h),
        FilledButton.icon(
          onPressed: running ? null : handOff,
          icon: running
              ? SizedBox.square(
                  dimension: 16.r,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(Icons.verified_user_rounded, size: 20.r),
          label: Text(
            running
                ? l10n.escalationRunningButton
                : l10n.escalationHandoffButton,
          ),
        ),
        if (target != null && handoff != null) ...[
          SizedBox(height: 16.h),
          _HandoffView(
            state: handoff,
            onRetry: () => ref.invalidate(handoffRootProvider(manager: target)),
          ),
        ],
      ],
    );
  }
}

/// 顶部连接状态条：这里显示的就是这条命令将以谁的身份跑。
class _LinkBanner extends StatelessWidget {
  const _LinkBanner({required this.connected, required this.uid});

  final bool connected;
  final int uid;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(
          connected ? Icons.link_rounded : Icons.link_off_rounded,
          size: 18.r,
          color: connected ? scheme.primary : scheme.error,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: SelectableText(
            connected
                ? l10n.escalationShellConnected(uid)
                : l10n.escalationShellDisconnected,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

/// 提权前的匹配摘要：设备身份、清单规模，以及这次会跑哪一份载荷。
///
/// 提权不可逆，执行前必须让用户看清命中结果；三个查询 Provider 的三态在
/// 这里统一收敛成「加载 / 失败 / 内容」，避免同一块区域出现三个转圈。
class _MatchSummary extends ConsumerWidget {
  const _MatchSummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final ThemeData theme = Theme.of(context);
    final AsyncValue<DeviceIdentity> device = ref.watch(
      currentDeviceIdentityProvider,
    );
    final AsyncValue<List<Payload>> catalog = ref.watch(payloadsProvider);
    final AsyncValue<PayloadMatch?> match = ref.watch(resolvedPayloadProvider);

    if (device.hasError || catalog.hasError || match.hasError) {
      return RefError(
        onRetry: () {
          ref.invalidate(currentDeviceIdentityProvider);
          ref.invalidate(payloadsProvider);
          ref.invalidate(resolvedPayloadProvider);
        },
        message: l10n.commonLoadFailed,
      );
    }
    if (device.isLoading || catalog.isLoading || match.isLoading) {
      return Loading(message: l10n.escalationMatchLoading);
    }

    final DeviceIdentity identity = device.requireValue;
    final PayloadMatch? hit = match.requireValue;
    final String kernel = identity.kernelUnknown
        ? l10n.escalationKernelUnknown
        : identity.kernelVersion;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _MatchLine(
          label: l10n.escalationDeviceLabel,
          value: '${identity.manufacturer} ${identity.model} · $kernel',
        ),
        _MatchLine(
          label: l10n.escalationCatalogLabel,
          value: '${catalog.requireValue.length}',
        ),
        _MatchLine(
          label: l10n.escalationMatchLabel,
          value: hit?.payload.displayName ?? l10n.escalationMatchNone,
          highlight: hit != null,
        ),
        if (hit != null && hit.isDegraded)
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Text(
              l10n.escalationMatchDegraded,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}

/// 匹配摘要的一行：左侧标签、右侧可复制的等宽值。
class _MatchLine extends StatelessWidget {
  const _MatchLine({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 76.w,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                color: highlight ? theme.colorScheme.primary : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 命令面板的结果区。
class _ResultView extends StatelessWidget {
  const _ResultView({required this.state});

  final ShellConsoleState state;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final String? error = state.error;
    final ShellExecResult? result = state.result;

    if (error != null) {
      return _Block(
        title: l10n.escalationInvokeFailed,
        color: scheme.error,
        body: error,
      );
    }
    if (result == null) {
      return const SizedBox.shrink();
    }

    return _Outcome(
      ok: result.exitCode == 0,
      exitCode: result.exitCode,
      durationMs: result.durationMs,
      timedOut: result.timedOut,
      stdout: result.stdout,
      stderr: result.stderr,
    );
  }
}

/// 提权结果区：三态分别交给通用 [Loading] / [RefError] / [_Outcome]。
class _ExploitView extends StatelessWidget {
  const _ExploitView({required this.state, required this.onRetry});

  final AsyncValue<EscalationRunResult> state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;

    return state.when(
      loading: () => Loading(message: l10n.escalationRunningButton),
      error: (Object error, StackTrace stackTrace) => RefError(
        onRetry: onRetry,
        message: '${l10n.escalationInvokeFailed}：$error',
      ),
      data: (EscalationRunResult result) => _Outcome(
        ok: result.success,
        exitCode: result.exitCode,
        durationMs: result.durationMs,
        timedOut: result.timedOut,
        stdout: result.stdout,
        stderr: result.stderr,
      ),
    );
  }
}

/// 移交结果区：三态分别交给通用 [Loading] / [RefError] / [_HandoffOutcomeView]。
class _HandoffView extends StatelessWidget {
  const _HandoffView({required this.state, required this.onRetry});

  final AsyncValue<HandoffOutcome> state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;

    return state.when(
      loading: () => Loading(message: l10n.escalationRunningButton),
      error: (Object error, StackTrace stackTrace) => RefError(
        onRetry: onRetry,
        message: '${l10n.escalationInvokeFailed}：$error',
      ),
      data: (HandoffOutcome outcome) => _HandoffOutcomeView(outcome: outcome),
    );
  }
}

/// 移交结果详情：按 [HandoffKind] 给出下一步该做什么。
///
/// 四型的差别不在于「成功还是失败」，而在于**用户接着该干什么**：
/// 管理器没装要去装、没有 root 要回去提权、命令失败才是真出问题。
/// 所以文案按 kind 分支，而不是复用 `_Outcome` 的「退出码 + stderr」，
/// 后者会把最有用的出路藏进一段英文输出里。
class _HandoffOutcomeView extends StatelessWidget {
  const _HandoffOutcomeView({required this.outcome});

  final HandoffOutcome outcome;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final RootManager manager = outcome.manager;

    final String message = switch (outcome.kind) {
      HandoffKind.success => l10n.escalationHandoffSuccess(manager.displayName),
      HandoffKind.managerMissing => l10n.escalationHandoffManagerMissing(
        manager.displayName,
        manager.packageName,
      ),
      HandoffKind.noRoot => l10n.escalationHandoffNoRoot,
      HandoffKind.failed => outcome.exitCode < 0
          ? l10n.escalationHandoffFailedNoCode
          : l10n.escalationHandoffFailed(outcome.exitCode),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              outcome.success
                  ? Icons.check_circle_rounded
                  : Icons.error_outline_rounded,
              size: 18.r,
              color: outcome.success ? scheme.primary : scheme.error,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: outcome.success ? null : scheme.error,
                ),
              ),
            ),
          ],
        ),
        // 「管理器没装」是唯一有外部出路的形态：把下载页给出去，
        // 用户装完回来重试即可。其余三种只能靠上面的操作或重试解决。
        if (outcome.kind == HandoffKind.managerMissing) ...[
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.tonalIcon(
              onPressed: () => launchUrl(
                Uri.parse(manager.homeUrl),
                mode: LaunchMode.externalApplication,
              ),
              icon: Icon(Icons.open_in_new_rounded, size: 18.r),
              label: Text(l10n.escalationHandoffOpenHome(manager.displayName)),
            ),
          ),
        ],
        SizedBox(height: 10.h),
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: outcome.success
                    ? scheme.primaryContainer
                    : scheme.errorContainer,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                // 与 `_Outcome` 同一约定：负数不是真实退出码，是「没取到」。
                outcome.exitCode < 0
                    ? 'exit --'
                    : 'exit ${outcome.exitCode}',
                style: TextStyle(fontFamily: 'monospace', fontSize: 12.sp),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              '${outcome.durationMs} ms'
              '${outcome.timedOut ? l10n.escalationTimedOutTag : ''}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        if (outcome.ksudPath.isNotEmpty) ...[
          SizedBox(height: 12.h),
          _Block(title: 'libksud.so', body: outcome.ksudPath),
        ],
        if (outcome.output.isNotEmpty) ...[
          SizedBox(height: 12.h),
          _Block(
            title: 'output',
            body: outcome.output,
            color: outcome.success ? null : scheme.error,
          ),
        ],
      ],
    );
  }
}

/// 结果详情：退出码、耗时与两路输出分行展示。
///
/// 命令面板与提权入口共用同一套版式，避免两处各自维护。
class _Outcome extends StatelessWidget {
  const _Outcome({
    required this.ok,
    required this.exitCode,
    required this.durationMs,
    required this.timedOut,
    required this.stdout,
    required this.stderr,
  });

  final bool ok;
  final int exitCode;
  final int durationMs;
  final bool timedOut;
  final String stdout;
  final String stderr;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: ok ? scheme.primaryContainer : scheme.errorContainer,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                // 负数不是真实退出码，是「没取到」：命令没跑起来，或者提权
                // 走后台轮询、回收不到返回值。显示成 `exit -1` 会误导。
                exitCode < 0 ? 'exit --' : 'exit $exitCode',
                style: TextStyle(fontFamily: 'monospace', fontSize: 12.sp),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              '$durationMs ms${timedOut ? l10n.escalationTimedOutTag : ''}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        if (stdout.isNotEmpty) ...[
          SizedBox(height: 12.h),
          _Block(title: 'stdout', body: stdout),
        ],
        if (stderr.isNotEmpty) ...[
          SizedBox(height: 12.h),
          _Block(title: 'stderr', body: stderr, color: scheme.error),
        ],
      ],
    );
  }
}

/// 等宽文本块：命令输出必须能原样复制，所以用可选中文本。
///
/// `title` 取 `stdout` / `stderr` 这类流名，属纯技术标识，不走 l10n。
class _Block extends StatelessWidget {
  const _Block({required this.title, required this.body, this.color});

  final String title;
  final String body;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelSmall?.copyWith(
            color: color ?? theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: SelectableText(
            body,
            style: TextStyle(fontFamily: 'monospace', fontSize: 12.sp),
          ),
        ),
      ],
    );
  }
}
