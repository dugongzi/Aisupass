import 'package:Aisupass/features/ai/domain/models/ai_builtin_group.dart';
import 'package:Aisupass/features/ai/domain/models/ai_builtin_wallet.dart';

/// 内置面板的只读仓储接口。
abstract class AiBuiltinQueryRepository {
  /// 读取当前账号可见的分组（含模型清单），按倍率升序排列。
  ///
  /// [token] 为空时只取模型广场的公开信息；非空时再叠加
  /// 可绑定性过滤与账号专属倍率。
  Future<List<AiBuiltinGroup>> getVisibleGroups({String token = ''});

  /// 读取当前账号的额度信息。
  Future<AiBuiltinWallet> getWallet({required String token});

  /// 读取当前账号已有的 API Key 明文列表。
  Future<List<String>> getMyKeys({required String token});

  /// 用明文密钥查它在面板上的 id，找不到返回 `0`。
  ///
  /// 换分组需要密钥 id，而本地只存明文，因此按明文反查一次。
  Future<int> findKeyId({required String token, required String key});
}
