// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coolapk_account_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoolapkAccountDto {

@JsonKey(name: 'uid', fromJson: stringFromJson) String get uid; String get username; String get userAvatar;
/// Create a copy of CoolapkAccountDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoolapkAccountDtoCopyWith<CoolapkAccountDto> get copyWith => _$CoolapkAccountDtoCopyWithImpl<CoolapkAccountDto>(this as CoolapkAccountDto, _$identity);

  /// Serializes this CoolapkAccountDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoolapkAccountDto&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.username, username) || other.username == username)&&(identical(other.userAvatar, userAvatar) || other.userAvatar == userAvatar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,username,userAvatar);

@override
String toString() {
  return 'CoolapkAccountDto(uid: $uid, username: $username, userAvatar: $userAvatar)';
}


}

/// @nodoc
abstract mixin class $CoolapkAccountDtoCopyWith<$Res>  {
  factory $CoolapkAccountDtoCopyWith(CoolapkAccountDto value, $Res Function(CoolapkAccountDto) _then) = _$CoolapkAccountDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'uid', fromJson: stringFromJson) String uid, String username, String userAvatar
});




}
/// @nodoc
class _$CoolapkAccountDtoCopyWithImpl<$Res>
    implements $CoolapkAccountDtoCopyWith<$Res> {
  _$CoolapkAccountDtoCopyWithImpl(this._self, this._then);

  final CoolapkAccountDto _self;
  final $Res Function(CoolapkAccountDto) _then;

/// Create a copy of CoolapkAccountDto
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


/// Adds pattern-matching-related methods to [CoolapkAccountDto].
extension CoolapkAccountDtoPatterns on CoolapkAccountDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoolapkAccountDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoolapkAccountDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoolapkAccountDto value)  $default,){
final _that = this;
switch (_that) {
case _CoolapkAccountDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoolapkAccountDto value)?  $default,){
final _that = this;
switch (_that) {
case _CoolapkAccountDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'uid', fromJson: stringFromJson)  String uid,  String username,  String userAvatar)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoolapkAccountDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'uid', fromJson: stringFromJson)  String uid,  String username,  String userAvatar)  $default,) {final _that = this;
switch (_that) {
case _CoolapkAccountDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'uid', fromJson: stringFromJson)  String uid,  String username,  String userAvatar)?  $default,) {final _that = this;
switch (_that) {
case _CoolapkAccountDto() when $default != null:
return $default(_that.uid,_that.username,_that.userAvatar);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CoolapkAccountDto extends CoolapkAccountDto {
  const _CoolapkAccountDto({@JsonKey(name: 'uid', fromJson: stringFromJson) this.uid = '', this.username = '', this.userAvatar = ''}): super._();
  factory _CoolapkAccountDto.fromJson(Map<String, dynamic> json) => _$CoolapkAccountDtoFromJson(json);

@override@JsonKey(name: 'uid', fromJson: stringFromJson) final  String uid;
@override@JsonKey() final  String username;
@override@JsonKey() final  String userAvatar;

/// Create a copy of CoolapkAccountDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoolapkAccountDtoCopyWith<_CoolapkAccountDto> get copyWith => __$CoolapkAccountDtoCopyWithImpl<_CoolapkAccountDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoolapkAccountDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoolapkAccountDto&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.username, username) || other.username == username)&&(identical(other.userAvatar, userAvatar) || other.userAvatar == userAvatar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,username,userAvatar);

@override
String toString() {
  return 'CoolapkAccountDto(uid: $uid, username: $username, userAvatar: $userAvatar)';
}


}

/// @nodoc
abstract mixin class _$CoolapkAccountDtoCopyWith<$Res> implements $CoolapkAccountDtoCopyWith<$Res> {
  factory _$CoolapkAccountDtoCopyWith(_CoolapkAccountDto value, $Res Function(_CoolapkAccountDto) _then) = __$CoolapkAccountDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'uid', fromJson: stringFromJson) String uid, String username, String userAvatar
});




}
/// @nodoc
class __$CoolapkAccountDtoCopyWithImpl<$Res>
    implements _$CoolapkAccountDtoCopyWith<$Res> {
  __$CoolapkAccountDtoCopyWithImpl(this._self, this._then);

  final _CoolapkAccountDto _self;
  final $Res Function(_CoolapkAccountDto) _then;

/// Create a copy of CoolapkAccountDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? username = null,Object? userAvatar = null,}) {
  return _then(_CoolapkAccountDto(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,userAvatar: null == userAvatar ? _self.userAvatar : userAvatar // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
