import 'package:Aisupass/features/escalation/domain/models/handoff_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';

/// 提权链路执行仓储。
///
/// 只负责「把给定的载荷变成要执行的命令行」与「把拿到的 root 移交给管理器」，
/// 选哪份载荷由查询仓储决定，两者的装配在 Provider 层完成。
abstract class EscalationActionRepository {
  /// 拼出执行指定载荷的那一行命令。
  ///
  /// 起不来的原因（so 没打进包、参数补不齐）抛 [PayloadLaunchException]，
  /// 由展示层翻译成文案写屏，命令行里不夹 `echo`。
  Future<String> runPayload(Payload payload);

  /// 终端上来一段载荷输出就喂一次，供实现从中提取并缓存 KASLR 偏移。
  void observeOutput(String text);

  /// 把临时 root 移交给设备上已安装的 [manager]。
  ///
  /// ksud 只由原生侧按该管理器解析（`resolveKsudPath`：固定名优先，随机名靠指纹 +
  /// 实测 `late-load --help`），随后以 root 身份执行
  /// `late-load --allow-shell --package-name <包名>`。定位与 `late-load` 合并在
  /// 同一次 `su` 会话里完成，定位结果不跨调用传递。
  ///
  /// [ksudPath] 必须是原生解析好的绝对路径；为空表示管理器里没有可用的 ksud，
  /// 移交会直接判为「管理器没装」，不再有按文件名兜底的第二条猜测路径。
  ///
  /// 返回 [HandoffOutcome] 而不是抛异常：移交给的是四种形态（成功 / 管理器
  /// 没装 / 没有 root / 命令失败），每种对应完全不同的用户动作，压成一个
  /// 「失败 + 一段 stderr」就丢掉了这些出路。管理器没装、没有 root 都是要给
  /// 用户看的信息，不是代码缺陷。
  Future<HandoffOutcome> handoffRoot({
    required RootManager manager,
    required String ksudPath,
  });

  /// 记住用户选定的 root 管理器，供下次启动与本页移交复用。
  Future<void> selectRootManager({required RootManager manager});
}
