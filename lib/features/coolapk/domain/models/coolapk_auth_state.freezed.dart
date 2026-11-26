// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coolapk_auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoolapkAuthState {

/// 登录后完整的 Cookie 串，形如 `SESSID=abc; uid=123`。
 String get cookie;/// 账号 id，由 `/v6/user/profile` 确认；空串即未登录。
 String get uid;/// 昵称。
 String get username;/// 易盾验证码的 `validate` 票据，随 Cookie 一起发给服务端。
///
/// 风控拦下 `/v6/feed/detail` 时，过完验证拿到票据写在这里；
/// 空串表示还没过验证。
 String get captchaValidate;/// 票据保存时间（毫秒时间戳）。
///
/// 验证卡片用它判断「用户是这次才过的验证」：只有保存时间晚于卡片
/// 出现的时刻才算完成，避免把上一次遗留的票据当成刚验证过。
 int get captchaSavedAt;/// 抓取时间（毫秒时间戳），仅用于展示登录时刻。
 int get savedAt;
/// Create a copy of CoolapkAuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoolapkAuthStateCopyWith<CoolapkAuthState> get copyWith => _$CoolapkAuthStateCopyWithImpl<CoolapkAuthState>(this as CoolapkAuthState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoolapkAuthState&&(identical(other.cookie, cookie) || other.cookie == cookie)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.username, username) || other.username == username)&&(identical(other.captchaValidate, captchaValidate) || other.captchaValidate == captchaValidate)&&(identical(other.captchaSavedAt, captchaSavedAt) || other.captchaSavedAt == captchaSavedAt)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt));
}


@override
int get hashCode => Object.hash(runtimeType,cookie,uid,username,captchaValidate,captchaSavedAt,savedAt);

@override
String toString() {
  return 'CoolapkAuthState(cookie: $cookie, uid: $uid, username: $username, captchaValidate: $captchaValidate, captchaSavedAt: $captchaSavedAt, savedAt: $savedAt)';
}


}

/// @nodoc
abstract mixin class $CoolapkAuthStateCopyWith<$Res>  {
  factory $CoolapkAuthStateCopyWith(CoolapkAuthState value, $Res Function(CoolapkAuthState) _then) = _$CoolapkAuthStateCopyWithImpl;
@useResult
$Res call({
 String cookie, String uid, String username, String captchaValidate, int captchaSavedAt, int savedAt
});




}
/// @nodoc
class _$CoolapkAuthStateCopyWithImpl<$Res>
    implements $CoolapkAuthStateCopyWith<$Res> {
  _$CoolapkAuthStateCopyWithImpl(this._self, this._then);

  final CoolapkAuthState _self;
  final $Res Function(CoolapkAuthState) _then;

/// Create a copy of CoolapkAuthState
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


/// Adds pattern-matching-related methods to [CoolapkAuthState].
extension CoolapkAuthStatePatterns on CoolapkAuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoolapkAuthState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoolapkAuthState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoolapkAuthState value)  $default,){
final _that = this;
switch (_that) {
case _CoolapkAuthState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoolapkAuthState value)?  $default,){
final _that = this;
switch (_that) {
case _CoolapkAuthState() when $default != null:
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
case _CoolapkAuthState() when $default != null:
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
case _CoolapkAuthState():
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
case _CoolapkAuthState() when $default != null:
return $default(_that.cookie,_that.uid,_that.username,_that.captchaValidate,_that.captchaSavedAt,_that.savedAt);case _:
  return null;

}
}

}

/// @nodoc


class _CoolapkAuthState extends CoolapkAuthState {
  const _CoolapkAuthState({required this.cookie, required this.uid, required this.username, required this.captchaValidate, required this.captchaSavedAt, required this.savedAt}): super._();
  

/// 登录后完整的 Cookie 串，形如 `SESSID=abc; uid=123`。
@override final  String cookie;
/// 账号 id，由 `/v6/user/profile` 确认；空串即未登录。
@override final  String uid;
/// 昵称。
@override final  String username;
/// 易盾验证码的 `validate` 票据，随 Cookie 一起发给服务端。
///
/// 风控拦下 `/v6/feed/detail` 时，过完验证拿到票据写在这里；
/// 空串表示还没过验证。
@override final  String captchaValidate;
/// 票据保存时间（毫秒时间戳）。
///
/// 验证卡片用它判断「用户是这次才过的验证」：只有保存时间晚于卡片
/// 出现的时刻才算完成，避免把上一次遗留的票据当成刚验证过。
@override final  int captchaSavedAt;
/// 抓取时间（毫秒时间戳），仅用于展示登录时刻。
@override final  int savedAt;

/// Create a copy of CoolapkAuthState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoolapkAuthStateCopyWith<_CoolapkAuthState> get copyWith => __$CoolapkAuthStateCopyWithImpl<_CoolapkAuthState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoolapkAuthState&&(identical(other.cookie, cookie) || other.cookie == cookie)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.username, username) || other.username == username)&&(identical(other.captchaValidate, captchaValidate) || other.captchaValidate == captchaValidate)&&(identical(other.captchaSavedAt, captchaSavedAt) || other.captchaSavedAt == captchaSavedAt)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt));
}


@override
int get hashCode => Object.hash(runtimeType,cookie,uid,username,captchaValidate,captchaSavedAt,savedAt);

@override
String toString() {
  return 'CoolapkAuthState(cookie: $cookie, uid: $uid, username: $username, captchaValidate: $captchaValidate, captchaSavedAt: $captchaSavedAt, savedAt: $savedAt)';
}


}

/// @nodoc
abstract mixin class _$CoolapkAuthStateCopyWith<$Res> implements $CoolapkAuthStateCopyWith<$Res> {
  factory _$CoolapkAuthStateCopyWith(_CoolapkAuthState value, $Res Function(_CoolapkAuthState) _then) = __$CoolapkAuthStateCopyWithImpl;
@override @useResult
$Res call({
 String cookie, String uid, String username, String captchaValidate, int captchaSavedAt, int savedAt
});




}
/// @nodoc
class __$CoolapkAuthStateCopyWithImpl<$Res>
    implements _$CoolapkAuthStateCopyWith<$Res> {
  __$CoolapkAuthStateCopyWithImpl(this._self, this._then);

  final _CoolapkAuthState _self;
  final $Res Function(_CoolapkAuthState) _then;

/// Create a copy of CoolapkAuthState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cookie = null,Object? uid = null,Object? username = null,Object? captchaValidate = null,Object? captchaSavedAt = null,Object? savedAt = null,}) {
  return _then(_CoolapkAuthState(
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
