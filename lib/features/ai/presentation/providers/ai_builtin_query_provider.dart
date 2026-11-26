import 'package:Aisupass/features/ai/data/datasources/ai_builtin_query_datasource.dart';
import 'package:Aisupass/features/ai/data/datasources/ai_config_query_datasource.dart';
import 'package:Aisupass/features/ai/data/repositories/ai_builtin_query_repository_impl.dart';
import 'package:Aisupass/features/ai/domain/models/ai_builtin_group.dart';
import 'package:Aisupass/features/ai/domain/models/ai_builtin_wallet.dart';
import 'package:Aisupass/features/ai/domain/repositories/ai_builtin_query_repository.dart';
import 'package:Aisupass/features/ai/presentation/providers/ai_config_query_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_builtin_query_provider.g.dart';

/// 内置面板的只读数据源。
@riverpod
AiBuiltinQueryDatasource aiBuiltinQueryDatasource(Ref ref) =>
    AiBuiltinQueryDatasource();

/// 内置面板的只读仓储。
@riverpod
AiBuiltinQueryRepository aiBuiltinQueryRepository(Ref ref) =>
    AiBuiltinQueryRepositoryImpl(
      datasource: ref.watch(aiBuiltinQueryDatasourceProvider),
    );

/// 当前账号可见的分组（含模型清单），已按倍率升序排列。
///
/// [token] 为空时只取公开分组；登录页拿到令牌后按令牌取值。
@riverpod
Future<List<AiBuiltinGroup>> builtinGroups(Ref ref, {String token = ''}) {
  return ref.watch(aiBuiltinQueryRepositoryProvider).getVisibleGroups(
    token: token,
  );
}

/// 内置配置已绑定的分组名，未绑定时为空串。
@riverpod
Future<String> builtinGroupName(Ref ref) =>
    ref.watch(aiConfigQueryDatasourceProvider).readBuiltinGroupName();

/// 内置面板账户的额度信息。
///
/// 登录令牌从安全存储读取；未登录或令牌失效时抛 `ApiException`，
/// 由界面展示失败态并提供重新登录入口。
@riverpod
Future<AiBuiltinWallet> builtinWallet(Ref ref) async {
  // 两个依赖都要在第一个 await 之前取出，避免 await 之后命中已销毁的 Ref。
  final AiBuiltinQueryRepository repository = ref.watch(
    aiBuiltinQueryRepositoryProvider,
  );
  final AiConfigQueryDatasource datasource = ref.watch(
    aiConfigQueryDatasourceProvider,
  );
  final String token = await datasource.readBuiltinAuthToken();
  return repository.getWallet(token: token);
}
