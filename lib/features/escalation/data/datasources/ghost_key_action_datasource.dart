import 'package:Aisupass/core/constants/storage_keys.dart';
import 'package:Aisupass/core/storage/key_value_store.dart';
import 'package:Aisupass/features/escalation/data/models/ghost_key_outcome_dto.dart';
import 'package:Aisupass/features/escalation/data/models/ghost_key_preflight_dto.dart';
import 'package:Aisupass/generated/cve98260.g.dart' as pigeon;

/// 一次受理结果；原生 `Cve98260StartResult` 只在本层出现。
typedef GhostKeyStartOutcome = ({
  bool accepted,
  String sessionId,
  String reason,
});

/// 一次轮询快照：输出已收敛成 [GhostKeyOutcomeDto]，阶段事件只留码。
typedef GhostKeyPollSnapshot = ({
  GhostKeyOutcomeDto outcome,
  bool finished,
  List<({String stage, String status})> events,
});

/// GhostKey 运行数据源。
///
/// 只做原生转发、DTO 收敛与偏好读写，受理判定与结果分型都在仓储实现里。
class GhostKeyActionDatasource {
  GhostKeyActionDatasource({required this._native, required this._storage});

  final pigeon.Cve98260Native _native;

  final KeyValueStore _storage;

  /// 运行前自检。
  Future<GhostKeyPreflightDto> preflight() async =>
      GhostKeyPreflightDto.fromNative(await _native.preflight());

  /// 受理一次运行。
  ///
  /// 末段移交给管理器不单独设开关：接管方就是全局选中的管理器，
  /// 选中了（[managerPackage] 非空）才移交，没选就跳过该阶段。
  Future<GhostKeyStartOutcome> start({
    required String managerPackage,
    required bool acceptFallbackPageOffset,
  }) async {
    final pigeon.Cve98260StartResult result = await _native.start(
      pigeon.Cve98260Request(
        managerPackage: managerPackage,
        runKsu: managerPackage.isNotEmpty,
        acceptFallbackPageOffset: acceptFallbackPageOffset,
      ),
    );
    return (
      accepted: result.accepted,
      sessionId: result.sessionId,
      reason: result.reason,
    );
  }

  /// 取走自上次轮询以来新增的阶段事件与输出。
  Future<GhostKeyPollSnapshot> poll({required String sessionId}) async {
    final pigeon.Cve98260Chunk chunk = await _native.poll(sessionId);
    return (
      outcome: GhostKeyOutcomeDto.fromNative(chunk),
      finished: chunk.finished,
      events: _toStageEvents(chunk.events),
    );
  }

  /// 取消运行。
  Future<void> cancel({required String sessionId}) => _native.cancel(sessionId);

  /// 是否接受 `calib_b` 的 fallback 置信度；缺省 `true`。
  Future<bool> readAcceptFallback() => _storage.read<bool>(
    StorageKeys.ghostKeyAcceptFallbackPageOffset,
    defaultValue: true,
  );

  /// 写「接受 fallback」开关。
  Future<void> writeAcceptFallback({required bool value}) =>
      _storage.write<bool>(StorageKeys.ghostKeyAcceptFallbackPageOffset, value);

  /// 原生阶段事件 -> 只含码的轻量快照。
  static List<({String stage, String status})> _toStageEvents(
    List<pigeon.Cve98260StageEvent> events,
  ) => events
      .map(
        (pigeon.Cve98260StageEvent event) =>
            (stage: event.stage, status: event.status),
      )
      .toList(growable: false);
}
