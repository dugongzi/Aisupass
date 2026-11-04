import 'package:Aisupass/generated/device_identity.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_identity_provider.g.dart';

/// 设备身份采集的原生接口实例，与 Pigeon 通道一一对应。
@riverpod
DeviceIdentityNative deviceIdentityNative(Ref ref) => DeviceIdentityNative();
