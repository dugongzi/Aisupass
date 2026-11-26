import 'dart:convert';

import 'package:Aisupass/core/extensions/context_extensions.dart';
import 'package:Aisupass/features/chat/domain/models/chat_tool_call.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/chat_widgets/adb_pairing_panel.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/chat_widgets/browser_open_panel.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/chat_widgets/coolapk_login_panel.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/chat_widgets/coolapk_post_panel.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/chat_widgets/coolapk_risk_panel.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/chat_widgets/coolapk_rom_panel.dart';
import 'package:Aisupass/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// 工具调用附带的自定义交互组件构造器；返回 null 表示该工具不需要。
typedef ChatToolPanelBuilder = Widget? Function(
  BuildContext context,
  String turnId,
  bool isLastTurn,
  ChatToolCall call,
);

/// 工具名 → 对话内常驻组件。
///
/// 需要用户在对话里直接操作的工具在这里登记，新增一个只加一项，
/// 不必改消息渲染逻辑。挂起与续跑由 [ChatUserActionGate] 承担。
const Map<String, ChatToolPanelBuilder> chatToolPanels =
    <String, ChatToolPanelBuilder>{
      'adb_pairing_request': _adbPairingPanel,
      'open_in_browser': _browserPanel,
      'coolapk_search': _coolapkQueryPanel,
      'coolapk_login': _coolapkLoginPanel,
      'coolapk_feed_detail': _coolapkQueryPanel,
      'coolapk_feed_all_replies': _coolapkAllRepliesPanel,
      'coolapk_offer_download': _coolapkDownloadPanel,
    };

Widget _adbPairingPanel(
  BuildContext context,
  String turnId,
  bool isLastTurn,
  ChatToolCall call,
) => AdbPairingPanel(turnId: turnId, isLastTurn: isLastTurn);

Widget? _browserPanel(
  BuildContext context,
  String turnId,
  bool isLastTurn,
  ChatToolCall call,
) {
  final Map<String, dynamic> arguments = _decodeArguments(call.argumentsJson);
  final String url = (arguments['url'] as String? ?? '').trim();
  if (url.isEmpty) return null;
  return BrowserOpenPanel(
    url: url,
    reason: (arguments['reason'] as String? ?? '').trim(),
  );
}

/// 未登录被拦下时挂出登录入口，由 [coolapkLoginPanelFor] 判定。
Widget? _coolapkLoginPanel(
  BuildContext context,
  String turnId,
  bool isLastTurn,
  ChatToolCall call,
) => coolapkLoginPanelFor(call);

/// 搜索与帖子正文：成功时内容已经在工具结果里，不再额外挂卡片。
///
/// 失败只可能是未登录或被风控，分别给登录入口与验证入口。
Widget? _coolapkQueryPanel(
  BuildContext context,
  String turnId,
  bool isLastTurn,
  ChatToolCall call,
) {
  final Widget? login = coolapkLoginPanelFor(call);
  if (login != null) return login;
  return coolapkRiskPanelFor(
    turnId: turnId,
    isLastTurn: isLastTurn,
    call: call,
  );
}

/// 全部评论：登录、风控之外，第一页就为空时才提示「暂无评论」。
Widget? _coolapkAllRepliesPanel(
  BuildContext context,
  String turnId,
  bool isLastTurn,
  ChatToolCall call,
) {
  final Widget? login = coolapkLoginPanelFor(call);
  if (login != null) return login;
  final Widget? risk = coolapkRiskPanelFor(
    turnId: turnId,
    isLastTurn: isLastTurn,
    call: call,
  );
  if (risk != null) return risk;
  final AppLocalizations l10n = context.l10n;
  return coolapkEmptyCommentsPanelFor(
    call: call,
    heading: l10n.chatCoolapkNoReplies,
    hint: l10n.chatCoolapkNoRepliesHint,
  );
}

/// 模型给出下载地址后挂出下载卡片，由 [coolapkDownloadOfferOf] 解析参数。
Widget? _coolapkDownloadPanel(
  BuildContext context,
  String turnId,
  bool isLastTurn,
  ChatToolCall call,
) {
  final CoolapkDownloadOffer? offer = coolapkDownloadOfferOf(call);
  if (offer == null) return null;
  return CoolapkDownloadPanel(offer: offer);
}

/// 工具参数是流式拼出来的 JSON 文本，非法或为空时按空参数处理。
Map<String, dynamic> _decodeArguments(String raw) {
  final String text = raw.trim();
  if (text.isEmpty) return const <String, dynamic>{};
  try {
    final Object? decoded = jsonDecode(text);
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
  } on FormatException {
    return const <String, dynamic>{};
  }
  return const <String, dynamic>{};
}
