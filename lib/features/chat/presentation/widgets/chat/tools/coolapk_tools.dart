import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/tool_schema.dart';
import 'package:Aisupass/features/coolapk/domain/enums/coolapk_search_type.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_search_batch.dart';
import 'package:Aisupass/features/coolapk/domain/models/coolapk_search_result.dart';
import 'package:Aisupass/features/coolapk/presentation/providers/coolapk_query_provider.dart';

/// 单次回传给模型的默认与最大条数。
const int _defaultLimit = 10;
const int _maxLimit = 20;

/// 支持的搜索维度，直接来自 [CoolapkSearchType]。
final List<String> _searchTypes = CoolapkSearchType.values
    .map((CoolapkSearchType type) => type.name)
    .toList(growable: false);

/// 酷安社区搜索工具：游客态可读，无需账号与 API Key。
List<ChatToolDefinition> coolapkTools(Ref ref) => <ChatToolDefinition>[
  ChatToolDefinition(
    name: 'coolapk_search',
    description:
        'Search Coolapk (酷安), the Chinese Android community, and return '
        'matching posts, users or topics. Use it when the user asks about '
        'real-world device experience rather than official docs: whether a '
        'specific model/ROM can be rooted, how bootloader unlock went for '
        'others, model-specific bugs, recommended apps or Magisk modules. '
        'Each post item carries cleaned body text, author, like/reply counts, '
        'posting device and a shareable URL. Post comments and full post '
        'detail require a logged-in session and are not available here, so '
        'answer from the post body instead of promising comment summaries.',
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
    execute: (Map<String, dynamic> arguments) async {
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
    },
  ),
];

/// 把条数夹到 `[1, _maxLimit]`。
int _clampLimit(int value) {
  if (value < 1) return 1;
  return value > _maxLimit ? _maxLimit : value;
}
