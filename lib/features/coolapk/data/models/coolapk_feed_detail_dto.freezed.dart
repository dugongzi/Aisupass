// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coolapk_feed_detail_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoolapkFeedDetailDto {

@JsonKey(fromJson: stringFromJson) String get id; String get title;@JsonKey(fromJson: plainTextFromJson) String get message; String get username;@JsonKey(fromJson: stringFromJson) String get uid;@JsonKey(fromJson: intFromJson) int get likenum;@JsonKey(fromJson: intFromJson) int get replynum;@JsonKey(name: 'dateline_text') String get datelineText;@JsonKey(name: 'device_title') String get deviceTitle;@JsonKey(fromJson: hashTagsFromJson) String get tags;@JsonKey(fromJson: stringListFromJson) List<String> get picArr; String get shareUrl;
/// Create a copy of CoolapkFeedDetailDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoolapkFeedDetailDtoCopyWith<CoolapkFeedDetailDto> get copyWith => _$CoolapkFeedDetailDtoCopyWithImpl<CoolapkFeedDetailDto>(this as CoolapkFeedDetailDto, _$identity);

  /// Serializes this CoolapkFeedDetailDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoolapkFeedDetailDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.username, username) || other.username == username)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.likenum, likenum) || other.likenum == likenum)&&(identical(other.replynum, replynum) || other.replynum == replynum)&&(identical(other.datelineText, datelineText) || other.datelineText == datelineText)&&(identical(other.deviceTitle, deviceTitle) || other.deviceTitle == deviceTitle)&&(identical(other.tags, tags) || other.tags == tags)&&const DeepCollectionEquality().equals(other.picArr, picArr)&&(identical(other.shareUrl, shareUrl) || other.shareUrl == shareUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,message,username,uid,likenum,replynum,datelineText,deviceTitle,tags,const DeepCollectionEquality().hash(picArr),shareUrl);

@override
String toString() {
  return 'CoolapkFeedDetailDto(id: $id, title: $title, message: $message, username: $username, uid: $uid, likenum: $likenum, replynum: $replynum, datelineText: $datelineText, deviceTitle: $deviceTitle, tags: $tags, picArr: $picArr, shareUrl: $shareUrl)';
}


}

/// @nodoc
abstract mixin class $CoolapkFeedDetailDtoCopyWith<$Res>  {
  factory $CoolapkFeedDetailDtoCopyWith(CoolapkFeedDetailDto value, $Res Function(CoolapkFeedDetailDto) _then) = _$CoolapkFeedDetailDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: stringFromJson) String id, String title,@JsonKey(fromJson: plainTextFromJson) String message, String username,@JsonKey(fromJson: stringFromJson) String uid,@JsonKey(fromJson: intFromJson) int likenum,@JsonKey(fromJson: intFromJson) int replynum,@JsonKey(name: 'dateline_text') String datelineText,@JsonKey(name: 'device_title') String deviceTitle,@JsonKey(fromJson: hashTagsFromJson) String tags,@JsonKey(fromJson: stringListFromJson) List<String> picArr, String shareUrl
});




}
/// @nodoc
class _$CoolapkFeedDetailDtoCopyWithImpl<$Res>
    implements $CoolapkFeedDetailDtoCopyWith<$Res> {
  _$CoolapkFeedDetailDtoCopyWithImpl(this._self, this._then);

  final CoolapkFeedDetailDto _self;
  final $Res Function(CoolapkFeedDetailDto) _then;

/// Create a copy of CoolapkFeedDetailDto
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


/// Adds pattern-matching-related methods to [CoolapkFeedDetailDto].
extension CoolapkFeedDetailDtoPatterns on CoolapkFeedDetailDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoolapkFeedDetailDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoolapkFeedDetailDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoolapkFeedDetailDto value)  $default,){
final _that = this;
switch (_that) {
case _CoolapkFeedDetailDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoolapkFeedDetailDto value)?  $default,){
final _that = this;
switch (_that) {
case _CoolapkFeedDetailDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringFromJson)  String id,  String title, @JsonKey(fromJson: plainTextFromJson)  String message,  String username, @JsonKey(fromJson: stringFromJson)  String uid, @JsonKey(fromJson: intFromJson)  int likenum, @JsonKey(fromJson: intFromJson)  int replynum, @JsonKey(name: 'dateline_text')  String datelineText, @JsonKey(name: 'device_title')  String deviceTitle, @JsonKey(fromJson: hashTagsFromJson)  String tags, @JsonKey(fromJson: stringListFromJson)  List<String> picArr,  String shareUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoolapkFeedDetailDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringFromJson)  String id,  String title, @JsonKey(fromJson: plainTextFromJson)  String message,  String username, @JsonKey(fromJson: stringFromJson)  String uid, @JsonKey(fromJson: intFromJson)  int likenum, @JsonKey(fromJson: intFromJson)  int replynum, @JsonKey(name: 'dateline_text')  String datelineText, @JsonKey(name: 'device_title')  String deviceTitle, @JsonKey(fromJson: hashTagsFromJson)  String tags, @JsonKey(fromJson: stringListFromJson)  List<String> picArr,  String shareUrl)  $default,) {final _that = this;
switch (_that) {
case _CoolapkFeedDetailDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: stringFromJson)  String id,  String title, @JsonKey(fromJson: plainTextFromJson)  String message,  String username, @JsonKey(fromJson: stringFromJson)  String uid, @JsonKey(fromJson: intFromJson)  int likenum, @JsonKey(fromJson: intFromJson)  int replynum, @JsonKey(name: 'dateline_text')  String datelineText, @JsonKey(name: 'device_title')  String deviceTitle, @JsonKey(fromJson: hashTagsFromJson)  String tags, @JsonKey(fromJson: stringListFromJson)  List<String> picArr,  String shareUrl)?  $default,) {final _that = this;
switch (_that) {
case _CoolapkFeedDetailDto() when $default != null:
return $default(_that.id,_that.title,_that.message,_that.username,_that.uid,_that.likenum,_that.replynum,_that.datelineText,_that.deviceTitle,_that.tags,_that.picArr,_that.shareUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CoolapkFeedDetailDto extends CoolapkFeedDetailDto {
  const _CoolapkFeedDetailDto({@JsonKey(fromJson: stringFromJson) this.id = '', this.title = '', @JsonKey(fromJson: plainTextFromJson) this.message = '', this.username = '', @JsonKey(fromJson: stringFromJson) this.uid = '', @JsonKey(fromJson: intFromJson) this.likenum = 0, @JsonKey(fromJson: intFromJson) this.replynum = 0, @JsonKey(name: 'dateline_text') this.datelineText = '', @JsonKey(name: 'device_title') this.deviceTitle = '', @JsonKey(fromJson: hashTagsFromJson) this.tags = '', @JsonKey(fromJson: stringListFromJson) this.picArr = const <String>[], this.shareUrl = ''}): super._();
  factory _CoolapkFeedDetailDto.fromJson(Map<String, dynamic> json) => _$CoolapkFeedDetailDtoFromJson(json);

@override@JsonKey(fromJson: stringFromJson) final  String id;
@override@JsonKey() final  String title;
@override@JsonKey(fromJson: plainTextFromJson) final  String message;
@override@JsonKey() final  String username;
@override@JsonKey(fromJson: stringFromJson) final  String uid;
@override@JsonKey(fromJson: intFromJson) final  int likenum;
@override@JsonKey(fromJson: intFromJson) final  int replynum;
@override@JsonKey(name: 'dateline_text') final  String datelineText;
@override@JsonKey(name: 'device_title') final  String deviceTitle;
@override@JsonKey(fromJson: hashTagsFromJson) final  String tags;
@override@JsonKey(fromJson: stringListFromJson) final  List<String> picArr;
@override@JsonKey() final  String shareUrl;

/// Create a copy of CoolapkFeedDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoolapkFeedDetailDtoCopyWith<_CoolapkFeedDetailDto> get copyWith => __$CoolapkFeedDetailDtoCopyWithImpl<_CoolapkFeedDetailDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoolapkFeedDetailDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoolapkFeedDetailDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.username, username) || other.username == username)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.likenum, likenum) || other.likenum == likenum)&&(identical(other.replynum, replynum) || other.replynum == replynum)&&(identical(other.datelineText, datelineText) || other.datelineText == datelineText)&&(identical(other.deviceTitle, deviceTitle) || other.deviceTitle == deviceTitle)&&(identical(other.tags, tags) || other.tags == tags)&&const DeepCollectionEquality().equals(other.picArr, picArr)&&(identical(other.shareUrl, shareUrl) || other.shareUrl == shareUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,message,username,uid,likenum,replynum,datelineText,deviceTitle,tags,const DeepCollectionEquality().hash(picArr),shareUrl);

@override
String toString() {
  return 'CoolapkFeedDetailDto(id: $id, title: $title, message: $message, username: $username, uid: $uid, likenum: $likenum, replynum: $replynum, datelineText: $datelineText, deviceTitle: $deviceTitle, tags: $tags, picArr: $picArr, shareUrl: $shareUrl)';
}


}

/// @nodoc
abstract mixin class _$CoolapkFeedDetailDtoCopyWith<$Res> implements $CoolapkFeedDetailDtoCopyWith<$Res> {
  factory _$CoolapkFeedDetailDtoCopyWith(_CoolapkFeedDetailDto value, $Res Function(_CoolapkFeedDetailDto) _then) = __$CoolapkFeedDetailDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: stringFromJson) String id, String title,@JsonKey(fromJson: plainTextFromJson) String message, String username,@JsonKey(fromJson: stringFromJson) String uid,@JsonKey(fromJson: intFromJson) int likenum,@JsonKey(fromJson: intFromJson) int replynum,@JsonKey(name: 'dateline_text') String datelineText,@JsonKey(name: 'device_title') String deviceTitle,@JsonKey(fromJson: hashTagsFromJson) String tags,@JsonKey(fromJson: stringListFromJson) List<String> picArr, String shareUrl
});




}
/// @nodoc
class __$CoolapkFeedDetailDtoCopyWithImpl<$Res>
    implements _$CoolapkFeedDetailDtoCopyWith<$Res> {
  __$CoolapkFeedDetailDtoCopyWithImpl(this._self, this._then);

  final _CoolapkFeedDetailDto _self;
  final $Res Function(_CoolapkFeedDetailDto) _then;

/// Create a copy of CoolapkFeedDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? message = null,Object? username = null,Object? uid = null,Object? likenum = null,Object? replynum = null,Object? datelineText = null,Object? deviceTitle = null,Object? tags = null,Object? picArr = null,Object? shareUrl = null,}) {
  return _then(_CoolapkFeedDetailDto(
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
