import 'dart:developer' show log;

import 'package:Aisupass/core/network/api_exception.dart';
import 'package:Aisupass/features/ai/data/datasources/ai_builtin_action_datasource.dart';
import 'package:Aisupass/features/ai/data/datasources/ai_config_action_datasource.dart';
import 'package:Aisupass/features/ai/data/datasources/ai_config_query_datasource.dart';
import 'package:Aisupass/features/ai/data/repositories/ai_builtin_action_repository_impl.dart';
import 'package:Aisupass/features/ai/domain/constants/builtin_ai_config.dart';
import 'package:Aisupass/features/ai/domain/enums/ai_api_type.dart';
import 'package:Aisupass/features/ai/domain/models/ai_builtin_group.dart';
import 'package:Aisupass/features/ai/domain/models/ai_builtin_model.dart';
import 'package:Aisupass/features/ai/domain/repositories/ai_builtin_action_repository.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_builtin_query_provider.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_config_action_provider.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_config_query_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_builtin_action_provider.g.dart';

/// 内置面板的写入数据源。
@riverpod
AiBuiltinActionDatasource aiBuiltinActionDatasource(Ref ref) =>
    AiBuiltinActionDatasource();

/// 内置面板的写入仓储。
@riverpod
AiBuiltinActionRepository aiBuiltinActionRepository(Ref ref) =>
    AiBuiltinActionRepositoryImpl(
      datasource: ref.watch(aiBuiltinActionDatasourceProvider),
    );

/// 内置面板的写操作入口。
///
/// 登录令牌的存取、建密钥、把结果写进内置配置并设为当前项，都在这里收口；
/// 界面只负责渲染与回调，不直接碰数据源。
class AiBuiltinActions {
  const AiBuiltinActions({required this._ref});

  final Ref _ref;

  AiBuiltinActionRepository get _repository =>
      _ref.read(aiBuiltinActionRepositoryProvider);

  /// 读取本地保存的登录令牌，未登录时为空串。
  Future<String> readToken() =>
      _ref.read(aiConfigQueryDatasourceProvider).readBuiltinAuthToken();

  /// 保存登录令牌。
  Future<void> saveToken(String token) => _ref
      .read(aiConfigActionDatasourceProvider)
      .writeBuiltinAuthToken(token.trim());

  /// 清除登录令牌，用于令牌失效后要求重新登录。
  Future<void> clearToken() =>
      _ref.read(aiConfigActionDatasourceProvider).deleteBuiltinAuthToken();

  /// 在面板上创建一把密钥，返回明文密钥。
  Future<String> createKey({required String token, required int groupId}) {
    return _repository.createKey(
      token: token,
      name: _buildKeyName(),
      groupId: groupId,
    );
  }

  /// 把密钥、模型、协议与分组写进内置配置，并设为当前配置。
  ///
  /// 分组两项只用于界面展示，写失败不影响配置本身可用，
  /// 因此与主写入分开处理。
  Future<void> persist({
    required String apiKey,
    required String modelName,
    required AiApiType apiType,
    required int groupId,
    required String groupName,
  }) async {
    final AiConfigActions actions = _ref.read(aiConfigActionsProvider);
    await actions.save(
      buildBuiltinAiConfig(
        apiKey: apiKey,
        modelName: modelName,
        apiType: apiType,
      ),
    );

    try {
      final AiConfigActionDatasource datasource = _ref.read(
        aiConfigActionDatasourceProvider,
      );
      await datasource.writeBuiltinGroupId(groupId);
      await datasource.writeBuiltinGroupName(groupName);
    } catch (error, stackTrace) {
      _logGroupPersistFailure(error, stackTrace);
    }

    await actions.setCurrent(builtinAiConfigId);
    _ref.invalidate(builtinGroupNameProvider);
  }

  /// 密钥默认名，带创建时间便于在面板上区分多把密钥。
  static String _buildKeyName() {
    final DateTime now = DateTime.now();
    String two(int value) => value.toString().padLeft(2, '0');
    return '$builtinAiConfigKeyNamePrefix-'
        '${now.year}${two(now.month)}${two(now.day)}'
        '-${two(now.hour)}${two(now.minute)}';
  }

  /// 用兑换码充值额度，成功后失效额度查询，让界面重新拉取余额。
  Future<void> redeemCode(String code) async {
    final String token = await readToken();
    await _repository.redeemCode(token: token, code: code);
    _ref.invalidate(builtinWalletProvider);
  }

  /// 把内置配置已绑定的密钥换到另一个分组，密钥本身不变。
  ///
  /// 面板改分组需要密钥 id：本地只存明文密钥，因此先在密钥列表里按明文反查。
  /// 换完分组后模型与协议可能不再适用——新分组里没有当前模型时清空模型，
  /// 协议按新分组重新推导，剩余字段（额度、限速、有效期）保持面板原值。
  ///
  /// 返回 `true` 表示模型已被清空，界面应提示用户重新选择模型。
  Future<bool> changeGroup({required AiBuiltinGroup group}) async {
    final String token = (await readToken()).trim();
    if (token.isEmpty) {
      throw const ApiException('登录状态已失效，请先获取 Key');
    }

    final AiConfigQueryDatasource query = _ref.read(
      aiConfigQueryDatasourceProvider,
    );
    final String apiKey = (await query.readApiKey(builtinAiConfigId)).trim();
    if (apiKey.isEmpty) {
      throw const ApiException('还没有密钥，请先获取 Key');
    }

    final int keyId = await _ref
        .read(aiBuiltinQueryRepositoryProvider)
        .findKeyId(token: token, key: apiKey);
    if (keyId <= 0) {
      throw const ApiException('面板上找不到这把密钥，请重新获取 Key');
    }

    await _repository.updateKeyGroup(
      token: token,
      keyId: keyId,
      groupId: group.id,
    );

    final String currentModel = (await query.readBuiltinModel()).trim();
    final bool modelKept =
        currentModel.isNotEmpty &&
        group.models.any((AiBuiltinModel item) => item.name == currentModel);

    final AiConfigActions actions = _ref.read(aiConfigActionsProvider);
    await actions.save(
      buildBuiltinAiConfig(
        apiKey: apiKey,
        modelName: modelKept ? currentModel : '',
        apiType: group.apiType,
      ),
    );

    final AiConfigActionDatasource datasource = _ref.read(
      aiConfigActionDatasourceProvider,
    );
    await datasource.writeBuiltinGroupId(group.id);
    await datasource.writeBuiltinGroupName(group.name);

    await actions.setCurrent(builtinAiConfigId);
    _ref.invalidate(builtinGroupNameProvider);
    return !modelKept;
  }
}

/// 内置面板写操作入口的 Provider。
///
/// 用 `keepAlive` 保住 [Ref]，避免 `ref.read` 后立即销毁导致异步落盘失效。
@Riverpod(keepAlive: true)
AiBuiltinActions aiBuiltinActions(Ref ref) => AiBuiltinActions(ref: ref);

/// 仅在 debug 下记录分组写入失败，release 编译后整段消失。
void _logGroupPersistFailure(Object error, StackTrace stackTrace) {
  assert(() {
    log(
      'ai.builtin: 分组信息写入失败 ${error.runtimeType}',
      name: 'ai.builtin',
      stackTrace: stackTrace,
    );
    return true;
  }());
}
