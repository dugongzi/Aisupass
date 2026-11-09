// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dirty_frag_run_defaults.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DirtyFragRunDefaults {

/// 是否启用 VR 反制。仅 vivo `vr.ko` 机型需要开。
 bool get vrDisarm;/// 是否由内核 BTF 自动解析偏移。
 bool get vrAuto;/// 手动偏移；[vrAuto] 为 true 时忽略。取值 1..256，`0` 表示从未设过。
 int get vrOffset;/// 成功后是否让管理器 soft-reboot。
 bool get softReboot;
/// Create a copy of DirtyFragRunDefaults
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DirtyFragRunDefaultsCopyWith<DirtyFragRunDefaults> get copyWith => _$DirtyFragRunDefaultsCopyWithImpl<DirtyFragRunDefaults>(this as DirtyFragRunDefaults, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DirtyFragRunDefaults&&(identical(other.vrDisarm, vrDisarm) || other.vrDisarm == vrDisarm)&&(identical(other.vrAuto, vrAuto) || other.vrAuto == vrAuto)&&(identical(other.vrOffset, vrOffset) || other.vrOffset == vrOffset)&&(identical(other.softReboot, softReboot) || other.softReboot == softReboot));
}


@override
int get hashCode => Object.hash(runtimeType,vrDisarm,vrAuto,vrOffset,softReboot);

@override
String toString() {
  return 'DirtyFragRunDefaults(vrDisarm: $vrDisarm, vrAuto: $vrAuto, vrOffset: $vrOffset, softReboot: $softReboot)';
}


}

/// @nodoc
abstract mixin class $DirtyFragRunDefaultsCopyWith<$Res>  {
  factory $DirtyFragRunDefaultsCopyWith(DirtyFragRunDefaults value, $Res Function(DirtyFragRunDefaults) _then) = _$DirtyFragRunDefaultsCopyWithImpl;
@useResult
$Res call({
 bool vrDisarm, bool vrAuto, int vrOffset, bool softReboot
});




}
/// @nodoc
class _$DirtyFragRunDefaultsCopyWithImpl<$Res>
    implements $DirtyFragRunDefaultsCopyWith<$Res> {
  _$DirtyFragRunDefaultsCopyWithImpl(this._self, this._then);

  final DirtyFragRunDefaults _self;
  final $Res Function(DirtyFragRunDefaults) _then;

/// Create a copy of DirtyFragRunDefaults
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vrDisarm = null,Object? vrAuto = null,Object? vrOffset = null,Object? softReboot = null,}) {
  return _then(_self.copyWith(
vrDisarm: null == vrDisarm ? _self.vrDisarm : vrDisarm // ignore: cast_nullable_to_non_nullable
as bool,vrAuto: null == vrAuto ? _self.vrAuto : vrAuto // ignore: cast_nullable_to_non_nullable
as bool,vrOffset: null == vrOffset ? _self.vrOffset : vrOffset // ignore: cast_nullable_to_non_nullable
as int,softReboot: null == softReboot ? _self.softReboot : softReboot // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DirtyFragRunDefaults].
extension DirtyFragRunDefaultsPatterns on DirtyFragRunDefaults {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DirtyFragRunDefaults value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DirtyFragRunDefaults() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DirtyFragRunDefaults value)  $default,){
final _that = this;
switch (_that) {
case _DirtyFragRunDefaults():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DirtyFragRunDefaults value)?  $default,){
final _that = this;
switch (_that) {
case _DirtyFragRunDefaults() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool vrDisarm,  bool vrAuto,  int vrOffset,  bool softReboot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DirtyFragRunDefaults() when $default != null:
return $default(_that.vrDisarm,_that.vrAuto,_that.vrOffset,_that.softReboot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool vrDisarm,  bool vrAuto,  int vrOffset,  bool softReboot)  $default,) {final _that = this;
switch (_that) {
case _DirtyFragRunDefaults():
return $default(_that.vrDisarm,_that.vrAuto,_that.vrOffset,_that.softReboot);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool vrDisarm,  bool vrAuto,  int vrOffset,  bool softReboot)?  $default,) {final _that = this;
switch (_that) {
case _DirtyFragRunDefaults() when $default != null:
return $default(_that.vrDisarm,_that.vrAuto,_that.vrOffset,_that.softReboot);case _:
  return null;

}
}

}

/// @nodoc


class _DirtyFragRunDefaults extends DirtyFragRunDefaults {
  const _DirtyFragRunDefaults({required this.vrDisarm, required this.vrAuto, required this.vrOffset, required this.softReboot}): super._();
  

/// 是否启用 VR 反制。仅 vivo `vr.ko` 机型需要开。
@override final  bool vrDisarm;
/// 是否由内核 BTF 自动解析偏移。
@override final  bool vrAuto;
/// 手动偏移；[vrAuto] 为 true 时忽略。取值 1..256，`0` 表示从未设过。
@override final  int vrOffset;
/// 成功后是否让管理器 soft-reboot。
@override final  bool softReboot;

/// Create a copy of DirtyFragRunDefaults
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DirtyFragRunDefaultsCopyWith<_DirtyFragRunDefaults> get copyWith => __$DirtyFragRunDefaultsCopyWithImpl<_DirtyFragRunDefaults>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DirtyFragRunDefaults&&(identical(other.vrDisarm, vrDisarm) || other.vrDisarm == vrDisarm)&&(identical(other.vrAuto, vrAuto) || other.vrAuto == vrAuto)&&(identical(other.vrOffset, vrOffset) || other.vrOffset == vrOffset)&&(identical(other.softReboot, softReboot) || other.softReboot == softReboot));
}


@override
int get hashCode => Object.hash(runtimeType,vrDisarm,vrAuto,vrOffset,softReboot);

@override
String toString() {
  return 'DirtyFragRunDefaults(vrDisarm: $vrDisarm, vrAuto: $vrAuto, vrOffset: $vrOffset, softReboot: $softReboot)';
}


}

/// @nodoc
abstract mixin class _$DirtyFragRunDefaultsCopyWith<$Res> implements $DirtyFragRunDefaultsCopyWith<$Res> {
  factory _$DirtyFragRunDefaultsCopyWith(_DirtyFragRunDefaults value, $Res Function(_DirtyFragRunDefaults) _then) = __$DirtyFragRunDefaultsCopyWithImpl;
@override @useResult
$Res call({
 bool vrDisarm, bool vrAuto, int vrOffset, bool softReboot
});




}
/// @nodoc
class __$DirtyFragRunDefaultsCopyWithImpl<$Res>
    implements _$DirtyFragRunDefaultsCopyWith<$Res> {
  __$DirtyFragRunDefaultsCopyWithImpl(this._self, this._then);

  final _DirtyFragRunDefaults _self;
  final $Res Function(_DirtyFragRunDefaults) _then;

/// Create a copy of DirtyFragRunDefaults
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vrDisarm = null,Object? vrAuto = null,Object? vrOffset = null,Object? softReboot = null,}) {
  return _then(_DirtyFragRunDefaults(
vrDisarm: null == vrDisarm ? _self.vrDisarm : vrDisarm // ignore: cast_nullable_to_non_nullable
as bool,vrAuto: null == vrAuto ? _self.vrAuto : vrAuto // ignore: cast_nullable_to_non_nullable
as bool,vrOffset: null == vrOffset ? _self.vrOffset : vrOffset // ignore: cast_nullable_to_non_nullable
as int,softReboot: null == softReboot ? _self.softReboot : softReboot // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
