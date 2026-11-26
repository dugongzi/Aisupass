import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/tool_schema.dart';
import 'package:Aisupass/features/coolapk/domain/enums/coolapk_search_type.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_auth_state.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_feed_detail.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_feed_reply.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_risk_control.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_search_batch.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_search_result.dart';
import 'package:Aisupass/features/coolapk/presentation/providers/coolapk_auth_action_provider.dart';
import 'package:Aisupass/features/coolapk/presentation/providers/coolapk_auth_query_provider.dart';
import 'package:Aisupass/features/coolapk/presentation/providers/coolapk_query_provider.dart';

/// 单次回传给模型的默认与最大条数。
const int _defaultLimit = 10;
const int _maxLimit = 20;

/// 评论接口单页固定返回的条数。
const int _replyPageSize = 20;

/// 支持的搜索维度，直接来自 [CoolapkSearchType]。
final List<String> _searchTypes = CoolapkSearchType.values
    .map((CoolapkSearchType type) => type.name)
    .toList(growable: false);

/// 酷安社区工具：搜索游客可读，帖子正文与完整评论需要账号。
List<ChatToolDefinition> coolapkTools(Ref ref) => <ChatToolDefinition>[
  ChatToolDefinition(
    name: 'coolapk_login',
    description:
        'Check the Coolapk sign-in state. Post bodies and full comment lists '
        'need an account, while search works as a guest. When '
        'this reports not signed in, tell the user to sign in: the app renders '
        'a sign-in card for them. Never ask for a password or phone number, '
        'the login happens in an in-app web page.',
    parameters: noArgsSchema,
    execute: (Map<String, dynamic> arguments) async {
      final CoolapkAuthState auth = await ref.read(coolapkAuthProvider.future);
      if (!auth.isLoggedIn) {
        throw const CoolapkAuthRequiredException(
          'COOLAPK_AUTH_REQUIRED: 用户还没登录酷安，请提示用户先登录再试',
        );
      }
      return jsonEncode(<String, Object?>{
        'loggedIn': true,
        if (auth.username.isNotEmpty) 'username': auth.username,
        'savedAt': auth.savedAt,
      });
    },
  ),
  ChatToolDefinition(
    name: 'coolapk_search',
    description:
        'Search Coolapk (酷安), the Chinese Android community, and return '
        'matching posts, users or topics. Use it when the user asks about '
        'real-world device experience rather than official docs: whether a '
        'specific model/ROM can be rooted, how bootloader unlock went for '
        'others, model-specific bugs, recommended apps or Magisk modules. '
        'Each post item carries cleaned body text, author, like/reply counts, '
        'posting device and a shareable URL. When a post mentions download '
        'links or files kept in its comments, call coolapk_feed_all_replies '
        "with that post's id to read the comments instead of guessing. "
        'Do not pass a numeric post id as the query: search matches text, not '
        'ids, and returns nothing.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'query': stringProperty(
          description:
              'Search keywords, as you would type into the Coolapk search box.',
        ),
        'type': stringProperty(
          description:
              'What to search. Defaults to feed (posts), which is what most '
              'device questions need. user finds accounts, feedTopic finds '
              'topic pages, all returns a mixed card list.',
          allowedValues: _searchTypes,
        ),
        'page': intProperty(
          description: 'Result page, starting at 1. Defaults to 1.',
          minimum: 1,
          maximum: 50,
        ),
        'limit': intProperty(
          description: 'How many items to return. Defaults to $_defaultLimit.',
          minimum: 1,
          maximum: _maxLimit,
        ),
      },
      required: <String>['query'],
    ),
    execute: (Map<String, dynamic> arguments) => _awaitOnRisk(ref, () async {
      final String query = requireString(arguments, 'query').trim();
      final CoolapkSearchType type = CoolapkSearchType.fromName(
        stringArg(arguments, 'type', fallback: CoolapkSearchType.feed.name),
      );
      final int page = intArg(arguments, 'page', fallback: 1)!;
      final int limit = _clampLimit(
        intArg(arguments, 'limit', fallback: _defaultLimit)!,
      );

      final CoolapkSearchBatch response = await ref.read(
        coolapkSearchProvider(query: query, type: type, page: page).future,
      );

      final List<CoolapkSearchResult> items = response.items
          .take(limit)
          .toList(growable: false);

      return jsonEncode(<String, Object?>{
        'query': query,
        'type': type.name,
        'page': page,
        'total': items.length,
        if (response.serverTotal > 0) 'serverTotal': response.serverTotal,
        'items': <Map<String, Object?>>[
          for (final CoolapkSearchResult item in items)
            <String, Object?>{
              'entityType': item.entityType,
              'id': item.id,
              'title': item.title,
              'message': item.message,
              'username': item.username,
              'uid': item.uid,
              'url': item.url.isNotEmpty ? item.url : item.shareUrl,
              'likenum': item.likenum,
              'replynum': item.replynum,
              'datelineText': item.datelineText,
              if (item.deviceTitle.isNotEmpty) 'deviceTitle': item.deviceTitle,
              if (item.tags.isNotEmpty) 'tags': item.tags,
              if (item.picArr.isNotEmpty) 'picArr': item.picArr,
            },
        ],
      });
    }),
  ),
  ChatToolDefinition(
    name: 'coolapk_feed_detail',
    description:
        'Read the full body of one Coolapk post by its id. Needs a Coolapk '
        'account. Coolapk also puts a captcha wall on this endpoint: the call '
        'then returns awaitsUser=true together with a captchaId instead of '
        'failing, the app renders a verification card, and the run is paused '
        'until the user clears it. Once resumed, call this tool again with the '
        'same feedId — the check is already passed. Use it when a search '
        'excerpt is truncated, or when the user gives a post URL and you need '
        'to know what the post actually says. The body often carries the real '
        'download links; the comments usually carry the rest.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'feedId': stringProperty(
          description:
              'The post id, i.e. the id field of a coolapk_search item or the '
              'numeric part of https://www.coolapk.com/feed/74522903.',
        ),
      },
      required: <String>['feedId'],
    ),
    execute: (Map<String, dynamic> arguments) => _awaitOnRisk(ref, () async {
      await _requireLogin(ref);
      final String feedId = requireString(arguments, 'feedId').trim();
      final CoolapkFeedDetail detail = await ref.read(
        coolapkFeedDetailProvider(feedId: feedId).future,
      );

      return jsonEncode(<String, Object?>{
        'id': detail.id,
        'title': detail.title,
        'message': detail.message,
        'username': detail.username,
        'uid': detail.uid,
        'likenum': detail.likenum,
        'replynum': detail.replynum,
        'datelineText': detail.datelineText,
        if (detail.deviceTitle.isNotEmpty) 'deviceTitle': detail.deviceTitle,
        if (detail.tags.isNotEmpty) 'tags': detail.tags,
        if (detail.picArr.isNotEmpty) 'picArr': detail.picArr,
        'shareUrl': detail.shareUrl,
      });
    }),
  ),
  ChatToolDefinition(
    name: 'coolapk_feed_all_replies',
    description:
        'Read the full comment list of one Coolapk post, newest first, '
        'including several nested replies per top comment. Needs a Coolapk '
        'account. The comment endpoint is captcha-walled just like the detail '
        'endpoint: a blocked call returns awaitsUser=true with a captchaId and '
        'the run pauses; once resumed, call this tool again with the same '
        'arguments. Call it whenever the post body is unreadable, when the hot '
        'list came back empty, or when download links are said to be in the '
        'comments. Each comment carries rowsMore: when it is greater than the '
        'nested rows returned, call again with replyId set to that comment id '
        'to page its sub-replies.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'feedId': stringProperty(
          description:
              'The post id, i.e. the id field of a coolapk_search item or the '
              'numeric part of https://www.coolapk.com/feed/74522903.',
        ),
        'replyId': stringProperty(
          description:
              'Comment id whose sub-replies you want. Leave empty to page the '
              'top-level comments of the post.',
        ),
        'page': intProperty(
          description: 'Page number, starting at 1. Defaults to 1.',
          minimum: 1,
          maximum: 50,
        ),
        'limit': intProperty(
          description:
              'How many top comments to return. Defaults to $_defaultLimit.',
          minimum: 1,
          maximum: _maxLimit,
        ),
      },
      required: <String>['feedId'],
    ),
    execute: (Map<String, dynamic> arguments) => _awaitOnRisk(ref, () async {
      await _requireLogin(ref);
      final String feedId = requireString(arguments, 'feedId').trim();
      final String replyId = stringArg(arguments, 'replyId').trim();
      final int page = intArg(arguments, 'page', fallback: 1)!;
      final int limit = _clampLimit(
        intArg(arguments, 'limit', fallback: _defaultLimit)!,
      );

      final List<CoolapkFeedReply> replies = await ref.read(
        coolapkFeedRepliesProvider(
          feedId: feedId,
          page: page,
          replyId: replyId,
        ).future,
      );

      final List<CoolapkFeedReply> items = replies
          .take(limit)
          .toList(growable: false);

      return jsonEncode(<String, Object?>{
        'feedId': feedId,
        'page': page,
        'total': items.length,
        if (replyId.isNotEmpty) 'replyId': replyId,
        if (replies.length >= _replyPageSize) 'nextPage': page + 1,
        'items': <Map<String, Object?>>[
          for (final CoolapkFeedReply item in items)
            <String, Object?>{
              'id': item.id,
              'username': item.username,
              'uid': item.uid,
              'message': item.message,
              'likenum': item.likenum,
              'replynum': item.replynum,
              'datelineText': item.datelineText,
              if (item.isFeedAuthor) 'isFeedAuthor': true,
              if (item.rusername.isNotEmpty) 'replyTo': item.rusername,
              if (item.replyRows.isNotEmpty)
                'rows': <Map<String, Object?>>[
                  for (final CoolapkFeedReply row in item.replyRows)
                    <String, Object?>{
                      'id': row.id,
                      'username': row.username,
                      if (row.rusername.isNotEmpty) 'replyTo': row.rusername,
                      'message': row.message,
                      'likenum': row.likenum,
                    },
                ],
              if (item.replyRowsCount > item.replyRows.length)
                'rowsMore': item.replyRowsCount - item.replyRows.length,
            },
        ],
      });
    }),
  ),
  ChatToolDefinition(
    name: 'coolapk_offer_download',
    description:
        'Hand the user the exact download links you actually saw in a Coolapk '
        'post or its comments, and render a card listing those links with a '
        "button that jumps to the original post. Call this only after a tool "
        'result really contains those URLs: never invent, shorten, re-encode or '
        'guess a link. Also write each URL in your reply, because the card is '
        'just a shortcut.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'feedId': stringProperty(
          description:
              'The post id the links came from, used for the jump button.',
        ),
        'urls': stringListProperty(
          description:
              'Download links exactly as they appear, one entry per file.',
          minItems: 1,
          maxItems: 5,
        ),
        'note': stringProperty(
          description:
              'Optional one-line hint, e.g. which file is the full package or '
              'which one matches the user version.',
        ),
      },
      required: <String>['feedId', 'urls'],
    ),
    execute: (Map<String, dynamic> arguments) async {
      final String feedId = requireString(arguments, 'feedId').trim();
      final List<String> urls = requireStringList(arguments, 'urls');
      // 只校验并回显参数：下载卡片由界面读取同一次调用的参数渲染。
      return jsonEncode(<String, Object?>{
        'feedId': feedId,
        'count': urls.length,
        'urls': urls,
        if (stringArg(arguments, 'note').trim().isNotEmpty)
          'note': stringArg(arguments, 'note').trim(),
      });
    },
  ),
];

/// 把条数夹到 `[1, _maxLimit]`。
int _clampLimit(int value) {
  if (value < 1) return 1;
  return value > _maxLimit ? _maxLimit : value;
}

/// 需要账号的接口先判登录：游客直接抛登录提示，界面挂登录入口，
/// 而不是等接口返回风控验证码、让用户看不懂为什么被拦。
Future<void> _requireLogin(Ref ref) async {
  final CoolapkAuthState auth = await ref.read(coolapkAuthProvider.future);
  if (auth.isLoggedIn) return;
  throw const CoolapkAuthRequiredException(
    'COOLAPK_AUTH_REQUIRED: 用户还没登录酷安，请提示用户先登录再试',
  );
}

/// 风控不能算工具失败：返回带 `awaitsUser` 的结果，Run loop 会原地挂起，
/// 等用户在验证卡片上过验证后自动续跑，模型再重调本工具即可。
///
/// 已经带票据仍被拦，说明这张票用掉或过期了：顺手清掉，免得后续请求
/// 一直白带一个失效票据。登录问题仍按失败抛出，走登录卡片那条路。
Future<String> _awaitOnRisk(Ref ref, Future<String> Function() body) async {
  try {
    return await body();
  } on CoolapkRiskControlException catch (error) {
    await ref.read(coolapkAuthActionsProvider).clearCaptchaValidate();
    return jsonEncode(<String, Object?>{
      'awaitsUser': true,
      'riskControl': true,
      'captchaId': error.captchaId,
      if (error.captchaType.isNotEmpty) 'captchaType': error.captchaType,
      'message': error.message,
      'hint':
          '酷安要求先过人机验证：界面上已挂出验证卡片，请等用户在卡片里完成验证。'
          '续跑后用同样的参数重新调用本工具，不要再解释或重试别的接口。',
    });
  }
}
