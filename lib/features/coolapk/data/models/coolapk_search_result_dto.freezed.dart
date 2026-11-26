// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coolapk_search_result_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoolapkSearchResultDto {

 String get entityType; String get id; String get title;@JsonKey(fromJson: plainTextFromJson) String get message; String get username; String get uid; String get url; String get shareUrl;@JsonKey(fromJson: intFromJson) int get likenum;@JsonKey(fromJson: intFromJson) int get replynum;@JsonKey(name: 'dateline_text') String get datelineText;@JsonKey(name: 'device_title') String get deviceTitle;@JsonKey(fromJson: hashTagsFromJson) String get tags;@JsonKey(fromJson: stringListFromJson) List<String> get picArr;@JsonKey(name: '_queryTotal', fromJson: intFromJson) int get queryTotal;
/// Create a copy of CoolapkSearchResultDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoolapkSearchResultDtoCopyWith<CoolapkSearchResultDto> get copyWith => _$CoolapkSearchResultDtoCopyWithImpl<CoolapkSearchResultDto>(this as CoolapkSearchResultDto, _$identity);

  /// Serializes this CoolapkSearchResultDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoolapkSearchResultDto&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.username, username) || other.username == username)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.url, url) || other.url == url)&&(identical(other.shareUrl, shareUrl) || other.shareUrl == shareUrl)&&(identical(other.likenum, likenum) || other.likenum == likenum)&&(identical(other.replynum, replynum) || other.replynum == replynum)&&(identical(other.datelineText, datelineText) || other.datelineText == datelineText)&&(identical(other.deviceTitle, deviceTitle) || other.deviceTitle == deviceTitle)&&(identical(other.tags, tags) || other.tags == tags)&&const DeepCollectionEquality().equals(other.picArr, picArr)&&(identical(other.queryTotal, queryTotal) || other.queryTotal == queryTotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,entityType,id,title,message,username,uid,url,shareUrl,likenum,replynum,datelineText,deviceTitle,tags,const DeepCollectionEquality().hash(picArr),queryTotal);

@override
String toString() {
  return 'CoolapkSearchResultDto(entityType: $entityType, id: $id, title: $title, message: $message, username: $username, uid: $uid, url: $url, shareUrl: $shareUrl, likenum: $likenum, replynum: $replynum, datelineText: $datelineText, deviceTitle: $deviceTitle, tags: $tags, picArr: $picArr, queryTotal: $queryTotal)';
}


}

/// @nodoc
abstract mixin class $CoolapkSearchResultDtoCopyWith<$Res>  {
  factory $CoolapkSearchResultDtoCopyWith(CoolapkSearchResultDto value, $Res Function(CoolapkSearchResultDto) _then) = _$CoolapkSearchResultDtoCopyWithImpl;
@useResult
$Res call({
 String entityType, String id, String title,@JsonKey(fromJson: plainTextFromJson) String message, String username, String uid, String url, String shareUrl,@JsonKey(fromJson: intFromJson) int likenum,@JsonKey(fromJson: intFromJson) int replynum,@JsonKey(name: 'dateline_text') String datelineText,@JsonKey(name: 'device_title') String deviceTitle,@JsonKey(fromJson: hashTagsFromJson) String tags,@JsonKey(fromJson: stringListFromJson) List<String> picArr,@JsonKey(name: '_queryTotal', fromJson: intFromJson) int queryTotal
});




}
/// @nodoc
class _$CoolapkSearchResultDtoCopyWithImpl<$Res>
    implements $CoolapkSearchResultDtoCopyWith<$Res> {
  _$CoolapkSearchResultDtoCopyWithImpl(this._self, this._then);

  final CoolapkSearchResultDto _self;
  final $Res Function(CoolapkSearchResultDto) _then;

/// Create a copy of CoolapkSearchResultDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entityType = null,Object? id = null,Object? title = null,Object? message = null,Object? username = null,Object? uid = null,Object? url = null,Object? shareUrl = null,Object? likenum = null,Object? replynum = null,Object? datelineText = null,Object? deviceTitle = null,Object? tags = null,Object? picArr = null,Object? queryTotal = null,}) {
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
as List<String>,queryTotal: null == queryTotal ? _self.queryTotal : queryTotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CoolapkSearchResultDto].
extension CoolapkSearchResultDtoPatterns on CoolapkSearchResultDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoolapkSearchResultDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoolapkSearchResultDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoolapkSearchResultDto value)  $default,){
final _that = this;
switch (_that) {
case _CoolapkSearchResultDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoolapkSearchResultDto value)?  $default,){
final _that = this;
switch (_that) {
case _CoolapkSearchResultDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String entityType,  String id,  String title, @JsonKey(fromJson: plainTextFromJson)  String message,  String username,  String uid,  String url,  String shareUrl, @JsonKey(fromJson: intFromJson)  int likenum, @JsonKey(fromJson: intFromJson)  int replynum, @JsonKey(name: 'dateline_text')  String datelineText, @JsonKey(name: 'device_title')  String deviceTitle, @JsonKey(fromJson: hashTagsFromJson)  String tags, @JsonKey(fromJson: stringListFromJson)  List<String> picArr, @JsonKey(name: '_queryTotal', fromJson: intFromJson)  int queryTotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoolapkSearchResultDto() when $default != null:
return $default(_that.entityType,_that.id,_that.title,_that.message,_that.username,_that.uid,_that.url,_that.shareUrl,_that.likenum,_that.replynum,_that.datelineText,_that.deviceTitle,_that.tags,_that.picArr,_that.queryTotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String entityType,  String id,  String title, @JsonKey(fromJson: plainTextFromJson)  String message,  String username,  String uid,  String url,  String shareUrl, @JsonKey(fromJson: intFromJson)  int likenum, @JsonKey(fromJson: intFromJson)  int replynum, @JsonKey(name: 'dateline_text')  String datelineText, @JsonKey(name: 'device_title')  String deviceTitle, @JsonKey(fromJson: hashTagsFromJson)  String tags, @JsonKey(fromJson: stringListFromJson)  List<String> picArr, @JsonKey(name: '_queryTotal', fromJson: intFromJson)  int queryTotal)  $default,) {final _that = this;
switch (_that) {
case _CoolapkSearchResultDto():
return $default(_that.entityType,_that.id,_that.title,_that.message,_that.username,_that.uid,_that.url,_that.shareUrl,_that.likenum,_that.replynum,_that.datelineText,_that.deviceTitle,_that.tags,_that.picArr,_that.queryTotal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String entityType,  String id,  String title, @JsonKey(fromJson: plainTextFromJson)  String message,  String username,  String uid,  String url,  String shareUrl, @JsonKey(fromJson: intFromJson)  int likenum, @JsonKey(fromJson: intFromJson)  int replynum, @JsonKey(name: 'dateline_text')  String datelineText, @JsonKey(name: 'device_title')  String deviceTitle, @JsonKey(fromJson: hashTagsFromJson)  String tags, @JsonKey(fromJson: stringListFromJson)  List<String> picArr, @JsonKey(name: '_queryTotal', fromJson: intFromJson)  int queryTotal)?  $default,) {final _that = this;
switch (_that) {
case _CoolapkSearchResultDto() when $default != null:
return $default(_that.entityType,_that.id,_that.title,_that.message,_that.username,_that.uid,_that.url,_that.shareUrl,_that.likenum,_that.replynum,_that.datelineText,_that.deviceTitle,_that.tags,_that.picArr,_that.queryTotal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CoolapkSearchResultDto extends CoolapkSearchResultDto {
  const _CoolapkSearchResultDto({this.entityType = '', this.id = '', this.title = '', @JsonKey(fromJson: plainTextFromJson) this.message = '', this.username = '', this.uid = '', this.url = '', this.shareUrl = '', @JsonKey(fromJson: intFromJson) this.likenum = 0, @JsonKey(fromJson: intFromJson) this.replynum = 0, @JsonKey(name: 'dateline_text') this.datelineText = '', @JsonKey(name: 'device_title') this.deviceTitle = '', @JsonKey(fromJson: hashTagsFromJson) this.tags = '', @JsonKey(fromJson: stringListFromJson) this.picArr = const <String>[], @JsonKey(name: '_queryTotal', fromJson: intFromJson) this.queryTotal = 0}): super._();
  factory _CoolapkSearchResultDto.fromJson(Map<String, dynamic> json) => _$CoolapkSearchResultDtoFromJson(json);

@override@JsonKey() final  String entityType;
@override@JsonKey() final  String id;
@override@JsonKey() final  String title;
@override@JsonKey(fromJson: plainTextFromJson) final  String message;
@override@JsonKey() final  String username;
@override@JsonKey() final  String uid;
@override@JsonKey() final  String url;
@override@JsonKey() final  String shareUrl;
@override@JsonKey(fromJson: intFromJson) final  int likenum;
@override@JsonKey(fromJson: intFromJson) final  int replynum;
@override@JsonKey(name: 'dateline_text') final  String datelineText;
@override@JsonKey(name: 'device_title') final  String deviceTitle;
@override@JsonKey(fromJson: hashTagsFromJson) final  String tags;
@override@JsonKey(fromJson: stringListFromJson) final  List<String> picArr;
@override@JsonKey(name: '_queryTotal', fromJson: intFromJson) final  int queryTotal;

/// Create a copy of CoolapkSearchResultDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoolapkSearchResultDtoCopyWith<_CoolapkSearchResultDto> get copyWith => __$CoolapkSearchResultDtoCopyWithImpl<_CoolapkSearchResultDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoolapkSearchResultDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoolapkSearchResultDto&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.username, username) || other.username == username)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.url, url) || other.url == url)&&(identical(other.shareUrl, shareUrl) || other.shareUrl == shareUrl)&&(identical(other.likenum, likenum) || other.likenum == likenum)&&(identical(other.replynum, replynum) || other.replynum == replynum)&&(identical(other.datelineText, datelineText) || other.datelineText == datelineText)&&(identical(other.deviceTitle, deviceTitle) || other.deviceTitle == deviceTitle)&&(identical(other.tags, tags) || other.tags == tags)&&const DeepCollectionEquality().equals(other.picArr, picArr)&&(identical(other.queryTotal, queryTotal) || other.queryTotal == queryTotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,entityType,id,title,message,username,uid,url,shareUrl,likenum,replynum,datelineText,deviceTitle,tags,const DeepCollectionEquality().hash(picArr),queryTotal);

@override
String toString() {
  return 'CoolapkSearchResultDto(entityType: $entityType, id: $id, title: $title, message: $message, username: $username, uid: $uid, url: $url, shareUrl: $shareUrl, likenum: $likenum, replynum: $replynum, datelineText: $datelineText, deviceTitle: $deviceTitle, tags: $tags, picArr: $picArr, queryTotal: $queryTotal)';
}


}

/// @nodoc
abstract mixin class _$CoolapkSearchResultDtoCopyWith<$Res> implements $CoolapkSearchResultDtoCopyWith<$Res> {
  factory _$CoolapkSearchResultDtoCopyWith(_CoolapkSearchResultDto value, $Res Function(_CoolapkSearchResultDto) _then) = __$CoolapkSearchResultDtoCopyWithImpl;
@override @useResult
$Res call({
 String entityType, String id, String title,@JsonKey(fromJson: plainTextFromJson) String message, String username, String uid, String url, String shareUrl,@JsonKey(fromJson: intFromJson) int likenum,@JsonKey(fromJson: intFromJson) int replynum,@JsonKey(name: 'dateline_text') String datelineText,@JsonKey(name: 'device_title') String deviceTitle,@JsonKey(fromJson: hashTagsFromJson) String tags,@JsonKey(fromJson: stringListFromJson) List<String> picArr,@JsonKey(name: '_queryTotal', fromJson: intFromJson) int queryTotal
});




}
/// @nodoc
class __$CoolapkSearchResultDtoCopyWithImpl<$Res>
    implements _$CoolapkSearchResultDtoCopyWith<$Res> {
  __$CoolapkSearchResultDtoCopyWithImpl(this._self, this._then);

  final _CoolapkSearchResultDto _self;
  final $Res Function(_CoolapkSearchResultDto) _then;

/// Create a copy of CoolapkSearchResultDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entityType = null,Object? id = null,Object? title = null,Object? message = null,Object? username = null,Object? uid = null,Object? url = null,Object? shareUrl = null,Object? likenum = null,Object? replynum = null,Object? datelineText = null,Object? deviceTitle = null,Object? tags = null,Object? picArr = null,Object? queryTotal = null,}) {
  return _then(_CoolapkSearchResultDto(
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
as List<String>,queryTotal: null == queryTotal ? _self.queryTotal : queryTotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
