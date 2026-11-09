// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vr_derive_progress_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VrDeriveProgressDto {

 int get phase; int get done; int get total;
/// Create a copy of VrDeriveProgressDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VrDeriveProgressDtoCopyWith<VrDeriveProgressDto> get copyWith => _$VrDeriveProgressDtoCopyWithImpl<VrDeriveProgressDto>(this as VrDeriveProgressDto, _$identity);

  /// Serializes this VrDeriveProgressDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VrDeriveProgressDto&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.done, done) || other.done == done)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phase,done,total);

@override
String toString() {
  return 'VrDeriveProgressDto(phase: $phase, done: $done, total: $total)';
}


}

/// @nodoc
abstract mixin class $VrDeriveProgressDtoCopyWith<$Res>  {
  factory $VrDeriveProgressDtoCopyWith(VrDeriveProgressDto value, $Res Function(VrDeriveProgressDto) _then) = _$VrDeriveProgressDtoCopyWithImpl;
@useResult
$Res call({
 int phase, int done, int total
});




}
/// @nodoc
class _$VrDeriveProgressDtoCopyWithImpl<$Res>
    implements $VrDeriveProgressDtoCopyWith<$Res> {
  _$VrDeriveProgressDtoCopyWithImpl(this._self, this._then);

  final VrDeriveProgressDto _self;
  final $Res Function(VrDeriveProgressDto) _then;

/// Create a copy of VrDeriveProgressDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phase = null,Object? done = null,Object? total = null,}) {
  return _then(_self.copyWith(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as int,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [VrDeriveProgressDto].
extension VrDeriveProgressDtoPatterns on VrDeriveProgressDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VrDeriveProgressDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VrDeriveProgressDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VrDeriveProgressDto value)  $default,){
final _that = this;
switch (_that) {
case _VrDeriveProgressDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VrDeriveProgressDto value)?  $default,){
final _that = this;
switch (_that) {
case _VrDeriveProgressDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int phase,  int done,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VrDeriveProgressDto() when $default != null:
return $default(_that.phase,_that.done,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int phase,  int done,  int total)  $default,) {final _that = this;
switch (_that) {
case _VrDeriveProgressDto():
return $default(_that.phase,_that.done,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int phase,  int done,  int total)?  $default,) {final _that = this;
switch (_that) {
case _VrDeriveProgressDto() when $default != null:
return $default(_that.phase,_that.done,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VrDeriveProgressDto extends VrDeriveProgressDto {
  const _VrDeriveProgressDto({this.phase = 0, this.done = 0, this.total = 0}): super._();
  factory _VrDeriveProgressDto.fromJson(Map<String, dynamic> json) => _$VrDeriveProgressDtoFromJson(json);

@override@JsonKey() final  int phase;
@override@JsonKey() final  int done;
@override@JsonKey() final  int total;

/// Create a copy of VrDeriveProgressDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VrDeriveProgressDtoCopyWith<_VrDeriveProgressDto> get copyWith => __$VrDeriveProgressDtoCopyWithImpl<_VrDeriveProgressDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VrDeriveProgressDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VrDeriveProgressDto&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.done, done) || other.done == done)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phase,done,total);

@override
String toString() {
  return 'VrDeriveProgressDto(phase: $phase, done: $done, total: $total)';
}


}

/// @nodoc
abstract mixin class _$VrDeriveProgressDtoCopyWith<$Res> implements $VrDeriveProgressDtoCopyWith<$Res> {
  factory _$VrDeriveProgressDtoCopyWith(_VrDeriveProgressDto value, $Res Function(_VrDeriveProgressDto) _then) = __$VrDeriveProgressDtoCopyWithImpl;
@override @useResult
$Res call({
 int phase, int done, int total
});




}
/// @nodoc
class __$VrDeriveProgressDtoCopyWithImpl<$Res>
    implements _$VrDeriveProgressDtoCopyWith<$Res> {
  __$VrDeriveProgressDtoCopyWithImpl(this._self, this._then);

  final _VrDeriveProgressDto _self;
  final $Res Function(_VrDeriveProgressDto) _then;

/// Create a copy of VrDeriveProgressDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phase = null,Object? done = null,Object? total = null,}) {
  return _then(_VrDeriveProgressDto(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as int,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
