import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// 桌面端首页内容。当前为占位内容，等待业务接入。
///
/// 标题栏与左侧导航由 `DesktopPage` 提供，这里不要自带 Scaffold。
class PcHomeTab extends HookWidget {
  const PcHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(context.l10n.desktopHomeTitle));
  }
}
