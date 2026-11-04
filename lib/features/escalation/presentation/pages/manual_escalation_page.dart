import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/providers/adb_shell_provider.dart';
import 'package:Aisupass/generated/adb_shell.g.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 手动提权页。
///
/// 当前只承载一个命令执行面板：把一条命令交给已连接的 shell（uid=2000）执行，
/// 并把退出码、stdout、stderr 原样展示。它是 LD_PRELOAD 注入链路的验证入口——
/// 先证明「App 内能执行命令并读到证据」，再往上接 payload。
///
/// payload 走 `jniLibs`：so 由 PackageManager 解压到 `nativeLibraryDir`，
/// shell 身份可直接 `LD_PRELOAD`，因此不需要把字节经 stdin 搬进
/// `/data/local/tmp`。代价是不能热更新，加 payload 必须重新出包。
class ManualEscalationPage extends HookConsumerWidget {
  const ManualEscalationPage({super.key});

  /// 命令模板里的原生库目录占位符。
  static const String _libToken = '{lib}';

  /// 预置命令模板：覆盖注入链路验证的各个判据，省得每次手敲。
  ///
  /// `{lib}` 在执行前换成设备上真实的 `nativeLibraryDir`——该路径带安装随机
  /// 后缀，每次安装都变，写死必然失效，所以只能运行时拼。
  static const List<({String label, String template})> _presets = [
    (label: 'id -u', template: 'id -u'),
    (label: 'id -Z', template: 'id -Z'),
    (label: 'lib 目录', template: 'ls -lZ $_libToken'),
    (
      label: 'L1 注入',
      template: 'LD_PRELOAD=$_libToken/libaisup_probe.so /system/bin/id -u',
    ),
    (label: 'so 校验', template: 'sha256sum $_libToken/libaisup_probe.so'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final TextEditingController input = useTextEditingController(text: 'id -u');
    final ShellConsoleState state = ref.watch(shellConsoleProvider);
    final ShellConnection? link = ref.watch(shellConnectionProvider).value;
    final String libDir = ref.watch(nativeLibraryDirProvider).value ?? '';

    final bool connected = link?.connected ?? false;
    final int uid = link?.uid ?? -1;

    void run(String template) {
      if (state.running || template.trim().isEmpty) return;
      // 目录拿不到时注定跑不通，就地给出原因：放它下去只会拿到一条
      // 「library not found」，看起来像 so 缺失，实际是没解压。
      if (template.contains(_libToken) && libDir.isEmpty) {
        ref
            .read(shellConsoleProvider.notifier)
            .fail('原生库目录不可用：当前安装没有解压 jniLibs 里的 so'
                '（需 extractNativeLibs / useLegacyPackaging 为 true）');
        return;
      }
      // 执行前把状态行刷新一次，避免面板显示的是配对前的旧身份。
      ref.invalidate(shellConnectionProvider);
      ref.read(shellConsoleProvider.notifier).run(
            template.replaceAll(_libToken, libDir),
          );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.escalationTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          _LinkBanner(connected: connected, uid: uid),
          const SizedBox(height: 16),
          TextField(
            controller: input,
            maxLines: 3,
            minLines: 1,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            decoration: const InputDecoration(
              labelText: '命令',
              hintText: 'id -u',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onSubmitted: run,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: state.running ? null : () => run(input.text),
                  icon: state.running
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.play_arrow_rounded, size: 20),
                  label: Text(state.running ? '执行中…' : '执行'),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: state.running
                    ? null
                    : ref.read(shellConsoleProvider.notifier).clear,
                child: const Text('清空'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final ({String label, String template}) preset in _presets)
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
                          run(preset.template);
                        },
                ),
            ],
          ),
          const SizedBox(height: 20),
          _ResultView(state: state),
        ],
      ),
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
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(
          connected ? Icons.link_rounded : Icons.link_off_rounded,
          size: 18,
          color: connected ? scheme.primary : scheme.error,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SelectableText(
            connected ? 'shell 已连接（uid=$uid）' : '未连接，请先在首页完成无线调试配对',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

/// 结果区：退出码、耗时与两路输出分行展示。
class _ResultView extends StatelessWidget {
  const _ResultView({required this.state});

  final ShellConsoleState state;

  @override
  Widget build(BuildContext context) {
    final String? error = state.error;
    final ShellExecResult? result = state.result;

    if (error != null) {
      return _Block(
        title: '调用失败',
        color: Theme.of(context).colorScheme.error,
        body: error,
      );
    }
    if (result == null) {
      return const SizedBox.shrink();
    }

    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: result.exitCode == 0
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'exit ${result.exitCode}',
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${result.durationMs} ms${result.timedOut ? '（超时）' : ''}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        if (result.stdout.isNotEmpty) ...[
          const SizedBox(height: 12),
          _Block(title: 'stdout', body: result.stdout),
        ],
        if (result.stderr.isNotEmpty) ...[
          const SizedBox(height: 12),
          _Block(
            title: 'stderr',
            body: result.stderr,
            color: theme.colorScheme.error,
          ),
        ],
      ],
    );
  }
}

/// 等宽文本块：命令输出必须能原样复制，所以用可选中文本。
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
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SelectableText(
            body,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
      ],
    );
  }
}
