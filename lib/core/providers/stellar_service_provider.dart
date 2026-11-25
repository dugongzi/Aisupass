import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:Aisupass/core/models/privileged_run_result.dart';
import 'package:Aisupass/core/models/stellar_launch_state.dart';
import 'package:Aisupass/core/models/stellar_service_status.dart';
import 'package:Aisupass/core/providers/privileged_runner_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stellar_service_provider.g.dart';

/// 探活端口，必须与原生 StellarServiceHost.PORT 一致。
const int stellarProbePort = 39187;

/// 拉起器在设备上的定位方式。
///
/// 不硬编码安装路径：APK 目录每次安装都会变，`pm path` 是唯一可靠的来源；
/// 引导文件与 base.apk 同级的 `lib/arm64/` 下。
const String _launchScript =
    'APK=\$(pm path org.supass.ai_su_pass | head -n 1 | sed "s/^package://"); '
    'LIB="\${APK%/*}/lib/arm64"; '
    '[ -x "\$LIB/libstellar_svc.so" ] || { echo "launcherMissing"; exit 21; }; '
    '"\$LIB/libstellar_svc.so"';

/// 单次探活的连接与应答上限。
const Duration _connectTimeout = Duration(milliseconds: 400);
const Duration _replyTimeout = Duration(milliseconds: 800);

/// 拉起后等待服务应答的总时长与轮询间隔。
const Duration _readyTimeout = Duration(seconds: 6);
const Duration _readyInterval = Duration(milliseconds: 400);

/// Stellar 特权服务的当前状态。
///
/// 判定依据是回环端口能否完成一次 PING/PONG——只回答「在不在、以谁的身份在」，
/// 不代表已经具备执行能力。
@riverpod
Future<StellarServiceStatus> stellarServiceStatus(Ref ref) => probeStellar();

/// 发起一次探活。
///
/// 失败一律归为「未运行」，不区分网络错误与拒绝连接：对上层而言两者都是
/// 「现在没有可用的服务」。
Future<StellarServiceStatus> probeStellar() async {
  if (!Platform.isAndroid) return _notRunning;

  Socket? socket;
  try {
    socket = await Socket.connect(
      InternetAddress.loopbackIPv4,
      stellarProbePort,
      timeout: _connectTimeout,
    );
    socket.write('PING\n');
    await socket.flush();

    final Uint8List reply = await socket.first.timeout(_replyTimeout);
    final Object? decoded = jsonDecode(
      utf8.decode(reply, allowMalformed: true).trim(),
    );
    if (decoded is! Map) return _notRunning;

    final Object? uid = decoded['uid'];
    return StellarServiceStatus(
      available: true,
      uid: uid is int ? uid : -1,
      reason: '',
    );
  } catch (_) {
    return _notRunning;
  } finally {
    socket?.destroy();
  }
}

const StellarServiceStatus _notRunning = StellarServiceStatus(
  available: false,
  uid: -1,
  reason: StellarServiceStatus.reasonServiceNotRunning,
);

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

    final StellarServiceStatus current = await probeStellar();
    if (current.available) return _finish(current);

    state = const StellarLaunchState(
      busy: true,
      reason: '',
    );

    final PrivilegedRunResult result;
    try {
      result = await ref.read(privilegedRunnerProvider)(_launchScript, 15000);
    } catch (_) {
      return _finish(_notRunning, StellarLaunchState.reasonNoRunner);
    }

    // 命令没跑起来：执行通道自己回的 -1，说明当前没有可用的执行者。
    if (!result.started) {
      return _finish(_notRunning, StellarLaunchState.reasonNoRunner);
    }
    if (result.stderr.contains('launcherMissing') ||
        result.stdout.contains('launcherMissing')) {
      return _finish(_notRunning, StellarLaunchState.reasonLauncherMissing);
    }

    final StellarServiceStatus ready = await _awaitReady();
    return _finish(
      ready,
      ready.available ? '' : StellarLaunchState.reasonNotAnswering,
    );
  }

  /// 在限定时间内反复探活，直到服务应答。
  Future<StellarServiceStatus> _awaitReady() async {
    final DateTime deadline = DateTime.now().add(_readyTimeout);
    while (DateTime.now().isBefore(deadline)) {
      final StellarServiceStatus status = await probeStellar();
      if (status.available) return status;
      await Future<void>.delayed(_readyInterval);
    }
    return _notRunning;
  }

  StellarServiceStatus _finish(StellarServiceStatus result, [String reason = '']) {
    state = StellarLaunchState(busy: false, reason: reason);
    ref.invalidate(stellarServiceStatusProvider);
    return result;
  }
}
