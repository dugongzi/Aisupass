// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_identity_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeviceIdentityDto {

 String get identityText; String get kernelRelease; String get kernelVersion; String get kernelCommit; String get manufacturer; String get model; int get pageSize;
/// Create a copy of DeviceIdentityDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceIdentityDtoCopyWith<DeviceIdentityDto> get copyWith => _$DeviceIdentityDtoCopyWithImpl<DeviceIdentityDto>(this as DeviceIdentityDto, _$identity);

  /// Serializes this DeviceIdentityDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceIdentityDto&&(identical(other.identityText, identityText) || other.identityText == identityText)&&(identical(other.kernelRelease, kernelRelease) || other.kernelRelease == kernelRelease)&&(identical(other.kernelVersion, kernelVersion) || other.kernelVersion == kernelVersion)&&(identical(other.kernelCommit, kernelCommit) || other.kernelCommit == kernelCommit)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.model, model) || other.model == model)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,identityText,kernelRelease,kernelVersion,kernelCommit,manufacturer,model,pageSize);

@override
String toString() {
  return 'DeviceIdentityDto(identityText: $identityText, kernelRelease: $kernelRelease, kernelVersion: $kernelVersion, kernelCommit: $kernelCommit, manufacturer: $manufacturer, model: $model, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class $DeviceIdentityDtoCopyWith<$Res>  {
  factory $DeviceIdentityDtoCopyWith(DeviceIdentityDto value, $Res Function(DeviceIdentityDto) _then) = _$DeviceIdentityDtoCopyWithImpl;
@useResult
$Res call({
 String identityText, String kernelRelease, String kernelVersion, String kernelCommit, String manufacturer, String model, int pageSize
});




}
/// @nodoc
class _$DeviceIdentityDtoCopyWithImpl<$Res>
    implements $DeviceIdentityDtoCopyWith<$Res> {
  _$DeviceIdentityDtoCopyWithImpl(this._self, this._then);

  final DeviceIdentityDto _self;
  final $Res Function(DeviceIdentityDto) _then;

/// Create a copy of DeviceIdentityDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? identityText = null,Object? kernelRelease = null,Object? kernelVersion = null,Object? kernelCommit = null,Object? manufacturer = null,Object? model = null,Object? pageSize = null,}) {
  return _then(_self.copyWith(
identityText: null == identityText ? _self.identityText : identityText // ignore: cast_nullable_to_non_nullable
as String,kernelRelease: null == kernelRelease ? _self.kernelRelease : kernelRelease // ignore: cast_nullable_to_non_nullable
as String,kernelVersion: null == kernelVersion ? _self.kernelVersion : kernelVersion // ignore: cast_nullable_to_non_nullable
as String,kernelCommit: null == kernelCommit ? _self.kernelCommit : kernelCommit // ignore: cast_nullable_to_non_nullable
as String,manufacturer: null == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceIdentityDto].
extension DeviceIdentityDtoPatterns on DeviceIdentityDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceIdentityDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceIdentityDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceIdentityDto value)  $default,){
final _that = this;
switch (_that) {
case _DeviceIdentityDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceIdentityDto value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceIdentityDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String identityText,  String kernelRelease,  String kernelVersion,  String kernelCommit,  String manufacturer,  String model,  int pageSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceIdentityDto() when $default != null:
return $default(_that.identityText,_that.kernelRelease,_that.kernelVersion,_that.kernelCommit,_that.manufacturer,_that.model,_that.pageSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String identityText,  String kernelRelease,  String kernelVersion,  String kernelCommit,  String manufacturer,  String model,  int pageSize)  $default,) {final _that = this;
switch (_that) {
case _DeviceIdentityDto():
return $default(_that.identityText,_that.kernelRelease,_that.kernelVersion,_that.kernelCommit,_that.manufacturer,_that.model,_that.pageSize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String identityText,  String kernelRelease,  String kernelVersion,  String kernelCommit,  String manufacturer,  String model,  int pageSize)?  $default,) {final _that = this;
switch (_that) {
case _DeviceIdentityDto() when $default != null:
return $default(_that.identityText,_that.kernelRelease,_that.kernelVersion,_that.kernelCommit,_that.manufacturer,_that.model,_that.pageSize);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeviceIdentityDto extends DeviceIdentityDto {
  const _DeviceIdentityDto({this.identityText = '', this.kernelRelease = '', this.kernelVersion = '', this.kernelCommit = '', this.manufacturer = '', this.model = '', this.pageSize = 0}): super._();
  factory _DeviceIdentityDto.fromJson(Map<String, dynamic> json) => _$DeviceIdentityDtoFromJson(json);

@override@JsonKey() final  String identityText;
@override@JsonKey() final  String kernelRelease;
@override@JsonKey() final  String kernelVersion;
@override@JsonKey() final  String kernelCommit;
@override@JsonKey() final  String manufacturer;
@override@JsonKey() final  String model;
@override@JsonKey() final  int pageSize;

/// Create a copy of DeviceIdentityDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceIdentityDtoCopyWith<_DeviceIdentityDto> get copyWith => __$DeviceIdentityDtoCopyWithImpl<_DeviceIdentityDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceIdentityDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceIdentityDto&&(identical(other.identityText, identityText) || other.identityText == identityText)&&(identical(other.kernelRelease, kernelRelease) || other.kernelRelease == kernelRelease)&&(identical(other.kernelVersion, kernelVersion) || other.kernelVersion == kernelVersion)&&(identical(other.kernelCommit, kernelCommit) || other.kernelCommit == kernelCommit)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.model, model) || other.model == model)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,identityText,kernelRelease,kernelVersion,kernelCommit,manufacturer,model,pageSize);

@override
String toString() {
  return 'DeviceIdentityDto(identityText: $identityText, kernelRelease: $kernelRelease, kernelVersion: $kernelVersion, kernelCommit: $kernelCommit, manufacturer: $manufacturer, model: $model, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class _$DeviceIdentityDtoCopyWith<$Res> implements $DeviceIdentityDtoCopyWith<$Res> {
  factory _$DeviceIdentityDtoCopyWith(_DeviceIdentityDto value, $Res Function(_DeviceIdentityDto) _then) = __$DeviceIdentityDtoCopyWithImpl;
@override @useResult
$Res call({
 String identityText, String kernelRelease, String kernelVersion, String kernelCommit, String manufacturer, String model, int pageSize
});




}
/// @nodoc
class __$DeviceIdentityDtoCopyWithImpl<$Res>
    implements _$DeviceIdentityDtoCopyWith<$Res> {
  __$DeviceIdentityDtoCopyWithImpl(this._self, this._then);

  final _DeviceIdentityDto _self;
  final $Res Function(_DeviceIdentityDto) _then;

/// Create a copy of DeviceIdentityDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? identityText = null,Object? kernelRelease = null,Object? kernelVersion = null,Object? kernelCommit = null,Object? manufacturer = null,Object? model = null,Object? pageSize = null,}) {
  return _then(_DeviceIdentityDto(
identityText: null == identityText ? _self.identityText : identityText // ignore: cast_nullable_to_non_nullable
as String,kernelRelease: null == kernelRelease ? _self.kernelRelease : kernelRelease // ignore: cast_nullable_to_non_nullable
as String,kernelVersion: null == kernelVersion ? _self.kernelVersion : kernelVersion // ignore: cast_nullable_to_non_nullable
as String,kernelCommit: null == kernelCommit ? _self.kernelCommit : kernelCommit // ignore: cast_nullable_to_non_nullable
as String,manufacturer: null == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
