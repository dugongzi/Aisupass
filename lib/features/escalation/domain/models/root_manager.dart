import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'root_manager.freezed.dart';

/// 设备上真实安装的一个 root 管理器（KernelSU 系及其各分支）。
///
/// 由原生层扫描「`lib/arm64` 下自带可用 ksud 的应用」得来——固定名 `libksud.so`
/// 优先，随机名须四条 ksud 帮助文案全中并实测 `late-load --help` 通过，因此不绑定
/// 任何具体包名；这里的每一条都确定可移交。[displayName] 与 [icon] 来自安装包
/// 自己的元数据。
@freezed
abstract class RootManager with _$RootManager {
  const RootManager._();

  const factory RootManager({
    /// 管理器包名，同时是 `late-load --package-name` 的参数。
    required String packageName,

    /// 应用图标上显示的名字。
    required String displayName,

    /// 图标 PNG 字节；空数组表示取不到，UI 退回通用图标。
    required Uint8List icon,
  }) = _RootManager;

  /// 管理器官网 / 下载页。
  ///
  /// 扫描结果里没有「官网」这个字段，只有登记过的包名才有链接；未登记的
  /// 管理器返回空串，调用方不得把它当成可点文本。
  String get homeUrl => _homeUrls[packageName] ?? '';

  /// 已知管理器的下载页，按包名登记。
  ///
  /// 只是「点名字能跳官网」的便利表，不参与任何识别逻辑；未登记的管理器
  /// 返回空串，功能不受影响。
  static const Map<String, String> _homeUrls = <String, String>{
    'me.weishu.kernelsu': 'https://kernelsu.org/',
    'com.sukisu.ultra': 'https://github.com/SukiSU-Ultra/SukiSU-Ultra',
  };
}
