import 'dart:io';

import 'package:Aisupass/features/escalation/data/models/escalation_capability_dto.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_chain.dart';
import 'package:Aisupass/features/escalation/domain/enums/escalation_reason.dart';
import 'package:Aisupass/features/escalation/domain/models/device_fingerprint.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_capability.dart';
import 'package:Aisupass/features/escalation/domain/models/escalation_capability_matrix.dart';
import 'package:Aisupass/generated/escalation.g.dart' as pigeon;
import 'package:device_info_plus/device_info_plus.dart';

/// 提权只读数据源：读取设备指纹与全部链的探测结论。
///
/// **零副作用**：这里只允许出现 `probeAll`，不得出现 prepare / execute / startRun。
class EscalationQueryDatasource {
  EscalationQueryDatasource({
    required this._native,
    this._rootStatusReader,
    DeviceInfoPlugin? deviceInfo,
  }) : _deviceInfo = deviceInfo ?? DeviceInfoPlugin();

  final pigeon.EscalationNative _native;

  /// 现有 `rootStatusProvider` 的读取入口。
  ///
  /// rootCheck 链的可用性由这里决定，原生只提供静态证据；
  /// 未注入时按「无 Root」处理，保证桌面端与单测可用。
  final Future<bool> Function()? _rootStatusReader;

  final DeviceInfoPlugin _deviceInfo;

  /// 读取判定所需的设备指纹。
  ///
  /// 非 Android 平台与读取失败都返回降级值而非抛异常，保证页面在桌面端也能渲染。
  Future<DeviceFingerprint> readFingerprint() async {
    if (!Platform.isAndroid) {
      return DeviceFingerprint(
        androidSdk: 0,
        abi: '',
        kernelVersion: Platform.operatingSystemVersion,
        selinuxEnforcing: false,
        manufacturer: Platform.operatingSystem,
        model: '',
        isEmulator: false,
      );
    }

    try {
      final AndroidDeviceInfo android = await _deviceInfo.androidInfo;
      return DeviceFingerprint(
        androidSdk: android.version.sdkInt,
        abi: android.supportedAbis.isEmpty ? '' : android.supportedAbis.first,
        kernelVersion: await _readKernelVersion() ?? '',
        selinuxEnforcing: await _readSelinuxEnforcing(),
        manufacturer: android.manufacturer,
        model: android.model,
        isEmulator: !android.isPhysicalDevice,
      );
    } catch (_) {
      // 设备信息插件在部分定制系统上可能失败，降级为空指纹，交由上层判 unsupported。
      return const DeviceFingerprint(
        androidSdk: 0,
        abi: '',
        kernelVersion: '',
        selinuxEnforcing: false,
        manufacturer: '',
        model: '',
        isEmulator: false,
      );
    }
  }

  /// 探测全部链的能力结论。
  ///
  /// 宿主不可用或返回为空时，统一降级为「全部不可用 + platformUnsupported」矩阵。
  Future<EscalationCapabilityMatrix> probeCapabilities() async {
    final DeviceFingerprint fingerprint = await readFingerprint();
    final List<pigeon.ChainProbe>? probes = await _probeAll();
    if (probes == null) return _unsupportedMatrix(fingerprint);

    final bool hasRoot = await _readRootStatus();

    final List<EscalationCapability> capabilities = <EscalationCapability>[];
    for (final pigeon.ChainProbe probe in probes) {
      final EscalationCapability? capability =
          EscalationCapabilityDto.fromPigeon(probe).toEntity();
      if (capability == null) continue;
      capabilities.add(_applyRootStatus(capability, hasRoot));
    }
    if (capabilities.isEmpty) return _unsupportedMatrix(fingerprint);

    return EscalationCapabilityMatrix(
      fingerprint: fingerprint,
      capabilities: _withDemoChain(capabilities),
      probedAtMs: DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// rootCheck 的可用性改由现有 `rootStatusProvider` 决定。
  ///
  /// 原生只回静态证据（su 路径、KernelSU/Magisk 标记、SELinux 状态等），
  /// 不给结论；判定权集中在 Dart，避免与首页 ROOT 状态出现两套口径。
  EscalationCapability _applyRootStatus(
    EscalationCapability capability,
    bool hasRoot,
  ) {
    if (capability.chain != EscalationChain.rootCheck) return capability;
    return capability.copyWith(
      available: hasRoot,
      reasons: hasRoot
          ? const <EscalationReason>[]
          : const <EscalationReason>[EscalationReason.noRootBinary],
    );
  }

  /// 读取现有 ROOT 状态；未注入读取器或读取失败都按「无 Root」处理。
  Future<bool> _readRootStatus() async {
    final Future<bool> Function()? reader = _rootStatusReader;
    if (reader == null) return false;
    try {
      return await reader();
    } catch (_) {
      return false;
    }
  }

  /// M0 演示链的固定能力结论。
  ///
  /// 原生骨架对所有链都回 `available = false`，但 fake 链不改变任何系统状态，
  /// 由 Dart 侧显式标记为可用，保证无外部资产时也能走完整演示流程。
  static const EscalationCapability _demoCapability = EscalationCapability(
    chain: EscalationChain.fake,
    available: true,
    reasons: <EscalationReason>[],
    evidence: <String, String>{'demo': 'true'},
  );

  /// 用演示链覆盖原生结论，并保证 fake 行一定存在。
  List<EscalationCapability> _withDemoChain(
    List<EscalationCapability> capabilities,
  ) {
    final List<EscalationCapability> result = <EscalationCapability>[];
    bool hasDemo = false;
    for (final EscalationCapability capability in capabilities) {
      if (capability.chain == EscalationChain.fake) {
        result.add(_demoCapability);
        hasDemo = true;
      } else {
        result.add(capability);
      }
    }
    if (!hasDemo) result.add(_demoCapability);
    return result;
  }

  Future<List<pigeon.ChainProbe>?> _probeAll() async {
    if (!Platform.isAndroid) return null;
    try {
      return await _native.probeAll();
    } catch (_) {
      // 原生通道未就绪时按「探测不可用」处理，不向上抛异常。
      return null;
    }
  }

  EscalationCapabilityMatrix _unsupportedMatrix(DeviceFingerprint fingerprint) =>
      EscalationCapabilityMatrix(
        fingerprint: fingerprint,
        capabilities: EscalationChain.values
            .map(
              (EscalationChain chain) => EscalationCapability(
                chain: chain,
                available: false,
                reasons: const <EscalationReason>[
                  EscalationReason.platformUnsupported,
                ],
                evidence: const <String, String>{},
              ),
            )
            .toList(growable: false),
        probedAtMs: DateTime.now().millisecondsSinceEpoch,
      );

  /// 读取内核版本，部分定制系统限制访问时返回 `null`。
  Future<String?> _readKernelVersion() async {
    try {
      final String content = await File('/proc/version').readAsString();
      return RegExp(r'Linux version (\S+)').firstMatch(content)?.group(1);
    } catch (_) {
      return null;
    }
  }

  /// 读取 SELinux 是否处于 Enforcing；读不到时按「非强制」处理。
  Future<bool> _readSelinuxEnforcing() async {
    try {
      final String value = (await File(
        '/sys/fs/selinux/enforce',
      ).readAsString()).trim();
      return value == '1';
    } catch (_) {
      return false;
    }
  }
}
