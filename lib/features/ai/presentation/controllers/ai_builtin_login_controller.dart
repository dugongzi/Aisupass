import 'package:Aisupass/features/ai/domain/models/ai_builtin_group.dart';
import 'package:Aisupass/features/ai/domain/models/ai_builtin_model.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_builtin_action_provider.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_builtin_query_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 内置登录页的流程编排。
///
/// 只做取数、建密钥与落库，不接触 `BuildContext`、不弹提示也不弹窗：
/// 界面拿到结果与异常后自己决定文案与下一步。
class AiBuiltinLoginController {
  const AiBuiltinLoginController({required this._ref});

  final WidgetRef _ref;

  /// 读取上次保存的登录令牌，未登录时为空串。
  Future<String> readSavedToken() =>
      _ref.read(aiBuiltinActionsProvider).readToken();

  /// 记住登录令牌，便于下次进入时直接复用。
  Future<void> rememberToken(String token) =>
      _ref.read(aiBuiltinActionsProvider).saveToken(token);

  /// 丢弃登录令牌，用于令牌已失效的情形。
  Future<void> forgetToken() =>
      _ref.read(aiBuiltinActionsProvider).clearToken();

  /// 读取当前账号可见的分组（含模型清单）。
  Future<List<AiBuiltinGroup>> loadGroups({required String token}) =>
      _ref.read(builtinGroupsProvider(token: token).future);

  /// 在面板上创建密钥，返回明文密钥。
  Future<String> createKey({
    required String token,
    required AiBuiltinGroup group,
  }) => _ref
      .read(aiBuiltinActionsProvider)
      .createKey(token: token, groupId: group.id);

  /// 把密钥、协议与分组写进内置配置，并设为当前配置。
  Future<void> persist({
    required String apiKey,
    required AiBuiltinGroup group,
    required AiBuiltinModel model,
  }) => _ref
      .read(aiBuiltinActionsProvider)
      .persist(
        apiKey: apiKey,
        modelName: model.name,
        apiType: group.apiType,
        groupId: group.id,
        groupName: group.name,
      );
}
