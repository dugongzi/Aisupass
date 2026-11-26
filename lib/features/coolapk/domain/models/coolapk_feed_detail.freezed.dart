// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coolapk_feed_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoolapkFeedDetail {

/// 动态 id。
 String get id;/// 标题；普通动态通常只是「某某的动态」。
 String get title;/// 正文，DTO 已去掉 HTML 标签与转义。
 String get message;/// 作者昵称。
 String get username;/// 作者 uid。
 String get uid;/// 点赞数。
 int get likenum;/// 回复数。
 int get replynum;/// 相对时间文案，如「刚刚」。
 String get datelineText;/// 发布设备。
 String get deviceTitle;/// 话题标签，多个以空格分隔。
 String get tags;/// 配图地址。
 List<String> get picArr;/// 分享链接。
 String get shareUrl;
/// Create a copy of CoolapkFeedDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoolapkFeedDetailCopyWith<CoolapkFeedDetail> get copyWith => _$CoolapkFeedDetailCopyWithImpl<CoolapkFeedDetail>(this as CoolapkFeedDetail, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoolapkFeedDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.username, username) || other.username == username)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.likenum, likenum) || other.likenum == likenum)&&(identical(other.replynum, replynum) || other.replynum == replynum)&&(identical(other.datelineText, datelineText) || other.datelineText == datelineText)&&(identical(other.deviceTitle, deviceTitle) || other.deviceTitle == deviceTitle)&&(identical(other.tags, tags) || other.tags == tags)&&const DeepCollectionEquality().equals(other.picArr, picArr)&&(identical(other.shareUrl, shareUrl) || other.shareUrl == shareUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,message,username,uid,likenum,replynum,datelineText,deviceTitle,tags,const DeepCollectionEquality().hash(picArr),shareUrl);

@override
String toString() {
  return 'CoolapkFeedDetail(id: $id, title: $title, message: $message, username: $username, uid: $uid, likenum: $likenum, replynum: $replynum, datelineText: $datelineText, deviceTitle: $deviceTitle, tags: $tags, picArr: $picArr, shareUrl: $shareUrl)';
}


}

/// @nodoc
abstract mixin class $CoolapkFeedDetailCopyWith<$Res>  {
  factory $CoolapkFeedDetailCopyWith(CoolapkFeedDetail value, $Res Function(CoolapkFeedDetail) _then) = _$CoolapkFeedDetailCopyWithImpl;
@useResult
$Res call({
 String id, String title, String message, String username, String uid, int likenum, int replynum, String datelineText, String deviceTitle, String tags, List<String> picArr, String shareUrl
});




}
/// @nodoc
class _$CoolapkFeedDetailCopyWithImpl<$Res>
    implements $CoolapkFeedDetailCopyWith<$Res> {
  _$CoolapkFeedDetailCopyWithImpl(this._self, this._then);

  final CoolapkFeedDetail _self;
  final $Res Function(CoolapkFeedDetail) _then;

/// Create a copy of CoolapkFeedDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? message = null,Object? username = null,Object? uid = null,Object? likenum = null,Object? replynum = null,Object? datelineText = null,Object? deviceTitle = null,Object? tags = null,Object? picArr = null,Object? shareUrl = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,likenum: null == likenum ? _self.likenum : likenum // ignore: cast_nullable_to_non_nullable
as int,replynum: null == replynum ? _self.replynum : replynum // ignore: cast_nullable_to_non_nullable
as int,datelineText: null == datelineText ? _self.datelineText : datelineText // ignore: cast_nullable_to_non_nullable
as String,deviceTitle: null == deviceTitle ? _self.deviceTitle : deviceTitle // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as String,picArr: null == picArr ? _self.picArr : picArr // ignore: cast_nullable_to_non_nullable
as List<String>,shareUrl: null == shareUrl ? _self.shareUrl : shareUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CoolapkFeedDetail].
extension CoolapkFeedDetailPatterns on CoolapkFeedDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoolapkFeedDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoolapkFeedDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoolapkFeedDetail value)  $default,){
final _that = this;
switch (_that) {
case _CoolapkFeedDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoolapkFeedDetail value)?  $default,){
final _that = this;
switch (_that) {
case _CoolapkFeedDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String message,  String username,  String uid,  int likenum,  int replynum,  String datelineText,  String deviceTitle,  String tags,  List<String> picArr,  String shareUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoolapkFeedDetail() when $default != null:
return $default(_that.id,_that.title,_that.message,_that.username,_that.uid,_that.likenum,_that.replynum,_that.datelineText,_that.deviceTitle,_that.tags,_that.picArr,_that.shareUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String message,  String username,  String uid,  int likenum,  int replynum,  String datelineText,  String deviceTitle,  String tags,  List<String> picArr,  String shareUrl)  $default,) {final _that = this;
switch (_that) {
case _CoolapkFeedDetail():
return $default(_that.id,_that.title,_that.message,_that.username,_that.uid,_that.likenum,_that.replynum,_that.datelineText,_that.deviceTitle,_that.tags,_that.picArr,_that.shareUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String message,  String username,  String uid,  int likenum,  int replynum,  String datelineText,  String deviceTitle,  String tags,  List<String> picArr,  String shareUrl)?  $default,) {final _that = this;
switch (_that) {
case _CoolapkFeedDetail() when $default != null:
return $default(_that.id,_that.title,_that.message,_that.username,_that.uid,_that.likenum,_that.replynum,_that.datelineText,_that.deviceTitle,_that.tags,_that.picArr,_that.shareUrl);case _:
  return null;

}
}

}

/// @nodoc


class _CoolapkFeedDetail extends CoolapkFeedDetail {
  const _CoolapkFeedDetail({required this.id, required this.title, required this.message, required this.username, required this.uid, required this.likenum, required this.replynum, required this.datelineText, required this.deviceTitle, required this.tags, required this.picArr, required this.shareUrl}): super._();
  

/// 动态 id。
@override final  String id;
/// 标题；普通动态通常只是「某某的动态」。
@override final  String title;
/// 正文，DTO 已去掉 HTML 标签与转义。
@override final  String message;
/// 作者昵称。
@override final  String username;
/// 作者 uid。
@override final  String uid;
/// 点赞数。
@override final  int likenum;
/// 回复数。
@override final  int replynum;
/// 相对时间文案，如「刚刚」。
@override final  String datelineText;
/// 发布设备。
@override final  String deviceTitle;
/// 话题标签，多个以空格分隔。
@override final  String tags;
/// 配图地址。
@override final  List<String> picArr;
/// 分享链接。
@override final  String shareUrl;

/// Create a copy of CoolapkFeedDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoolapkFeedDetailCopyWith<_CoolapkFeedDetail> get copyWith => __$CoolapkFeedDetailCopyWithImpl<_CoolapkFeedDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoolapkFeedDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.username, username) || other.username == username)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.likenum, likenum) || other.likenum == likenum)&&(identical(other.replynum, replynum) || other.replynum == replynum)&&(identical(other.datelineText, datelineText) || other.datelineText == datelineText)&&(identical(other.deviceTitle, deviceTitle) || other.deviceTitle == deviceTitle)&&(identical(other.tags, tags) || other.tags == tags)&&const DeepCollectionEquality().equals(other.picArr, picArr)&&(identical(other.shareUrl, shareUrl) || other.shareUrl == shareUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,message,username,uid,likenum,replynum,datelineText,deviceTitle,tags,const DeepCollectionEquality().hash(picArr),shareUrl);

@override
String toString() {
  return 'CoolapkFeedDetail(id: $id, title: $title, message: $message, username: $username, uid: $uid, likenum: $likenum, replynum: $replynum, datelineText: $datelineText, deviceTitle: $deviceTitle, tags: $tags, picArr: $picArr, shareUrl: $shareUrl)';
}


}

/// @nodoc
abstract mixin class _$CoolapkFeedDetailCopyWith<$Res> implements $CoolapkFeedDetailCopyWith<$Res> {
  factory _$CoolapkFeedDetailCopyWith(_CoolapkFeedDetail value, $Res Function(_CoolapkFeedDetail) _then) = __$CoolapkFeedDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String message, String username, String uid, int likenum, int replynum, String datelineText, String deviceTitle, String tags, List<String> picArr, String shareUrl
});




}
/// @nodoc
class __$CoolapkFeedDetailCopyWithImpl<$Res>
    implements _$CoolapkFeedDetailCopyWith<$Res> {
  __$CoolapkFeedDetailCopyWithImpl(this._self, this._then);

  final _CoolapkFeedDetail _self;
  final $Res Function(_CoolapkFeedDetail) _then;

/// Create a copy of CoolapkFeedDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? message = null,Object? username = null,Object? uid = null,Object? likenum = null,Object? replynum = null,Object? datelineText = null,Object? deviceTitle = null,Object? tags = null,Object? picArr = null,Object? shareUrl = null,}) {
  return _then(_CoolapkFeedDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,likenum: null == likenum ? _self.likenum : likenum // ignore: cast_nullable_to_non_nullable
as int,replynum: null == replynum ? _self.replynum : replynum // ignore: cast_nullable_to_non_nullable
as int,datelineText: null == datelineText ? _self.datelineText : datelineText // ignore: cast_nullable_to_non_nullable
as String,deviceTitle: null == deviceTitle ? _self.deviceTitle : deviceTitle // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as String,picArr: null == picArr ? _self.picArr : picArr // ignore: cast_nullable_to_non_nullable
as List<String>,shareUrl: null == shareUrl ? _self.shareUrl : shareUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
