import 'package:Aisupass/common/widgets/app_select.dart';
import 'package:Aisupass/common/widgets/toast.dart';
import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/core/network/api_exception.dart';
import 'package:Aisupass/core/routes/app_route.dart';
import 'package:Aisupass/core/utils/platform.dart';
import 'package:Aisupass/features/ai/data/datasources/ai_model_query_datasource.dart';
import 'package:Aisupass/features/ai/domain/constants/builtin_ai_config.dart';
import 'package:Aisupass/features/ai/domain/enums/ai_api_type.dart';
import 'package:Aisupass/features/ai/domain/models/ai_builtin_group.dart';
import 'package:Aisupass/features/ai/domain/models/ai_config.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_builtin_action_provider.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_builtin_query_provider.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_config_action_provider.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_config_query_provider.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_model_query_provider.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_builtin_group_picker_sheet.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_builtin_platform_picker_sheet.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_builtin_wallet_card.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_model_picker.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_section_card.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_test_sheet.dart';
import 'package:Aisupass/features/ai/presentation/widgets/ai_text_field.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

/// 连通性检测状态。
enum _ConnState { idle, testing, ok, failed }

/// 密钥的预期前缀；不以此开头时提示用户改用一键获取。
const String _apiKeyPrefix = 'sk-';

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
    final AiConfigState? configState = ref.watch(aiConfigProvider).value;
    final AiConfig? existing = configId == AppRoute.newConfigId
        ? null
        : configState?.byId(configId);

    // 内置配置只允许改 API Key，其余字段一律取常量。
    final bool isBuiltinEditing =
        existing != null && isBuiltinAiConfig(existing);
    final bool isCurrent =
        existing != null && configState?.currentId == existing.id;

    // 已保存的配置才需要底部操作；内置配置只能「设为当前」，不能删除。
    final bool showFooterActions =
        existing != null && (!isCurrent || !isBuiltinEditing);

    // 内置配置已绑定的分组名，只用于展示，未绑定时为空串。
    final String builtinGroupName = isBuiltinEditing
        ? ref.watch(builtinGroupNameProvider).value ?? ''
        : '';

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
    final ValueNotifier<bool> changingGroup = useState<bool>(false);
    final ValueNotifier<Map<String, String>> errors =
        useState<Map<String, String>>(const <String, String>{});
    final ValueNotifier<_ConnState> connState = useState<_ConnState>(
      _ConnState.idle,
    );
    final ValueNotifier<String> connMessage = useState<String>('');
    final ValueNotifier<int> connCount = useState<int>(0);

    // 内置登录页写完配置后会失效 aiConfigProvider，本页随即拿到新的
    // 密钥 / 模型 / 协议；这里把输入框与选择器同步过去，否则停留在本页时
    // 仍显示旧值（密钥为空、模型未选）。
    useEffect(() {
      final AiConfig? config = existing;
      if (config == null) return null;
      if (config.apiKey.isNotEmpty && apiKeyController.text != config.apiKey) {
        apiKeyController.text = config.apiKey;
      }
      if (config.modelName.isNotEmpty && model.value != config.modelName) {
        model.value = config.modelName;
      }
      if (config.apiType != apiType.value) apiType.value = config.apiType;
      return null;
    }, <Object?>[existing?.apiKey, existing?.modelName, existing?.apiType]);

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

    String describeError(AiRequestException error) {
      final int? code = error.statusCode;
      if (code == 401 || code == 403) return l10n.aiErrorAuth(code!);
      if (code == 404) return l10n.aiErrorNotFound;
      if (code != null) return l10n.aiErrorHttp(code, error.message);
      return l10n.aiErrorNetwork(error.message);
    }

    /// 进入内置登录页；取到密钥即说明配置已写入，停留在本页并刷新额度。
    ///
    /// 不在这里回填输入框再触发拉模型：模型与分组已由登录页写进配置，
    /// 再拉一次网关模型列表反而可能把已选模型清掉。
    Future<void> openBuiltinLogin() async {
      final String? issued = await context.push<String>(
        AppRoute.aiBuiltinLogin,
      );
      if (!context.mounted) return;
      if ((issued ?? '').trim().isEmpty) return;
      ToastMessage.success(l10n.aiSaveSuccess);
      ref.invalidate(builtinWalletProvider);
    }

    /// 密钥不像面板格式时确认一次。
    ///
    /// 返回 `true` 表示用户选择继续用自己的 Key，调用方可以往下走；
    /// 返回 `false` 表示用户选择去内置配置 / 一键获取，调用方应中止本次请求。
    Future<bool> confirmApiKeyFormat() async {
      final bool? goBuiltin = await showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) {
          final AppLocalizations dialogL10n = dialogContext.l10n;
          return AlertDialog(
            title: Text(dialogL10n.aiKeyFormatTitle),
            content: Text(dialogL10n.aiKeyFormatBody),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(dialogL10n.aiKeyFormatSkip),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(
                  // 已在内置配置页时，同一个按钮直接走一键获取。
                  isBuiltinEditing
                      ? dialogL10n.aiBuiltinGetKey
                      : dialogL10n.aiKeyFormatGoBuiltin,
                ),
              ),
            ],
          );
        },
      );
      if (!context.mounted) return false;
      if (goBuiltin != true) return true;

      if (isBuiltinEditing) {
        await openBuiltinLogin();
        return false;
      }
      await context.push(AppRoute.aiConfigEditPath(builtinAiConfigId));
      return false;
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

      // 拉模型是用户第一次真正用到这把 Key 的地方：格式不像面板密钥时
      // 先提醒一次，避免用户拿着错格式的 Key 反复试错。
      if (!apiKeyController.text.trim().startsWith(_apiKeyPrefix)) {
        final bool proceed = await confirmApiKeyFormat();
        if (!context.mounted || !proceed) return false;
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

    /// 把已绑定的密钥换到另一个分组：密钥不变，只改面板上的分组绑定。
    ///
    /// 只需选厂商与分组，不涉及模型；换完后若当前模型不在新分组里会被清空，
    /// 提示用户回到模型卡片重新选择。
    Future<void> handleChangeGroup() async {
      if (changingGroup.value) return;
      if (apiKeyController.text.trim().isEmpty) {
        ToastMessage.show(l10n.aiBuiltinChangeGroupNoKey);
        return;
      }

      changingGroup.value = true;
      try {
        final String token =
            (await ref.read(aiBuiltinActionsProvider).readToken()).trim();
        if (!context.mounted) return;
        if (token.isEmpty) {
          ToastMessage.show(l10n.aiBuiltinChangeGroupNoKey);
          return;
        }

        final List<AiBuiltinGroup> groups = await ref.read(
          builtinGroupsProvider(token: token).future,
        );
        if (!context.mounted) return;
        if (groups.isEmpty) {
          ToastMessage.show(l10n.aiBuiltinPlatformEmpty);
          return;
        }

        final List<AiBuiltinGroup>? vendorGroups =
            await showAiBuiltinPlatformPickerSheet(context, groups: groups);
        if (vendorGroups == null || !context.mounted) return;

        final AiBuiltinGroup? group = await showAiBuiltinGroupPickerSheet(
          context,
          groups: vendorGroups,
        );
        if (group == null || !context.mounted) return;

        final bool modelCleared = await ref
            .read(aiBuiltinActionsProvider)
            .changeGroup(group: group);
        if (!context.mounted) return;

        // 配置已被重写：把协议同步成新分组的，模型被清空时一并清掉本页选择。
        apiType.value = group.apiType;
        if (modelCleared) model.value = '';
        ToastMessage.success(
          modelCleared
              ? l10n.aiBuiltinChangeGroupNeedModel(group.name)
              : l10n.aiBuiltinChangeGroupSuccess(group.name),
        );
      } on ApiException catch (error) {
        if (!context.mounted) return;
        ToastMessage.error(error.message);
      } catch (error) {
        if (!context.mounted) return;
        ToastMessage.error(l10n.aiBuiltinChangeGroupFailed('$error'));
      } finally {
        changingGroup.value = false;
      }
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

    /// 把当前编辑的配置设为启用项。
    Future<void> handleSetCurrent() async {
      final AiConfig? config = existing;
      if (config == null) return;
      await ref.read(aiConfigActionsProvider).setCurrent(config.id);
      if (!context.mounted) return;
      ToastMessage.success(l10n.aiConfigSwitched);
    }

    /// 删除当前编辑的配置，成功后返回列表页。
    Future<void> handleDelete() async {
      final AiConfig? config = existing;
      if (config == null) return;

      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) {
          final ColorScheme scheme = dialogContext.colorScheme;
          return AlertDialog(
            title: Text(l10n.aiConfigDelete),
            content: Text(l10n.aiConfigDeleteConfirm(config.name)),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l10n.aiCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.error,
                  foregroundColor: scheme.onError,
                ),
                child: Text(l10n.aiDelete),
              ),
            ],
          );
        },
      );
      if (confirmed != true || !context.mounted) return;

      await ref.read(aiConfigActionsProvider).remove(config.id);
      if (!context.mounted) return;
      ToastMessage.success(l10n.aiConfigDeleted);
      context.pop();
    }

    /// 打开测试窗口；先做最基本的完整性检查。
    void handleTest() {
      if (apiKeyController.text.trim().isEmpty) {
        errors.value = <String, String>{
          ...errors.value,
          'key': l10n.aiFieldRequired,
        };
        ToastMessage.show(l10n.aiTestNoKey);
        return;
      }
      if (model.value.trim().isEmpty) {
        errors.value = <String, String>{
          ...errors.value,
          'model': l10n.aiTestNoModel,
        };
        ToastMessage.show(l10n.aiTestNoModel);
        return;
      }
      showAiTestSheet(context, buildConfig());
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

    final Widget connectionCard = AiSectionCard(
      title: l10n.aiConnectionSection,
      icon: Icons.link_rounded,
      children: <Widget>[
        if (isBuiltinEditing) ...<Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.layers_outlined,
                size: 14.sp,
                color: context.colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  builtinGroupName.isEmpty
                      ? l10n.aiBuiltinGroupUnbound
                      : l10n.aiBuiltinCurrentGroup(builtinGroupName),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              if (builtinGroupName.isNotEmpty)
                _InlineActionButton(
                  icon: Icons.swap_horiz_rounded,
                  label: l10n.aiBuiltinChangeGroup,
                  busy: changingGroup.value,
                  onTap: handleChangeGroup,
                ),
            ],
          ),
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
          // 内置配置在密钥框右侧直接给「获取 Key」，走内置登录页一键取密钥；
          // 自定义配置保持原样，仍由用户自行粘贴。
          labelTrailing: isBuiltinEditing
              ? _InlineActionButton(
                  icon: Icons.key_rounded,
                  label: l10n.aiConfigGetKey,
                  onTap: openBuiltinLogin,
                )
              : null,
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
            // 额度只在已走通网页流程（有绑定分组）时展示，避免仅手工填 Key
            // 的用户被一次必然失败的额度查询打扰。
            if (isBuiltinEditing && builtinGroupName.isNotEmpty) ...<Widget>[
              const AiBuiltinWalletCard(),
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

    final Widget testButton = OutlinedButton(
      onPressed: saving.value ? null : handleTest,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(isDesktop ? 88 : 64.w, isDesktop ? 42 : 44.h),
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 16 : 10.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
      ),
      child: Text(l10n.aiTestTitle),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (showFooterActions) ...<Widget>[
                    Row(
                      children: <Widget>[
                        if (!isCurrent)
                          _FooterAction(
                            icon: Icons.check_circle_outline_rounded,
                            label: l10n.aiConfigUse,
                            onTap: handleSetCurrent,
                          ),
                        if (!isCurrent && !isBuiltinEditing)
                          SizedBox(width: 4.w),
                        if (!isBuiltinEditing)
                          _FooterAction(
                            icon: Icons.delete_outline_rounded,
                            label: l10n.aiConfigDelete,
                            color: context.colorScheme.error,
                            onTap: handleDelete,
                          ),
                        const Spacer(),
                      ],
                    ),
                    SizedBox(height: 6.h),
                  ],
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _ConnStatus(
                          state: connState.value,
                          message: connMessage.value,
                          count: connCount.value,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      testButton,
                      SizedBox(width: 8.w),
                      saveButton,
                    ],
                  ),
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

/// 底部栏里的次要操作：设为当前 / 删除。
class _FooterAction extends HookWidget {
  const _FooterAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Color effective = color ?? context.colorScheme.primary;

    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16.sp),
      label: Text(
        label,
        style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600),
      ),
      style: TextButton.styleFrom(
        foregroundColor: effective,
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }
}

/// 字段标题或说明行末尾的紧凑文字按钮。
///
/// 内置配置用它承载「获取 Key」与「更换分组」；[busy] 时换成同尺寸的进度圈，
/// 避免连点。
class _InlineActionButton extends StatelessWidget {
  const _InlineActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.busy = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;

    if (busy) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        child: SizedBox(
          width: 13.w,
          height: 13.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: scheme.primary,
          ),
        ),
      );
    }

    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 13.sp),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: scheme.primary,
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0),
        textStyle: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w600),
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
