import 'package:flutter/foundation.dart';

/// 是否运行在桌面平台（Windows / macOS / Linux）。
///
/// 用 [defaultTargetPlatform] 而不是 `dart:io` 的 `Platform`，
/// 这样 Web 端也能安全编译。
bool get isDesktopPlatform =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux);
