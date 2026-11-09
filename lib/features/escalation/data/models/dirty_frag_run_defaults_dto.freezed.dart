// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dirty_frag_run_defaults_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DirtyFragRunDefaultsDto {

 bool get vrDisarm; bool get vrAuto; int get vrOffset; bool get softReboot;
/// Create a copy of DirtyFragRunDefaultsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DirtyFragRunDefaultsDtoCopyWith<DirtyFragRunDefaultsDto> get copyWith => _$DirtyFragRunDefaultsDtoCopyWithImpl<DirtyFragRunDefaultsDto>(this as DirtyFragRunDefaultsDto, _$identity);

  /// Serializes this DirtyFragRunDefaultsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DirtyFragRunDefaultsDto&&(identical(other.vrDisarm, vrDisarm) || other.vrDisarm == vrDisarm)&&(identical(other.vrAuto, vrAuto) || other.vrAuto == vrAuto)&&(identical(other.vrOffset, vrOffset) || other.vrOffset == vrOffset)&&(identical(other.softReboot, softReboot) || other.softReboot == softReboot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,vrDisarm,vrAuto,vrOffset,softReboot);

@override
String toString() {
  return 'DirtyFragRunDefaultsDto(vrDisarm: $vrDisarm, vrAuto: $vrAuto, vrOffset: $vrOffset, softReboot: $softReboot)';
}


}

/// @nodoc
abstract mixin class $DirtyFragRunDefaultsDtoCopyWith<$Res>  {
  factory $DirtyFragRunDefaultsDtoCopyWith(DirtyFragRunDefaultsDto value, $Res Function(DirtyFragRunDefaultsDto) _then) = _$DirtyFragRunDefaultsDtoCopyWithImpl;
@useResult
$Res call({
 bool vrDisarm, bool vrAuto, int vrOffset, bool softReboot
});




}
/// @nodoc
class _$DirtyFragRunDefaultsDtoCopyWithImpl<$Res>
    implements $DirtyFragRunDefaultsDtoCopyWith<$Res> {
  _$DirtyFragRunDefaultsDtoCopyWithImpl(this._self, this._then);

  final DirtyFragRunDefaultsDto _self;
  final $Res Function(DirtyFragRunDefaultsDto) _then;

/// Create a copy of DirtyFragRunDefaultsDto
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


/// Adds pattern-matching-related methods to [DirtyFragRunDefaultsDto].
extension DirtyFragRunDefaultsDtoPatterns on DirtyFragRunDefaultsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DirtyFragRunDefaultsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DirtyFragRunDefaultsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DirtyFragRunDefaultsDto value)  $default,){
final _that = this;
switch (_that) {
case _DirtyFragRunDefaultsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DirtyFragRunDefaultsDto value)?  $default,){
final _that = this;
switch (_that) {
case _DirtyFragRunDefaultsDto() when $default != null:
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
case _DirtyFragRunDefaultsDto() when $default != null:
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
case _DirtyFragRunDefaultsDto():
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
case _DirtyFragRunDefaultsDto() when $default != null:
return $default(_that.vrDisarm,_that.vrAuto,_that.vrOffset,_that.softReboot);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DirtyFragRunDefaultsDto extends DirtyFragRunDefaultsDto {
  const _DirtyFragRunDefaultsDto({this.vrDisarm = false, this.vrAuto = true, this.vrOffset = 0, this.softReboot = false}): super._();
  factory _DirtyFragRunDefaultsDto.fromJson(Map<String, dynamic> json) => _$DirtyFragRunDefaultsDtoFromJson(json);

@override@JsonKey() final  bool vrDisarm;
@override@JsonKey() final  bool vrAuto;
@override@JsonKey() final  int vrOffset;
@override@JsonKey() final  bool softReboot;

/// Create a copy of DirtyFragRunDefaultsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DirtyFragRunDefaultsDtoCopyWith<_DirtyFragRunDefaultsDto> get copyWith => __$DirtyFragRunDefaultsDtoCopyWithImpl<_DirtyFragRunDefaultsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DirtyFragRunDefaultsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DirtyFragRunDefaultsDto&&(identical(other.vrDisarm, vrDisarm) || other.vrDisarm == vrDisarm)&&(identical(other.vrAuto, vrAuto) || other.vrAuto == vrAuto)&&(identical(other.vrOffset, vrOffset) || other.vrOffset == vrOffset)&&(identical(other.softReboot, softReboot) || other.softReboot == softReboot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,vrDisarm,vrAuto,vrOffset,softReboot);

@override
String toString() {
  return 'DirtyFragRunDefaultsDto(vrDisarm: $vrDisarm, vrAuto: $vrAuto, vrOffset: $vrOffset, softReboot: $softReboot)';
}


}

/// @nodoc
abstract mixin class _$DirtyFragRunDefaultsDtoCopyWith<$Res> implements $DirtyFragRunDefaultsDtoCopyWith<$Res> {
  factory _$DirtyFragRunDefaultsDtoCopyWith(_DirtyFragRunDefaultsDto value, $Res Function(_DirtyFragRunDefaultsDto) _then) = __$DirtyFragRunDefaultsDtoCopyWithImpl;
@override @useResult
$Res call({
 bool vrDisarm, bool vrAuto, int vrOffset, bool softReboot
});




}
/// @nodoc
class __$DirtyFragRunDefaultsDtoCopyWithImpl<$Res>
    implements _$DirtyFragRunDefaultsDtoCopyWith<$Res> {
  __$DirtyFragRunDefaultsDtoCopyWithImpl(this._self, this._then);

  final _DirtyFragRunDefaultsDto _self;
  final $Res Function(_DirtyFragRunDefaultsDto) _then;

/// Create a copy of DirtyFragRunDefaultsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vrDisarm = null,Object? vrAuto = null,Object? vrOffset = null,Object? softReboot = null,}) {
  return _then(_DirtyFragRunDefaultsDto(
vrDisarm: null == vrDisarm ? _self.vrDisarm : vrDisarm // ignore: cast_nullable_to_non_nullable
as bool,vrAuto: null == vrAuto ? _self.vrAuto : vrAuto // ignore: cast_nullable_to_non_nullable
as bool,vrOffset: null == vrOffset ? _self.vrOffset : vrOffset // ignore: cast_nullable_to_non_nullable
as int,softReboot: null == softReboot ? _self.softReboot : softReboot // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
