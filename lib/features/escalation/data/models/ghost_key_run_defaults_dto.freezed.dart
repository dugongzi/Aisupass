// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ghost_key_run_defaults_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GhostKeyRunDefaultsDto {

 bool get acceptFallbackPageOffset;
/// Create a copy of GhostKeyRunDefaultsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GhostKeyRunDefaultsDtoCopyWith<GhostKeyRunDefaultsDto> get copyWith => _$GhostKeyRunDefaultsDtoCopyWithImpl<GhostKeyRunDefaultsDto>(this as GhostKeyRunDefaultsDto, _$identity);

  /// Serializes this GhostKeyRunDefaultsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GhostKeyRunDefaultsDto&&(identical(other.acceptFallbackPageOffset, acceptFallbackPageOffset) || other.acceptFallbackPageOffset == acceptFallbackPageOffset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,acceptFallbackPageOffset);

@override
String toString() {
  return 'GhostKeyRunDefaultsDto(acceptFallbackPageOffset: $acceptFallbackPageOffset)';
}


}

/// @nodoc
abstract mixin class $GhostKeyRunDefaultsDtoCopyWith<$Res>  {
  factory $GhostKeyRunDefaultsDtoCopyWith(GhostKeyRunDefaultsDto value, $Res Function(GhostKeyRunDefaultsDto) _then) = _$GhostKeyRunDefaultsDtoCopyWithImpl;
@useResult
$Res call({
 bool acceptFallbackPageOffset
});




}
/// @nodoc
class _$GhostKeyRunDefaultsDtoCopyWithImpl<$Res>
    implements $GhostKeyRunDefaultsDtoCopyWith<$Res> {
  _$GhostKeyRunDefaultsDtoCopyWithImpl(this._self, this._then);

  final GhostKeyRunDefaultsDto _self;
  final $Res Function(GhostKeyRunDefaultsDto) _then;

/// Create a copy of GhostKeyRunDefaultsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? acceptFallbackPageOffset = null,}) {
  return _then(_self.copyWith(
acceptFallbackPageOffset: null == acceptFallbackPageOffset ? _self.acceptFallbackPageOffset : acceptFallbackPageOffset // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GhostKeyRunDefaultsDto].
extension GhostKeyRunDefaultsDtoPatterns on GhostKeyRunDefaultsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GhostKeyRunDefaultsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GhostKeyRunDefaultsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GhostKeyRunDefaultsDto value)  $default,){
final _that = this;
switch (_that) {
case _GhostKeyRunDefaultsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GhostKeyRunDefaultsDto value)?  $default,){
final _that = this;
switch (_that) {
case _GhostKeyRunDefaultsDto() when $default != null:
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
case _GhostKeyRunDefaultsDto() when $default != null:
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
case _GhostKeyRunDefaultsDto():
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
case _GhostKeyRunDefaultsDto() when $default != null:
return $default(_that.acceptFallbackPageOffset);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GhostKeyRunDefaultsDto extends GhostKeyRunDefaultsDto {
  const _GhostKeyRunDefaultsDto({this.acceptFallbackPageOffset = true}): super._();
  factory _GhostKeyRunDefaultsDto.fromJson(Map<String, dynamic> json) => _$GhostKeyRunDefaultsDtoFromJson(json);

@override@JsonKey() final  bool acceptFallbackPageOffset;

/// Create a copy of GhostKeyRunDefaultsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GhostKeyRunDefaultsDtoCopyWith<_GhostKeyRunDefaultsDto> get copyWith => __$GhostKeyRunDefaultsDtoCopyWithImpl<_GhostKeyRunDefaultsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GhostKeyRunDefaultsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GhostKeyRunDefaultsDto&&(identical(other.acceptFallbackPageOffset, acceptFallbackPageOffset) || other.acceptFallbackPageOffset == acceptFallbackPageOffset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,acceptFallbackPageOffset);

@override
String toString() {
  return 'GhostKeyRunDefaultsDto(acceptFallbackPageOffset: $acceptFallbackPageOffset)';
}


}

/// @nodoc
abstract mixin class _$GhostKeyRunDefaultsDtoCopyWith<$Res> implements $GhostKeyRunDefaultsDtoCopyWith<$Res> {
  factory _$GhostKeyRunDefaultsDtoCopyWith(_GhostKeyRunDefaultsDto value, $Res Function(_GhostKeyRunDefaultsDto) _then) = __$GhostKeyRunDefaultsDtoCopyWithImpl;
@override @useResult
$Res call({
 bool acceptFallbackPageOffset
});




}
/// @nodoc
class __$GhostKeyRunDefaultsDtoCopyWithImpl<$Res>
    implements _$GhostKeyRunDefaultsDtoCopyWith<$Res> {
  __$GhostKeyRunDefaultsDtoCopyWithImpl(this._self, this._then);

  final _GhostKeyRunDefaultsDto _self;
  final $Res Function(_GhostKeyRunDefaultsDto) _then;

/// Create a copy of GhostKeyRunDefaultsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? acceptFallbackPageOffset = null,}) {
  return _then(_GhostKeyRunDefaultsDto(
acceptFallbackPageOffset: null == acceptFallbackPageOffset ? _self.acceptFallbackPageOffset : acceptFallbackPageOffset // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
