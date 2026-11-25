// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'imported_payload_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ImportedPayloadDto {

 String get displayName; String get devicePath; bool get standalone; String get arguments; int get size;
/// Create a copy of ImportedPayloadDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportedPayloadDtoCopyWith<ImportedPayloadDto> get copyWith => _$ImportedPayloadDtoCopyWithImpl<ImportedPayloadDto>(this as ImportedPayloadDto, _$identity);

  /// Serializes this ImportedPayloadDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportedPayloadDto&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.devicePath, devicePath) || other.devicePath == devicePath)&&(identical(other.standalone, standalone) || other.standalone == standalone)&&(identical(other.arguments, arguments) || other.arguments == arguments)&&(identical(other.size, size) || other.size == size));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,displayName,devicePath,standalone,arguments,size);

@override
String toString() {
  return 'ImportedPayloadDto(displayName: $displayName, devicePath: $devicePath, standalone: $standalone, arguments: $arguments, size: $size)';
}


}

/// @nodoc
abstract mixin class $ImportedPayloadDtoCopyWith<$Res>  {
  factory $ImportedPayloadDtoCopyWith(ImportedPayloadDto value, $Res Function(ImportedPayloadDto) _then) = _$ImportedPayloadDtoCopyWithImpl;
@useResult
$Res call({
 String displayName, String devicePath, bool standalone, String arguments, int size
});




}
/// @nodoc
class _$ImportedPayloadDtoCopyWithImpl<$Res>
    implements $ImportedPayloadDtoCopyWith<$Res> {
  _$ImportedPayloadDtoCopyWithImpl(this._self, this._then);

  final ImportedPayloadDto _self;
  final $Res Function(ImportedPayloadDto) _then;

/// Create a copy of ImportedPayloadDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayName = null,Object? devicePath = null,Object? standalone = null,Object? arguments = null,Object? size = null,}) {
  return _then(_self.copyWith(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,devicePath: null == devicePath ? _self.devicePath : devicePath // ignore: cast_nullable_to_non_nullable
as String,standalone: null == standalone ? _self.standalone : standalone // ignore: cast_nullable_to_non_nullable
as bool,arguments: null == arguments ? _self.arguments : arguments // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ImportedPayloadDto].
extension ImportedPayloadDtoPatterns on ImportedPayloadDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImportedPayloadDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImportedPayloadDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImportedPayloadDto value)  $default,){
final _that = this;
switch (_that) {
case _ImportedPayloadDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImportedPayloadDto value)?  $default,){
final _that = this;
switch (_that) {
case _ImportedPayloadDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String displayName,  String devicePath,  bool standalone,  String arguments,  int size)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImportedPayloadDto() when $default != null:
return $default(_that.displayName,_that.devicePath,_that.standalone,_that.arguments,_that.size);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String displayName,  String devicePath,  bool standalone,  String arguments,  int size)  $default,) {final _that = this;
switch (_that) {
case _ImportedPayloadDto():
return $default(_that.displayName,_that.devicePath,_that.standalone,_that.arguments,_that.size);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String displayName,  String devicePath,  bool standalone,  String arguments,  int size)?  $default,) {final _that = this;
switch (_that) {
case _ImportedPayloadDto() when $default != null:
return $default(_that.displayName,_that.devicePath,_that.standalone,_that.arguments,_that.size);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImportedPayloadDto extends ImportedPayloadDto {
  const _ImportedPayloadDto({this.displayName = '', this.devicePath = '', this.standalone = false, this.arguments = '', this.size = 0}): super._();
  factory _ImportedPayloadDto.fromJson(Map<String, dynamic> json) => _$ImportedPayloadDtoFromJson(json);

@override@JsonKey() final  String displayName;
@override@JsonKey() final  String devicePath;
@override@JsonKey() final  bool standalone;
@override@JsonKey() final  String arguments;
@override@JsonKey() final  int size;

/// Create a copy of ImportedPayloadDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportedPayloadDtoCopyWith<_ImportedPayloadDto> get copyWith => __$ImportedPayloadDtoCopyWithImpl<_ImportedPayloadDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImportedPayloadDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportedPayloadDto&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.devicePath, devicePath) || other.devicePath == devicePath)&&(identical(other.standalone, standalone) || other.standalone == standalone)&&(identical(other.arguments, arguments) || other.arguments == arguments)&&(identical(other.size, size) || other.size == size));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,displayName,devicePath,standalone,arguments,size);

@override
String toString() {
  return 'ImportedPayloadDto(displayName: $displayName, devicePath: $devicePath, standalone: $standalone, arguments: $arguments, size: $size)';
}


}

/// @nodoc
abstract mixin class _$ImportedPayloadDtoCopyWith<$Res> implements $ImportedPayloadDtoCopyWith<$Res> {
  factory _$ImportedPayloadDtoCopyWith(_ImportedPayloadDto value, $Res Function(_ImportedPayloadDto) _then) = __$ImportedPayloadDtoCopyWithImpl;
@override @useResult
$Res call({
 String displayName, String devicePath, bool standalone, String arguments, int size
});




}
/// @nodoc
class __$ImportedPayloadDtoCopyWithImpl<$Res>
    implements _$ImportedPayloadDtoCopyWith<$Res> {
  __$ImportedPayloadDtoCopyWithImpl(this._self, this._then);

  final _ImportedPayloadDto _self;
  final $Res Function(_ImportedPayloadDto) _then;

/// Create a copy of ImportedPayloadDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayName = null,Object? devicePath = null,Object? standalone = null,Object? arguments = null,Object? size = null,}) {
  return _then(_ImportedPayloadDto(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,devicePath: null == devicePath ? _self.devicePath : devicePath // ignore: cast_nullable_to_non_nullable
as String,standalone: null == standalone ? _self.standalone : standalone // ignore: cast_nullable_to_non_nullable
as bool,arguments: null == arguments ? _self.arguments : arguments // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
