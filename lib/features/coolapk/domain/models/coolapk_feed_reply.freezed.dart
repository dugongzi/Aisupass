// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coolapk_feed_reply.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoolapkFeedReply {

/// 评论 id，翻楼中楼时作为 `replyId` 传入。
 String get id;/// 所属动态 id。
 String get fid;/// 评论者 uid。
 String get uid;/// 评论者昵称。
 String get username;/// 被回复者 uid，顶层评论为空。
 String get ruid;/// 被回复者昵称，顶层评论为空。
 String get rusername;/// 评论正文，DTO 已去掉 HTML 标签与转义。
 String get message;/// 点赞数。
 int get likenum;/// 该评论的回复总数（含未展开的楼中楼）。
 int get replynum;/// 相对时间文案，如「前天」。
 String get datelineText;/// 是否为动态作者本人的评论。
 bool get isFeedAuthor;/// 评论者头像地址。
 String get userAvatar;/// 已展开的楼中楼，通常只有前几条。
 List<CoolapkFeedReply> get replyRows;/// 楼中楼总数；大于 [replyRows] 长度说明还有没展开的。
 int get replyRowsCount;
/// Create a copy of CoolapkFeedReply
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoolapkFeedReplyCopyWith<CoolapkFeedReply> get copyWith => _$CoolapkFeedReplyCopyWithImpl<CoolapkFeedReply>(this as CoolapkFeedReply, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoolapkFeedReply&&(identical(other.id, id) || other.id == id)&&(identical(other.fid, fid) || other.fid == fid)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.username, username) || other.username == username)&&(identical(other.ruid, ruid) || other.ruid == ruid)&&(identical(other.rusername, rusername) || other.rusername == rusername)&&(identical(other.message, message) || other.message == message)&&(identical(other.likenum, likenum) || other.likenum == likenum)&&(identical(other.replynum, replynum) || other.replynum == replynum)&&(identical(other.datelineText, datelineText) || other.datelineText == datelineText)&&(identical(other.isFeedAuthor, isFeedAuthor) || other.isFeedAuthor == isFeedAuthor)&&(identical(other.userAvatar, userAvatar) || other.userAvatar == userAvatar)&&const DeepCollectionEquality().equals(other.replyRows, replyRows)&&(identical(other.replyRowsCount, replyRowsCount) || other.replyRowsCount == replyRowsCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,fid,uid,username,ruid,rusername,message,likenum,replynum,datelineText,isFeedAuthor,userAvatar,const DeepCollectionEquality().hash(replyRows),replyRowsCount);

@override
String toString() {
  return 'CoolapkFeedReply(id: $id, fid: $fid, uid: $uid, username: $username, ruid: $ruid, rusername: $rusername, message: $message, likenum: $likenum, replynum: $replynum, datelineText: $datelineText, isFeedAuthor: $isFeedAuthor, userAvatar: $userAvatar, replyRows: $replyRows, replyRowsCount: $replyRowsCount)';
}


}

/// @nodoc
abstract mixin class $CoolapkFeedReplyCopyWith<$Res>  {
  factory $CoolapkFeedReplyCopyWith(CoolapkFeedReply value, $Res Function(CoolapkFeedReply) _then) = _$CoolapkFeedReplyCopyWithImpl;
@useResult
$Res call({
 String id, String fid, String uid, String username, String ruid, String rusername, String message, int likenum, int replynum, String datelineText, bool isFeedAuthor, String userAvatar, List<CoolapkFeedReply> replyRows, int replyRowsCount
});




}
/// @nodoc
class _$CoolapkFeedReplyCopyWithImpl<$Res>
    implements $CoolapkFeedReplyCopyWith<$Res> {
  _$CoolapkFeedReplyCopyWithImpl(this._self, this._then);

  final CoolapkFeedReply _self;
  final $Res Function(CoolapkFeedReply) _then;

/// Create a copy of CoolapkFeedReply
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fid = null,Object? uid = null,Object? username = null,Object? ruid = null,Object? rusername = null,Object? message = null,Object? likenum = null,Object? replynum = null,Object? datelineText = null,Object? isFeedAuthor = null,Object? userAvatar = null,Object? replyRows = null,Object? replyRowsCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fid: null == fid ? _self.fid : fid // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,ruid: null == ruid ? _self.ruid : ruid // ignore: cast_nullable_to_non_nullable
as String,rusername: null == rusername ? _self.rusername : rusername // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,likenum: null == likenum ? _self.likenum : likenum // ignore: cast_nullable_to_non_nullable
as int,replynum: null == replynum ? _self.replynum : replynum // ignore: cast_nullable_to_non_nullable
as int,datelineText: null == datelineText ? _self.datelineText : datelineText // ignore: cast_nullable_to_non_nullable
as String,isFeedAuthor: null == isFeedAuthor ? _self.isFeedAuthor : isFeedAuthor // ignore: cast_nullable_to_non_nullable
as bool,userAvatar: null == userAvatar ? _self.userAvatar : userAvatar // ignore: cast_nullable_to_non_nullable
as String,replyRows: null == replyRows ? _self.replyRows : replyRows // ignore: cast_nullable_to_non_nullable
as List<CoolapkFeedReply>,replyRowsCount: null == replyRowsCount ? _self.replyRowsCount : replyRowsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CoolapkFeedReply].
extension CoolapkFeedReplyPatterns on CoolapkFeedReply {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoolapkFeedReply value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoolapkFeedReply() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoolapkFeedReply value)  $default,){
final _that = this;
switch (_that) {
case _CoolapkFeedReply():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoolapkFeedReply value)?  $default,){
final _that = this;
switch (_that) {
case _CoolapkFeedReply() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fid,  String uid,  String username,  String ruid,  String rusername,  String message,  int likenum,  int replynum,  String datelineText,  bool isFeedAuthor,  String userAvatar,  List<CoolapkFeedReply> replyRows,  int replyRowsCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoolapkFeedReply() when $default != null:
return $default(_that.id,_that.fid,_that.uid,_that.username,_that.ruid,_that.rusername,_that.message,_that.likenum,_that.replynum,_that.datelineText,_that.isFeedAuthor,_that.userAvatar,_that.replyRows,_that.replyRowsCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fid,  String uid,  String username,  String ruid,  String rusername,  String message,  int likenum,  int replynum,  String datelineText,  bool isFeedAuthor,  String userAvatar,  List<CoolapkFeedReply> replyRows,  int replyRowsCount)  $default,) {final _that = this;
switch (_that) {
case _CoolapkFeedReply():
return $default(_that.id,_that.fid,_that.uid,_that.username,_that.ruid,_that.rusername,_that.message,_that.likenum,_that.replynum,_that.datelineText,_that.isFeedAuthor,_that.userAvatar,_that.replyRows,_that.replyRowsCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fid,  String uid,  String username,  String ruid,  String rusername,  String message,  int likenum,  int replynum,  String datelineText,  bool isFeedAuthor,  String userAvatar,  List<CoolapkFeedReply> replyRows,  int replyRowsCount)?  $default,) {final _that = this;
switch (_that) {
case _CoolapkFeedReply() when $default != null:
return $default(_that.id,_that.fid,_that.uid,_that.username,_that.ruid,_that.rusername,_that.message,_that.likenum,_that.replynum,_that.datelineText,_that.isFeedAuthor,_that.userAvatar,_that.replyRows,_that.replyRowsCount);case _:
  return null;

}
}

}

/// @nodoc


class _CoolapkFeedReply extends CoolapkFeedReply {
  const _CoolapkFeedReply({required this.id, required this.fid, required this.uid, required this.username, required this.ruid, required this.rusername, required this.message, required this.likenum, required this.replynum, required this.datelineText, required this.isFeedAuthor, required this.userAvatar, required this.replyRows, required this.replyRowsCount}): super._();
  

/// 评论 id，翻楼中楼时作为 `replyId` 传入。
@override final  String id;
/// 所属动态 id。
@override final  String fid;
/// 评论者 uid。
@override final  String uid;
/// 评论者昵称。
@override final  String username;
/// 被回复者 uid，顶层评论为空。
@override final  String ruid;
/// 被回复者昵称，顶层评论为空。
@override final  String rusername;
/// 评论正文，DTO 已去掉 HTML 标签与转义。
@override final  String message;
/// 点赞数。
@override final  int likenum;
/// 该评论的回复总数（含未展开的楼中楼）。
@override final  int replynum;
/// 相对时间文案，如「前天」。
@override final  String datelineText;
/// 是否为动态作者本人的评论。
@override final  bool isFeedAuthor;
/// 评论者头像地址。
@override final  String userAvatar;
/// 已展开的楼中楼，通常只有前几条。
@override final  List<CoolapkFeedReply> replyRows;
/// 楼中楼总数；大于 [replyRows] 长度说明还有没展开的。
@override final  int replyRowsCount;

/// Create a copy of CoolapkFeedReply
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoolapkFeedReplyCopyWith<_CoolapkFeedReply> get copyWith => __$CoolapkFeedReplyCopyWithImpl<_CoolapkFeedReply>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoolapkFeedReply&&(identical(other.id, id) || other.id == id)&&(identical(other.fid, fid) || other.fid == fid)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.username, username) || other.username == username)&&(identical(other.ruid, ruid) || other.ruid == ruid)&&(identical(other.rusername, rusername) || other.rusername == rusername)&&(identical(other.message, message) || other.message == message)&&(identical(other.likenum, likenum) || other.likenum == likenum)&&(identical(other.replynum, replynum) || other.replynum == replynum)&&(identical(other.datelineText, datelineText) || other.datelineText == datelineText)&&(identical(other.isFeedAuthor, isFeedAuthor) || other.isFeedAuthor == isFeedAuthor)&&(identical(other.userAvatar, userAvatar) || other.userAvatar == userAvatar)&&const DeepCollectionEquality().equals(other.replyRows, replyRows)&&(identical(other.replyRowsCount, replyRowsCount) || other.replyRowsCount == replyRowsCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,fid,uid,username,ruid,rusername,message,likenum,replynum,datelineText,isFeedAuthor,userAvatar,const DeepCollectionEquality().hash(replyRows),replyRowsCount);

@override
String toString() {
  return 'CoolapkFeedReply(id: $id, fid: $fid, uid: $uid, username: $username, ruid: $ruid, rusername: $rusername, message: $message, likenum: $likenum, replynum: $replynum, datelineText: $datelineText, isFeedAuthor: $isFeedAuthor, userAvatar: $userAvatar, replyRows: $replyRows, replyRowsCount: $replyRowsCount)';
}


}

/// @nodoc
abstract mixin class _$CoolapkFeedReplyCopyWith<$Res> implements $CoolapkFeedReplyCopyWith<$Res> {
  factory _$CoolapkFeedReplyCopyWith(_CoolapkFeedReply value, $Res Function(_CoolapkFeedReply) _then) = __$CoolapkFeedReplyCopyWithImpl;
@override @useResult
$Res call({
 String id, String fid, String uid, String username, String ruid, String rusername, String message, int likenum, int replynum, String datelineText, bool isFeedAuthor, String userAvatar, List<CoolapkFeedReply> replyRows, int replyRowsCount
});




}
/// @nodoc
class __$CoolapkFeedReplyCopyWithImpl<$Res>
    implements _$CoolapkFeedReplyCopyWith<$Res> {
  __$CoolapkFeedReplyCopyWithImpl(this._self, this._then);

  final _CoolapkFeedReply _self;
  final $Res Function(_CoolapkFeedReply) _then;

/// Create a copy of CoolapkFeedReply
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fid = null,Object? uid = null,Object? username = null,Object? ruid = null,Object? rusername = null,Object? message = null,Object? likenum = null,Object? replynum = null,Object? datelineText = null,Object? isFeedAuthor = null,Object? userAvatar = null,Object? replyRows = null,Object? replyRowsCount = null,}) {
  return _then(_CoolapkFeedReply(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fid: null == fid ? _self.fid : fid // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,ruid: null == ruid ? _self.ruid : ruid // ignore: cast_nullable_to_non_nullable
as String,rusername: null == rusername ? _self.rusername : rusername // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,likenum: null == likenum ? _self.likenum : likenum // ignore: cast_nullable_to_non_nullable
as int,replynum: null == replynum ? _self.replynum : replynum // ignore: cast_nullable_to_non_nullable
as int,datelineText: null == datelineText ? _self.datelineText : datelineText // ignore: cast_nullable_to_non_nullable
as String,isFeedAuthor: null == isFeedAuthor ? _self.isFeedAuthor : isFeedAuthor // ignore: cast_nullable_to_non_nullable
as bool,userAvatar: null == userAvatar ? _self.userAvatar : userAvatar // ignore: cast_nullable_to_non_nullable
as String,replyRows: null == replyRows ? _self.replyRows : replyRows // ignore: cast_nullable_to_non_nullable
as List<CoolapkFeedReply>,replyRowsCount: null == replyRowsCount ? _self.replyRowsCount : replyRowsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
