// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coolapk_feed_reply_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoolapkFeedReplyDto {

@JsonKey(fromJson: stringFromJson) String get id;@JsonKey(fromJson: stringFromJson) String get fid;@JsonKey(fromJson: stringFromJson) String get uid; String get username;@JsonKey(fromJson: stringFromJson) String get ruid; String get rusername;@JsonKey(fromJson: plainTextFromJson) String get message;@JsonKey(fromJson: intFromJson) int get likenum;@JsonKey(fromJson: intFromJson) int get replynum;@JsonKey(name: 'dateline_text') String get datelineText;@JsonKey(fromJson: boolFromJson) bool get isFeedAuthor; String get userAvatar; List<CoolapkFeedReplyDto> get replyRows;@JsonKey(fromJson: intFromJson) int get replyRowsCount;
/// Create a copy of CoolapkFeedReplyDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoolapkFeedReplyDtoCopyWith<CoolapkFeedReplyDto> get copyWith => _$CoolapkFeedReplyDtoCopyWithImpl<CoolapkFeedReplyDto>(this as CoolapkFeedReplyDto, _$identity);

  /// Serializes this CoolapkFeedReplyDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoolapkFeedReplyDto&&(identical(other.id, id) || other.id == id)&&(identical(other.fid, fid) || other.fid == fid)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.username, username) || other.username == username)&&(identical(other.ruid, ruid) || other.ruid == ruid)&&(identical(other.rusername, rusername) || other.rusername == rusername)&&(identical(other.message, message) || other.message == message)&&(identical(other.likenum, likenum) || other.likenum == likenum)&&(identical(other.replynum, replynum) || other.replynum == replynum)&&(identical(other.datelineText, datelineText) || other.datelineText == datelineText)&&(identical(other.isFeedAuthor, isFeedAuthor) || other.isFeedAuthor == isFeedAuthor)&&(identical(other.userAvatar, userAvatar) || other.userAvatar == userAvatar)&&const DeepCollectionEquality().equals(other.replyRows, replyRows)&&(identical(other.replyRowsCount, replyRowsCount) || other.replyRowsCount == replyRowsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fid,uid,username,ruid,rusername,message,likenum,replynum,datelineText,isFeedAuthor,userAvatar,const DeepCollectionEquality().hash(replyRows),replyRowsCount);

@override
String toString() {
  return 'CoolapkFeedReplyDto(id: $id, fid: $fid, uid: $uid, username: $username, ruid: $ruid, rusername: $rusername, message: $message, likenum: $likenum, replynum: $replynum, datelineText: $datelineText, isFeedAuthor: $isFeedAuthor, userAvatar: $userAvatar, replyRows: $replyRows, replyRowsCount: $replyRowsCount)';
}


}

/// @nodoc
abstract mixin class $CoolapkFeedReplyDtoCopyWith<$Res>  {
  factory $CoolapkFeedReplyDtoCopyWith(CoolapkFeedReplyDto value, $Res Function(CoolapkFeedReplyDto) _then) = _$CoolapkFeedReplyDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: stringFromJson) String id,@JsonKey(fromJson: stringFromJson) String fid,@JsonKey(fromJson: stringFromJson) String uid, String username,@JsonKey(fromJson: stringFromJson) String ruid, String rusername,@JsonKey(fromJson: plainTextFromJson) String message,@JsonKey(fromJson: intFromJson) int likenum,@JsonKey(fromJson: intFromJson) int replynum,@JsonKey(name: 'dateline_text') String datelineText,@JsonKey(fromJson: boolFromJson) bool isFeedAuthor, String userAvatar, List<CoolapkFeedReplyDto> replyRows,@JsonKey(fromJson: intFromJson) int replyRowsCount
});




}
/// @nodoc
class _$CoolapkFeedReplyDtoCopyWithImpl<$Res>
    implements $CoolapkFeedReplyDtoCopyWith<$Res> {
  _$CoolapkFeedReplyDtoCopyWithImpl(this._self, this._then);

  final CoolapkFeedReplyDto _self;
  final $Res Function(CoolapkFeedReplyDto) _then;

/// Create a copy of CoolapkFeedReplyDto
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
as List<CoolapkFeedReplyDto>,replyRowsCount: null == replyRowsCount ? _self.replyRowsCount : replyRowsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CoolapkFeedReplyDto].
extension CoolapkFeedReplyDtoPatterns on CoolapkFeedReplyDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoolapkFeedReplyDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoolapkFeedReplyDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoolapkFeedReplyDto value)  $default,){
final _that = this;
switch (_that) {
case _CoolapkFeedReplyDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoolapkFeedReplyDto value)?  $default,){
final _that = this;
switch (_that) {
case _CoolapkFeedReplyDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringFromJson)  String id, @JsonKey(fromJson: stringFromJson)  String fid, @JsonKey(fromJson: stringFromJson)  String uid,  String username, @JsonKey(fromJson: stringFromJson)  String ruid,  String rusername, @JsonKey(fromJson: plainTextFromJson)  String message, @JsonKey(fromJson: intFromJson)  int likenum, @JsonKey(fromJson: intFromJson)  int replynum, @JsonKey(name: 'dateline_text')  String datelineText, @JsonKey(fromJson: boolFromJson)  bool isFeedAuthor,  String userAvatar,  List<CoolapkFeedReplyDto> replyRows, @JsonKey(fromJson: intFromJson)  int replyRowsCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoolapkFeedReplyDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringFromJson)  String id, @JsonKey(fromJson: stringFromJson)  String fid, @JsonKey(fromJson: stringFromJson)  String uid,  String username, @JsonKey(fromJson: stringFromJson)  String ruid,  String rusername, @JsonKey(fromJson: plainTextFromJson)  String message, @JsonKey(fromJson: intFromJson)  int likenum, @JsonKey(fromJson: intFromJson)  int replynum, @JsonKey(name: 'dateline_text')  String datelineText, @JsonKey(fromJson: boolFromJson)  bool isFeedAuthor,  String userAvatar,  List<CoolapkFeedReplyDto> replyRows, @JsonKey(fromJson: intFromJson)  int replyRowsCount)  $default,) {final _that = this;
switch (_that) {
case _CoolapkFeedReplyDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: stringFromJson)  String id, @JsonKey(fromJson: stringFromJson)  String fid, @JsonKey(fromJson: stringFromJson)  String uid,  String username, @JsonKey(fromJson: stringFromJson)  String ruid,  String rusername, @JsonKey(fromJson: plainTextFromJson)  String message, @JsonKey(fromJson: intFromJson)  int likenum, @JsonKey(fromJson: intFromJson)  int replynum, @JsonKey(name: 'dateline_text')  String datelineText, @JsonKey(fromJson: boolFromJson)  bool isFeedAuthor,  String userAvatar,  List<CoolapkFeedReplyDto> replyRows, @JsonKey(fromJson: intFromJson)  int replyRowsCount)?  $default,) {final _that = this;
switch (_that) {
case _CoolapkFeedReplyDto() when $default != null:
return $default(_that.id,_that.fid,_that.uid,_that.username,_that.ruid,_that.rusername,_that.message,_that.likenum,_that.replynum,_that.datelineText,_that.isFeedAuthor,_that.userAvatar,_that.replyRows,_that.replyRowsCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CoolapkFeedReplyDto extends CoolapkFeedReplyDto {
  const _CoolapkFeedReplyDto({@JsonKey(fromJson: stringFromJson) this.id = '', @JsonKey(fromJson: stringFromJson) this.fid = '', @JsonKey(fromJson: stringFromJson) this.uid = '', this.username = '', @JsonKey(fromJson: stringFromJson) this.ruid = '', this.rusername = '', @JsonKey(fromJson: plainTextFromJson) this.message = '', @JsonKey(fromJson: intFromJson) this.likenum = 0, @JsonKey(fromJson: intFromJson) this.replynum = 0, @JsonKey(name: 'dateline_text') this.datelineText = '', @JsonKey(fromJson: boolFromJson) this.isFeedAuthor = false, this.userAvatar = '', this.replyRows = const <CoolapkFeedReplyDto>[], @JsonKey(fromJson: intFromJson) this.replyRowsCount = 0}): super._();
  factory _CoolapkFeedReplyDto.fromJson(Map<String, dynamic> json) => _$CoolapkFeedReplyDtoFromJson(json);

@override@JsonKey(fromJson: stringFromJson) final  String id;
@override@JsonKey(fromJson: stringFromJson) final  String fid;
@override@JsonKey(fromJson: stringFromJson) final  String uid;
@override@JsonKey() final  String username;
@override@JsonKey(fromJson: stringFromJson) final  String ruid;
@override@JsonKey() final  String rusername;
@override@JsonKey(fromJson: plainTextFromJson) final  String message;
@override@JsonKey(fromJson: intFromJson) final  int likenum;
@override@JsonKey(fromJson: intFromJson) final  int replynum;
@override@JsonKey(name: 'dateline_text') final  String datelineText;
@override@JsonKey(fromJson: boolFromJson) final  bool isFeedAuthor;
@override@JsonKey() final  String userAvatar;
@override@JsonKey() final  List<CoolapkFeedReplyDto> replyRows;
@override@JsonKey(fromJson: intFromJson) final  int replyRowsCount;

/// Create a copy of CoolapkFeedReplyDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoolapkFeedReplyDtoCopyWith<_CoolapkFeedReplyDto> get copyWith => __$CoolapkFeedReplyDtoCopyWithImpl<_CoolapkFeedReplyDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoolapkFeedReplyDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoolapkFeedReplyDto&&(identical(other.id, id) || other.id == id)&&(identical(other.fid, fid) || other.fid == fid)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.username, username) || other.username == username)&&(identical(other.ruid, ruid) || other.ruid == ruid)&&(identical(other.rusername, rusername) || other.rusername == rusername)&&(identical(other.message, message) || other.message == message)&&(identical(other.likenum, likenum) || other.likenum == likenum)&&(identical(other.replynum, replynum) || other.replynum == replynum)&&(identical(other.datelineText, datelineText) || other.datelineText == datelineText)&&(identical(other.isFeedAuthor, isFeedAuthor) || other.isFeedAuthor == isFeedAuthor)&&(identical(other.userAvatar, userAvatar) || other.userAvatar == userAvatar)&&const DeepCollectionEquality().equals(other.replyRows, replyRows)&&(identical(other.replyRowsCount, replyRowsCount) || other.replyRowsCount == replyRowsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fid,uid,username,ruid,rusername,message,likenum,replynum,datelineText,isFeedAuthor,userAvatar,const DeepCollectionEquality().hash(replyRows),replyRowsCount);

@override
String toString() {
  return 'CoolapkFeedReplyDto(id: $id, fid: $fid, uid: $uid, username: $username, ruid: $ruid, rusername: $rusername, message: $message, likenum: $likenum, replynum: $replynum, datelineText: $datelineText, isFeedAuthor: $isFeedAuthor, userAvatar: $userAvatar, replyRows: $replyRows, replyRowsCount: $replyRowsCount)';
}


}

/// @nodoc
abstract mixin class _$CoolapkFeedReplyDtoCopyWith<$Res> implements $CoolapkFeedReplyDtoCopyWith<$Res> {
  factory _$CoolapkFeedReplyDtoCopyWith(_CoolapkFeedReplyDto value, $Res Function(_CoolapkFeedReplyDto) _then) = __$CoolapkFeedReplyDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: stringFromJson) String id,@JsonKey(fromJson: stringFromJson) String fid,@JsonKey(fromJson: stringFromJson) String uid, String username,@JsonKey(fromJson: stringFromJson) String ruid, String rusername,@JsonKey(fromJson: plainTextFromJson) String message,@JsonKey(fromJson: intFromJson) int likenum,@JsonKey(fromJson: intFromJson) int replynum,@JsonKey(name: 'dateline_text') String datelineText,@JsonKey(fromJson: boolFromJson) bool isFeedAuthor, String userAvatar, List<CoolapkFeedReplyDto> replyRows,@JsonKey(fromJson: intFromJson) int replyRowsCount
});




}
/// @nodoc
class __$CoolapkFeedReplyDtoCopyWithImpl<$Res>
    implements _$CoolapkFeedReplyDtoCopyWith<$Res> {
  __$CoolapkFeedReplyDtoCopyWithImpl(this._self, this._then);

  final _CoolapkFeedReplyDto _self;
  final $Res Function(_CoolapkFeedReplyDto) _then;

/// Create a copy of CoolapkFeedReplyDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fid = null,Object? uid = null,Object? username = null,Object? ruid = null,Object? rusername = null,Object? message = null,Object? likenum = null,Object? replynum = null,Object? datelineText = null,Object? isFeedAuthor = null,Object? userAvatar = null,Object? replyRows = null,Object? replyRowsCount = null,}) {
  return _then(_CoolapkFeedReplyDto(
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
as List<CoolapkFeedReplyDto>,replyRowsCount: null == replyRowsCount ? _self.replyRowsCount : replyRowsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
