// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ghost_key_run_defaults.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GhostKeyRunDefaults {

/// 是否接受 `calibrate-b` 的 `fallback` 置信度。
 bool get acceptFallbackPageOffset;
/// Create a copy of GhostKeyRunDefaults
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GhostKeyRunDefaultsCopyWith<GhostKeyRunDefaults> get copyWith => _$GhostKeyRunDefaultsCopyWithImpl<GhostKeyRunDefaults>(this as GhostKeyRunDefaults, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GhostKeyRunDefaults&&(identical(other.acceptFallbackPageOffset, acceptFallbackPageOffset) || other.acceptFallbackPageOffset == acceptFallbackPageOffset));
}


@override
int get hashCode => Object.hash(runtimeType,acceptFallbackPageOffset);

@override
String toString() {
  return 'GhostKeyRunDefaults(acceptFallbackPageOffset: $acceptFallbackPageOffset)';
}


}

/// @nodoc
abstract mixin class $GhostKeyRunDefaultsCopyWith<$Res>  {
  factory $GhostKeyRunDefaultsCopyWith(GhostKeyRunDefaults value, $Res Function(GhostKeyRunDefaults) _then) = _$GhostKeyRunDefaultsCopyWithImpl;
@useResult
$Res call({
 bool acceptFallbackPageOffset
});




}
/// @nodoc
class _$GhostKeyRunDefaultsCopyWithImpl<$Res>
    implements $GhostKeyRunDefaultsCopyWith<$Res> {
  _$GhostKeyRunDefaultsCopyWithImpl(this._self, this._then);

  final GhostKeyRunDefaults _self;
  final $Res Function(GhostKeyRunDefaults) _then;

/// Create a copy of GhostKeyRunDefaults
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? acceptFallbackPageOffset = null,}) {
  return _then(_self.copyWith(
acceptFallbackPageOffset: null == acceptFallbackPageOffset ? _self.acceptFallbackPageOffset : acceptFallbackPageOffset // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GhostKeyRunDefaults].
extension GhostKeyRunDefaultsPatterns on GhostKeyRunDefaults {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GhostKeyRunDefaults value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GhostKeyRunDefaults() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GhostKeyRunDefaults value)  $default,){
final _that = this;
switch (_that) {
case _GhostKeyRunDefaults():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GhostKeyRunDefaults value)?  $default,){
final _that = this;
switch (_that) {
case _GhostKeyRunDefaults() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool acceptFallbackPageOffset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GhostKeyRunDefaults() when $default != null:
return $default(_that.acceptFallbackPageOffset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool acceptFallbackPageOffset)  $default,) {final _that = this;
switch (_that) {
case _GhostKeyRunDefaults():
return $default(_that.acceptFallbackPageOffset);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool acceptFallbackPageOffset)?  $default,) {final _that = this;
switch (_that) {
case _GhostKeyRunDefaults() when $default != null:
return $default(_that.acceptFallbackPageOffset);case _:
  return null;

}
}

}

/// @nodoc


class _GhostKeyRunDefaults extends GhostKeyRunDefaults {
  const _GhostKeyRunDefaults({required this.acceptFallbackPageOffset}): super._();
  

/// 是否接受 `calibrate-b` 的 `fallback` 置信度。
@override final  bool acceptFallbackPageOffset;

/// Create a copy of GhostKeyRunDefaults
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GhostKeyRunDefaultsCopyWith<_GhostKeyRunDefaults> get copyWith => __$GhostKeyRunDefaultsCopyWithImpl<_GhostKeyRunDefaults>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GhostKeyRunDefaults&&(identical(other.acceptFallbackPageOffset, acceptFallbackPageOffset) || other.acceptFallbackPageOffset == acceptFallbackPageOffset));
}


@override
int get hashCode => Object.hash(runtimeType,acceptFallbackPageOffset);

@override
String toString() {
  return 'GhostKeyRunDefaults(acceptFallbackPageOffset: $acceptFallbackPageOffset)';
}


}

/// @nodoc
abstract mixin class _$GhostKeyRunDefaultsCopyWith<$Res> implements $GhostKeyRunDefaultsCopyWith<$Res> {
  factory _$GhostKeyRunDefaultsCopyWith(_GhostKeyRunDefaults value, $Res Function(_GhostKeyRunDefaults) _then) = __$GhostKeyRunDefaultsCopyWithImpl;
@override @useResult
$Res call({
 bool acceptFallbackPageOffset
});




}
/// @nodoc
class __$GhostKeyRunDefaultsCopyWithImpl<$Res>
    implements _$GhostKeyRunDefaultsCopyWith<$Res> {
  __$GhostKeyRunDefaultsCopyWithImpl(this._self, this._then);

  final _GhostKeyRunDefaults _self;
  final $Res Function(_GhostKeyRunDefaults) _then;

/// Create a copy of GhostKeyRunDefaults
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? acceptFallbackPageOffset = null,}) {
  return _then(_GhostKeyRunDefaults(
acceptFallbackPageOffset: null == acceptFallbackPageOffset ? _self.acceptFallbackPageOffset : acceptFallbackPageOffset // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
