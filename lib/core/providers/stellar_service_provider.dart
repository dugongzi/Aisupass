import 'dart:io';

import 'package:Aisupass/core/models/privileged_run_result.dart';
import 'package:Aisupass/core/models/stellar_launch_state.dart';
import 'package:Aisupass/core/models/stellar_service_status.dart';
import 'package:Aisupass/core/providers/privileged_runner_provider.dart';
import 'package:Aisupass/core/providers/stellar_token_provider.dart';
import 'package:Aisupass/core/utils/stellar_client.dart';
import 'package:Aisupass/core/utils/stellar_protocol.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stellar_service_provider.g.dart';

/// 拉起器在设备上的定位方式。
///
/// 不硬编码安装路径：APK 目录每次安装都会变，`pm path` 是唯一可靠的来源；
/// 引导文件与 base.apk 同级的 `lib/arm64/` 下。
/// token 只含十六进制字符，直接拼进参数即可。
String _launchScript(String token) =>
    'APK=\$(pm path org.supass.ai_su_pass | head -n 1 | sed "s/^package://"); '
    'LIB="\${APK%/*}/lib/arm64"; '
    '[ -x "\$LIB/libstellar_svc.so" ] || { echo "launcherMissing"; exit 21; }; '
    '"\$LIB/libstellar_svc.so" --svc-token=$token';

/// 拉起后等待服务应答的总时长与轮询间隔。
const Duration _readyTimeout = Duration(seconds: 6);
const Duration _readyInterval = Duration(milliseconds: 400);

/// 发 STOP 后等待端口释放的总时长与轮询间隔。
const Duration _goneTimeout = Duration(seconds: 4);
const Duration _goneInterval = Duration(milliseconds: 200);

/// Stellar 特权服务的当前状态。
///
/// 判定依据是「token 握手能否通过」——裸端口有人应答不代表是本应用的服务，
/// 也不代表它认这把钥匙。详见任务文档 00 的 §5.4。
@riverpod
Future<StellarServiceStatus> stellarServiceStatus(Ref ref) async {
  final String token = await ref.watch(stellarServiceTokenProvider.future);
  return probeStellar(token);
}

/// 发起一次探活。
///
/// 依次尝试「带 token 的 PING」与「裸 PING」，据此把结果分型：
/// 未运行 / 凭据不匹配 / 协议不匹配 / 端口被占。
Future<StellarServiceStatus> probeStellar(String token) async {
  if (!Platform.isAndroid) return _notRunning;

  final StellarProbe authed = await stellarProbe(
    port: stellarServicePort,
    line: 'PING $token',
  );
  final StellarHeader header = authed.header;
  if (header.protocol == stellarProtocolVersion) {
    return StellarServiceStatus(available: true, uid: header.uid, reason: '');
  }
  if (header.protocol != 0) {
    return const StellarServiceStatus(
      available: false,
      uid: -1,
      reason: StellarServiceStatus.reasonProtocolMismatch,
    );
  }

  // 连不上 = 端口上没人；连上却没应答 = 交给下一轮裸 PING 判定。
  if (!authed.reachable) return _notRunning;

  final StellarProbe bare = await stellarProbe(
    port: stellarServicePort,
    line: 'PING',
  );
  if (bare.header.protocol == stellarProtocolVersion) {
    return const StellarServiceStatus(
      available: false,
      uid: -1,
      reason: StellarServiceStatus.reasonTokenMismatch,
    );
  }
  if (bare.header.protocol != 0) {
    return const StellarServiceStatus(
      available: false,
      uid: -1,
      reason: StellarServiceStatus.reasonProtocolMismatch,
    );
  }

  return const StellarServiceStatus(
    available: false,
    uid: -1,
    reason: StellarServiceStatus.reasonPortTaken,
  );
}

const StellarServiceStatus _notRunning = StellarServiceStatus(
  available: false,
  uid: -1,
  reason: StellarServiceStatus.reasonServiceNotRunning,
);

/// 让服务自己退出。
///
/// 与探活走同一条回环连接：发一行 `STOP <token>`，服务应答后收摊关端口。
/// 这条指令不需要任何执行通道——退出的动作由服务自己做。
///
/// @return 是否收到了服务的确认应答。
Future<bool> requestStellarStop(String token) async {
  if (!Platform.isAndroid) return false;

  final StellarProbe result = await stellarProbe(
    port: stellarServicePort,
    line: 'STOP $token',
  );
  return result.header.ok == 1;
}

/// 把服务拉起来。
///
/// 拉起动作与「当前有没有可用的执行通道」无关：没有通道时命令根本跑不起来，
/// 这里只按结果分型，不做通道层面的判断。
@Riverpod(keepAlive: true)
class StellarLaunch extends _$StellarLaunch {
  @override
  StellarLaunchState build() => const StellarLaunchState.idle();

  /// 执行一次拉起；返回最终探测到的状态。
  ///
  /// 已在运行时直接返回当前状态，不重复拉起：重启会把已建立的会话全部作废。
  Future<StellarServiceStatus> start() async {
    if (state.busy) return ref.read(stellarServiceStatusProvider.future);

    final String token = await ref.read(stellarServiceTokenProvider.future);

    final StellarServiceStatus current = await probeStellar(token);
    if (current.available) return _finish(current);
    // 端口被别人占着：拉起只会撞墙，直接把原因交给界面。
    if (current.reason == StellarServiceStatus.reasonPortTaken) {
      return _finish(current, StellarLaunchState.reasonPortTaken);
    }

    state = const StellarLaunchState(busy: true, reason: '');

    final PrivilegedRunResult result;
    try {
      result = await ref.read(privilegedRunnerProvider)(
        _launchScript(token),
        15000,
      );
    } catch (_) {
      return _finish(_notRunning, StellarLaunchState.reasonNoRunner);
    }

    // 命令没跑起来：执行通道自己回的 -1，原因写在 stderr 里。
    if (!result.started) {
      return _finish(
        _notRunning,
        result.stderr.contains('pairingCodeRequired')
            ? StellarLaunchState.reasonAwaitingCode
            : StellarLaunchState.reasonNoRunner,
      );
    }
    if (result.stderr.contains('launcherMissing') ||
        result.stdout.contains('launcherMissing')) {
      return _finish(_notRunning, StellarLaunchState.reasonLauncherMissing);
    }
    if (result.stderr.contains('portTaken') ||
        result.stdout.contains('portTaken')) {
      return _finish(_notRunning, StellarLaunchState.reasonPortTaken);
    }
    if (result.stderr.contains('legacyAlive') ||
        result.stdout.contains('legacyAlive')) {
      return _finish(_notRunning, StellarLaunchState.reasonProtocolMismatch);
    }

    final StellarServiceStatus ready = await _awaitReady(token);
    return _finish(
      ready,
      ready.available ? '' : StellarLaunchState.reasonNotAnswering,
    );
  }

  /// 在限定时间内反复探活，直到服务应答。
  Future<StellarServiceStatus> _awaitReady(String token) async {
    final DateTime deadline = DateTime.now().add(_readyTimeout);
    while (DateTime.now().isBefore(deadline)) {
      final StellarServiceStatus status = await probeStellar(token);
      if (status.available) return status;
      await Future<void>.delayed(_readyInterval);
    }
    return _notRunning;
  }

  /// 停掉服务；返回最终探测到的状态。
  ///
  /// 只需要一个 STOP：退出的动作由服务自己完成，所以这里既不用执行通道，也不用
  /// 拉起器。端口可能在应答之后还要一小会儿才真正释放，所以在预算内反复探活。
  Future<StellarServiceStatus> stop() async {
    if (state.busy) return ref.read(stellarServiceStatusProvider.future);

    final String token = await ref.read(stellarServiceTokenProvider.future);
    final StellarServiceStatus current = await probeStellar(token);
    if (!current.available) return _finish(current);

    state = const StellarLaunchState.stopping();

    if (!await requestStellarStop(token)) {
      return _finish(current, StellarLaunchState.reasonStopFailed);
    }

    final StellarServiceStatus after = await _awaitGone(token);
    return _finish(
      after,
      after.available ? StellarLaunchState.reasonStopFailed : '',
    );
  }

  /// 在限定时间内反复探活，直到端口不再应答。
  ///
  /// 超时后返回最后一次探测结果（仍是「可用」），由调用方据此判为停止失败，
  /// 不能像 [probeStellar] 那样一律折成「未运行」——那会把失败谎报成成功。
  Future<StellarServiceStatus> _awaitGone(String token) async {
    final DateTime deadline = DateTime.now().add(_goneTimeout);
    StellarServiceStatus latest = _notRunning;
    while (DateTime.now().isBefore(deadline)) {
      latest = await probeStellar(token);
      if (!latest.available) return latest;
      await Future<void>.delayed(_goneInterval);
    }
    return latest;
  }

  StellarServiceStatus _finish(
    StellarServiceStatus result, [
    String reason = '',
  ]) {
    state = StellarLaunchState(busy: false, reason: reason);
    ref.invalidate(stellarServiceStatusProvider);
    return result;
  }
}
