// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vr_offset_result_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VrOffsetResultDto {

 bool get ok; int get member; String get release; String get error;
/// Create a copy of VrOffsetResultDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VrOffsetResultDtoCopyWith<VrOffsetResultDto> get copyWith => _$VrOffsetResultDtoCopyWithImpl<VrOffsetResultDto>(this as VrOffsetResultDto, _$identity);

  /// Serializes this VrOffsetResultDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VrOffsetResultDto&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.member, member) || other.member == member)&&(identical(other.release, release) || other.release == release)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,member,release,error);

@override
String toString() {
  return 'VrOffsetResultDto(ok: $ok, member: $member, release: $release, error: $error)';
}


}

/// @nodoc
abstract mixin class $VrOffsetResultDtoCopyWith<$Res>  {
  factory $VrOffsetResultDtoCopyWith(VrOffsetResultDto value, $Res Function(VrOffsetResultDto) _then) = _$VrOffsetResultDtoCopyWithImpl;
@useResult
$Res call({
 bool ok, int member, String release, String error
});




}
/// @nodoc
class _$VrOffsetResultDtoCopyWithImpl<$Res>
    implements $VrOffsetResultDtoCopyWith<$Res> {
  _$VrOffsetResultDtoCopyWithImpl(this._self, this._then);

  final VrOffsetResultDto _self;
  final $Res Function(VrOffsetResultDto) _then;

/// Create a copy of VrOffsetResultDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? member = null,Object? release = null,Object? error = null,}) {
  return _then(_self.copyWith(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,member: null == member ? _self.member : member // ignore: cast_nullable_to_non_nullable
as int,release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VrOffsetResultDto].
extension VrOffsetResultDtoPatterns on VrOffsetResultDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VrOffsetResultDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VrOffsetResultDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VrOffsetResultDto value)  $default,){
final _that = this;
switch (_that) {
case _VrOffsetResultDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VrOffsetResultDto value)?  $default,){
final _that = this;
switch (_that) {
case _VrOffsetResultDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  int member,  String release,  String error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VrOffsetResultDto() when $default != null:
return $default(_that.ok,_that.member,_that.release,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  int member,  String release,  String error)  $default,) {final _that = this;
switch (_that) {
case _VrOffsetResultDto():
return $default(_that.ok,_that.member,_that.release,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  int member,  String release,  String error)?  $default,) {final _that = this;
switch (_that) {
case _VrOffsetResultDto() when $default != null:
return $default(_that.ok,_that.member,_that.release,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VrOffsetResultDto extends VrOffsetResultDto {
  const _VrOffsetResultDto({this.ok = false, this.member = 0, this.release = '', this.error = ''}): super._();
  factory _VrOffsetResultDto.fromJson(Map<String, dynamic> json) => _$VrOffsetResultDtoFromJson(json);

@override@JsonKey() final  bool ok;
@override@JsonKey() final  int member;
@override@JsonKey() final  String release;
@override@JsonKey() final  String error;

/// Create a copy of VrOffsetResultDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VrOffsetResultDtoCopyWith<_VrOffsetResultDto> get copyWith => __$VrOffsetResultDtoCopyWithImpl<_VrOffsetResultDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VrOffsetResultDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VrOffsetResultDto&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.member, member) || other.member == member)&&(identical(other.release, release) || other.release == release)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,member,release,error);

@override
String toString() {
  return 'VrOffsetResultDto(ok: $ok, member: $member, release: $release, error: $error)';
}


}

/// @nodoc
abstract mixin class _$VrOffsetResultDtoCopyWith<$Res> implements $VrOffsetResultDtoCopyWith<$Res> {
  factory _$VrOffsetResultDtoCopyWith(_VrOffsetResultDto value, $Res Function(_VrOffsetResultDto) _then) = __$VrOffsetResultDtoCopyWithImpl;
@override @useResult
$Res call({
 bool ok, int member, String release, String error
});




}
/// @nodoc
class __$VrOffsetResultDtoCopyWithImpl<$Res>
    implements _$VrOffsetResultDtoCopyWith<$Res> {
  __$VrOffsetResultDtoCopyWithImpl(this._self, this._then);

  final _VrOffsetResultDto _self;
  final $Res Function(_VrOffsetResultDto) _then;

/// Create a copy of VrOffsetResultDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? member = null,Object? release = null,Object? error = null,}) {
  return _then(_VrOffsetResultDto(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,member: null == member ? _self.member : member // ignore: cast_nullable_to_non_nullable
as int,release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
