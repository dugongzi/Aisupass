// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coolapk_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoolapkAccount {

/// 账号 id，空串即未取到。
 String get uid;/// 昵称。
 String get username;/// 头像地址，可能为空。
 String get userAvatar;
/// Create a copy of CoolapkAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoolapkAccountCopyWith<CoolapkAccount> get copyWith => _$CoolapkAccountCopyWithImpl<CoolapkAccount>(this as CoolapkAccount, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoolapkAccount&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.username, username) || other.username == username)&&(identical(other.userAvatar, userAvatar) || other.userAvatar == userAvatar));
}


@override
int get hashCode => Object.hash(runtimeType,uid,username,userAvatar);

@override
String toString() {
  return 'CoolapkAccount(uid: $uid, username: $username, userAvatar: $userAvatar)';
}


}

/// @nodoc
abstract mixin class $CoolapkAccountCopyWith<$Res>  {
  factory $CoolapkAccountCopyWith(CoolapkAccount value, $Res Function(CoolapkAccount) _then) = _$CoolapkAccountCopyWithImpl;
@useResult
$Res call({
 String uid, String username, String userAvatar
});




}
/// @nodoc
class _$CoolapkAccountCopyWithImpl<$Res>
    implements $CoolapkAccountCopyWith<$Res> {
  _$CoolapkAccountCopyWithImpl(this._self, this._then);

  final CoolapkAccount _self;
  final $Res Function(CoolapkAccount) _then;

/// Create a copy of CoolapkAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? username = null,Object? userAvatar = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,userAvatar: null == userAvatar ? _self.userAvatar : userAvatar // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CoolapkAccount].
extension CoolapkAccountPatterns on CoolapkAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoolapkAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoolapkAccount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoolapkAccount value)  $default,){
final _that = this;
switch (_that) {
case _CoolapkAccount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoolapkAccount value)?  $default,){
final _that = this;
switch (_that) {
case _CoolapkAccount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String username,  String userAvatar)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoolapkAccount() when $default != null:
return $default(_that.uid,_that.username,_that.userAvatar);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String username,  String userAvatar)  $default,) {final _that = this;
switch (_that) {
case _CoolapkAccount():
return $default(_that.uid,_that.username,_that.userAvatar);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String username,  String userAvatar)?  $default,) {final _that = this;
switch (_that) {
case _CoolapkAccount() when $default != null:
return $default(_that.uid,_that.username,_that.userAvatar);case _:
  return null;

}
}

}

/// @nodoc


class _CoolapkAccount extends CoolapkAccount {
  const _CoolapkAccount({required this.uid, required this.username, required this.userAvatar}): super._();
  

/// 账号 id，空串即未取到。
@override final  String uid;
/// 昵称。
@override final  String username;
/// 头像地址，可能为空。
@override final  String userAvatar;

/// Create a copy of CoolapkAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoolapkAccountCopyWith<_CoolapkAccount> get copyWith => __$CoolapkAccountCopyWithImpl<_CoolapkAccount>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoolapkAccount&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.username, username) || other.username == username)&&(identical(other.userAvatar, userAvatar) || other.userAvatar == userAvatar));
}


@override
int get hashCode => Object.hash(runtimeType,uid,username,userAvatar);

@override
String toString() {
  return 'CoolapkAccount(uid: $uid, username: $username, userAvatar: $userAvatar)';
}


}

/// @nodoc
abstract mixin class _$CoolapkAccountCopyWith<$Res> implements $CoolapkAccountCopyWith<$Res> {
  factory _$CoolapkAccountCopyWith(_CoolapkAccount value, $Res Function(_CoolapkAccount) _then) = __$CoolapkAccountCopyWithImpl;
@override @useResult
$Res call({
 String uid, String username, String userAvatar
});




}
/// @nodoc
class __$CoolapkAccountCopyWithImpl<$Res>
    implements _$CoolapkAccountCopyWith<$Res> {
  __$CoolapkAccountCopyWithImpl(this._self, this._then);

  final _CoolapkAccount _self;
  final $Res Function(_CoolapkAccount) _then;

/// Create a copy of CoolapkAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? username = null,Object? userAvatar = null,}) {
  return _then(_CoolapkAccount(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,userAvatar: null == userAvatar ? _self.userAvatar : userAvatar // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
