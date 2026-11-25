import 'package:Aisupass/core/models/stellar_service_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stellar_service_provider.g.dart';

/// Stellar 特权服务的当前状态。
///
/// 服务端尚未接入，这里如实返回「服务未运行」；接入后改为查询原生状态，
/// 本 Provider 的签名与调用方都不需要变。
@riverpod
Future<StellarServiceStatus> stellarServiceStatus(Ref ref) async {
  return const StellarServiceStatus(
    available: false,
    uid: -1,
    reason: StellarServiceStatus.reasonServiceNotRunning,
  );
}
