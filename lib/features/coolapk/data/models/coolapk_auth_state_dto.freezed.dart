// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coolapk_auth_state_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoolapkAuthStateDto {

 String get cookie; String get uid; String get username; String get captchaValidate; int get captchaSavedAt; int get savedAt;
/// Create a copy of CoolapkAuthStateDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoolapkAuthStateDtoCopyWith<CoolapkAuthStateDto> get copyWith => _$CoolapkAuthStateDtoCopyWithImpl<CoolapkAuthStateDto>(this as CoolapkAuthStateDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoolapkAuthStateDto&&(identical(other.cookie, cookie) || other.cookie == cookie)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.username, username) || other.username == username)&&(identical(other.captchaValidate, captchaValidate) || other.captchaValidate == captchaValidate)&&(identical(other.captchaSavedAt, captchaSavedAt) || other.captchaSavedAt == captchaSavedAt)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt));
}


@override
int get hashCode => Object.hash(runtimeType,cookie,uid,username,captchaValidate,captchaSavedAt,savedAt);

@override
String toString() {
  return 'CoolapkAuthStateDto(cookie: $cookie, uid: $uid, username: $username, captchaValidate: $captchaValidate, captchaSavedAt: $captchaSavedAt, savedAt: $savedAt)';
}


}

/// @nodoc
abstract mixin class $CoolapkAuthStateDtoCopyWith<$Res>  {
  factory $CoolapkAuthStateDtoCopyWith(CoolapkAuthStateDto value, $Res Function(CoolapkAuthStateDto) _then) = _$CoolapkAuthStateDtoCopyWithImpl;
@useResult
$Res call({
 String cookie, String uid, String username, String captchaValidate, int captchaSavedAt, int savedAt
});




}
/// @nodoc
class _$CoolapkAuthStateDtoCopyWithImpl<$Res>
    implements $CoolapkAuthStateDtoCopyWith<$Res> {
  _$CoolapkAuthStateDtoCopyWithImpl(this._self, this._then);

  final CoolapkAuthStateDto _self;
  final $Res Function(CoolapkAuthStateDto) _then;

/// Create a copy of CoolapkAuthStateDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cookie = null,Object? uid = null,Object? username = null,Object? captchaValidate = null,Object? captchaSavedAt = null,Object? savedAt = null,}) {
  return _then(_self.copyWith(
cookie: null == cookie ? _self.cookie : cookie // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,captchaValidate: null == captchaValidate ? _self.captchaValidate : captchaValidate // ignore: cast_nullable_to_non_nullable
as String,captchaSavedAt: null == captchaSavedAt ? _self.captchaSavedAt : captchaSavedAt // ignore: cast_nullable_to_non_nullable
as int,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CoolapkAuthStateDto].
extension CoolapkAuthStateDtoPatterns on CoolapkAuthStateDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoolapkAuthStateDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoolapkAuthStateDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoolapkAuthStateDto value)  $default,){
final _that = this;
switch (_that) {
case _CoolapkAuthStateDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoolapkAuthStateDto value)?  $default,){
final _that = this;
switch (_that) {
case _CoolapkAuthStateDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String cookie,  String uid,  String username,  String captchaValidate,  int captchaSavedAt,  int savedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoolapkAuthStateDto() when $default != null:
return $default(_that.cookie,_that.uid,_that.username,_that.captchaValidate,_that.captchaSavedAt,_that.savedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String cookie,  String uid,  String username,  String captchaValidate,  int captchaSavedAt,  int savedAt)  $default,) {final _that = this;
switch (_that) {
case _CoolapkAuthStateDto():
return $default(_that.cookie,_that.uid,_that.username,_that.captchaValidate,_that.captchaSavedAt,_that.savedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String cookie,  String uid,  String username,  String captchaValidate,  int captchaSavedAt,  int savedAt)?  $default,) {final _that = this;
switch (_that) {
case _CoolapkAuthStateDto() when $default != null:
return $default(_that.cookie,_that.uid,_that.username,_that.captchaValidate,_that.captchaSavedAt,_that.savedAt);case _:
  return null;

}
}

}

/// @nodoc


class _CoolapkAuthStateDto extends CoolapkAuthStateDto {
  const _CoolapkAuthStateDto({this.cookie = '', this.uid = '', this.username = '', this.captchaValidate = '', this.captchaSavedAt = 0, this.savedAt = 0}): super._();
  

@override@JsonKey() final  String cookie;
@override@JsonKey() final  String uid;
@override@JsonKey() final  String username;
@override@JsonKey() final  String captchaValidate;
@override@JsonKey() final  int captchaSavedAt;
@override@JsonKey() final  int savedAt;

/// Create a copy of CoolapkAuthStateDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoolapkAuthStateDtoCopyWith<_CoolapkAuthStateDto> get copyWith => __$CoolapkAuthStateDtoCopyWithImpl<_CoolapkAuthStateDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoolapkAuthStateDto&&(identical(other.cookie, cookie) || other.cookie == cookie)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.username, username) || other.username == username)&&(identical(other.captchaValidate, captchaValidate) || other.captchaValidate == captchaValidate)&&(identical(other.captchaSavedAt, captchaSavedAt) || other.captchaSavedAt == captchaSavedAt)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt));
}


@override
int get hashCode => Object.hash(runtimeType,cookie,uid,username,captchaValidate,captchaSavedAt,savedAt);

@override
String toString() {
  return 'CoolapkAuthStateDto(cookie: $cookie, uid: $uid, username: $username, captchaValidate: $captchaValidate, captchaSavedAt: $captchaSavedAt, savedAt: $savedAt)';
}


}

/// @nodoc
abstract mixin class _$CoolapkAuthStateDtoCopyWith<$Res> implements $CoolapkAuthStateDtoCopyWith<$Res> {
  factory _$CoolapkAuthStateDtoCopyWith(_CoolapkAuthStateDto value, $Res Function(_CoolapkAuthStateDto) _then) = __$CoolapkAuthStateDtoCopyWithImpl;
@override @useResult
$Res call({
 String cookie, String uid, String username, String captchaValidate, int captchaSavedAt, int savedAt
});




}
/// @nodoc
class __$CoolapkAuthStateDtoCopyWithImpl<$Res>
    implements _$CoolapkAuthStateDtoCopyWith<$Res> {
  __$CoolapkAuthStateDtoCopyWithImpl(this._self, this._then);

  final _CoolapkAuthStateDto _self;
  final $Res Function(_CoolapkAuthStateDto) _then;

/// Create a copy of CoolapkAuthStateDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cookie = null,Object? uid = null,Object? username = null,Object? captchaValidate = null,Object? captchaSavedAt = null,Object? savedAt = null,}) {
  return _then(_CoolapkAuthStateDto(
cookie: null == cookie ? _self.cookie : cookie // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,captchaValidate: null == captchaValidate ? _self.captchaValidate : captchaValidate // ignore: cast_nullable_to_non_nullable
as String,captchaSavedAt: null == captchaSavedAt ? _self.captchaSavedAt : captchaSavedAt // ignore: cast_nullable_to_non_nullable
as int,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
