// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coolapk_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 酷安查询数据源。
///
/// 登录态与验证码票据变化会重建它，让请求头立即跟上。

@ProviderFor(coolapkQueryDatasource)
const coolapkQueryDatasourceProvider = CoolapkQueryDatasourceProvider._();

/// 酷安查询数据源。
///
/// 登录态与验证码票据变化会重建它，让请求头立即跟上。

final class CoolapkQueryDatasourceProvider
    extends
        $FunctionalProvider<
          CoolapkQueryDatasource,
          CoolapkQueryDatasource,
          CoolapkQueryDatasource
        >
    with $Provider<CoolapkQueryDatasource> {
  /// 酷安查询数据源。
  ///
  /// 登录态与验证码票据变化会重建它，让请求头立即跟上。
  const CoolapkQueryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coolapkQueryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coolapkQueryDatasourceHash();

  @$internal
  @override
  $ProviderElement<CoolapkQueryDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CoolapkQueryDatasource create(Ref ref) {
    return coolapkQueryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoolapkQueryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoolapkQueryDatasource>(value),
    );
  }
}

String _$coolapkQueryDatasourceHash() =>
    r'a3d79b782f89c3a9e05a38405cc6b2f8b6fd0e39';

/// 酷安查询仓储。

@ProviderFor(coolapkQueryRepository)
const coolapkQueryRepositoryProvider = CoolapkQueryRepositoryProvider._();

/// 酷安查询仓储。

final class CoolapkQueryRepositoryProvider
    extends
        $FunctionalProvider<
          CoolapkQueryRepository,
          CoolapkQueryRepository,
          CoolapkQueryRepository
        >
    with $Provider<CoolapkQueryRepository> {
  /// 酷安查询仓储。
  const CoolapkQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coolapkQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coolapkQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<CoolapkQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CoolapkQueryRepository create(Ref ref) {
    return coolapkQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoolapkQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoolapkQueryRepository>(value),
    );
  }
}

String _$coolapkQueryRepositoryHash() =>
    r'f4145a878d6a85f68d918ee6d7ca0e31890de684';

/// 一次酷安搜索。
///
/// 关键词、维度与页码都是入参，结果不缓存：社区内容实时变动。

@ProviderFor(coolapkSearch)
const coolapkSearchProvider = CoolapkSearchFamily._();

/// 一次酷安搜索。
///
/// 关键词、维度与页码都是入参，结果不缓存：社区内容实时变动。

final class CoolapkSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<CoolapkSearchBatch>,
          CoolapkSearchBatch,
          FutureOr<CoolapkSearchBatch>
        >
    with
        $FutureModifier<CoolapkSearchBatch>,
        $FutureProvider<CoolapkSearchBatch> {
  /// 一次酷安搜索。
  ///
  /// 关键词、维度与页码都是入参，结果不缓存：社区内容实时变动。
  const CoolapkSearchProvider._({
    required CoolapkSearchFamily super.from,
    required ({String query, CoolapkSearchType type, int page}) super.argument,
  }) : super(
         retry: null,
         name: r'coolapkSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$coolapkSearchHash();

  @override
  String toString() {
    return r'coolapkSearchProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<CoolapkSearchBatch> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CoolapkSearchBatch> create(Ref ref) {
    final argument =
        this.argument as ({String query, CoolapkSearchType type, int page});
    return coolapkSearch(
      ref,
      query: argument.query,
      type: argument.type,
      page: argument.page,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CoolapkSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$coolapkSearchHash() => r'6e2e5fd4ba27d56eef869dfe54b3649b900b482c';

/// 一次酷安搜索。
///
/// 关键词、维度与页码都是入参，结果不缓存：社区内容实时变动。

final class CoolapkSearchFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<CoolapkSearchBatch>,
          ({String query, CoolapkSearchType type, int page})
        > {
  const CoolapkSearchFamily._()
    : super(
        retry: null,
        name: r'coolapkSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 一次酷安搜索。
  ///
  /// 关键词、维度与页码都是入参，结果不缓存：社区内容实时变动。

  CoolapkSearchProvider call({
    required String query,
    CoolapkSearchType type = CoolapkSearchType.feed,
    int page = 1,
  }) => CoolapkSearchProvider._(
    argument: (query: query, type: type, page: page),
    from: this,
  );

  @override
  String toString() => r'coolapkSearchProvider';
}

/// 某条动态的完整内容。
///
/// 需要登录；游客态会抛 [CoolapkAuthRequiredException]。

@ProviderFor(coolapkFeedDetail)
const coolapkFeedDetailProvider = CoolapkFeedDetailFamily._();

/// 某条动态的完整内容。
///
/// 需要登录；游客态会抛 [CoolapkAuthRequiredException]。

final class CoolapkFeedDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<CoolapkFeedDetail>,
          CoolapkFeedDetail,
          FutureOr<CoolapkFeedDetail>
        >
    with
        $FutureModifier<CoolapkFeedDetail>,
        $FutureProvider<CoolapkFeedDetail> {
  /// 某条动态的完整内容。
  ///
  /// 需要登录；游客态会抛 [CoolapkAuthRequiredException]。
  const CoolapkFeedDetailProvider._({
    required CoolapkFeedDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'coolapkFeedDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$coolapkFeedDetailHash();

  @override
  String toString() {
    return r'coolapkFeedDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CoolapkFeedDetail> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CoolapkFeedDetail> create(Ref ref) {
    final argument = this.argument as String;
    return coolapkFeedDetail(ref, feedId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CoolapkFeedDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$coolapkFeedDetailHash() => r'8944085e5edad6cd9f21bf4fd7e25a14badf1fba';

/// 某条动态的完整内容。
///
/// 需要登录；游客态会抛 [CoolapkAuthRequiredException]。

final class CoolapkFeedDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CoolapkFeedDetail>, String> {
  const CoolapkFeedDetailFamily._()
    : super(
        retry: null,
        name: r'coolapkFeedDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 某条动态的完整内容。
  ///
  /// 需要登录；游客态会抛 [CoolapkAuthRequiredException]。

  CoolapkFeedDetailProvider call({required String feedId}) =>
      CoolapkFeedDetailProvider._(argument: feedId, from: this);

  @override
  String toString() => r'coolapkFeedDetailProvider';
}

/// 某条动态的全部评论（含楼中楼）。
///
/// 需要登录；游客态会抛 [CoolapkAuthRequiredException]。

@ProviderFor(coolapkFeedReplies)
const coolapkFeedRepliesProvider = CoolapkFeedRepliesFamily._();

/// 某条动态的全部评论（含楼中楼）。
///
/// 需要登录；游客态会抛 [CoolapkAuthRequiredException]。

final class CoolapkFeedRepliesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CoolapkFeedReply>>,
          List<CoolapkFeedReply>,
          FutureOr<List<CoolapkFeedReply>>
        >
    with
        $FutureModifier<List<CoolapkFeedReply>>,
        $FutureProvider<List<CoolapkFeedReply>> {
  /// 某条动态的全部评论（含楼中楼）。
  ///
  /// 需要登录；游客态会抛 [CoolapkAuthRequiredException]。
  const CoolapkFeedRepliesProvider._({
    required CoolapkFeedRepliesFamily super.from,
    required ({String feedId, int page, String replyId}) super.argument,
  }) : super(
         retry: null,
         name: r'coolapkFeedRepliesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$coolapkFeedRepliesHash();

  @override
  String toString() {
    return r'coolapkFeedRepliesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<CoolapkFeedReply>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CoolapkFeedReply>> create(Ref ref) {
    final argument =
        this.argument as ({String feedId, int page, String replyId});
    return coolapkFeedReplies(
      ref,
      feedId: argument.feedId,
      page: argument.page,
      replyId: argument.replyId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CoolapkFeedRepliesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$coolapkFeedRepliesHash() =>
    r'9d7c8c1171f57b6e43b5005839d32ec97268ce33';

/// 某条动态的全部评论（含楼中楼）。
///
/// 需要登录；游客态会抛 [CoolapkAuthRequiredException]。

final class CoolapkFeedRepliesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<CoolapkFeedReply>>,
          ({String feedId, int page, String replyId})
        > {
  const CoolapkFeedRepliesFamily._()
    : super(
        retry: null,
        name: r'coolapkFeedRepliesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 某条动态的全部评论（含楼中楼）。
  ///
  /// 需要登录；游客态会抛 [CoolapkAuthRequiredException]。

  CoolapkFeedRepliesProvider call({
    required String feedId,
    int page = 1,
    String replyId = '',
  }) => CoolapkFeedRepliesProvider._(
    argument: (feedId: feedId, page: page, replyId: replyId),
    from: this,
  );

  @override
  String toString() => r'coolapkFeedRepliesProvider';
}
