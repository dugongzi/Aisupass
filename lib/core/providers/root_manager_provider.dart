import 'package:Aisupass/generated/root_manager.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'root_manager_provider.g.dart';

/// root 管理器扫描的原生接口实例，与 Pigeon 通道一一对应。
@riverpod
RootManagerNative rootManagerNative(Ref ref) => RootManagerNative();
