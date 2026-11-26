// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coolapk_search_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoolapkSearchResult {

/// 条目类型，服务器取值如 `feed` / `user` / `feedTopic`。
 String get entityType;/// 条目 id，用户条目为 uid。
 String get id;/// 标题，用户条目为昵称，话题为话题名。
 String get title;/// 正文，DTO 已去掉 HTML 标签与转义。
 String get message;/// 作者昵称。
 String get username;/// 作者 uid。
 String get uid;/// 网页地址，部分类型才有。
 String get url;/// 分享地址，动态才有。
 String get shareUrl;/// 点赞数。
 int get likenum;/// 回复数。
 int get replynum;/// 相对时间文案，如「3小时前」。
 String get datelineText;/// 发帖机型。
 String get deviceTitle;/// 标签，DTO 已去掉 `#`。
 String get tags;/// 配图地址。
 List<String> get picArr;
/// Create a copy of CoolapkSearchResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoolapkSearchResultCopyWith<CoolapkSearchResult> get copyWith => _$CoolapkSearchResultCopyWithImpl<CoolapkSearchResult>(this as CoolapkSearchResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoolapkSearchResult&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.username, username) || other.username == username)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.url, url) || other.url == url)&&(identical(other.shareUrl, shareUrl) || other.shareUrl == shareUrl)&&(identical(other.likenum, likenum) || other.likenum == likenum)&&(identical(other.replynum, replynum) || other.replynum == replynum)&&(identical(other.datelineText, datelineText) || other.datelineText == datelineText)&&(identical(other.deviceTitle, deviceTitle) || other.deviceTitle == deviceTitle)&&(identical(other.tags, tags) || other.tags == tags)&&const DeepCollectionEquality().equals(other.picArr, picArr));
}


@override
int get hashCode => Object.hash(runtimeType,entityType,id,title,message,username,uid,url,shareUrl,likenum,replynum,datelineText,deviceTitle,tags,const DeepCollectionEquality().hash(picArr));

@override
String toString() {
  return 'CoolapkSearchResult(entityType: $entityType, id: $id, title: $title, message: $message, username: $username, uid: $uid, url: $url, shareUrl: $shareUrl, likenum: $likenum, replynum: $replynum, datelineText: $datelineText, deviceTitle: $deviceTitle, tags: $tags, picArr: $picArr)';
}


}

/// @nodoc
abstract mixin class $CoolapkSearchResultCopyWith<$Res>  {
  factory $CoolapkSearchResultCopyWith(CoolapkSearchResult value, $Res Function(CoolapkSearchResult) _then) = _$CoolapkSearchResultCopyWithImpl;
@useResult
$Res call({
 String entityType, String id, String title, String message, String username, String uid, String url, String shareUrl, int likenum, int replynum, String datelineText, String deviceTitle, String tags, List<String> picArr
});




}
/// @nodoc
class _$CoolapkSearchResultCopyWithImpl<$Res>
    implements $CoolapkSearchResultCopyWith<$Res> {
  _$CoolapkSearchResultCopyWithImpl(this._self, this._then);

  final CoolapkSearchResult _self;
  final $Res Function(CoolapkSearchResult) _then;

/// Create a copy of CoolapkSearchResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entityType = null,Object? id = null,Object? title = null,Object? message = null,Object? username = null,Object? uid = null,Object? url = null,Object? shareUrl = null,Object? likenum = null,Object? replynum = null,Object? datelineText = null,Object? deviceTitle = null,Object? tags = null,Object? picArr = null,}) {
  return _then(_self.copyWith(
entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,shareUrl: null == shareUrl ? _self.shareUrl : shareUrl // ignore: cast_nullable_to_non_nullable
as String,likenum: null == likenum ? _self.likenum : likenum // ignore: cast_nullable_to_non_nullable
as int,replynum: null == replynum ? _self.replynum : replynum // ignore: cast_nullable_to_non_nullable
as int,datelineText: null == datelineText ? _self.datelineText : datelineText // ignore: cast_nullable_to_non_nullable
as String,deviceTitle: null == deviceTitle ? _self.deviceTitle : deviceTitle // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as String,picArr: null == picArr ? _self.picArr : picArr // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CoolapkSearchResult].
extension CoolapkSearchResultPatterns on CoolapkSearchResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoolapkSearchResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoolapkSearchResult() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoolapkSearchResult value)  $default,){
final _that = this;
switch (_that) {
case _CoolapkSearchResult():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoolapkSearchResult value)?  $default,){
final _that = this;
switch (_that) {
case _CoolapkSearchResult() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String entityType,  String id,  String title,  String message,  String username,  String uid,  String url,  String shareUrl,  int likenum,  int replynum,  String datelineText,  String deviceTitle,  String tags,  List<String> picArr)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoolapkSearchResult() when $default != null:
return $default(_that.entityType,_that.id,_that.title,_that.message,_that.username,_that.uid,_that.url,_that.shareUrl,_that.likenum,_that.replynum,_that.datelineText,_that.deviceTitle,_that.tags,_that.picArr);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String entityType,  String id,  String title,  String message,  String username,  String uid,  String url,  String shareUrl,  int likenum,  int replynum,  String datelineText,  String deviceTitle,  String tags,  List<String> picArr)  $default,) {final _that = this;
switch (_that) {
case _CoolapkSearchResult():
return $default(_that.entityType,_that.id,_that.title,_that.message,_that.username,_that.uid,_that.url,_that.shareUrl,_that.likenum,_that.replynum,_that.datelineText,_that.deviceTitle,_that.tags,_that.picArr);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String entityType,  String id,  String title,  String message,  String username,  String uid,  String url,  String shareUrl,  int likenum,  int replynum,  String datelineText,  String deviceTitle,  String tags,  List<String> picArr)?  $default,) {final _that = this;
switch (_that) {
case _CoolapkSearchResult() when $default != null:
return $default(_that.entityType,_that.id,_that.title,_that.message,_that.username,_that.uid,_that.url,_that.shareUrl,_that.likenum,_that.replynum,_that.datelineText,_that.deviceTitle,_that.tags,_that.picArr);case _:
  return null;

}
}

}

/// @nodoc


class _CoolapkSearchResult extends CoolapkSearchResult {
  const _CoolapkSearchResult({required this.entityType, required this.id, required this.title, required this.message, required this.username, required this.uid, required this.url, required this.shareUrl, required this.likenum, required this.replynum, required this.datelineText, required this.deviceTitle, required this.tags, required this.picArr}): super._();
  

/// 条目类型，服务器取值如 `feed` / `user` / `feedTopic`。
@override final  String entityType;
/// 条目 id，用户条目为 uid。
@override final  String id;
/// 标题，用户条目为昵称，话题为话题名。
@override final  String title;
/// 正文，DTO 已去掉 HTML 标签与转义。
@override final  String message;
/// 作者昵称。
@override final  String username;
/// 作者 uid。
@override final  String uid;
/// 网页地址，部分类型才有。
@override final  String url;
/// 分享地址，动态才有。
@override final  String shareUrl;
/// 点赞数。
@override final  int likenum;
/// 回复数。
@override final  int replynum;
/// 相对时间文案，如「3小时前」。
@override final  String datelineText;
/// 发帖机型。
@override final  String deviceTitle;
/// 标签，DTO 已去掉 `#`。
@override final  String tags;
/// 配图地址。
@override final  List<String> picArr;

/// Create a copy of CoolapkSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoolapkSearchResultCopyWith<_CoolapkSearchResult> get copyWith => __$CoolapkSearchResultCopyWithImpl<_CoolapkSearchResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoolapkSearchResult&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.username, username) || other.username == username)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.url, url) || other.url == url)&&(identical(other.shareUrl, shareUrl) || other.shareUrl == shareUrl)&&(identical(other.likenum, likenum) || other.likenum == likenum)&&(identical(other.replynum, replynum) || other.replynum == replynum)&&(identical(other.datelineText, datelineText) || other.datelineText == datelineText)&&(identical(other.deviceTitle, deviceTitle) || other.deviceTitle == deviceTitle)&&(identical(other.tags, tags) || other.tags == tags)&&const DeepCollectionEquality().equals(other.picArr, picArr));
}


@override
int get hashCode => Object.hash(runtimeType,entityType,id,title,message,username,uid,url,shareUrl,likenum,replynum,datelineText,deviceTitle,tags,const DeepCollectionEquality().hash(picArr));

@override
String toString() {
  return 'CoolapkSearchResult(entityType: $entityType, id: $id, title: $title, message: $message, username: $username, uid: $uid, url: $url, shareUrl: $shareUrl, likenum: $likenum, replynum: $replynum, datelineText: $datelineText, deviceTitle: $deviceTitle, tags: $tags, picArr: $picArr)';
}


}

/// @nodoc
abstract mixin class _$CoolapkSearchResultCopyWith<$Res> implements $CoolapkSearchResultCopyWith<$Res> {
  factory _$CoolapkSearchResultCopyWith(_CoolapkSearchResult value, $Res Function(_CoolapkSearchResult) _then) = __$CoolapkSearchResultCopyWithImpl;
@override @useResult
$Res call({
 String entityType, String id, String title, String message, String username, String uid, String url, String shareUrl, int likenum, int replynum, String datelineText, String deviceTitle, String tags, List<String> picArr
});




}
/// @nodoc
class __$CoolapkSearchResultCopyWithImpl<$Res>
    implements _$CoolapkSearchResultCopyWith<$Res> {
  __$CoolapkSearchResultCopyWithImpl(this._self, this._then);

  final _CoolapkSearchResult _self;
  final $Res Function(_CoolapkSearchResult) _then;

/// Create a copy of CoolapkSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entityType = null,Object? id = null,Object? title = null,Object? message = null,Object? username = null,Object? uid = null,Object? url = null,Object? shareUrl = null,Object? likenum = null,Object? replynum = null,Object? datelineText = null,Object? deviceTitle = null,Object? tags = null,Object? picArr = null,}) {
  return _then(_CoolapkSearchResult(
entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,shareUrl: null == shareUrl ? _self.shareUrl : shareUrl // ignore: cast_nullable_to_non_nullable
as String,likenum: null == likenum ? _self.likenum : likenum // ignore: cast_nullable_to_non_nullable
as int,replynum: null == replynum ? _self.replynum : replynum // ignore: cast_nullable_to_non_nullable
as int,datelineText: null == datelineText ? _self.datelineText : datelineText // ignore: cast_nullable_to_non_nullable
as String,deviceTitle: null == deviceTitle ? _self.deviceTitle : deviceTitle // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as String,picArr: null == picArr ? _self.picArr : picArr // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
