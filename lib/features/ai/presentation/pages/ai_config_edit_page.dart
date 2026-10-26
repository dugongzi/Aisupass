import 'package:Aisupass/common/widgets/app_select.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/routes/app_route.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/ai/data/datasources/ai_model_query_datasource.dart';
import 'package:Aisupass/features/ai/domain/constants/builtin_ai_config.dart';
import 'package:Aisupass/features/ai/domain/enums/ai_api_type.dart';
import 'package:Aisupass/features/ai/domain/models/ai_config.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_config_action_provider.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_config_query_provider.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_model_query_provider.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_brand_icon.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_model_picker.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_section_card.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_text_field.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

/// 常用服务商预设。名称属于品牌专有名词，不做翻译。
class _AiPreset {
  const _AiPreset({
    required this.label,
    required this.baseUrl,
    required this.apiType,
  });

  final String label;
  final String baseUrl;
  final AiApiType apiType;
}

const List<_AiPreset> _presets = <_AiPreset>[
  _AiPreset(
    label: 'OpenAI',
    baseUrl: 'https://api.openai.com/v1',
    apiType: AiApiType.openai,
  ),
  _AiPreset(
    label: 'DeepSeek',
    baseUrl: 'https://api.deepseek.com/v1',
    apiType: AiApiType.openai,
  ),
  _AiPreset(
    label: 'Moonshot',
    baseUrl: 'https://api.moonshot.cn/v1',
    apiType: AiApiType.openai,
  ),
  _AiPreset(
    label: 'Anthropic',
    baseUrl: 'https://api.anthropic.com/v1',
    apiType: AiApiType.anthropic,
  ),
];

/// 连通性检测状态。
enum _ConnState { idle, testing, ok, failed }

/// AI 配置编辑页。
///
/// [configId] 传 [AppRoute.newConfigId] 表示新建，其余按 id 读取已有配置。
class AiConfigEditPage extends HookConsumerWidget {
  const AiConfigEditPage({super.key, required this.configId});

  final String configId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = context.l10n;
    final bool isDesktop = isDesktopPlatform;
    final AiConfig? existing = configId == AppRoute.newConfigId
        ? null
        : ref.watch(aiConfigProvider).value?.byId(configId);

    // 内置配置只允许改 API Key，其余字段一律取常量。
    final bool isBuiltinEditing = existing != null && isBuiltinAiConfig(existing);

    final TextEditingController nameController = useTextEditingController(
      text: existing?.name ?? '',
    );
    final TextEditingController urlController = useTextEditingController(
      text: existing?.apiUrl ?? '',
    );
    final TextEditingController apiKeyController = useTextEditingController(
      text: existing?.apiKey ?? '',
    );
    final TextEditingController maxTokensController = useTextEditingController(
      text: (existing?.maxToken ?? 0) > 0 ? '${existing!.maxToken}' : '',
    );
    final TextEditingController temperatureController =
        useTextEditingController(
          text: (existing?.temperature ?? -1) >= 0
              ? '${existing!.temperature}'
              : '',
        );

    // 新建时生成一次 id，保存时直接复用，避免每次 build 都换 id。
    final String draftId = useMemoized<String>(
      () => existing?.id ?? const Uuid().v4(),
      <Object?>[existing?.id],
    );

    final ValueNotifier<AiApiType> apiType = useState<AiApiType>(
      existing?.apiType ?? AiApiType.openai,
    );
    final ValueNotifier<String> model = useState<String>(
      existing?.modelName ?? '',
    );
    final ValueNotifier<List<String>> models = useState<List<String>>(
      const <String>[],
    );
    final ValueNotifier<bool> loadingModels = useState<bool>(false);
    final ValueNotifier<bool> saving = useState<bool>(false);
    final ValueNotifier<bool> advancedOpen = useState<bool>(false);
    final ValueNotifier<Map<String, String>> errors =
        useState<Map<String, String>>(const <String, String>{});
    final ValueNotifier<_ConnState> connState = useState<_ConnState>(
      _ConnState.idle,
    );
    final ValueNotifier<String> connMessage = useState<String>('');
    final ValueNotifier<int> connCount = useState<int>(0);

    void clearFieldError(String key) {
      if (!errors.value.containsKey(key)) return;
      errors.value = <String, String>{...errors.value}..remove(key);
    }

    AiConfig buildConfig() => isBuiltinEditing
        ? buildBuiltinAiConfig(
            apiKey: apiKeyController.text.trim(),
            modelName: model.value.trim(),
            apiType: apiType.value,
          )
        : AiConfig(
            id: draftId,
            name: nameController.text.trim(),
            apiUrl: urlController.text.trim(),
            apiKey: apiKeyController.text.trim(),
            modelName: model.value.trim(),
            maxToken: int.tryParse(maxTokensController.text.trim()) ?? 0,
            temperature:
                double.tryParse(temperatureController.text.trim()) ?? -1,
            apiType: apiType.value,
          );

    /// 打开内置服务的站点获取 API Key。
    Future<void> openGetKey() => launchUrl(
      Uri.parse(builtinAiConfigPurchaseUrl),
      mode: LaunchMode.externalApplication,
    );

    String describeError(AiRequestException error) {
      final int? code = error.statusCode;
      if (code == 401 || code == 403) return l10n.aiErrorAuth(code!);
      if (code == 404) return l10n.aiErrorNotFound;
      if (code != null) return l10n.aiErrorHttp(code, error.message);
      return l10n.aiErrorNetwork(error.message);
    }

    /// 拉取模型列表，同时充当连通性检测。
    Future<bool> loadModels() async {
      final String url = urlController.text.trim();
      if (url.isEmpty) {
        errors.value = <String, String>{
          ...errors.value,
          'url': l10n.aiFieldRequired,
        };
        return false;
      }
      if (!_isValidUrl(url)) {
        errors.value = <String, String>{
          ...errors.value,
          'url': l10n.aiInvalidUrl,
        };
        return false;
      }
      if (apiKeyController.text.trim().isEmpty) {
        errors.value = <String, String>{
          ...errors.value,
          'key': l10n.aiFieldRequired,
        };
        return false;
      }

      loadingModels.value = true;
      connState.value = _ConnState.testing;
      try {
        final List<String> list = await ref
            .read(aiModelQueryRepositoryProvider)
            .fetchModels(buildConfig());
        models.value = list;
        connCount.value = list.length;
        clearFieldError('model');
        connState.value = _ConnState.ok;
        // 已选模型若不在最新列表里（例如服务端已下线该模型），清空让用户重选。
        final String current = model.value.trim();
        if (current.isNotEmpty && !list.contains(current)) {
          model.value = '';
        }
        // 不自动选中，交由用户从列表里挑。
        if (model.value.trim().isEmpty) {
          ToastMessage.show(l10n.aiModelPickHint);
        }
        return true;
      } on AiRequestException catch (error) {
        connMessage.value = describeError(error);
        connState.value = _ConnState.failed;
        ToastMessage.error(connMessage.value);
        return false;
      } catch (error) {
        connMessage.value = l10n.aiErrorNetwork(error.toString());
        connState.value = _ConnState.failed;
        ToastMessage.error(connMessage.value);
        return false;
      } finally {
        loadingModels.value = false;
      }
    }

    void applyPreset(_AiPreset preset) {
      urlController.text = preset.baseUrl;
      apiType.value = preset.apiType;
      if (nameController.text.trim().isEmpty) {
        nameController.text = preset.label;
      }
      model.value = '';
      models.value = const <String>[];
      connState.value = _ConnState.idle;
      clearFieldError('url');
    }

    Future<void> handleSave() async {
      final Map<String, String> nextErrors = <String, String>{};
      // 内置配置的名称与地址由常量决定，跳过这两项校验。
      if (!isBuiltinEditing) {
        if (nameController.text.trim().isEmpty) {
          nextErrors['name'] = l10n.aiFieldRequired;
        }
        final String url = urlController.text.trim();
        if (url.isEmpty) {
          nextErrors['url'] = l10n.aiFieldRequired;
        } else if (!_isValidUrl(url)) {
          nextErrors['url'] = l10n.aiInvalidUrl;
        }
      }
      if (apiKeyController.text.trim().isEmpty) {
        nextErrors['key'] = l10n.aiFieldRequired;
      }
      errors.value = nextErrors;
      if (nextErrors.isNotEmpty) return;

      // 保存与刷新互不触发：只校验模型是否已选定。
      if (model.value.trim().isEmpty) {
        final String tip = models.value.isEmpty
            ? l10n.aiModelRequired
            : l10n.aiModelPickHint;
        errors.value = <String, String>{...errors.value, 'model': tip};
        ToastMessage.show(tip);
        return;
      }

      saving.value = true;
      try {
        await ref.read(aiConfigActionsProvider).save(buildConfig());
        saving.value = false;
        ToastMessage.success(l10n.aiSaveSuccess);
        if (context.mounted) context.pop();
      } catch (error) {
        saving.value = false;
        ToastMessage.error(l10n.aiSaveFailed(error.toString()));
      }
    }

    final TextStyle labelStyle = TextStyle(
      fontSize: 12.5.sp,
      fontWeight: FontWeight.w600,
      color: context.colorScheme.onSurfaceVariant,
    );

    final Widget apiTypeControl = isDesktop
        ? AppSelect<AiApiType>(
            value: apiType.value,
            width: 220,
            items: <AppSelectItem<AiApiType>>[
              for (final AiApiType type in AiApiType.values)
                AppSelectItem<AiApiType>(value: type, label: type.label),
            ],
            onChanged: (AiApiType value) => apiType.value = value,
          )
        : SizedBox(
            width: double.infinity,
            child: SegmentedButton<AiApiType>(
              segments: <ButtonSegment<AiApiType>>[
                for (final AiApiType type in AiApiType.values)
                  ButtonSegment<AiApiType>(
                    value: type,
                    label: Text(type.shortLabel),
                  ),
              ],
              selected: <AiApiType>{apiType.value},
              showSelectedIcon: false,
              style: SegmentedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                textStyle: TextStyle(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onSelectionChanged: (Set<AiApiType> selection) =>
                  apiType.value = selection.first,
            ),
          );

    final Widget apiTypeField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 2.w, bottom: 7.h),
          child: Text(l10n.aiApiType, style: labelStyle),
        ),
        apiTypeControl,
      ],
    );

    final Widget quickStartCard = AiSectionCard(
      title: l10n.aiQuickStart,
      icon: Icons.bolt_rounded,
      children: <Widget>[
        Text(
          l10n.aiQuickStartHint,
          style: TextStyle(
            fontSize: 11.5.sp,
            height: 1.4,
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: <Widget>[
            for (final _AiPreset preset in _presets)
              _PresetChip(
                preset: preset,
                selected: urlController.text.trim() == preset.baseUrl,
                onTap: () => applyPreset(preset),
              ),
          ],
        ),
      ],
    );

    final Widget connectionCard = AiSectionCard(
      title: l10n.aiConnectionSection,
      icon: Icons.link_rounded,
      children: <Widget>[
        if (isBuiltinEditing) ...<Widget>[
          _BuiltinNotice(onGetKey: openGetKey),
          SizedBox(height: 14.h),
        ],
        AiTextField(
          controller: nameController,
          label: l10n.aiConfigName,
          hint: l10n.aiConfigNameHint,
          readOnly: isBuiltinEditing,
          errorText: errors.value['name'],
          onChanged: (String _) => clearFieldError('name'),
        ),
        SizedBox(height: 14.h),
        AiTextField(
          controller: urlController,
          label: l10n.aiBaseUrl,
          hint: l10n.aiBaseUrlHint,
          keyboardType: TextInputType.url,
          readOnly: isBuiltinEditing,
          errorText: errors.value['url'],
          onChanged: (String _) {
            clearFieldError('url');
            if (connState.value != _ConnState.idle) {
              connState.value = _ConnState.idle;
            }
          },
        ),
        SizedBox(height: 14.h),
        AiTextField(
          controller: apiKeyController,
          label: l10n.aiApiKey,
          hint: l10n.aiApiKeyHint,
          obscure: true,
          errorText: errors.value['key'],
          onChanged: (String _) => clearFieldError('key'),
        ),
        SizedBox(height: 14.h),
        apiTypeField,
      ],
    );

    final Widget modelCard = AiSectionCard(
      title: l10n.aiModelName,
      icon: Icons.hub_outlined,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: AiModelPicker(
                value: model.value,
                models: models.value,
                loading: loadingModels.value,
                onChanged: (String value) {
                  model.value = value;
                  clearFieldError('model');
                },
                errorText: errors.value['model'],
              ),
            ),
            SizedBox(width: 8.w),
            _RefreshButton(
              loading: loadingModels.value,
              tooltip: l10n.aiModelLoad,
              onTap: loadModels,
            ),
          ],
        ),
      ],
    );

    final Widget advancedCard = AiSectionCard(
      title: l10n.aiAdvancedSection,
      icon: Icons.tune_rounded,
      onHeaderTap: () => advancedOpen.value = !advancedOpen.value,
      trailing: AnimatedRotation(
        turns: advancedOpen.value ? 0.5 : 0,
        duration: const Duration(milliseconds: 200),
        child: Icon(
          Icons.expand_more_rounded,
          size: 20.sp,
          color: context.colorScheme.onSurfaceVariant,
        ),
      ),
      children: <Widget>[
        if (!advancedOpen.value)
          Text(
            l10n.aiAdvancedHint,
            style: TextStyle(
              fontSize: 11.5.sp,
              height: 1.4,
              color: context.colorScheme.onSurfaceVariant,
            ),
          )
        else ...<Widget>[
          AiTextField(
            controller: maxTokensController,
            label: l10n.aiMaxTokens,
            hint: l10n.aiMaxTokensHint,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
          SizedBox(height: 14.h),
          AiTextField(
            controller: temperatureController,
            label: l10n.aiTemperature,
            hint: l10n.aiTemperatureHint,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
          ),
        ],
      ],
    );

    final Widget body = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isDesktop ? 760 : double.infinity,
        ),
        child: ListView(
          padding: isDesktop
              ? const EdgeInsets.fromLTRB(28, 6, 28, 24)
              : EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          children: <Widget>[
            if (!isBuiltinEditing) ...<Widget>[
              quickStartCard,
              SizedBox(height: isDesktop ? 16 : 16.h),
            ],
            connectionCard,
            SizedBox(height: isDesktop ? 16 : 16.h),
            modelCard,
            if (!isBuiltinEditing) ...<Widget>[
              SizedBox(height: isDesktop ? 16 : 16.h),
              advancedCard,
            ],
          ],
        ),
      ),
    );

    final Widget saveButton = FilledButton(
      onPressed: saving.value ? null : handleSave,
      style: FilledButton.styleFrom(
        minimumSize: Size(isDesktop ? 120 : 108.w, isDesktop ? 42 : 44.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
      ),
      child: saving.value
          ? SizedBox(
              width: 16.w,
              height: 16.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.colorScheme.onPrimary,
              ),
            )
          : Text(l10n.aiSave),
    );

    final Widget bottomBar = Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: context.colorScheme.outline.withValues(
              alpha: context.isDark ? 0.28 : 0.14,
            ),
          ),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: context.colorScheme.shadow.withValues(
              alpha: context.isDark ? 0.24 : 0.05,
            ),
            blurRadius: 14,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        // heightFactor 让底部栏贴合内容高度；直接 Center 会在
        // bottomNavigationBar 的松约束下撑满整屏，把 body 挤成 0 高。
        child: Align(
          alignment: Alignment.center,
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 760 : double.infinity,
            ),
            child: Padding(
              padding: isDesktop
                  ? const EdgeInsets.symmetric(horizontal: 28, vertical: 12)
                  : EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: _ConnStatus(
                      state: connState.value,
                      message: connMessage.value,
                      count: connCount.value,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  saveButton,
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final String title = existing == null
        ? l10n.aiConfigNew
        : l10n.aiConfigEditTitle;

    if (!isDesktop) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: body,
        bottomNavigationBar: bottomBar,
      );
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 28, 8),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    title,
                    style: context.textTheme.titleLarge?.copyWith(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: body),
        ],
      ),
      bottomNavigationBar: bottomBar,
    );
  }

  static bool _isValidUrl(String value) =>
      value.startsWith('http://') || value.startsWith('https://');
}

/// 服务商预设小胶囊。
class _PresetChip extends HookWidget {
  const _PresetChip({
    required this.preset,
    required this.selected,
    required this.onTap,
  });

  final _AiPreset preset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    final bool isDark = context.isDark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected
              ? scheme.primary.withValues(alpha: 0.10)
              : (isDark
                    ? scheme.onSurface.withValues(alpha: 0.04)
                    : scheme.surfaceContainerHighest.withValues(alpha: 0.35)),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: selected
                ? scheme.primary.withValues(alpha: 0.65)
                : scheme.outline.withValues(alpha: isDark ? 0.28 : 0.16),
            width: selected ? 1.2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AiBrandIcon(
              brand: resolveAiBrand(apiUrl: preset.baseUrl, name: preset.label),
              size: 20.w,
            ),
            SizedBox(width: 8.w),
            Text(
              preset.label,
              style: TextStyle(
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
                color: selected ? scheme.primary : scheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 模型输入框右侧的小刷新按钮，用于重新拉取模型列表。
class _RefreshButton extends HookWidget {
  const _RefreshButton({
    required this.loading,
    required this.tooltip,
    required this.onTap,
  });

  final bool loading;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;
    final bool isDark = context.isDark;
    final bool disabled = onTap == null;

    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 44.w,
        height: 44.h,
        child: Material(
          color: isDark
              ? scheme.onSurface.withValues(alpha: 0.04)
              : scheme.surfaceContainerHighest.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(14.r),
          child: InkWell(
            onTap: loading ? null : onTap,
            borderRadius: BorderRadius.circular(14.r),
            child: Center(
              child: loading
                  ? SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: scheme.primary,
                      ),
                    )
                  : Icon(
                      Icons.refresh_rounded,
                      size: 19.sp,
                      color: disabled
                          ? scheme.onSurfaceVariant.withValues(alpha: 0.45)
                          : scheme.primary,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 内置配置提示条：说明服务地址已锁定，并给出获取 Key 的入口。
class _BuiltinNotice extends HookWidget {
  const _BuiltinNotice({required this.onGetKey});

  final VoidCallback onGetKey;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.lock_outline_rounded, size: 16.sp, color: scheme.primary),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              l10n.aiConfigBuiltinHint,
              style: TextStyle(
                fontSize: 11.5.sp,
                height: 1.35,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          TextButton(
            onPressed: onGetKey,
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size.zero,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            ),
            child: Text(
              l10n.aiConfigGetKey,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

/// 底部连通性状态行。
class _ConnStatus extends HookWidget {
  const _ConnStatus({
    required this.state,
    required this.message,
    required this.count,
  });

  final _ConnState state;
  final String message;
  final int count;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme scheme = context.colorScheme;
    final bool isDark = context.isDark;

    final (IconData icon, Color color, String text) = switch (state) {
      _ConnState.idle => (
        Icons.wifi_tethering_rounded,
        scheme.onSurfaceVariant,
        l10n.aiConnIdle,
      ),
      _ConnState.testing => (
        Icons.sync_rounded,
        scheme.primary,
        l10n.aiConnTesting,
      ),
      _ConnState.ok => (
        Icons.check_circle_rounded,
        isDark ? const Color(0xFF66BB6A) : const Color(0xFF2E7D32),
        l10n.aiConnOk(count),
      ),
      _ConnState.failed => (
        Icons.error_outline_rounded,
        scheme.error,
        l10n.aiConnFailed(message),
      ),
    };

    return Row(
      children: <Widget>[
        if (state == _ConnState.testing)
          SizedBox(
            width: 14.w,
            height: 14.w,
            child: CircularProgressIndicator(strokeWidth: 1.8, color: color),
          )
        else
          Icon(icon, size: 15.sp, color: color),
        SizedBox(width: 7.w),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11.5.sp, height: 1.35, color: color),
          ),
        ),
      ],
    );
  }
}
